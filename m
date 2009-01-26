Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0Q7WhrT203670 for <xfs@oss.sgi.com>; Mon, 26 Jan 2009 01:32:43 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC48B185E8EA
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id q6KHVcev4zfXs37x for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 23:32:00 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LRLwu-0002z5-0f
	for xfs@oss.sgi.com; Mon, 26 Jan 2009 07:32:00 +0000
Message-Id: <20090126073159.820491000@bombadil.infradead.org>
Date: Mon, 26 Jan 2009 02:31:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/17] xfs: cleanup error handling in xfs_mountfs:
References: <20090126073136.384490000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xfs_mountfs
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Clean up the error handling in xfs_mountfs.  Use readable goto label names,
simplify the uuid handling and other error conditions.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2009-01-24 18:02:18.279779227 +0100
+++ xfs/fs/xfs/xfs_mount.c	2009-01-24 18:02:20.240779188 +0100
@@ -886,8 +886,6 @@ xfs_check_sizes(xfs_mount_t *mp)
 }
 
 /*
- * xfs_mountfs
- *
  * This function does the following on an initial mount of a file system:
  *	- reads the superblock from disk and init the mount struct
  *	- if we're a 32-bit kernel, do a size check on the superblock
@@ -905,7 +903,6 @@ xfs_mountfs(
 	xfs_inode_t	*rip;
 	__uint64_t	resblks;
 	uint		quotamount, quotaflags;
-	int		uuid_mounted = 0;
 	int		error = 0;
 
 	xfs_mount_common(mp, sbp);
@@ -960,7 +957,7 @@ xfs_mountfs(
 	 */
 	error = xfs_update_alignment(mp);
 	if (error)
-		goto error1;
+		goto out;
 
 	xfs_alloc_compute_maxlevels(mp);
 	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
@@ -977,12 +974,11 @@ xfs_mountfs(
 	 * since a single partition filesystem is identical to a single
 	 * partition volume/filesystem.
 	 */
-	if ((mp->m_flags & XFS_MOUNT_NOUUID) == 0) {
+	if (!(mp->m_flags & XFS_MOUNT_NOUUID)) {
 		if (xfs_uuid_mount(mp)) {
 			error = XFS_ERROR(EINVAL);
-			goto error1;
+			goto out;
 		}
-		uuid_mounted=1;
 	}
 
 	/*
@@ -1007,7 +1003,7 @@ xfs_mountfs(
 	 */
 	error = xfs_check_sizes(mp);
 	if (error)
-		goto error1;
+		goto out_remove_uuid;
 
 	/*
 	 * Initialize realtime fields in the mount structure
@@ -1015,7 +1011,7 @@ xfs_mountfs(
 	error = xfs_rtmount_init(mp);
 	if (error) {
 		cmn_err(CE_WARN, "XFS: RT mount failed");
-		goto error1;
+		goto out_remove_uuid;
 	}
 
 	/*
@@ -1045,26 +1041,26 @@ xfs_mountfs(
 	mp->m_perag = kmem_zalloc(sbp->sb_agcount * sizeof(xfs_perag_t),
 				  KM_MAYFAIL);
 	if (!mp->m_perag)
-		goto error1;
+		goto out_remove_uuid;
 
 	mp->m_maxagi = xfs_initialize_perag(mp, sbp->sb_agcount);
 
+	if (!sbp->sb_logblocks) {
+		cmn_err(CE_WARN, "XFS: no log defined");
+		XFS_ERROR_REPORT("xfs_mountfs", XFS_ERRLEVEL_LOW, mp);
+		error = XFS_ERROR(EFSCORRUPTED);
+		goto out_free_perag;
+	}
+
 	/*
 	 * log's mount-time initialization. Perform 1st part recovery if needed
 	 */
-	if (likely(sbp->sb_logblocks > 0)) {	/* check for volume case */
-		error = xfs_log_mount(mp, mp->m_logdev_targp,
-				      XFS_FSB_TO_DADDR(mp, sbp->sb_logstart),
-				      XFS_FSB_TO_BB(mp, sbp->sb_logblocks));
-		if (error) {
-			cmn_err(CE_WARN, "XFS: log mount failed");
-			goto error2;
-		}
-	} else {	/* No log has been defined */
-		cmn_err(CE_WARN, "XFS: no log defined");
-		XFS_ERROR_REPORT("xfs_mountfs_int(1)", XFS_ERRLEVEL_LOW, mp);
-		error = XFS_ERROR(EFSCORRUPTED);
-		goto error2;
+	error = xfs_log_mount(mp, mp->m_logdev_targp,
+			      XFS_FSB_TO_DADDR(mp, sbp->sb_logstart),
+			      XFS_FSB_TO_BB(mp, sbp->sb_logblocks));
+	if (error) {
+		cmn_err(CE_WARN, "XFS: log mount failed");
+		goto out_free_perag;
 	}
 
 	/*
@@ -1086,15 +1082,14 @@ xfs_mountfs(
 	 * If we are currently making the filesystem, the initialisation will
 	 * fail as the perag data is in an undefined state.
 	 */
-
 	if (xfs_sb_version_haslazysbcount(&mp->m_sb) &&
 	    !XFS_LAST_UNMOUNT_WAS_CLEAN(mp) &&
 	     !mp->m_sb.sb_inprogress) {
 		error = xfs_initialize_perag_data(mp, sbp->sb_agcount);
-		if (error) {
-			goto error2;
-		}
+		if (error)
+			goto out_free_perag;
 	}
+
 	/*
 	 * Get and sanity-check the root inode.
 	 * Save the pointer to it in the mount structure.
@@ -1102,7 +1097,7 @@ xfs_mountfs(
 	error = xfs_iget(mp, NULL, sbp->sb_rootino, 0, XFS_ILOCK_EXCL, &rip, 0);
 	if (error) {
 		cmn_err(CE_WARN, "XFS: failed to read root inode");
-		goto error3;
+		goto out_log_dealloc;
 	}
 
 	ASSERT(rip != NULL);
@@ -1116,7 +1111,7 @@ xfs_mountfs(
 		XFS_ERROR_REPORT("xfs_mountfs_int(2)", XFS_ERRLEVEL_LOW,
 				 mp);
 		error = XFS_ERROR(EFSCORRUPTED);
-		goto error4;
+		goto out_rele_rip;
 	}
 	mp->m_rootip = rip;	/* save it */
 
@@ -1131,7 +1126,7 @@ xfs_mountfs(
 		 * Free up the root inode.
 		 */
 		cmn_err(CE_WARN, "XFS: failed to read RT inodes");
-		goto error4;
+		goto out_rele_rip;
 	}
 
 	/*
@@ -1143,7 +1138,7 @@ xfs_mountfs(
 		error = xfs_mount_log_sb(mp, mp->m_update_flags);
 		if (error) {
 			cmn_err(CE_WARN, "XFS: failed to write sb changes");
-			goto error4;
+			goto out_rele_rip;
 		}
 	}
 
@@ -1152,7 +1147,7 @@ xfs_mountfs(
 	 */
 	error = XFS_QM_INIT(mp, &quotamount, &quotaflags);
 	if (error)
-		goto error4;
+		goto out_rele_rip;
 
 	/*
 	 * Finish recovering the file system.  This part needed to be
@@ -1162,7 +1157,7 @@ xfs_mountfs(
 	error = xfs_log_mount_finish(mp);
 	if (error) {
 		cmn_err(CE_WARN, "XFS: log mount finish failed");
-		goto error4;
+		goto out_rele_rip;
 	}
 
 	/*
@@ -1170,7 +1165,7 @@ xfs_mountfs(
 	 */
 	error = XFS_QM_MOUNT(mp, quotamount, quotaflags);
 	if (error)
-		goto error4;
+		goto out_rele_rip;
 
 	/*
 	 * Now we are mounted, reserve a small amount of unused space for
@@ -1194,18 +1189,16 @@ xfs_mountfs(
 
 	return 0;
 
- error4:
-	/*
-	 * Free up the root inode.
-	 */
+ out_rele_rip:
 	IRELE(rip);
- error3:
+ out_log_dealloc:
 	xfs_log_unmount_dealloc(mp);
- error2:
+ out_free_perag:
 	xfs_free_perag(mp);
- error1:
-	if (uuid_mounted)
+ out_remove_uuid:
+	if (!(mp->m_flags & XFS_MOUNT_NOUUID))
 		uuid_table_remove(&mp->m_sb.sb_uuid);
+ out:
 	return error;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
