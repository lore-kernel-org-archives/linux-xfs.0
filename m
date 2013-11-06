Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 464A429E30
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 15:23:14 -0600 (CST)
Received: from eagdhcp-232-150.americas.sgi.com
	(eagdhcp-232-150.americas.sgi.com [128.162.232.150])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0C0C48F804B
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 13:23:11 -0800 (PST)
Received: from eagdhcp-232-150.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-150.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	rA6LMwlW040153
	for <xfs@oss.sgi.com>; Wed, 6 Nov 2013 15:22:58 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-150.americas.sgi.com)
Message-Id: <20131106211618.754470168@sgi.com>
Date: Wed, 06 Nov 2013 15:14:58 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH v2] xfs: fix unlock in xfs_bmap_add_attrfork
Content-Disposition: inline;
	filename=v2-xfs-fix-unlock-in-xfs_bmap_add_attrfork.patch
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

xfs_trans_ijoin() activates the inode in a transaction and
also can specify which lock to free when the transaction is
committed or canceled.

xfs_bmap_add_attrfork call locks and add the lock to the
transaction but also manually removes the lock. Change the
routine to not add the lock to the transaction and manually
remove lock on completion.

While here, clean up the xfs_trans_cancel flags and goto names.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
v2 per Dave's suggestion:
   remove the lock from the transaction
   adjust the cancel_flags.

 fs/xfs/xfs_bmap.c |   37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

Index: b/fs/xfs/xfs_bmap.c
===================================================================
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -1137,6 +1137,7 @@ xfs_bmap_add_attrfork(
 	int			committed;	/* xaction was committed */
 	int			logflags;	/* logging flags */
 	int			error;		/* error return value */
+	int			cancel_flags = 0;
 
 	ASSERT(XFS_IFORK_Q(ip) == 0);
 
@@ -1147,19 +1148,20 @@ xfs_bmap_add_attrfork(
 	if (rsvd)
 		tp->t_flags |= XFS_TRANS_RESERVE;
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_addafork, blks, 0);
-	if (error)
-		goto error0;
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		return error;
+	}
+	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
 			XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
 			XFS_QMOPT_RES_REGBLKS);
-	if (error) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
-		return error;
-	}
+	if (error)
+		goto trans_cancel;
+	cancel_flags |= XFS_TRANS_ABORT;
 	if (XFS_IFORK_Q(ip))
-		goto error1;
+		goto trans_cancel;
 	if (ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS) {
 		/*
 		 * For inodes coming from pre-6.2 filesystems.
@@ -1169,7 +1171,7 @@ xfs_bmap_add_attrfork(
 	}
 	ASSERT(ip->i_d.di_anextents == 0);
 
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	switch (ip->i_d.di_format) {
@@ -1191,7 +1193,7 @@ xfs_bmap_add_attrfork(
 	default:
 		ASSERT(0);
 		error = XFS_ERROR(EINVAL);
-		goto error1;
+		goto trans_cancel;
 	}
 
 	ASSERT(ip->i_afp == NULL);
@@ -1219,7 +1221,7 @@ xfs_bmap_add_attrfork(
 	if (logflags)
 		xfs_trans_log_inode(tp, ip, logflags);
 	if (error)
-		goto error2;
+		goto bmap_cancel;
 	if (!xfs_sb_version_hasattr(&mp->m_sb) ||
 	   (!xfs_sb_version_hasattr2(&mp->m_sb) && version == 2)) {
 		__int64_t sbfields = 0;
@@ -1242,14 +1244,15 @@ xfs_bmap_add_attrfork(
 
 	error = xfs_bmap_finish(&tp, &flist, &committed);
 	if (error)
-		goto error2;
-	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-error2:
+		goto bmap_cancel;
+	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+	goto unlock_return;
+bmap_cancel:
 	xfs_bmap_cancel(&flist);
-error1:
+trans_cancel:
+	xfs_trans_cancel(tp, cancel_flags);
+unlock_return:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-error0:
-	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
 	return error;
 }
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
