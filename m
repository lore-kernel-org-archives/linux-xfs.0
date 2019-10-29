Return-Path: <SRS0=yuEF=YW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E37CA9EAE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 22:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3CAC2087E
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Oct 2019 22:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbfJ2Wh6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Oct 2019 18:37:58 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:39717 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbfJ2Wh6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 18:37:58 -0400
Received: from dread.disaster.area (pa49-180-67-183.pa.nsw.optusnet.com.au [49.180.67.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9D2D843F5AF
        for <linux-xfs@vger.kernel.org>; Wed, 30 Oct 2019 09:37:54 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iPa7d-0006fE-55
        for linux-xfs@vger.kernel.org; Wed, 30 Oct 2019 09:37:53 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iPa7d-0007RP-0N
        for linux-xfs@vger.kernel.org; Wed, 30 Oct 2019 09:37:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V2] xfs: properly serialise fallocate against AIO+DIO
Date:   Wed, 30 Oct 2019 09:37:52 +1100
Message-Id: <20191029223752.28562-1-david@fromorbit.com>
X-Mailer: git-send-email 2.24.0.rc0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=3wLbm4YUAFX2xaPZIabsgw==:117 a=3wLbm4YUAFX2xaPZIabsgw==:17
        a=XobE76Q3jBoA:10 a=20KFwNOVAAAA:8 a=WUWNor0LOpfXaxb9K2cA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

AIO+DIO can extend the file size on IO completion, and it holds
no inode locks while the IO is in flight. Therefore, a race
condition exists in file size updates if we do something like this:

aio-thread			fallocate-thread

lock inode
submit IO beyond inode->i_size
unlock inode
.....
				lock inode
				break layouts
				if (off + len > inode->i_size)
					new_size = off + len
				.....
				inode_dio_wait()
				<blocks>
.....
completes
inode->i_size updated
inode_dio_done()
....
				<wakes>
				<does stuff no long beyond EOF>
				if (new_size)
					xfs_vn_setattr(inode, new_size)


Yup, that attempt to extend the file size in the fallocate code
turns into a truncate - it removes the whatever the aio write
allocated and put to disk, and reduced the inode size back down to
where the fallocate operation ends.

Fundamentally, xfs_file_fallocate()  not compatible with racing
AIO+DIO completions, so we need to move the inode_dio_wait() call
up to where the lock the inode and break the layouts.

Secondly, storing the inode size and then using it unchecked without
holding the ILOCK is not safe; we can only do such a thing if we've
locked out and drained all IO and other modification operations,
which we don't do initially in xfs_file_fallocate.

It should be noted that some of the fallocate operations are
compound operations - they are made up of multiple manipulations
that may zero data, and so we may need to flush and invalidate the
file multiple times during an operation. However, we only need to
lock out IO and other space manipulation operations once, as that
lockout is maintained until the entire fallocate operation has been
completed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c |  8 +-------
 fs/xfs/xfs_file.c      | 23 +++++++++++++++++++++++
 fs/xfs/xfs_ioctl.c     |  1 +
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index fb31d7d6701e..dea68308fb64 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1040,6 +1040,7 @@ xfs_unmap_extent(
 	goto out_unlock;
 }
 
+/* Caller must first wait for the completion of any pending DIOs if required. */
 int
 xfs_flush_unmap_range(
 	struct xfs_inode	*ip,
@@ -1051,9 +1052,6 @@ xfs_flush_unmap_range(
 	xfs_off_t		rounding, start, end;
 	int			error;
 
-	/* wait for the completion of any pending DIOs */
-	inode_dio_wait(inode);
-
 	rounding = max_t(xfs_off_t, 1 << mp->m_sb.sb_blocklog, PAGE_SIZE);
 	start = round_down(offset, rounding);
 	end = round_up(offset + len, rounding) - 1;
@@ -1085,10 +1083,6 @@ xfs_free_file_space(
 	if (len <= 0)	/* if nothing being freed */
 		return 0;
 
-	error = xfs_flush_unmap_range(ip, offset, len);
-	if (error)
-		return error;
-
 	startoffset_fsb = XFS_B_TO_FSB(mp, offset);
 	endoffset_fsb = XFS_B_TO_FSBT(mp, offset + len);
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 525b29b99116..46fc5629369b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -817,6 +817,29 @@ xfs_file_fallocate(
 	if (error)
 		goto out_unlock;
 
+	/*
+	 * Must wait for all AIO to complete before we continue as AIO can
+	 * change the file size on completion without holding any locks we
+	 * currently hold. We must do this first because AIO can update both
+	 * the on disk and in memory inode sizes, and the operations that follow
+	 * require the in-memory size to be fully up-to-date.
+	 */
+	inode_dio_wait(inode);
+
+	/*
+	 * Now that AIO and DIO has drained we can flush and (if necessary)
+	 * invalidate the cached range over the first operation we are about to
+	 * run. We include zero and collapse here because they both start with a
+	 * hole punch over the target range. Insert and collapse both invalidate
+	 * the broader range affected by the shift in xfs_prepare_shift().
+	 */
+	if (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE |
+		    FALLOC_FL_COLLAPSE_RANGE)) {
+		error = xfs_flush_unmap_range(ip, offset, len);
+		if (error)
+			goto out_unlock;
+	}
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 287f83eb791f..800f07044636 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -623,6 +623,7 @@ xfs_ioc_space(
 	error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
 	if (error)
 		goto out_unlock;
+	inode_dio_wait(inode);
 
 	switch (bf->l_whence) {
 	case 0: /*SEEK_SET*/
-- 
2.24.0.rc0

