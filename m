Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 Mar 2007 16:33:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2TNXU6p004715
	for <xfs@oss.sgi.com>; Thu, 29 Mar 2007 16:33:31 -0700
Date: Fri, 30 Mar 2007 10:33:23 +1100
From: David Chinner <dgc@sgi.com>
Subject: Review: Make xfs_dm_sync_by_handle really sync data
Message-ID: <20070329233323.GM32597093@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


xfs_dm_sync_by_handle doesn't sync data right now. Never has.
It is supposed to work exactly like fsync(), except that it
only ever calls XFS functions that log the inode and
not the generic functions that actually sync out the data.

Fix it.

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/dmapi/xfs_dm.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/dmapi/xfs_dm.c	2007-03-30 09:02:07.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/dmapi/xfs_dm.c	2007-03-30 09:28:54.348239386 +1000
@@ -3054,22 +3054,36 @@ xfs_dm_symlink_by_handle(
 }
 
 
+/*
+ * xfs_dm_sync_by_handle needs to do the same thing as sys_fsync()
+ */
 STATIC int
 xfs_dm_sync_by_handle(
 	struct inode	*inode,
 	dm_right_t	right)
 {
+	int		err, ret;
 	bhv_vnode_t	*vp = vn_from_inode(inode);
 
 	/* Returns negative errors to DMAPI */
-
 	if (right < DM_RIGHT_EXCL)
 		return(-EACCES);
 
+	/* We need to protect against concurrent writers.. */
+	ret = filemap_fdatawrite(inode->i_mapping);
+	down_rw_sems(inode, DM_FLAGS_IMUX);
+	err = bhv_vop_fsync(vp, FSYNC_WAIT, NULL, (xfs_off_t)0,(xfs_off_t)-1);
+	if (!ret)
+		ret = err;
+	up_rw_sems(inode, DM_FLAGS_IMUX);
+	err = filemap_fdatawait(inode->i_mapping);
+	if (!ret)
+		ret = err;
+
 	if (VN_TRUNC(vp))
 		VUNTRUNCATE(vp);
 
-	return -bhv_vop_fsync(vp, FSYNC_WAIT, NULL, (xfs_off_t)0,(xfs_off_t)-1);
+	return(-ret); /* Return negative error to DMAPI */
 }
 
 
