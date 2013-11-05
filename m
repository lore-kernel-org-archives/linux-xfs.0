Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 800BA7FC8
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 14:38:27 -0600 (CST)
Received: from eagdhcp-232-150.americas.sgi.com
	(eagdhcp-232-150.americas.sgi.com [128.162.232.150])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 49B8430406A
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 12:38:27 -0800 (PST)
Received: from eagdhcp-232-150.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-150.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	rA5KcGNr034043
	for <xfs@oss.sgi.com>; Tue, 5 Nov 2013 14:38:16 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-150.americas.sgi.com)
Message-Id: <20131105202719.667077352@eagdhcp-232-150.americas.sgi.com>
Date: Tue, 05 Nov 2013 14:27:07 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfs: fix unlock in xfs_bmap_add_attrfork
Content-Disposition: inline;
	filename=xfs-fix-unlock-in-xfs_bmap_add_attrfork.patch
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

xfs_bmap_add_attrfork adds the XFS_ILOCK_EXCL flag when calling
xfs_trans_ijoin() so it wrong to also free this lock before doing
a xfs_trans_cancel. Add the unlock to the error case before the
xfs_trans_ijoin and remove the unlock from the error recovery.
While here, clean up the goto names.

It seem doubtful that this routine fails, I found this visually
looking for another issue.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_bmap.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

Index: b/fs/xfs/xfs_bmap.c
===================================================================
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -1137,9 +1137,11 @@ xfs_bmap_add_attrfork(
 	int			committed;	/* xaction was committed */
 	int			logflags;	/* logging flags */
 	int			error;		/* error return value */
+	int			cancel_flags;
 
 	ASSERT(XFS_IFORK_Q(ip) == 0);
 
+	cancel_flags = XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT;
 	mp = ip->i_mount;
 	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 	tp = xfs_trans_alloc(mp, XFS_TRANS_ADDAFORK);
@@ -1148,18 +1150,20 @@ xfs_bmap_add_attrfork(
 		tp->t_flags |= XFS_TRANS_RESERVE;
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_addafork, blks, 0);
 	if (error)
-		goto error0;
+		goto trans_cancel;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
 			XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
 			XFS_QMOPT_RES_REGBLKS);
 	if (error) {
+		cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
-		return error;
+		goto trans_cancel;
+	}
+	if (XFS_IFORK_Q(ip)) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		goto trans_cancel;
 	}
-	if (XFS_IFORK_Q(ip))
-		goto error1;
 	if (ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS) {
 		/*
 		 * For inodes coming from pre-6.2 filesystems.
@@ -1191,7 +1195,7 @@ xfs_bmap_add_attrfork(
 	default:
 		ASSERT(0);
 		error = XFS_ERROR(EINVAL);
-		goto error1;
+		goto trans_cancel;
 	}
 
 	ASSERT(ip->i_afp == NULL);
@@ -1219,7 +1223,7 @@ xfs_bmap_add_attrfork(
 	if (logflags)
 		xfs_trans_log_inode(tp, ip, logflags);
 	if (error)
-		goto error2;
+		goto bmap_cancel;
 	if (!xfs_sb_version_hasattr(&mp->m_sb) ||
 	   (!xfs_sb_version_hasattr2(&mp->m_sb) && version == 2)) {
 		__int64_t sbfields = 0;
@@ -1242,14 +1246,12 @@ xfs_bmap_add_attrfork(
 
 	error = xfs_bmap_finish(&tp, &flist, &committed);
 	if (error)
-		goto error2;
+		goto bmap_cancel;
 	return xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
-error2:
+bmap_cancel:
 	xfs_bmap_cancel(&flist);
-error1:
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-error0:
-	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
+trans_cancel:
+	xfs_trans_cancel(tp, cancel_flags);
 	return error;
 }
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
