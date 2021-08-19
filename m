Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD620C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 03:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A280610CB
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Aug 2021 03:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236313AbhHSDqM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 23:46:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236271AbhHSDqL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Aug 2021 23:46:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C3FD6109E;
        Thu, 19 Aug 2021 03:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629344736;
        bh=PgZJp64WbAY3YxHmm+m+8UrMuxarex8mQ8pjbGr6/Nw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K4a4wtvq2yNZfwS/y5VVGWHdNQdhWfVAbCl/moDQTBlyNjJF7DOP32o+hhgEhFir0
         YhCienYNuypDUiUZzTWAqrkijkbErsUVWW2KhLejZ6rs5pnqodKZ0vxfFe9RAgxSpo
         +2aYEVNQs+p5QYO0dbH8iMEenLIMF12AubgtcqPCoyIFA0wjbfdThuUCulSQP6dwfr
         IAMme/QoSxzdZSrUmjWkAt/+hbsMIW2KzOeeYMiOFMr+kA/HCMiAfoIhZWRILv4/gS
         sXZ53FC8pBU/mVZWtuUaS5fxK1T+Pd3ESV7rif2McIP9f26rLAapIu6DwyJlyDifeD
         1HT+2LSblHZXg==
Date:   Wed, 18 Aug 2021 20:45:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 10/15] xfs: disambiguate units for ftrace fields tagged
 "count"
Message-ID: <20210819034536.GQ12640@magnolia>
References: <162924373176.761813.10896002154570305865.stgit@magnolia>
 <162924378705.761813.11309968953103960937.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924378705.761813.11309968953103960937.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Some of our tracepoints have a field known as "count".  That name
doesn't describe any units, which makes the fields not very useful.
Rename the fields to capture units and ensure the format is hexadecimal
when we're referring to blocks, extents, or IO operations.

"fsbcount" are in units of fs blocks
"bytecount" are in units of bytes
"ireccount" are in units of inode records

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: rename the count units
---
 fs/xfs/xfs_trace.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4169dc6cb5b9..cc479caffd55 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -346,7 +346,7 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d ino 0x%llx state %s cur %p/%d "
-		  "fileoff 0x%llx startblock 0x%llx count %lld flag %d caller %pS",
+		  "fileoff 0x%llx startblock 0x%llx fsbcount 0x%llx flag %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS),
@@ -1392,7 +1392,7 @@ DECLARE_EVENT_CLASS(xfs_file_class,
 		__entry->offset = iocb->ki_pos;
 		__entry->count = iov_iter_count(iter);
 	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx pos 0x%llx count 0x%zx",
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx pos 0x%llx bytecount 0x%zx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->size,
@@ -1439,7 +1439,7 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
 		__entry->startblock = irec ? irec->br_startblock : 0;
 		__entry->blockcount = irec ? irec->br_blockcount : 0;
 	),
-	TP_printk("dev %d:%d ino 0x%llx size 0x%llx pos 0x%llx count %zd "
+	TP_printk("dev %d:%d ino 0x%llx size 0x%llx pos 0x%llx bytecount 0x%zx "
 		  "fork %s startoff 0x%llx startblock 0x%llx fsbcount 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
@@ -1482,7 +1482,7 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
 		__entry->count = count;
 	),
 	TP_printk("dev %d:%d ino 0x%llx isize 0x%llx disize 0x%llx "
-		  "pos 0x%llx count %zd",
+		  "pos 0x%llx bytecount 0x%zx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->isize,
@@ -3227,7 +3227,7 @@ DECLARE_EVENT_CLASS(xfs_double_io_class,
 		__field(loff_t, src_isize)
 		__field(loff_t, src_disize)
 		__field(loff_t, src_offset)
-		__field(size_t, len)
+		__field(long long, len)
 		__field(xfs_ino_t, dest_ino)
 		__field(loff_t, dest_isize)
 		__field(loff_t, dest_disize)
@@ -3245,7 +3245,7 @@ DECLARE_EVENT_CLASS(xfs_double_io_class,
 		__entry->dest_disize = dest->i_disk_size;
 		__entry->dest_offset = doffset;
 	),
-	TP_printk("dev %d:%d count %zd "
+	TP_printk("dev %d:%d bytecount 0x%llx "
 		  "ino 0x%llx isize 0x%llx disize 0x%llx pos 0x%llx -> "
 		  "ino 0x%llx isize 0x%llx disize 0x%llx pos 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
