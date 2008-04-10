Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Apr 2008 12:00:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3AJ0cj0005992
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 12:00:39 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 10D429A04E1
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 12:01:16 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id SAvGZiGeJYbWh7fF for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 12:01:16 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m3AIiDF3006923
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 20:44:14 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m3AIiDxB006921
	for xfs@oss.sgi.com; Thu, 10 Apr 2008 20:44:13 +0200
Date: Thu, 10 Apr 2008 20:44:13 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] simplify xfs_lock_for_rename
Message-ID: <20080410184413.GB6771@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

as with lookup merge what's left of xfs_dir_lookup_int into it, kill
a useless lock roundtrip left over from IRIX and kill a bunch of useless
variables.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_rename.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rename.c	2008-04-09 20:30:08.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_rename.c	2008-04-10 08:58:50.000000000 +0200
@@ -67,10 +67,6 @@ xfs_rename_unlock4(
 	}
 }
 
-#ifdef DEBUG
-int xfs_rename_skip, xfs_rename_nskip;
-#endif
-
 /*
  * The following routine will acquire the locks required for a rename
  * operation. The code understands the semantics of renames and will
@@ -92,47 +88,33 @@ xfs_lock_for_rename(
 	xfs_inode_t	**i_tab,/* out: array of inode returned, sorted */
 	int		*num_inodes)  /* out: number of inodes in array */
 {
-	xfs_inode_t		*ip2 = NULL;
 	xfs_inode_t		*temp;
-	xfs_ino_t		inum1, inum2;
+	xfs_ino_t		inum2;
 	int			error;
 	int			i, j;
 	uint			lock_mode;
-	int			diff_dirs = (dp1 != dp2);
 
-	/*
-	 * First, find out the current inums of the entries so that we
-	 * can determine the initial locking order.  We'll have to
-	 * sanity check stuff after all the locks have been acquired
-	 * to see if we still have the right inodes, directories, etc.
-	 */
-	lock_mode = xfs_ilock_map_shared(dp1);
+	*ipp2 = NULL;
+
 	IHOLD(ip1);
 	xfs_itrace_ref(ip1);
 
-	inum1 = ip1->i_ino;
-
-	/*
-	 * Unlock dp1 and lock dp2 if they are different.
-	 */
-	if (diff_dirs) {
-		xfs_iunlock_map_shared(dp1, lock_mode);
-		lock_mode = xfs_ilock_map_shared(dp2);
+	lock_mode = xfs_ilock_map_shared(dp2);
+	error = xfs_dir_lookup(NULL, dp2, name2, &inum2);
+	if (!error) {
+		xfs_iunlock(dp2, lock_mode);
+		error = xfs_iget(dp2->i_mount, NULL, inum2, 0, 0, ipp2, 0);
+		xfs_ilock(dp2, lock_mode);
 	}
 
-	error = xfs_dir_lookup_int(dp2, lock_mode, name2, &inum2, &ip2);
 	if (error == ENOENT) {		/* target does not need to exist. */
 		inum2 = 0;
 	} else if (error) {
-		/*
-		 * If dp2 and dp1 are the same, the next line unlocks dp1.
-		 * Got it?
-		 */
 		xfs_iunlock_map_shared(dp2, lock_mode);
-		IRELE (ip1);
+		IRELE(ip1);
 		return error;
 	} else {
-		xfs_itrace_ref(ip2);
+		xfs_itrace_ref(*ipp2);
 	}
 
 	/*
@@ -150,9 +132,8 @@ xfs_lock_for_rename(
 		i_tab[3] = NULL;
 	} else {
 		*num_inodes = 4;
-		i_tab[3] = ip2;
+		i_tab[3] = *ipp2;
 	}
-	*ipp2 = i_tab[3];
 
 	/*
 	 * Sort the elements via bubble sort.  (Remember, there are at
@@ -178,14 +159,8 @@ xfs_lock_for_rename(
 	 */
 
 	if (i_tab[0] == dp2 && lock_mode == XFS_ILOCK_SHARED) {
-#ifdef DEBUG
-		xfs_rename_skip++;
-#endif
 		xfs_lock_inodes(i_tab, *num_inodes, 1, XFS_ILOCK_SHARED);
 	} else {
-#ifdef DEBUG
-		xfs_rename_nskip++;
-#endif
 		xfs_iunlock_map_shared(dp2, lock_mode);
 		xfs_lock_inodes(i_tab, *num_inodes, 0, XFS_ILOCK_SHARED);
 	}
Index: linux-2.6-xfs/fs/xfs/xfs_utils.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_utils.c	2008-04-09 20:30:08.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_utils.c	2008-04-10 08:46:27.000000000 +0200
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
--- linux-2.6-xfs.orig/fs/xfs/xfs_utils.h	2008-04-09 20:30:08.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_utils.h	2008-04-10 08:46:27.000000000 +0200
@@ -21,8 +21,6 @@
 #define IRELE(ip)	VN_RELE(XFS_ITOV(ip))
 #define IHOLD(ip)	VN_HOLD(XFS_ITOV(ip))
 
-extern int xfs_dir_lookup_int(xfs_inode_t *, uint, struct xfs_name *,
-				xfs_ino_t *, xfs_inode_t **);
 extern int xfs_truncate_file(xfs_mount_t *, xfs_inode_t *);
 extern int xfs_dir_ialloc(xfs_trans_t **, xfs_inode_t *, mode_t, xfs_nlink_t,
 				xfs_dev_t, cred_t *, prid_t, int,
