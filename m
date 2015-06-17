Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6B7ED7F9D
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 05:55:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6163D304070
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 03:55:03 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Hh5bl2sNwghUTnOD (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Jun 2015 03:55:01 -0700 (PDT)
Received: from [88.128.80.44] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z5Azk-0002CN-CU
	for xfs@oss.sgi.com; Wed, 17 Jun 2015 10:55:00 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] libxfs: remove the flags argument to xfs_trans_cancel
Date: Wed, 17 Jun 2015 12:53:00 +0200
Message-Id: <1434538381-4847-4-git-send-email-hch@lst.de>
In-Reply-To: <1434538381-4847-1-git-send-email-hch@lst.de>
References: <1434538381-4847-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Synchronize with the kernel changes that dropped the argument.  Unlike the
kernel libxfs always ignored the flags anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_trans.h |  2 +-
 libxfs/trans.c      |  3 +--
 libxfs/util.c       |  4 ++--
 libxfs/xfs_attr.c   | 18 +++++++-----------
 libxfs/xfs_bmap.c   | 11 ++++-------
 libxfs/xfs_sb.c     |  2 +-
 libxfs/xfs_shared.h |  1 -
 repair/phase6.c     |  5 ++---
 repair/phase7.c     |  2 +-
 9 files changed, 19 insertions(+), 29 deletions(-)

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 46c2955..9180575 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -90,7 +90,7 @@ xfs_trans_t	*libxfs_trans_alloc(struct xfs_mount *, int);
 int	libxfs_trans_reserve(struct xfs_trans *, struct xfs_trans_res *,
 				     uint, uint);
 int	libxfs_trans_commit(struct xfs_trans *, uint);
-void	libxfs_trans_cancel(struct xfs_trans *, int);
+void	libxfs_trans_cancel(struct xfs_trans *);
 struct xfs_buf *libxfs_trans_getsb(struct xfs_trans *, struct xfs_mount *, int);
 
 int	libxfs_trans_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 866c379..ef9c510 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -200,8 +200,7 @@ libxfs_trans_reserve(
 
 void
 libxfs_trans_cancel(
-	xfs_trans_t	*tp,
-	int		flags)
+	xfs_trans_t	*tp)
 {
 #ifdef XACT_DEBUG
 	xfs_trans_t	*otp = tp;
diff --git a/libxfs/util.c b/libxfs/util.c
index daebbe2..491c358 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -572,7 +572,7 @@ libxfs_alloc_file_space(
 			 * Free the transaction structure.
 			 */
 			ASSERT(error == -ENOSPC);
-			xfs_trans_cancel(tp, 0);
+			xfs_trans_cancel(tp);
 			break;
 		}
 		xfs_trans_ijoin(tp, ip, 0);
@@ -605,7 +605,7 @@ libxfs_alloc_file_space(
 
 error0:	/* Cancel bmap, cancel trans */
 	xfs_bmap_cancel(&free_list);
-	xfs_trans_cancel(tp, 0);
+	xfs_trans_cancel(tp);
 	return error;
 }
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index f8c24f6..b4c1e92 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -261,7 +261,7 @@ xfs_attr_set(
 	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
 	error = xfs_trans_reserve(args.trans, &tres, args.total, 0);
 	if (error) {
-		xfs_trans_cancel(args.trans, 0);
+		xfs_trans_cancel(args.trans);
 		return error;
 	}
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
@@ -271,7 +271,7 @@ xfs_attr_set(
 				       XFS_QMOPT_RES_REGBLKS);
 	if (error) {
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
-		xfs_trans_cancel(args.trans, XFS_TRANS_RELEASE_LOG_RES);
+		xfs_trans_cancel(args.trans);
 		return error;
 	}
 
@@ -384,10 +384,8 @@ xfs_attr_set(
 	return error;
 
 out:
-	if (args.trans) {
-		xfs_trans_cancel(args.trans,
-			XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
-	}
+	if (args.trans)
+		xfs_trans_cancel(args.trans);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return error;
 }
@@ -457,7 +455,7 @@ xfs_attr_remove(
 	error = xfs_trans_reserve(args.trans, &M_RES(mp)->tr_attrrm,
 				  XFS_ATTRRM_SPACE_RES(mp), 0);
 	if (error) {
-		xfs_trans_cancel(args.trans, 0);
+		xfs_trans_cancel(args.trans);
 		return error;
 	}
 
@@ -502,10 +500,8 @@ xfs_attr_remove(
 	return error;
 
 out:
-	if (args.trans) {
-		xfs_trans_cancel(args.trans,
-			XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
-	}
+	if (args.trans)
+		xfs_trans_cancel(args.trans);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return error;
 }
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index e6d1e6c..a2e7764 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1104,7 +1104,6 @@ xfs_bmap_add_attrfork(
 	int			committed;	/* xaction was committed */
 	int			logflags;	/* logging flags */
 	int			error;		/* error return value */
-	int			cancel_flags = 0;
 
 	ASSERT(XFS_IFORK_Q(ip) == 0);
 
@@ -1116,17 +1115,15 @@ xfs_bmap_add_attrfork(
 		tp->t_flags |= XFS_TRANS_RESERVE;
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_addafork, blks, 0);
 	if (error) {
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		return error;
 	}
-	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
 			XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
 			XFS_QMOPT_RES_REGBLKS);
 	if (error)
 		goto trans_cancel;
-	cancel_flags |= XFS_TRANS_ABORT;
 	if (XFS_IFORK_Q(ip))
 		goto trans_cancel;
 	if (ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS) {
@@ -1217,7 +1214,7 @@ xfs_bmap_add_attrfork(
 bmap_cancel:
 	xfs_bmap_cancel(&flist);
 trans_cancel:
-	xfs_trans_cancel(tp, cancel_flags);
+	xfs_trans_cancel(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
@@ -5903,7 +5900,7 @@ xfs_bmap_split_extent(
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
 			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
 	if (error) {
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		return error;
 	}
 
@@ -5925,6 +5922,6 @@ xfs_bmap_split_extent(
 
 
 out:
-	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
+	xfs_trans_cancel(tp);
 	return error;
 }
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index d528a3f..07dc2a6 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -798,7 +798,7 @@ xfs_sync_sb(
 	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_CHANGE, KM_SLEEP);
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_sb, 0, 0);
 	if (error) {
-		xfs_trans_cancel(tp, 0);
+		xfs_trans_cancel(tp);
 		return error;
 	}
 
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 8dda4b3..930cc7d 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -185,7 +185,6 @@ int	xfs_log_calc_minimum_size(struct xfs_mount *);
  * Values for call flags parameter.
  */
 #define	XFS_TRANS_RELEASE_LOG_RES	0x4
-#define	XFS_TRANS_ABORT			0x8
 
 /*
  * Field values for xfs_trans_mod_sb.
diff --git a/repair/phase6.c b/repair/phase6.c
index 130ed4f..bbd005e 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1403,7 +1403,7 @@ _("name create failed in ino %" PRIu64 " (%d), filesystem may be out of space\n"
 
 out_bmap_cancel:
 	libxfs_bmap_cancel(&flist);
-	libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
+	libxfs_trans_cancel(tp);
 	return;
 }
 
@@ -2949,8 +2949,7 @@ process_dir_inode(
 					XFS_TRANS_RELEASE_LOG_RES |
 					XFS_TRANS_SYNC);
 			} else  {
-				libxfs_trans_cancel(tp,
-					XFS_TRANS_RELEASE_LOG_RES);
+				libxfs_trans_cancel(tp);
 			}
 			break;
 
diff --git a/repair/phase7.c b/repair/phase7.c
index becacf8..926dda0 100644
--- a/repair/phase7.c
+++ b/repair/phase7.c
@@ -93,7 +93,7 @@ update_inode_nlinks(
 	set_nlinks(&ip->i_d, ino, nlinks, &dirty);
 
 	if (!dirty)  {
-		libxfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
+		libxfs_trans_cancel(tp);
 	} else  {
 		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 		/*
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
