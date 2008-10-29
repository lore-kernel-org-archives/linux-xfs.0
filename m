Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 23:35:32 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9T6ZIYC011344
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 23:35:18 -0700
Message-ID: <4908041F.2020905@sgi.com>
Date: Wed, 29 Oct 2008 17:35:11 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] use inode_change_ok for setattr permission checking
References: <20080929215329.GC30363@lst.de>
In-Reply-To: <20080929215329.GC30363@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Instead of implementing our own checks use inode_change_ok to check for
> nessecary permission in setattr.  

Yeah, the 1st bit I quite like and is similar to what I did in some
nfs4acl code, as you know.
We put all the EPERM cases early on which is nice.

> There is a slight change in behaviour
> as inode_change_ok doesn't allow i_mode updates to add the suid or sgid
> without superuser privilegues while the old XFS code just stripped away
> those bits from the file mode.
> 
This bit is of concern for me. And I want to understand.
It seems confusing.

So for xfs, we currently have it that if we try to set the suid/sgid bit
on the mode, and we are not the owner/group-member,
and we don't have CAP_FSETID,
then we clear that bit out of the mode (setuid/setgid) that we were going to set
below.

Now in inode_change_ok() we have some relevant code:

        /* Make sure a caller can chmod. */
        if (ia_valid & ATTR_MODE) {
                if (!is_owner_or_cap(inode))
                        goto error;
                /* Also check the setgid bit! */
                if (!in_group_p((ia_valid & ATTR_GID) ? attr->ia_gid :
                                inode->i_gid) && !capable(CAP_FSETID))
                        attr->ia_mode &= ~S_ISGID;
        }

It "looks" like it is doing a similar thing for the S_ISGID case but
not for the S_ISUID case.

And then we have similar code in inode_setattr()
        if (ia_valid & ATTR_MODE) {
                umode_t mode = attr->ia_mode;

                if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
                        mode &= ~S_ISGID;
                inode->i_mode = mode;
        }

But what about the suid case?

And also, what is with the ATTR_KILL_* bits?
Lemme look...

should_remove_suid:
  CAP_FSETID -> return 0
  else -> return (S_ISUID ? ATTR_KILL_SUID : 0) | (S_ISGID & S_IXGRP ? ATTR_KILL_SGID : 0)

do_truncate:
        /* Remove suid/sgid on truncate too */
        newattrs.ia_valid |= should_remove_suid(dentry);
        err = notify_change(dentry, &newattrs);

Oh okay,
so in notify_change() we clear the S_SUID/S_SGID bits in the cases that
ATTR_KILL_SUID/ATTR_KILL_SGID are set and let lower setattr
funcs interpret the KILL bits (as said in a comment).
Hmmm....but it first clears the bits out of the attr->ia_mode
so it does interpret them.

This seems a bit twisty to follow.

--Tim

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-09-29 18:27:29.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-09-29 18:27:32.000000000 +0200
> @@ -158,56 +161,6 @@ xfs_setattr(
>  
>  	xfs_ilock(ip, lock_flags);
>  
> -	/* boolean: are we the file owner? */
> -	file_owner = (current_fsuid(credp) == ip->i_d.di_uid);
> -
> -	/*
> -	 * Change various properties of a file.
> -	 * Only the owner or users with CAP_FOWNER
> -	 * capability may do these things.
> -	 */
> -	if (mask & (ATTR_MODE|ATTR_UID|ATTR_GID)) {
> -		/*
> -		 * CAP_FOWNER overrides the following restrictions:
> -		 *
> -		 * The user ID of the calling process must be equal
> -		 * to the file owner ID, except in cases where the
> -		 * CAP_FSETID capability is applicable.
> -		 */
> -		if (!file_owner && !capable(CAP_FOWNER)) {
> -			code = XFS_ERROR(EPERM);
> -			goto error_return;
> -		}
> -
> -		/*
> -		 * CAP_FSETID overrides the following restrictions:
> -		 *
> -		 * The effective user ID of the calling process shall match
> -		 * the file owner when setting the set-user-ID and
> -		 * set-group-ID bits on that file.
> -		 *
> -		 * The effective group ID or one of the supplementary group
> -		 * IDs of the calling process shall match the group owner of
> -		 * the file when setting the set-group-ID bit on that file
> -		 */
> -		if (mask & ATTR_MODE) {
> -			mode_t m = 0;
> -
> -			if ((iattr->ia_mode & S_ISUID) && !file_owner)
> -				m |= S_ISUID;
> -			if ((iattr->ia_mode & S_ISGID) &&
> -			    !in_group_p((gid_t)ip->i_d.di_gid))
> -				m |= S_ISGID;
> -#if 0
> -			/* Linux allows this, Irix doesn't. */
> -			if ((iattr->ia_mode & S_ISVTX) && !S_ISDIR(ip->i_d.di_mode))
> -				m |= S_ISVTX;
> -#endif
> -			if (m && !capable(CAP_FSETID))
> -				iattr->ia_mode &= ~m;
> -		}
> -	}
> -
