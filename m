Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 00:38:13 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6A7cBpQ017167
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 00:38:11 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: [PATCH] Introduce xfs_bmap_add_attrfork_trans.
Date: Thu, 10 Jul 2008 17:39:04 +1000
Message-Id: <1215675545-2707-4-git-send-email-xaiki@sgi.com>
In-Reply-To: <1215675545-2707-3-git-send-email-xaiki@sgi.com>
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com>
 <1215675545-2707-1-git-send-email-xaiki@sgi.com>
 <1215675545-2707-2-git-send-email-xaiki@sgi.com>
 <1215675545-2707-3-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Niv Sardi <xaiki@sgi.com>

That takes a transaction and doesn't require everything to be locked
anymore. This doesn't commit the transaction ! so direct callers,
willing to use xfs_trans_roll() should do it themselves.

Change xfs_bmap_add_attrfork to do the initialization/allocation of
the transaction and commit arround xfs_bmap_add_attrfork_trans.

Signed-off-by: Niv Sardi <xaiki@sgi.com>
---
 fs/xfs/xfs_bmap.c |  107 ++++++++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_bmap.h |   11 +++++
 2 files changed, 81 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 53c259f..231c8bc 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -3941,20 +3941,20 @@ xfs_bunmap_trace(
 #endif
 
 /*
- * Convert inode from non-attributed to attributed.
- * Must not be in a transaction, ip must not be locked.
+ * Convert inode from non-attributed to attributed (transaction 
+ * version: Use the transaction given via tpp)
  */
 int						/* error code */
-xfs_bmap_add_attrfork(
-	xfs_inode_t		*ip,		/* incore inode pointer */
+xfs_bmap_add_attrfork_trans(
+	struct xfs_trans	**tpp,		/* transaction pointer */
+	struct xfs_inode	*ip,		/* incore inode pointer */
 	int			size,		/* space new attribute needs */
 	int			rsvd)		/* xact may use reserved blks */
 {
 	xfs_fsblock_t		firstblock;	/* 1st block/ag allocated */
-	xfs_bmap_free_t		flist;		/* freed extent records */
-	xfs_mount_t		*mp;		/* mount structure */
-	xfs_trans_t		*tp;		/* transaction pointer */
-	int			blks;		/* space reservation */
+	struct xfs_bmap_free	flist;		/* freed extent records */
+	struct xfs_mount	*mp;		/* mount structure */
+	struct xfs_trans	*tp;		/* transaction pointer */
 	int			version = 1;	/* superblock attr version */
 	int			committed;	/* xaction was committed */
 	int			logflags;	/* logging flags */
@@ -3966,24 +3966,8 @@ xfs_bmap_add_attrfork(
 
 	mp = ip->i_mount;
 	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
-	tp = xfs_trans_alloc(mp, XFS_TRANS_ADDAFORK);
-	blks = XFS_ADDAFORK_SPACE_RES(mp);
-	if (rsvd)
-		tp->t_flags |= XFS_TRANS_RESERVE;
-	if ((error = xfs_trans_reserve(tp, blks, XFS_ADDAFORK_LOG_RES(mp), 0,
-			XFS_TRANS_PERM_LOG_RES, XFS_ADDAFORK_LOG_COUNT)))
-		goto error0;
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	error = XFS_TRANS_RESERVE_QUOTA_NBLKS(mp, tp, ip, blks, 0, rsvd ?
-			XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
-			XFS_QMOPT_RES_REGBLKS);
-	if (error) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
-		return error;
-	}
-	if (XFS_IFORK_Q(ip))
-		goto error1;
+	ASSERT(*tpp);
+	tp = *tpp;
 	if (ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS) {
 		/*
 		 * For inodes coming from pre-6.2 filesystems.
@@ -3991,10 +3975,7 @@ xfs_bmap_add_attrfork(
 		ASSERT(ip->i_d.di_aformat == 0);
 		ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 	}
-	ASSERT(ip->i_d.di_anextents == 0);
-	VN_HOLD(XFS_ITOV(ip));
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
 	switch (ip->i_d.di_format) {
 	case XFS_DINODE_FMT_DEV:
 		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
@@ -4014,7 +3995,7 @@ xfs_bmap_add_attrfork(
 	default:
 		ASSERT(0);
 		error = XFS_ERROR(EINVAL);
-		goto error1;
+		goto error0;
 	}
 	ip->i_df.if_ext_max =
 		XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t);
@@ -4045,7 +4026,7 @@ xfs_bmap_add_attrfork(
 	if (logflags)
 		xfs_trans_log_inode(tp, ip, logflags);
 	if (error)
-		goto error2;
+		goto error1;
 	if (!xfs_sb_version_hasattr(&mp->m_sb) ||
 	   (!xfs_sb_version_hasattr2(&mp->m_sb) && version == 2)) {
 		__int64_t sbfields = 0;
@@ -4065,14 +4046,66 @@ xfs_bmap_add_attrfork(
 		} else
 			spin_unlock(&mp->m_sb_lock);
 	}
-	if ((error = xfs_bmap_finish(&tp, &flist, &committed)))
-		goto error2;
-	error = xfs_trans_commit(tp, XFS_TRANS_PERM_LOG_RES);
+	error = xfs_bmap_finish(tpp, &flist, &committed);
+	if (error)
+		goto error1;
 	ASSERT(ip->i_df.if_ext_max ==
 	       XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t));
-	return error;
-error2:
+	return 0;
+error1:
 	xfs_bmap_cancel(&flist);
+error0:
+	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
+	ASSERT(ip->i_df.if_ext_max ==
+	       XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t));
+	return error;
+}
+
+/*
+ * Convert inode from non-attributed to attributed.
+ * Must not be in a transaction, ip must not be locked.
+ */
+int
+xfs_bmap_add_attrfork(
+	struct xfs_inode	*ip,		/* incore inode pointer */
+	int			size,		/* space new attribute needs */
+	int			rsvd)		/* xact may use reserved blks */
+{
+	struct xfs_trans	*tp;		/* transaction pointer */
+	struct xfs_mount	*mp;		/* mount structure */
+	int			blks;		/* space reservation */
+	int			error;		/* error return value */
+
+	mp = ip->i_mount;
+	tp = xfs_trans_alloc(mp, XFS_TRANS_ADDAFORK);
+	blks = XFS_ADDAFORK_SPACE_RES(mp);
+
+	if (rsvd)
+		tp->t_flags |= XFS_TRANS_RESERVE;
+	error = xfs_trans_reserve(tp, blks, XFS_ADDAFORK_LOG_RES(mp), 0,
+				XFS_TRANS_PERM_LOG_RES, XFS_ADDAFORK_LOG_COUNT);
+	if (error)
+		goto error0;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	error = XFS_TRANS_RESERVE_QUOTA_NBLKS(mp, tp, ip, blks, 0, rsvd ?
+			      XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
+			      XFS_QMOPT_RES_REGBLKS);
+	if (error)
+		goto error1;
+
+	if (XFS_IFORK_Q(ip))
+		goto error1;
+
+	ASSERT(ip->i_d.di_anextents == 0);
+	VN_HOLD(XFS_ITOV(ip));
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	error = xfs_bmap_add_attrfork_trans(&tp, ip, size, rsvd);
+	if (error)
+		return error;
+	return xfs_trans_commit(tp, XFS_TRANS_PERM_LOG_RES);
 error1:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 error0:
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index 6ff70cd..7a6b3f3 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -157,6 +157,17 @@ xfs_bmap_trace_exlist(
 #endif
 
 /*
+ * Convert inode from non-attributed to attributed (transaction 
+ * version: Use the transaction given via tpp)
+ */
+int					/* error code */
+xfs_bmap_add_attrfork_trans(
+	struct xfs_trans	**tpp,   /* transaction */
+	struct xfs_inode	*ip,	/* incore inode pointer */
+	int			size,	/* space needed for new attribute */
+	int			rsvd);	/* flag for reserved block allocation */
+
+/*
  * Convert inode from non-attributed to attributed.
  * Must not be in a transaction, ip must not be locked.
  */
-- 
1.5.6.2
