Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Nov 2008 14:24:23 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mABMOFEN023268
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2008 14:24:16 -0800
Date: Tue, 11 Nov 2008 17:24:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] use inode_change_ok for setattr permission checking
Message-ID: <20081111222414.GA9134@infradead.org>
References: <20080929215329.GC30363@lst.de> <4908041F.2020905@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4908041F.2020905@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 29, 2008 at 05:35:11PM +1100, Timothy Shimmin wrote:
> Christoph Hellwig wrote:
> > Instead of implementing our own checks use inode_change_ok to check for
> > nessecary permission in setattr.  
> 
> Yeah, the 1st bit I quite like and is similar to what I did in some
> nfs4acl code, as you know.
> We put all the EPERM cases early on which is nice.

Yes.  The big differene to the NFSv4 ACL patches is that we use the
standard kernel inode_change_ok routine, which means we are guaranteed
to have the same checks as all other filesystems and get rid of
duplicated code.

Btw, I must also say that I really hate the way the NFSv4 ACL patches make
this filesystem-specific for all filesystems that support the NFSv4
ACLs.  All these permission checks should instead go through
->permission with additional MAY_ flags.

> 
> And then we have similar code in inode_setattr()
>         if (ia_valid & ATTR_MODE) {
>                 umode_t mode = attr->ia_mode;
> 
>                 if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
>                         mode &= ~S_ISGID;
>                 inode->i_mode = mode;
>         }
> 
> But what about the suid case?

SUID is handled in the inode_change_ok bit you quoted earlier.  But we
should add this S_ISGID handling here to XFS, too.

> And also, what is with the ATTR_KILL_* bits?
> Lemme look...

ATTR_KILL_SUID/ATTR_KILL_SGID is a rather special thing added for NFS
which doesn't want to do these locally but only on the server.  Local
filesystems can simply ignore it.

Updated patch below.  Note that the S_ISGID hadling required moving
the ATTR_MODE handling after the ATTR_GID handling.

-- 

use inode_change_ok for setattr permission checking

Instead of implementing our own checks use inode_change_ok to check for
nessecary permission in setattr.  There is a slight change in behaviour
as inode_change_ok doesn't allow i_mode updates to add the suid or sgid
without superuser privilegues while the old XFS code just stripped away
those bits from the file mode.

(First sent on Semptember 29th)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-11-10 14:03:59.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-11-10 14:25:44.000000000 +0100
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
@@ -413,20 +337,6 @@ xfs_setattr(
 	}
 
 	/*
-	 * Change file access modes.
-	 */
-	if (mask & ATTR_MODE) {
-		ip->i_d.di_mode &= S_IFMT;
-		ip->i_d.di_mode |= iattr->ia_mode & ~S_IFMT;
-
-		inode->i_mode &= S_IFMT;
-		inode->i_mode |= iattr->ia_mode & ~S_IFMT;
-
-		xfs_trans_log_inode (tp, ip, XFS_ILOG_CORE);
-		timeflags |= XFS_ICHGTIME_CHG;
-	}
-
-	/*
 	 * Change file ownership.  Must be the owner or privileged.
 	 */
 	if (mask & (ATTR_UID|ATTR_GID)) {
@@ -471,6 +381,24 @@ xfs_setattr(
 		timeflags |= XFS_ICHGTIME_CHG;
 	}
 
+	/*
+	 * Change file access modes.
+	 */
+	if (mask & ATTR_MODE) {
+		umode_t mode = iattr->ia_mode;
+
+		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+			mode &= ~S_ISGID;
+
+		ip->i_d.di_mode &= S_IFMT;
+		ip->i_d.di_mode |= mode & ~S_IFMT;
+
+		inode->i_mode &= S_IFMT;
+		inode->i_mode |= mode & ~S_IFMT;
+
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+		timeflags |= XFS_ICHGTIME_CHG;
+	}
 
 	/*
 	 * Change file access or modified times.
