Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF084C2D0E4
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Nov 2020 04:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DAA4208D5
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Nov 2020 04:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgKSEXT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Nov 2020 23:23:19 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48838 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725964AbgKSEXT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Nov 2020 23:23:19 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E5EF358BF41;
        Thu, 19 Nov 2020 15:23:15 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kfbTX-00CfxS-9t; Thu, 19 Nov 2020 15:23:15 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kfbTX-002FMx-1l; Thu, 19 Nov 2020 15:23:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     axboe@kernel.dk
Subject: [PATCH] xfs: don't allow NOWAIT DIO across extent boundaries
Date:   Thu, 19 Nov 2020 15:23:15 +1100
Message-Id: <20201119042315.535693-1-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=nNwsprhYR40A:10 a=20KFwNOVAAAA:8 a=iauB3OMTt7I84X71ONoA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Jens has reported a situation where partial direct IOs can be issued
and completed yet still return -EAGAIN. We don't want this to report
a short IO as we want XFS to complete user DIO entirely or not at
all.

This partial IO situation can occur on a write IO that is split
across an allocated extent and a hole, and the second mapping is
returning EAGAIN because allocation would be required.

The trivial reproducer:

$ sudo xfs_io -fdt -c "pwrite 0 4k" -c "pwrite -V 1 -b 8k -N 0 8k" /mnt/scr/foo
wrote 4096/4096 bytes at offset 0
4 KiB, 1 ops; 0.0001 sec (27.509 MiB/sec and 7042.2535 ops/sec)
pwrite: Resource temporarily unavailable
$

The pwritev2(0, 8kB, RWF_NOWAIT) call returns EAGAIN having done
the first 4kB write:

 xfs_file_direct_write: dev 259:1 ino 0x83 size 0x1000 offset 0x0 count 0x2000
 iomap_apply:          dev 259:1 ino 0x83 pos 0 length 8192 flags WRITE|DIRECT|NOWAIT (0x31) ops xfs_direct_write_iomap_ops caller iomap_dio_rw actor iomap_dio_actor
 xfs_ilock_nowait:     dev 259:1 ino 0x83 flags ILOCK_SHARED caller xfs_ilock_for_iomap
 xfs_iunlock:          dev 259:1 ino 0x83 flags ILOCK_SHARED caller xfs_direct_write_iomap_begin
 xfs_iomap_found:      dev 259:1 ino 0x83 size 0x1000 offset 0x0 count 8192 fork data startoff 0x0 startblock 24 blockcount 0x1
 iomap_apply_dstmap:   dev 259:1 ino 0x83 bdev 259:1 addr 102400 offset 0 length 4096 type MAPPED flags DIRTY

Here the first iomap loop has mapped the first 4kB of the file and
issued the IO, and we enter the second iomap_apply loop:

 iomap_apply: dev 259:1 ino 0x83 pos 4096 length 4096 flags WRITE|DIRECT|NOWAIT (0x31) ops xfs_direct_write_iomap_ops caller iomap_dio_rw actor iomap_dio_actor
 xfs_ilock_nowait:     dev 259:1 ino 0x83 flags ILOCK_SHARED caller xfs_ilock_for_iomap
 xfs_iunlock:          dev 259:1 ino 0x83 flags ILOCK_SHARED caller xfs_direct_write_iomap_begin

And we exit with -EAGAIN out because we hit the allocate case trying
to make the second 4kB block.

Then IO completes on the first 4kB and the original IO context
completes and unlocks the inode, returning -EAGAIN to userspace:

 xfs_end_io_direct_write: dev 259:1 ino 0x83 isize 0x1000 disize 0x1000 offset 0x0 count 4096
 xfs_iunlock:          dev 259:1 ino 0x83 flags IOLOCK_SHARED caller xfs_file_dio_aio_write

There are other vectors to the same problem when we re-enter the
mapping code if we have to make multiple mappinfs under NOWAIT
conditions. e.g. failing trylocks, COW extents being found,
allocation being required, and so on.

Avoid all these potential problems by only allowing IOMAP_NOWAIT IO
to go ahead if the mapping we retrieve for the IO spans an entire
allocated extent. This avoids the possibility of subsequent mappings
to complete the IO from triggering NOWAIT semantics by any means as
NOWAIT IO will now only enter the mapping code once per NOWAIT IO.

Reported-and-tested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iomap.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 3abb8b9d6f4c..7b9ff824e82d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -706,6 +706,23 @@ xfs_ilock_for_iomap(
 	return 0;
 }
 
+/*
+ * Check that the imap we are going to return to the caller spans the entire
+ * range that the caller requested for the IO.
+ */
+static bool
+imap_spans_range(
+	struct xfs_bmbt_irec	*imap,
+	xfs_fileoff_t		offset_fsb,
+	xfs_fileoff_t		end_fsb)
+{
+	if (imap->br_startoff > offset_fsb)
+		return false;
+	if (imap->br_startoff + imap->br_blockcount < end_fsb)
+		return false;
+	return true;
+}
+
 static int
 xfs_direct_write_iomap_begin(
 	struct inode		*inode,
@@ -766,6 +783,18 @@ xfs_direct_write_iomap_begin(
 	if (imap_needs_alloc(inode, flags, &imap, nimaps))
 		goto allocate_blocks;
 
+	/*
+	 * NOWAIT IO needs to span the entire requested IO with a single map so
+	 * that we avoid partial IO failures due to the rest of the IO range not
+	 * covered by this map triggering an EAGAIN condition when it is
+	 * subsequently mapped and aborting the IO.
+	 */
+	if ((flags & IOMAP_NOWAIT) &&
+	    !imap_spans_range(&imap, offset_fsb, end_fsb)) {
+		error = -EAGAIN;
+		goto out_unlock;
+	}
+
 	xfs_iunlock(ip, lockmode);
 	trace_xfs_iomap_found(ip, offset, length, XFS_DATA_FORK, &imap);
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, iomap_flags);
-- 
2.28.0

