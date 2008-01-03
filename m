Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Jan 2008 04:59:25 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m03CxHT2017715
	for <xfs@oss.sgi.com>; Thu, 3 Jan 2008 04:59:21 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9067E1221A17
	for <xfs@oss.sgi.com>; Thu,  3 Jan 2008 04:59:31 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id hZV0AEKknJxoc9Gq for <xfs@oss.sgi.com>; Thu, 03 Jan 2008 04:59:31 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m03CqRF3005494
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 3 Jan 2008 13:52:27 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m03CqRKf005492
	for xfs@oss.sgi.com; Thu, 3 Jan 2008 13:52:27 +0100
Date: Thu, 3 Jan 2008 13:52:27 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill xfs_get_dir_entry
Message-ID: <20080103125227.GB5331@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Instead of of xfs_get_dir_entry use a macro to get the xfs_inode from
the dentry in the callers and grab the reference manually.

Only grab the reference once as it's fine to keep it over the dmapi
calls.  (And even that reference is actually superflous in Linux but
I'll leave that for another patch)

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_rename.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rename.c	2007-11-30 10:15:48.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_rename.c	2007-12-26 16:35:10.000000000 +0100
@@ -94,7 +94,8 @@ xfs_lock_for_rename(
 	xfs_inode_t	**i_tab,/* array of inode returned, sorted */
 	int		*num_inodes)  /* number of inodes in array */
 {
-	xfs_inode_t		*ip1, *ip2, *temp;
+	xfs_inode_t		*ip1 = VNAME_TO_INODE(vname1);
+	xfs_inode_t		*ip2, *temp;
 	xfs_ino_t		inum1, inum2;
 	int			error;
 	int			i, j;
@@ -110,16 +111,11 @@ xfs_lock_for_rename(
 	 * to see if we still have the right inodes, directories, etc.
 	 */
 	lock_mode = xfs_ilock_map_shared(dp1);
-	error = xfs_get_dir_entry(vname1, &ip1);
-	if (error) {
-		xfs_iunlock_map_shared(dp1, lock_mode);
-		return error;
-	}
+	IHOLD(ip1);
+	xfs_itrace_ref(ip1);
 
 	inum1 = ip1->i_ino;
 
-	ASSERT(ip1);
-	xfs_itrace_ref(ip1);
 
 	/*
 	 * Unlock dp1 and lock dp2 if they are different.
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2007-12-17 14:49:28.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2007-12-26 16:35:10.000000000 +0100
@@ -230,7 +230,7 @@ static inline bhv_vnode_t *vn_grab(bhv_v
  */
 #define VNAME(dentry)		((char *) (dentry)->d_name.name)
 #define VNAMELEN(dentry)	((dentry)->d_name.len)
-#define VNAME_TO_VNODE(dentry)	(vn_from_inode((dentry)->d_inode))
+#define VNAME_TO_INODE(dentry)	(XFS_I((dentry)->d_inode))
 
 /*
  * Dealing with bad inodes
Index: linux-2.6-xfs/fs/xfs/xfs_utils.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_utils.c	2007-12-21 07:22:56.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_utils.c	2007-12-26 16:35:10.000000000 +0100
@@ -40,28 +40,6 @@
 #include "xfs_itable.h"
 #include "xfs_utils.h"
 
-/*
- * xfs_get_dir_entry is used to get a reference to an inode given
- * its parent directory inode and the name of the file.	 It does
- * not lock the child inode, and it unlocks the directory before
- * returning.  The directory's generation number is returned for
- * use by a later call to xfs_lock_dir_and_entry.
- */
-int
-xfs_get_dir_entry(
-	bhv_vname_t	*dentry,
-	xfs_inode_t	**ipp)
-{
-	bhv_vnode_t	*vp;
-
-	vp = VNAME_TO_VNODE(dentry);
-
-	*ipp = xfs_vtoi(vp);
-	if (!*ipp)
-		return XFS_ERROR(ENOENT);
-	VN_HOLD(vp);
-	return 0;
-}
 
 int
 xfs_dir_lookup_int(
Index: linux-2.6-xfs/fs/xfs/xfs_utils.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_utils.h	2007-12-17 14:49:28.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_utils.h	2007-12-26 16:35:10.000000000 +0100
@@ -21,7 +21,6 @@
 #define IRELE(ip)	VN_RELE(XFS_ITOV(ip))
 #define IHOLD(ip)	VN_HOLD(XFS_ITOV(ip))
 
-extern int xfs_get_dir_entry (bhv_vname_t *, xfs_inode_t **);
 extern int xfs_dir_lookup_int (xfs_inode_t *, uint, bhv_vname_t *, xfs_ino_t *,
 				xfs_inode_t **);
 extern int xfs_truncate_file (xfs_mount_t *, xfs_inode_t *);
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-12-21 07:45:40.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-12-26 16:35:10.000000000 +0100
@@ -2277,41 +2277,30 @@ xfs_remove(
 	bhv_vnode_t		*dir_vp = XFS_ITOV(dp);
 	char			*name = VNAME(dentry);
 	xfs_mount_t		*mp = dp->i_mount;
-	xfs_inode_t             *ip;
+	xfs_inode_t             *ip = VNAME_TO_INODE(dentry);
+	int			namelen = VNAMELEN(dentry);
 	xfs_trans_t             *tp = NULL;
 	int                     error = 0;
 	xfs_bmap_free_t         free_list;
 	xfs_fsblock_t           first_block;
 	int			cancel_flags;
 	int			committed;
-	int			dm_di_mode = 0;
 	int			link_zero;
 	uint			resblks;
-	int			namelen;
 
 	xfs_itrace_entry(dp);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	namelen = VNAMELEN(dentry);
-
-	if (!xfs_get_dir_entry(dentry, &ip)) {
-	        dm_di_mode = ip->i_d.di_mode;
-		IRELE(ip);
-	}
-
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_REMOVE)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_REMOVE, dir_vp,
 					DM_RIGHT_NULL, NULL, DM_RIGHT_NULL,
-					name, NULL, dm_di_mode, 0, 0);
+					name, NULL, ip->i_d.di_mode, 0, 0);
 		if (error)
 			return error;
 	}
 
-	/* From this point on, return through std_return */
-	ip = NULL;
-
 	/*
 	 * We need to get a reference to ip before we get our log
 	 * reservation. The reason for this is that we cannot call
@@ -2324,13 +2313,7 @@ xfs_remove(
 	 * when we call xfs_iget.  Instead we get an unlocked reference
 	 * to the inode before getting our log reservation.
 	 */
-	error = xfs_get_dir_entry(dentry, &ip);
-	if (error) {
-		REMOVE_DEBUG_TRACE(__LINE__);
-		goto std_return;
-	}
-
-	dm_di_mode = ip->i_d.di_mode;
+	IHOLD(ip);
 
 	xfs_itrace_entry(ip);
 	xfs_itrace_ref(ip);
@@ -2474,7 +2457,7 @@ xfs_remove(
 		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTREMOVE,
 				dir_vp, DM_RIGHT_NULL,
 				NULL, DM_RIGHT_NULL,
-				name, NULL, dm_di_mode, error, 0);
+				name, NULL, ip->i_d.di_mode, error, 0);
 	}
 	return error;
 
@@ -2891,14 +2874,13 @@ xfs_rmdir(
 	char			*name = VNAME(dentry);
 	int			namelen = VNAMELEN(dentry);
 	xfs_mount_t		*mp = dp->i_mount;
-  	xfs_inode_t             *cdp;   /* child directory */
+  	xfs_inode_t             *cdp = VNAME_TO_INODE(dentry);
 	xfs_trans_t             *tp;
 	int                     error;
 	xfs_bmap_free_t         free_list;
 	xfs_fsblock_t           first_block;
 	int			cancel_flags;
 	int			committed;
-	int			dm_di_mode = S_IFDIR;
 	int			last_cdp_link;
 	uint			resblks;
 
@@ -2907,24 +2889,15 @@ xfs_rmdir(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	if (!xfs_get_dir_entry(dentry, &cdp)) {
-	        dm_di_mode = cdp->i_d.di_mode;
-		IRELE(cdp);
-	}
-
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_REMOVE)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_REMOVE,
 					dir_vp, DM_RIGHT_NULL,
 					NULL, DM_RIGHT_NULL,
-					name, NULL, dm_di_mode, 0, 0);
+					name, NULL, cdp->i_d.di_mode, 0, 0);
 		if (error)
 			return XFS_ERROR(error);
 	}
 
-	/* Return through std_return after this point. */
-
-	cdp = NULL;
-
 	/*
 	 * We need to get a reference to cdp before we get our log
 	 * reservation.  The reason for this is that we cannot call
@@ -2937,13 +2910,7 @@ xfs_rmdir(
 	 * when we call xfs_iget.  Instead we get an unlocked reference
 	 * to the inode before getting our log reservation.
 	 */
-	error = xfs_get_dir_entry(dentry, &cdp);
-	if (error) {
-		REMOVE_DEBUG_TRACE(__LINE__);
-		goto std_return;
-	}
-	mp = dp->i_mount;
-	dm_di_mode = cdp->i_d.di_mode;
+	IHOLD(cdp);
 
 	/*
 	 * Get the dquots for the inodes.
@@ -3100,7 +3067,7 @@ xfs_rmdir(
 		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTREMOVE,
 					dir_vp, DM_RIGHT_NULL,
 					NULL, DM_RIGHT_NULL,
-					name, NULL, dm_di_mode,
+					name, NULL, cdp->i_d.di_mode,
 					error, 0);
 	}
 	return error;
