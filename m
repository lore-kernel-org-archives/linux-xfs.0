Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:14605
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751528AbdHOIod (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Aug 2017 04:44:33 -0400
Date: Tue, 15 Aug 2017 18:44:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: preserve i_mode if __xfs_set_acl() fails
Message-ID: <20170815084430.GK21024@dastard>
References: <20170814081806.GA3924@debian.home>
 <20170815020018.GF21024@dastard>
 <20170815061857.GA2803@debian.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170815061857.GA2803@debian.home>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ernesto =?iso-8859-1?Q?A=2E_Fern=E1ndez?= <ernesto.mnd.fernandez@gmail.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Zorro Lang <zlang@redhat.com>

On Tue, Aug 15, 2017 at 03:18:58AM -0300, Ernesto A. Fernández wrote:
> Hi Dave, thanks for the review!
> 
> On Tue, Aug 15, 2017 at 12:00:18PM +1000, Dave Chinner wrote:
> > On Mon, Aug 14, 2017 at 05:18:10AM -0300, Ernesto A. Fernández wrote:
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index de7b9bd..c3193e1 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > @@ -395,6 +395,7 @@ xfs_attr_remove(
> > >  	struct xfs_defer_ops	dfops;
> > >  	xfs_fsblock_t		firstblock;
> > >  	int			error;
> > > +	int			noattr = 0;
> > 
> > bool.
> > 
> > And make it "bool has_attr = true" to avoid the nasty double
> > negative of "!noattr" later on.
> 
> I called it noattr because the error was -ENOATTR, but you are right,
> has_attr is better. I assume you would prefer mode_changed to be a bool
> as well?
> 
> > 
> > >  
> > >  	XFS_STATS_INC(mp, xs_attr_remove);
> > >  
> > > @@ -438,7 +439,12 @@ xfs_attr_remove(
> > >  	xfs_trans_ijoin(args.trans, dp, 0);
> > >  
> > >  	if (!xfs_inode_hasattr(dp)) {
> > > -		error = -ENOATTR;
> > > +		/*
> > > +		 * Commit even if there is no attr to remove, because when
> > > +		 * setting ACLs the caller may be changing the mode in the
> > > +		 * same transaction.
> > > +		 */
> > > +		noattr = 1;
> > >  	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> > >  		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> > >  		error = xfs_attr_shortform_remove(&args);
> > > @@ -458,7 +464,7 @@ xfs_attr_remove(
> > >  	if (mp->m_flags & XFS_MOUNT_WSYNC)
> > >  		xfs_trans_set_sync(args.trans);
> > >  
> > > -	if ((flags & ATTR_KERNOTIME) == 0)
> > > +	if ((flags & ATTR_KERNOTIME) == 0 && !noattr)
> > >  		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
> > 
> > Why?
> 
> Because we don't want the ctime to change when you try to delete an
> attribute that didn't exist in the first place. At least that's how
> it went before, so I tried to keep it the same.

Which means the logic is convoluted and no longer obvious as to what
it does. i.e. the noattr case is running a transaction that dirties
an inode that no modifications were made to. Alarm bells right
there.

> > > @@ -257,16 +242,20 @@ xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
> > >  		return error;
> > >  
> > >  	if (type == ACL_TYPE_ACCESS) {
> > > -		umode_t mode;
> > > -
> > > -		error = posix_acl_update_mode(inode, &mode, &acl);
> > > -		if (error)
> > > -			return error;
> > > -		error = xfs_set_mode(inode, mode);
> > > +		error = posix_acl_update_mode(inode, &inode->i_mode, &acl);
> > >  		if (error)
> > >  			return error;
> > > +		inode->i_ctime = current_time(inode);
> > > +		XFS_STATS_INC(XFS_I(inode)->i_mount, xs_ig_attrchg);
> > > +		mode_changed = 1;
> > >  	}
> > 
> > And this doesn't.
> > 
> > So this breaks all our rules for inode metadata updates, both for
> > runtime access serialisation and for crash consistency.
> 
> I'm only making changes to the vfs inode, and xfs_set_acl() should always
> be called with i_rwsem held for writing. I think that should be enough to
> serialize access to the vfs inode fields.

It's not. The i_rwsem does not protect XFS inode metadata, which is
what needs changing here. i.e. we change both the VFS inode and
the corresponding XFS inode metadata at the same time, under the
same XFS_ILOCK_EXCL lock, only inside a transaction context.

That's the rules, no exceptions.

> I'm sorry, I'm not sure I follow the crash consistency part. This is not
> writing anything to disk.

xfs_set_mode() runs a transaction that is journalled to change the
inode mode. You break in-memory consistency by modifying the VFS
inode state directly without holding the correct locks (see
xfs_setattr_mode()), and you break the transactional change model
(i.e. on-disk journal consistency and on-disk metadata change
ordering) by making metadata changes this outside transaction
contexts and without holding the correct locks.

> My expectation was that the changes I made to
> the vfs inode would be attached to the transaction later, when calling
> xfs_trans_log_inode() in xfs_attr_set() or xfs_attr_remove(). Would that
> not work as intended?

No, it wouldn't.  You have to follow the filesystem specific update
rules to change inode metadata, not make up your own....

> I was mostly imitating how btrfs sets an ACL, so I
> could be misunderstanding how xfs does journaling.

... and btrfs has a completely different transaction model and
implementation to XFS. IOWs, trying to do what works for btrfs in
XFS code will break XFS. And vice versa.

> > >   set_acl:
> > > -	return __xfs_set_acl(inode, acl, type);
> > > +	error = __xfs_set_acl(inode, acl, type);
> > > +	if (error && mode_changed) {
> > > +		inode->i_mode = old_mode;
> > > +		inode->i_ctime = old_ctime;
> > > +		XFS_STATS_DEC(XFS_I(inode)->i_mount, xs_ig_attrchg);
> > > +	}
> > 
> > Same here.
> 
> i_rwsem would still be held here. My reasoning is that, since there was
> an error, no changes were actually committed; so there would be no need
> to commit the restoration either, just restore the old in-memory vfs inode
> fields. Once again, this is inspired by btrfs, so I suppose it may fail
> here in some way I can't see.
> 
> (I should probably clarify I did run tests before submitting)

When you treat the code as a black box for testing, then end result
might appear to be what you want. That doesn't mean the
implementation is correct or that hidden transient states within the
block box are incorrect or invalid.

> > IOWs, you can't just remove a transactional modification of inode
> > state and replace it with in-memory VFS inode level changes. You
> > need to do the changes in transaction context and with the correct
> > locks held.
> >
> > IOWs, if you need to undo the mode changes xfs_set_mode() did, you
> > need to call xfs_set_mode() again. And because modifications have
> 
> But that could fail as well, and how would we handle that?

If the xattr change was not a fatal error (which will shut down the
filesystem), then calling xfs_set_mode() should work just fine as it
doesn't require any new space to be allocated (XFS != BTRFS - we can
run overwriting transactions even at ENOSPC).

And you need to run the mode undo as a separate transaction
because....

> If this bug
> is to be fixed the whole thing needs to be a single transaction.

.... this is simply not possible. Why? Because __xfs_set_acl() can
run up three separate transactions internally in adding the new
xattr. That means your unlogged vfs indoe change has already been
logged to the journal and so we *require* a transaction to overwrite
the new mode that has already been committed to the journal.

But I have to ask - why do we even need to modify the mode first?
Why not change the ACL first, then modify the mode+timestamp? If
setting the ACL fails, then we don't have anything to undo and all
is good....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
