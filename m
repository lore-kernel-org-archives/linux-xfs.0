Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56364 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbfEUDrM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 23:47:12 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/7] libxfs: rename bli_format to avoid confusion with bli_formats
Date: Mon, 20 May 2019 22:47:02 -0500
Message-Id: <1558410427-1837-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
References: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Rename the bli_format structure to __bli_format to avoid
accidently confusing them with the bli_formats pointer.

(nb: userspace currently has no bli_formats pointer)

Source kernel commit: b94381737e9c4d014a4003e8ece9ba88670a2dd4

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 include/xfs_trans.h | 2 +-
 libxfs/logitem.c    | 6 +++---
 libxfs/trans.c      | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 10b7453..118fa0b 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -39,7 +39,7 @@ typedef struct xfs_buf_log_item {
 	struct xfs_buf		*bli_buf;	/* real buffer pointer */
 	unsigned int		bli_flags;	/* misc flags */
 	unsigned int		bli_recur;	/* recursion count */
-	xfs_buf_log_format_t	bli_format;	/* in-log header */
+	xfs_buf_log_format_t	__bli_format;	/* in-log header */
 } xfs_buf_log_item_t;
 
 #define XFS_BLI_DIRTY			(1<<0)
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 4da9bc1..e862ab4 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -107,9 +107,9 @@ xfs_buf_item_init(
 	bip->bli_item.li_mountp = mp;
 	INIT_LIST_HEAD(&bip->bli_item.li_trans);
 	bip->bli_buf = bp;
-	bip->bli_format.blf_type = XFS_LI_BUF;
-	bip->bli_format.blf_blkno = (int64_t)XFS_BUF_ADDR(bp);
-	bip->bli_format.blf_len = (unsigned short)BTOBB(bp->b_bcount);
+	bip->__bli_format.blf_type = XFS_LI_BUF;
+	bip->__bli_format.blf_blkno = (int64_t)XFS_BUF_ADDR(bp);
+	bip->__bli_format.blf_len = (unsigned short)BTOBB(bp->b_bcount);
 	bp->b_log_item = bip;
 }
 
diff --git a/libxfs/trans.c b/libxfs/trans.c
index f50a9b2..763daa0 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -531,8 +531,8 @@ libxfs_trans_binval(
 	xfs_buf_stale(bp);
 	bip->bli_flags |= XFS_BLI_STALE;
 	bip->bli_flags &= ~XFS_BLI_DIRTY;
-	bip->bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
-	bip->bli_format.blf_flags |= XFS_BLF_CANCEL;
+	bip->__bli_format.blf_flags &= ~XFS_BLF_INODE_BUF;
+	bip->__bli_format.blf_flags |= XFS_BLF_CANCEL;
 	set_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags);
 	tp->t_flags |= XFS_TRANS_DIRTY;
 }
-- 
1.8.3.1
