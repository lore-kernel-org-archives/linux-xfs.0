Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 972CEC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Jan 2022 23:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiAaXj2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Jan 2022 18:39:28 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:52338 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229640AbiAaXjZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jan 2022 18:39:25 -0500
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7F11A10C4C0F
        for <linux-xfs@vger.kernel.org>; Tue,  1 Feb 2022 10:39:24 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nEgGY-006aS1-Rr
        for linux-xfs@vger.kernel.org; Tue, 01 Feb 2022 10:39:22 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nEgGY-003I1w-Qf
        for linux-xfs@vger.kernel.org;
        Tue, 01 Feb 2022 10:39:22 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] xfs: remove XFS_PREALLOC_SYNC
Date:   Tue,  1 Feb 2022 10:39:16 +1100
Message-Id: <20220131233920.784181-2-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220131233920.784181-1-david@fromorbit.com>
References: <20220131233920.784181-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61f8732c
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=oGFeUVbbRNcA:10 a=20KFwNOVAAAA:8 a=QGsI9pyVmG3Z0Kn9KY0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Callers can acheive the same thing by calling xfs_log_force_inode()
after making their modifications. There is no need for
xfs_update_prealloc_flags() to do this.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c  | 13 +++++++------
 fs/xfs/xfs_inode.h |  3 +--
 fs/xfs/xfs_pnfs.c  |  6 ++++--
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 22ad207bedf4..ed375b3d0614 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -95,8 +95,6 @@ xfs_update_prealloc_flags(
 		ip->i_diflags &= ~XFS_DIFLAG_PREALLOC;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	if (flags & XFS_PREALLOC_SYNC)
-		xfs_trans_set_sync(tp);
 	return xfs_trans_commit(tp);
 }
 
@@ -1057,9 +1055,6 @@ xfs_file_fallocate(
 		}
 	}
 
-	if (file->f_flags & O_DSYNC)
-		flags |= XFS_PREALLOC_SYNC;
-
 	error = xfs_update_prealloc_flags(ip, flags);
 	if (error)
 		goto out_unlock;
@@ -1082,8 +1077,14 @@ xfs_file_fallocate(
 	 * leave shifted extents past EOF and hence losing access to
 	 * the data that is contained within them.
 	 */
-	if (do_file_insert)
+	if (do_file_insert) {
 		error = xfs_insert_file_space(ip, offset, len);
+		if (error)
+			goto out_unlock;
+	}
+
+	if (file->f_flags & O_DSYNC)
+		error = xfs_log_force_inode(ip);
 
 out_unlock:
 	xfs_iunlock(ip, iolock);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c447bf04205a..3fc6d77f5be9 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -465,8 +465,7 @@ xfs_itruncate_extents(
 enum xfs_prealloc_flags {
 	XFS_PREALLOC_SET	= (1 << 1),
 	XFS_PREALLOC_CLEAR	= (1 << 2),
-	XFS_PREALLOC_SYNC	= (1 << 3),
-	XFS_PREALLOC_INVISIBLE	= (1 << 4),
+	XFS_PREALLOC_INVISIBLE	= (1 << 3),
 };
 
 int	xfs_update_prealloc_flags(struct xfs_inode *ip,
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index d6334abbc0b3..ce6d66f20385 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -164,10 +164,12 @@ xfs_fs_map_blocks(
 		 * that the blocks allocated and handed out to the client are
 		 * guaranteed to be present even after a server crash.
 		 */
-		error = xfs_update_prealloc_flags(ip,
-				XFS_PREALLOC_SET | XFS_PREALLOC_SYNC);
+		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
+		if (!error)
+			error = xfs_log_force_inode(ip);
 		if (error)
 			goto out_unlock;
+
 	} else {
 		xfs_iunlock(ip, lock_flags);
 	}
-- 
2.33.0

