Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 02:11:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3B9BMb0022927
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 02:11:24 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2718B77E439
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 02:11:59 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id cZ0P6WY3WzXTZrOy for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 02:11:59 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m3B9BqF3014948
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 11:11:52 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m3B9BqxU014946
	for xfs@oss.sgi.com; Fri, 11 Apr 2008 11:11:52 +0200
Date: Fri, 11 Apr 2008 11:11:52 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] remove manual lookup from xfs_rename and simplify locking
Message-ID: <20080411091152.GA14495@lst.de>
References: <20080410184413.GB6771@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410184413.GB6771@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

->rename already gets the target inode passed if it exits.  Pass it down
to xfs_rename so that we can avoid looking it up again.  Also simplify
locking as the first lock section in xfs_rename can go away now:  the
isdir is an invariant over the lifetime of the inode, and new_parent and
the nlink check are namespace topology protected by i_mutex in the VFS.
The projid check needs to move into the second lock section anyway to
not be racy.

Also kill the now unused xfs_dir_lookup_int and remove the now-unused
first_locked argumet to xfs_lock_inodes.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_rename.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rename.c	2008-04-09 18:35:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_rename.c	2008-04-11 09:06:51.000000000 +0200
@@ -55,85 +55,32 @@ xfs_rename_unlock4(
 
 	xfs_iunlock(i_tab[0], lock_mode);
 	for (i = 1; i < 4; i++) {
-		if (i_tab[i] == NULL) {
+		if (i_tab[i] == NULL)
 			break;
-		}
+
 		/*
 		 * Watch out for duplicate entries in the table.
 		 */
-		if (i_tab[i] != i_tab[i-1]) {
+		if (i_tab[i] != i_tab[i-1])
 			xfs_iunlock(i_tab[i], lock_mode);
-		}
 	}
 }
 
-#ifdef DEBUG
-int xfs_rename_skip, xfs_rename_nskip;
-#endif
-
 /*
- * The following routine will acquire the locks required for a rename
- * operation. The code understands the semantics of renames and will
- * validate that name1 exists under dp1 & that name2 may or may not
- * exist under dp2.
- *
- * We are renaming dp1/name1 to dp2/name2.
- *
- * Return ENOENT if dp1 does not exist, other lookup errors, or 0 for success.
+ * Enter all inodes for a rename transaction into a sorted array.
  */
-STATIC int
-xfs_lock_for_rename(
+STATIC void
+xfs_sort_for_rename(
 	xfs_inode_t	*dp1,	/* in: old (source) directory inode */
 	xfs_inode_t	*dp2,	/* in: new (target) directory inode */
 	xfs_inode_t	*ip1,	/* in: inode of old entry */
-	struct xfs_name	*name2,	/* in: new entry name */
-	xfs_inode_t	**ipp2,	/* out: inode of new entry, if it
+	xfs_inode_t	*ip2,	/* in: inode of new entry, if it
 				   already exists, NULL otherwise. */
 	xfs_inode_t	**i_tab,/* out: array of inode returned, sorted */
 	int		*num_inodes)  /* out: number of inodes in array */
 {
-	xfs_inode_t		*ip2 = NULL;
 	xfs_inode_t		*temp;
-	xfs_ino_t		inum1, inum2;
-	int			error;
 	int			i, j;
-	uint			lock_mode;
-	int			diff_dirs = (dp1 != dp2);
-
-	/*
-	 * First, find out the current inums of the entries so that we
-	 * can determine the initial locking order.  We'll have to
-	 * sanity check stuff after all the locks have been acquired
-	 * to see if we still have the right inodes, directories, etc.
-	 */
-	lock_mode = xfs_ilock_map_shared(dp1);
-	IHOLD(ip1);
-	xfs_itrace_ref(ip1);
-
-	inum1 = ip1->i_ino;
-
-	/*
-	 * Unlock dp1 and lock dp2 if they are different.
-	 */
-	if (diff_dirs) {
-		xfs_iunlock_map_shared(dp1, lock_mode);
-		lock_mode = xfs_ilock_map_shared(dp2);
-	}
-
-	error = xfs_dir_lookup_int(dp2, lock_mode, name2, &inum2, &ip2);
-	if (error == ENOENT) {		/* target does not need to exist. */
-		inum2 = 0;
-	} else if (error) {
-		/*
-		 * If dp2 and dp1 are the same, the next line unlocks dp1.
-		 * Got it?
-		 */
-		xfs_iunlock_map_shared(dp2, lock_mode);
-		IRELE (ip1);
-		return error;
-	} else {
-		xfs_itrace_ref(ip2);
-	}
 
 	/*
 	 * i_tab contains a list of pointers to inodes.  We initialize
@@ -145,21 +92,20 @@ xfs_lock_for_rename(
 	i_tab[0] = dp1;
 	i_tab[1] = dp2;
 	i_tab[2] = ip1;
-	if (inum2 == 0) {
-		*num_inodes = 3;
-		i_tab[3] = NULL;
-	} else {
+	if (ip2) {
 		*num_inodes = 4;
 		i_tab[3] = ip2;
+	} else {
+		*num_inodes = 3;
+		i_tab[3] = NULL;
 	}
-	*ipp2 = i_tab[3];
 
 	/*
 	 * Sort the elements via bubble sort.  (Remember, there are at
 	 * most 4 elements to sort, so this is adequate.)
 	 */
-	for (i=0; i < *num_inodes; i++) {
-		for (j=1; j < *num_inodes; j++) {
+	for (i = 0; i < *num_inodes; i++) {
+		for (j = 1; j < *num_inodes; j++) {
 			if (i_tab[j]->i_ino < i_tab[j-1]->i_ino) {
 				temp = i_tab[j];
 				i_tab[j] = i_tab[j-1];
@@ -167,30 +113,6 @@ xfs_lock_for_rename(
 			}
 		}
 	}
-
-	/*
-	 * We have dp2 locked. If it isn't first, unlock it.
-	 * If it is first, tell xfs_lock_inodes so it can skip it
-	 * when locking. if dp1 == dp2, xfs_lock_inodes will skip both
-	 * since they are equal. xfs_lock_inodes needs all these inodes
-	 * so that it can unlock and retry if there might be a dead-lock
-	 * potential with the log.
-	 */
-
-	if (i_tab[0] == dp2 && lock_mode == XFS_ILOCK_SHARED) {
-#ifdef DEBUG
-		xfs_rename_skip++;
-#endif
-		xfs_lock_inodes(i_tab, *num_inodes, 1, XFS_ILOCK_SHARED);
-	} else {
-#ifdef DEBUG
-		xfs_rename_nskip++;
-#endif
-		xfs_iunlock_map_shared(dp2, lock_mode);
-		xfs_lock_inodes(i_tab, *num_inodes, 0, XFS_ILOCK_SHARED);
-	}
-
-	return 0;
 }
 
 /*
@@ -202,10 +124,10 @@ xfs_rename(
 	struct xfs_name	*src_name,
 	xfs_inode_t	*src_ip,
 	xfs_inode_t	*target_dp,
-	struct xfs_name	*target_name)
+	struct xfs_name	*target_name,
+	xfs_inode_t	*target_ip)
 {
-	xfs_trans_t	*tp;
-	xfs_inode_t	*target_ip;
+	xfs_trans_t	*tp = NULL;
 	xfs_mount_t	*mp = src_dp->i_mount;
 	int		new_parent;		/* moving to a new dir */
 	int		src_is_directory;	/* src_name is a directory */
@@ -230,64 +152,31 @@ xfs_rename(
 					target_dp, DM_RIGHT_NULL,
 					src_name->name, target_name->name,
 					0, 0, 0);
-		if (error) {
+		if (error)
 			return error;
-		}
 	}
 	/* Return through std_return after this point. */
 
-	/*
-	 * Lock all the participating inodes. Depending upon whether
-	 * the target_name exists in the target directory, and
-	 * whether the target directory is the same as the source
-	 * directory, we can lock from 2 to 4 inodes.
-	 * xfs_lock_for_rename() will return ENOENT if src_name
-	 * does not exist in the source directory.
-	 */
-	tp = NULL;
-	error = xfs_lock_for_rename(src_dp, target_dp, src_ip, target_name,
-					&target_ip, inodes, &num_inodes);
-	if (error) {
-		/*
-		 * We have nothing locked, no inode references, and
-		 * no transaction, so just get out.
-		 */
-		goto std_return;
-	}
-
-	ASSERT(src_ip != NULL);
+	new_parent = (src_dp != target_dp);
+	src_is_directory = ((src_ip->i_d.di_mode & S_IFMT) == S_IFDIR);
 
-	if ((src_ip->i_d.di_mode & S_IFMT) == S_IFDIR) {
+	if (src_is_directory) {
 		/*
 		 * Check for link count overflow on target_dp
 		 */
-		if (target_ip == NULL && (src_dp != target_dp) &&
+		if (target_ip == NULL && new_parent &&
 		    target_dp->i_d.di_nlink >= XFS_MAXLINK) {
 			error = XFS_ERROR(EMLINK);
-			xfs_rename_unlock4(inodes, XFS_ILOCK_SHARED);
-			goto rele_return;
+			goto std_return;
 		}
 	}
 
-	/*
-	 * If we are using project inheritance, we only allow renames
-	 * into our tree when the project IDs are the same; else the
-	 * tree quota mechanism would be circumvented.
-	 */
-	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-		     (target_dp->i_d.di_projid != src_ip->i_d.di_projid))) {
-		error = XFS_ERROR(EXDEV);
-		xfs_rename_unlock4(inodes, XFS_ILOCK_SHARED);
-		goto rele_return;
-	}
-
-	new_parent = (src_dp != target_dp);
-	src_is_directory = ((src_ip->i_d.di_mode & S_IFMT) == S_IFDIR);
+	xfs_sort_for_rename(src_dp, target_dp, src_ip, target_ip,
+				inodes, &num_inodes);
 
-	/*
-	 * Drop the locks on our inodes so that we can start the transaction.
-	 */
-	xfs_rename_unlock4(inodes, XFS_ILOCK_SHARED);
+	IHOLD(src_ip);
+	if (target_ip)
+		IHOLD(target_ip);
 
 	XFS_BMAP_INIT(&free_list, &first_block);
 	tp = xfs_trans_alloc(mp, XFS_TRANS_RENAME);
@@ -314,9 +203,25 @@ xfs_rename(
 	}
 
 	/*
-	 * Reacquire the inode locks we dropped above.
+	 * Lock all the participating inodes. Depending upon whether
+	 * the target_name exists in the target directory, and
+	 * whether the target directory is the same as the source
+	 * directory, we can lock from 2 to 4 inodes.
+	 */
+	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
+
+	/*
+	 * If we are using project inheritance, we only allow renames
+	 * into our tree when the project IDs are the same; else the
+	 * tree quota mechanism would be circumvented.
 	 */
-	xfs_lock_inodes(inodes, num_inodes, 0, XFS_ILOCK_EXCL);
+	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
+		     (target_dp->i_d.di_projid != src_ip->i_d.di_projid))) {
+		error = XFS_ERROR(EXDEV);
+		xfs_rename_unlock4(inodes, XFS_ILOCK_SHARED);
+		xfs_trans_cancel(tp, cancel_flags);
+		goto rele_return;
+	}
 
 	/*
 	 * Join all the inodes to the transaction. From this point on,
Index: linux-2.6-xfs/fs/xfs/xfs_utils.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_utils.c	2008-04-09 18:35:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_utils.c	2008-04-11 08:41:32.000000000 +0200
@@ -41,49 +41,6 @@
 #include "xfs_utils.h"
 
 
-int
-xfs_dir_lookup_int(
-	xfs_inode_t	*dp,
-	uint		lock_mode,
-	struct xfs_name	*name,
-	xfs_ino_t	*inum,
-	xfs_inode_t	**ipp)
-{
-	int		error;
-
-	xfs_itrace_entry(dp);
-
-	error = xfs_dir_lookup(NULL, dp, name, inum);
-	if (!error) {
-		/*
-		 * Unlock the directory. We do this because we can't
-		 * hold the directory lock while doing the vn_get()
-		 * in xfs_iget().  Doing so could cause us to hold
-		 * a lock while waiting for the inode to finish
-		 * being inactive while it's waiting for a log
-		 * reservation in the inactive routine.
-		 */
-		xfs_iunlock(dp, lock_mode);
-		error = xfs_iget(dp->i_mount, NULL, *inum, 0, 0, ipp, 0);
-		xfs_ilock(dp, lock_mode);
-
-		if (error) {
-			*ipp = NULL;
-		} else if ((*ipp)->i_d.di_mode == 0) {
-			/*
-			 * The inode has been freed.  Something is
-			 * wrong so just get out of here.
-			 */
-			xfs_iunlock(dp, lock_mode);
-			xfs_iput_new(*ipp, 0);
-			*ipp = NULL;
-			xfs_ilock(dp, lock_mode);
-			error = XFS_ERROR(ENOENT);
-		}
-	}
-	return error;
-}
-
 /*
  * Allocates a new inode from disk and return a pointer to the
  * incore copy. This routine will internally commit the current
Index: linux-2.6-xfs/fs/xfs/xfs_utils.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_utils.h	2008-04-09 18:35:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_utils.h	2008-04-10 20:40:36.000000000 +0200
@@ -21,8 +21,6 @@
 #define IRELE(ip)	VN_RELE(XFS_ITOV(ip))
 #define IHOLD(ip)	VN_HOLD(XFS_ITOV(ip))
 
-extern int xfs_dir_lookup_int(xfs_inode_t *, uint, struct xfs_name *,
-				xfs_ino_t *, xfs_inode_t **);
 extern int xfs_truncate_file(xfs_mount_t *, xfs_inode_t *);
 extern int xfs_dir_ialloc(xfs_trans_t **, xfs_inode_t *, mode_t, xfs_nlink_t,
 				xfs_dev_t, cred_t *, prid_t, int,
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2008-04-11 08:42:18.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2008-04-11 08:43:47.000000000 +0200
@@ -518,7 +518,8 @@ xfs_vn_rename(
 	xfs_dentry_to_name(&nname, ndentry);
 
 	error = xfs_rename(XFS_I(odir), &oname, XFS_I(odentry->d_inode),
-							XFS_I(ndir), &nname);
+			   XFS_I(ndir), &nname, new_inode ?
+			   			XFS_I(new_inode) : NULL);
 	if (likely(!error)) {
 		if (new_inode)
 			xfs_validate_fields(new_inode);
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.h	2008-04-11 08:43:54.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.h	2008-04-11 08:44:19.000000000 +0200
@@ -48,7 +48,7 @@ int xfs_change_file_space(struct xfs_ino
 		struct cred *credp, int	attr_flags);
 int xfs_rename(struct xfs_inode *src_dp, struct xfs_name *src_name,
 		struct xfs_inode *src_ip, struct xfs_inode *target_dp,
-		struct xfs_name *target_name);
+		struct xfs_name *target_name, struct xfs_inode *target_ip);
 int xfs_attr_get(struct xfs_inode *ip, const char *name, char *value,
 		int *valuelenp, int flags, cred_t *cred);
 int xfs_attr_set(struct xfs_inode *dp, const char *name, char *value,
Index: linux-2.6-xfs/fs/xfs/xfs_dfrag.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dfrag.c	2008-04-11 09:06:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dfrag.c	2008-04-11 09:07:06.000000000 +0200
@@ -162,7 +162,7 @@ xfs_swap_extents(
 		ips[1] = ip;
 	}
 
-	xfs_lock_inodes(ips, 2, 0, lock_flags);
+	xfs_lock_inodes(ips, 2, lock_flags);
 	locked = 1;
 
 	/* Verify that both files have the same format */
@@ -265,7 +265,7 @@ xfs_swap_extents(
 		locked = 0;
 		goto error0;
 	}
-	xfs_lock_inodes(ips, 2, 0, XFS_ILOCK_EXCL);
+	xfs_lock_inodes(ips, 2, XFS_ILOCK_EXCL);
 
 	/*
 	 * Count the number of extended attribute blocks
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-04-11 09:07:13.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-04-11 09:07:22.000000000 +0200
@@ -534,7 +534,7 @@ int		xfs_iflush(xfs_inode_t *, uint);
 void		xfs_iflush_all(struct xfs_mount *);
 void		xfs_ichgtime(xfs_inode_t *, int);
 xfs_fsize_t	xfs_file_last_byte(xfs_inode_t *);
-void		xfs_lock_inodes(xfs_inode_t **, int, int, uint);
+void		xfs_lock_inodes(xfs_inode_t **, int, uint);
 
 void		xfs_synchronize_atime(xfs_inode_t *);
 void		xfs_mark_inode_dirty_sync(xfs_inode_t *);
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-04-11 09:07:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-04-11 09:08:56.000000000 +0200
@@ -2120,7 +2120,7 @@ again:
 
 		ips[0] = ip;
 		ips[1] = dp;
-		xfs_lock_inodes(ips, 2, 0, XFS_ILOCK_EXCL);
+		xfs_lock_inodes(ips, 2, XFS_ILOCK_EXCL);
 	}
 	/* else	 e_inum == dp->i_ino */
 	/*     This can happen if we're asked to lock /x/..
@@ -2168,7 +2168,6 @@ void
 xfs_lock_inodes(
 	xfs_inode_t	**ips,
 	int		inodes,
-	int		first_locked,
 	uint		lock_mode)
 {
 	int		attempts = 0, i, j, try_lock;
@@ -2176,13 +2175,8 @@ xfs_lock_inodes(
 
 	ASSERT(ips && (inodes >= 2)); /* we need at least two */
 
-	if (first_locked) {
-		try_lock = 1;
-		i = 1;
-	} else {
-		try_lock = 0;
-		i = 0;
-	}
+	try_lock = 0;
+	i = 0;
 
 again:
 	for (; i < inodes; i++) {
@@ -2544,7 +2538,7 @@ xfs_link(
 		ips[1] = sip;
 	}
 
-	xfs_lock_inodes(ips, 2, 0, XFS_ILOCK_EXCL);
+	xfs_lock_inodes(ips, 2, XFS_ILOCK_EXCL);
 
 	/*
 	 * Increment vnode ref counts since xfs_trans_commit &
