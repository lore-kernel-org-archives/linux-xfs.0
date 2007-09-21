Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Sep 2007 23:34:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8L6Xqgf013972
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2007 23:33:54 -0700
Message-ID: <46F36639.3050004@sgi.com>
Date: Fri, 21 Sep 2007 16:35:37 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Review: get_bulkall() returns incorrect inode state
Content-Type: multipart/mixed;
 boundary="------------050703030108060701050103"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------050703030108060701050103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

In the following scenario xfs_bulkstat() returns incorrect
stale inode state:

1. File_A is created and its inode synced to disk.
2. File_A is unlinked and doesn't exist anymore.
3. Filesystem sync is invoked.
4. File_B is created. File_B happens to reclaim File_A's inode.
5. xfs_bulkstat() is called and detects File_B but reports the
  incorrect File_A inode state.

Explanation for the incorrect inode state is that inodes are not immediately
synced on file create for performance reasons. This leaves the on-disk inode
buffer uninitialized (or with old state from a previous generation inode)
and this is what xfs_bulkstat() would report.

Solutions:

One solution provided by the attached patch is to mark the on-disk
inode buffer "dirty" on unlink. When the inode is reclaimed
(by a new file create), xfs_bulkstat() would filter this inode by the
"dirty" mark. Once the inode is flushed to disk, the on-disk buffer "dirty"
mark is automatically removed and a following xfs_bulkstat() would return
the correct inode state.

A better solution would be if the inode is immediately synced at create.
This would make the on-disk inode buffer up to date and xfs_bulkstat() 
should
return the correct inode state.

Disadvantages of the above solutions:

The first solution marks the inode "dirty" on unlink by setting the on-disk
di_nlink field to 0. Note that the in-core di_nlink has already been set to
0 and a corresponding transaction logged by xfs_droplink().
This is an exception from the rule that any on-disk inode buffer changes
has to be followed by a disk write (inode flush).
Synchronizing the in-core to on-disk di_nlink values in advance (before the
actual inode flush to disk) should be fine in this case because the inode
is already unlinked and it would never change its di_nlink again for this
inode generation.

The second solution would be a performance hit as it would require disk
write for each new file create to flush the inode to disk. Dave suggested
modifying the inode sync code to allow on-disk buffer updates without
disk writes. This doesn't seem to be very simple and would require some
time for a proper implementation and testing. I have been assigned to
do it in the near future.

In the mean time we have XFS users that urgently need a solution
and the patch bellow seems to fix the problem for them.

Regards,
Vlad

--------------050703030108060701050103
Content-Type: text/x-patch;
 name="get_bulkall-appears-to-return-stale-information.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="get_bulkall-appears-to-return-stale-information.patch"

Index: linux-xfs1/fs/xfs/xfs_inode.c
===================================================================
--- linux-xfs1.orig/fs/xfs/xfs_inode.c
+++ linux-xfs1/fs/xfs/xfs_inode.c
@@ -1952,6 +1952,25 @@ xfs_iunlink(
 	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	ASSERT(agi->agi_unlinked[bucket_index]);
 	ASSERT(be32_to_cpu(agi->agi_unlinked[bucket_index]) != agino);
+	error = xfs_itobp(mp, tp, ip, &dip, &ibp, 0, 0);
+
+	if (error) {
+		return error;
+	}
+
+	/*
+	 * Clear the on-disk di_nlink. This is to prevent xfs_bulkstat
+	 * from picking up this inode when it is reclaimed (its incore state
+	 * initialzed but not flushed to disk yet). The in-core di_nlink is
+	 * already cleared in xfs_droplink() and a corresponding transaction
+	 * logged. The hack here just synchronizes the in-core to on-disk
+	 * di_nlink value in advance before the actual inode sync to disk.
+	 * This is OK because the inode is already unlinked and would never
+	 * change its di_nlink again for this inode generation.
+	 * This is a temporary hack that would require a proper fix
+	 * in the future.
+	 */
+	dip->di_core.di_nlink = 0;
 
 	if (be32_to_cpu(agi->agi_unlinked[bucket_index]) != NULLAGINO) {
 		/*
@@ -1960,10 +1979,6 @@ xfs_iunlink(
 		 * Here we put the head pointer into our next pointer,
 		 * and then we fall through to point the head at us.
 		 */
-		error = xfs_itobp(mp, tp, ip, &dip, &ibp, 0, 0);
-		if (error) {
-			return error;
-		}
 		ASSERT(be32_to_cpu(dip->di_next_unlinked) == NULLAGINO);
 		/* both on-disk, don't endian flip twice */
 		dip->di_next_unlinked = agi->agi_unlinked[bucket_index];
Index: linux-xfs1/fs/xfs/xfs_itable.c
===================================================================
--- linux-xfs1.orig/fs/xfs/xfs_itable.c
+++ linux-xfs1/fs/xfs/xfs_itable.c
@@ -290,8 +290,16 @@ xfs_bulkstat_use_dinode(
 		return 1;
 	dip = (xfs_dinode_t *)
 			xfs_buf_offset(bp, clustidx << mp->m_sb.sb_inodelog);
+	/*
+	 * Check the buffer containing the on-disk inode for di_nlink == 0.
+	 * This is to prevent xfs_bulkstat from picking up just reclaimed
+	 * inodes that have their in-core state initialized but not flushed
+	 * to disk yet. This is a temporary hack that would require a proper
+	 * fix in the future.
+	 */
 	if (be16_to_cpu(dip->di_core.di_magic) != XFS_DINODE_MAGIC ||
-	    !XFS_DINODE_GOOD_VERSION(dip->di_core.di_version))
+	    !XFS_DINODE_GOOD_VERSION(dip->di_core.di_version) ||
+	    !dip->di_core.di_nlink)
 		return 0;
 	if (flags & BULKSTAT_FG_QUICK) {
 		*dipp = dip;

--------------050703030108060701050103--
