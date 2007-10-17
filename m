Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 16 Oct 2007 22:47:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9H5krRI019832
	for <xfs@oss.sgi.com>; Tue, 16 Oct 2007 22:46:55 -0700
Message-ID: <4715A22D.1070409@sgi.com>
Date: Wed, 17 Oct 2007 15:48:29 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Review: Make xfs_bulkstat() to report unlinked but referenced inodes
Content-Type: multipart/mixed;
 boundary="------------080804040807060908060006"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs mailing list <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------080804040807060908060006
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

We need xfs_bulkstat() to report inode stat for inodes with
link count zero but reference count non zero.

The fix here:

http://oss.sgi.com/archives/xfs/2007-09/msg00266.html

changed this behavior and made xfs_bulkstat() to filter all
unlinked inodes including those that are not destroyed yet but
held by reference.

The attached patch returns back to the original behavior by
marking the on-disk inode buffer "dirty" when di_mode is cleared
(at that time both inode link and reference counter are zero).

Regards,
Vlad

--------------080804040807060908060006
Content-Type: text/x-patch;
 name="Make-xfs_bulkstat-report-inodes-with-link-count-zero-and-reference-count-non-zero.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="Make-xfs_bulkstat-report-inodes-with-link-count-zero-and-ref";
 filename*1="erence-count-non-zero.patch"

Index: linux-xfs1/fs/xfs/xfs_inode.c
===================================================================
--- linux-xfs1.orig/fs/xfs/xfs_inode.c
+++ linux-xfs1/fs/xfs/xfs_inode.c
@@ -1951,24 +1951,6 @@ xfs_iunlink(
 	ASSERT(agi->agi_unlinked[bucket_index]);
 	ASSERT(be32_to_cpu(agi->agi_unlinked[bucket_index]) != agino);
 
-	error = xfs_itobp(mp, tp, ip, &dip, &ibp, 0, 0);
-	if (error)
-		return error;
-
-	/*
-	 * Clear the on-disk di_nlink. This is to prevent xfs_bulkstat
-	 * from picking up this inode when it is reclaimed (its incore state
-	 * initialzed but not flushed to disk yet). The in-core di_nlink is
-	 * already cleared in xfs_droplink() and a corresponding transaction
-	 * logged. The hack here just synchronizes the in-core to on-disk
-	 * di_nlink value in advance before the actual inode sync to disk.
-	 * This is OK because the inode is already unlinked and would never
-	 * change its di_nlink again for this inode generation.
-	 * This is a temporary hack that would require a proper fix
-	 * in the future.
-	 */
-	dip->di_core.di_nlink = 0;
-
 	if (be32_to_cpu(agi->agi_unlinked[bucket_index]) != NULLAGINO) {
 		/*
 		 * There is already another inode in the bucket we need
@@ -1976,6 +1958,10 @@ xfs_iunlink(
 		 * Here we put the head pointer into our next pointer,
 		 * and then we fall through to point the head at us.
 		 */
+		error = xfs_itobp(mp, tp, ip, &dip, &ibp, 0, 0);
+		if (error)
+			return error;
+
 		ASSERT(be32_to_cpu(dip->di_next_unlinked) == NULLAGINO);
 		/* both on-disk, don't endian flip twice */
 		dip->di_next_unlinked = agi->agi_unlinked[bucket_index];
@@ -2365,6 +2351,8 @@ xfs_ifree(
 	int			error;
 	int			delete;
 	xfs_ino_t		first_ino;
+	xfs_dinode_t    	*dip;
+	xfs_buf_t       	*ibp;
 
 	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
 	ASSERT(ip->i_transp == tp);
@@ -2400,8 +2388,27 @@ xfs_ifree(
 	 * by reincarnations of this inode.
 	 */
 	ip->i_d.di_gen++;
+
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
+	error = xfs_itobp(ip->i_mount, tp, ip, &dip, &ibp, 0, 0);
+	if (error)
+		return error;
+
+        /*
+	* Clear the on-disk di_mode. This is to prevent xfs_bulkstat
+	* from picking up this inode when it is reclaimed (its incore state
+	* initialzed but not flushed to disk yet). The in-core di_mode is
+	* already cleared  and a corresponding transaction logged.
+	* The hack here just synchronizes the in-core to on-disk
+	* di_mode value in advance before the actual inode sync to disk.
+	* This is OK because the inode is already unlinked and would never
+	* change its di_mode again for this inode generation.
+	* This is a temporary hack that would require a proper fix
+	* in the future.
+	*/
+	dip->di_core.di_mode = 0;
+
 	if (delete) {
 		xfs_ifree_cluster(ip, tp, first_ino);
 	}
Index: linux-xfs1/fs/xfs/xfs_itable.c
===================================================================
--- linux-xfs1.orig/fs/xfs/xfs_itable.c
+++ linux-xfs1/fs/xfs/xfs_itable.c
@@ -291,7 +291,7 @@ xfs_bulkstat_use_dinode(
 	dip = (xfs_dinode_t *)
 			xfs_buf_offset(bp, clustidx << mp->m_sb.sb_inodelog);
 	/*
-	 * Check the buffer containing the on-disk inode for di_nlink == 0.
+	 * Check the buffer containing the on-disk inode for di_mode == 0.
 	 * This is to prevent xfs_bulkstat from picking up just reclaimed
 	 * inodes that have their in-core state initialized but not flushed
 	 * to disk yet. This is a temporary hack that would require a proper
@@ -299,7 +299,7 @@ xfs_bulkstat_use_dinode(
 	 */
 	if (be16_to_cpu(dip->di_core.di_magic) != XFS_DINODE_MAGIC ||
 	    !XFS_DINODE_GOOD_VERSION(dip->di_core.di_version) ||
-	    !dip->di_core.di_nlink)
+	    !dip->di_core.di_mode)
 		return 0;
 	if (flags & BULKSTAT_FG_QUICK) {
 		*dipp = dip;

--------------080804040807060908060006--
