Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:34780 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753193AbdHOGTE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Aug 2017 02:19:04 -0400
Received: by mail-qk0-f180.google.com with SMTP id u139so289627qka.1
        for <linux-xfs@vger.kernel.org>; Mon, 14 Aug 2017 23:19:04 -0700 (PDT)
Date: Tue, 15 Aug 2017 03:18:58 -0300
From: Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
Subject: Re: [PATCH] xfs: preserve i_mode if __xfs_set_acl() fails
Message-ID: <20170815061857.GA2803@debian.home>
References: <20170814081806.GA3924@debian.home>
 <20170815020018.GF21024@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170815020018.GF21024@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Zorro Lang <zlang@redhat.com>, Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?= <ernesto.mnd.fernandez@gmail.com>

Hi Dave, thanks for the review!

On Tue, Aug 15, 2017 at 12:00:18PM +1000, Dave Chinner wrote:
> On Mon, Aug 14, 2017 at 05:18:10AM -0300, Ernesto A. Fernández wrote:
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index de7b9bd..c3193e1 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> > @@ -395,6 +395,7 @@ xfs_attr_remove(
> >  	struct xfs_defer_ops	dfops;
> >  	xfs_fsblock_t		firstblock;
> >  	int			error;
> > +	int			noattr = 0;
> 
> bool.
> 
> And make it "bool has_attr = true" to avoid the nasty double
> negative of "!noattr" later on.

I called it noattr because the error was -ENOATTR, but you are right,
has_attr is better. I assume you would prefer mode_changed to be a bool
as well?

> 
> >  
> >  	XFS_STATS_INC(mp, xs_attr_remove);
> >  
> > @@ -438,7 +439,12 @@ xfs_attr_remove(
> >  	xfs_trans_ijoin(args.trans, dp, 0);
> >  
> >  	if (!xfs_inode_hasattr(dp)) {
> > -		error = -ENOATTR;
> > +		/*
> > +		 * Commit even if there is no attr to remove, because when
> > +		 * setting ACLs the caller may be changing the mode in the
> > +		 * same transaction.
> > +		 */
> > +		noattr = 1;
> >  	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> >  		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> >  		error = xfs_attr_shortform_remove(&args);
> > @@ -458,7 +464,7 @@ xfs_attr_remove(
> >  	if (mp->m_flags & XFS_MOUNT_WSYNC)
> >  		xfs_trans_set_sync(args.trans);
> >  
> > -	if ((flags & ATTR_KERNOTIME) == 0)
> > +	if ((flags & ATTR_KERNOTIME) == 0 && !noattr)
> >  		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
> 
> Why?

Because we don't want the ctime to change when you try to delete an
attribute that didn't exist in the first place. At least that's how
it went before, so I tried to keep it the same.

> 
> >  
> >  	/*
> > @@ -468,6 +474,9 @@ xfs_attr_remove(
> >  	error = xfs_trans_commit(args.trans);
> >  	xfs_iunlock(dp, XFS_ILOCK_EXCL);
> >  
> > +	if (!error && noattr)
> > +		error = -ENOATTR;
> > +
> >  	return error;
> >  
> >  out:
> > diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> > index 7034e17..1fe4363 100644
> > --- a/fs/xfs/xfs_acl.c
> > +++ b/fs/xfs/xfs_acl.c
> > @@ -226,28 +226,13 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
> >  	return error;
> >  }
> >  
> > -static int
> > -xfs_set_mode(struct inode *inode, umode_t mode)
> > -{
> > -	int error = 0;
> > -
> > -	if (mode != inode->i_mode) {
> > -		struct iattr iattr;
> > -
> > -		iattr.ia_valid = ATTR_MODE | ATTR_CTIME;
> > -		iattr.ia_mode = mode;
> > -		iattr.ia_ctime = current_time(inode);
> > -
> > -		error = xfs_setattr_nonsize(XFS_I(inode), &iattr, XFS_ATTR_NOACL);
> > -	}
> > -
> > -	return error;
> > -}
> 
> Ok, so that does an atomic, transactional change to the inode
> mode....
> 
> >  int
> >  xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
> >  {
> >  	int error = 0;
> > +	int mode_changed = 0;
> > +	umode_t old_mode = inode->i_mode;
> > +	struct timespec old_ctime = inode->i_ctime;
> >  
> >  	if (!acl)
> >  		goto set_acl;
> > @@ -257,16 +242,20 @@ xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
> >  		return error;
> >  
> >  	if (type == ACL_TYPE_ACCESS) {
> > -		umode_t mode;
> > -
> > -		error = posix_acl_update_mode(inode, &mode, &acl);
> > -		if (error)
> > -			return error;
> > -		error = xfs_set_mode(inode, mode);
> > +		error = posix_acl_update_mode(inode, &inode->i_mode, &acl);
> >  		if (error)
> >  			return error;
> > +		inode->i_ctime = current_time(inode);
> > +		XFS_STATS_INC(XFS_I(inode)->i_mount, xs_ig_attrchg);
> > +		mode_changed = 1;
> >  	}
> 
> And this doesn't.
> 
> So this breaks all our rules for inode metadata updates, both for
> runtime access serialisation and for crash consistency.
> 

I'm only making changes to the vfs inode, and xfs_set_acl() should always
be called with i_rwsem held for writing. I think that should be enough to
serialize access to the vfs inode fields.

I'm sorry, I'm not sure I follow the crash consistency part. This is not
writing anything to disk. My expectation was that the changes I made to
the vfs inode would be attached to the transaction later, when calling
xfs_trans_log_inode() in xfs_attr_set() or xfs_attr_remove(). Would that
not work as intended? I was mostly imitating how btrfs sets an ACL, so I
could be misunderstanding how xfs does journaling.

> >   set_acl:
> > -	return __xfs_set_acl(inode, acl, type);
> > +	error = __xfs_set_acl(inode, acl, type);
> > +	if (error && mode_changed) {
> > +		inode->i_mode = old_mode;
> > +		inode->i_ctime = old_ctime;
> > +		XFS_STATS_DEC(XFS_I(inode)->i_mount, xs_ig_attrchg);
> > +	}
> 
> Same here.

i_rwsem would still be held here. My reasoning is that, since there was
an error, no changes were actually committed; so there would be no need
to commit the restoration either, just restore the old in-memory vfs inode
fields. Once again, this is inspired by btrfs, so I suppose it may fail
here in some way I can't see.

(I should probably clarify I did run tests before submitting)

> IOWs, you can't just remove a transactional modification of inode
> state and replace it with in-memory VFS inode level changes. You
> need to do the changes in transaction context and with the correct
> locks held.
>
> IOWs, if you need to undo the mode changes xfs_set_mode() did, you
> need to call xfs_set_mode() again. And because modifications have

But that could fail as well, and how would we handle that? If this bug
is to be fixed the whole thing needs to be a single transaction. That's
why I removed the xfs_set_mode() function in the first place.

> been made, the new ctime should remain in place, too.
>
> Of course, this still isn't atomic from a runtime access POV, but
> that's substantially harder to provide than just undoing the mode
> change on ACL attribute save error.
>
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

Thanks,
Ernest
