Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 13:29:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97KT21j020949
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 13:29:02 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E613913B2C3A
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 13:30:41 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id fermUwPHIkbJ5Bi5 for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 13:30:41 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m97KUeIF017154
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 22:30:40 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m97KUefL017152
	for xfs@oss.sgi.com; Tue, 7 Oct 2008 22:30:40 +0200
Date: Tue, 7 Oct 2008 22:30:40 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] use inode_change_ok for setattr permission checking
Message-ID: <20081007203040.GB17005@lst.de>
References: <20080929215329.GC30363@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929215329.GC30363@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Mon, Sep 29, 2008 at 11:53:29PM +0200, Christoph Hellwig wrote:
> Instead of implementing our own checks use inode_change_ok to check for
> nessecary permission in setattr.  There is a slight change in behaviour
> as inode_change_ok doesn't allow i_mode updates to add the suid or sgid
> without superuser privilegues while the old XFS code just stripped away
> those bits from the file mode.

This one needs a slight respin for the 2.6.27-rc8 merge:


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-10-03 22:16:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-10-03 22:16:32.000000000 +0200
@@ -70,7 +70,6 @@ xfs_setattr(
 	gid_t			gid=0, igid=0;
 	int			timeflags = 0;
 	struct xfs_dquot	*udqp, *gdqp, *olddquot1, *olddquot2;
-	int			file_owner;
 	int			need_iolock = 1;
 
 	xfs_itrace_entry(ip);
@@ -81,6 +80,10 @@ xfs_setattr(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
+	code = -inode_change_ok(inode, iattr);
+	if (code)
+		return code;
+
 	olddquot1 = olddquot2 = NULL;
 	udqp = gdqp = NULL;
 
@@ -158,56 +161,6 @@ xfs_setattr(
 
 	xfs_ilock(ip, lock_flags);
 
-	/* boolean: are we the file owner? */
-	file_owner = (current_fsuid() == ip->i_d.di_uid);
-
-	/*
-	 * Change various properties of a file.
-	 * Only the owner or users with CAP_FOWNER
-	 * capability may do these things.
-	 */
-	if (mask & (ATTR_MODE|ATTR_UID|ATTR_GID)) {
-		/*
-		 * CAP_FOWNER overrides the following restrictions:
-		 *
-		 * The user ID of the calling process must be equal
-		 * to the file owner ID, except in cases where the
-		 * CAP_FSETID capability is applicable.
-		 */
-		if (!file_owner && !capable(CAP_FOWNER)) {
-			code = XFS_ERROR(EPERM);
-			goto error_return;
-		}
-
-		/*
-		 * CAP_FSETID overrides the following restrictions:
-		 *
-		 * The effective user ID of the calling process shall match
-		 * the file owner when setting the set-user-ID and
-		 * set-group-ID bits on that file.
-		 *
-		 * The effective group ID or one of the supplementary group
-		 * IDs of the calling process shall match the group owner of
-		 * the file when setting the set-group-ID bit on that file
-		 */
-		if (mask & ATTR_MODE) {
-			mode_t m = 0;
-
-			if ((iattr->ia_mode & S_ISUID) && !file_owner)
-				m |= S_ISUID;
-			if ((iattr->ia_mode & S_ISGID) &&
-			    !in_group_p((gid_t)ip->i_d.di_gid))
-				m |= S_ISGID;
-#if 0
-			/* Linux allows this, Irix doesn't. */
-			if ((iattr->ia_mode & S_ISVTX) && !S_ISDIR(ip->i_d.di_mode))
-				m |= S_ISVTX;
-#endif
-			if (m && !capable(CAP_FSETID))
-				iattr->ia_mode &= ~m;
-		}
-	}
-
 	/*
 	 * Change file ownership.  Must be the owner or privileged.
 	 */
@@ -224,22 +177,6 @@ xfs_setattr(
 		uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
 
 		/*
-		 * CAP_CHOWN overrides the following restrictions:
-		 *
-		 * If _POSIX_CHOWN_RESTRICTED is defined, this capability
-		 * shall override the restriction that a process cannot
-		 * change the user ID of a file it owns and the restriction
-		 * that the group ID supplied to the chown() function
-		 * shall be equal to either the group ID or one of the
-		 * supplementary group IDs of the calling process.
-		 */
-		if ((iuid != uid ||
-		     (igid != gid && !in_group_p((gid_t)gid))) &&
-		    !capable(CAP_CHOWN)) {
-			code = XFS_ERROR(EPERM);
-			goto error_return;
-		}
-		/*
 		 * Do a quota reservation only if uid/gid is actually
 		 * going to change.
 		 */
@@ -284,19 +221,6 @@ xfs_setattr(
 	}
 
 	/*
-	 * Change file access or modified times.
-	 */
-	if (mask & (ATTR_ATIME|ATTR_MTIME)) {
-		if (!file_owner) {
-			if ((mask & (ATTR_MTIME_SET|ATTR_ATIME_SET)) &&
-			    !capable(CAP_FOWNER)) {
-				code = XFS_ERROR(EPERM);
-				goto error_return;
-			}
-		}
-	}
-
-	/*
 	 * Now we can make the changes.  Before we join the inode
 	 * to the transaction, if ATTR_SIZE is set then take care of
 	 * the part of the truncation that must be done without the
