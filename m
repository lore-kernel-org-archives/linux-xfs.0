Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AD2427F66
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2014 07:48:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 93C468F8049
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2014 05:48:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HlzneBr0z5w9knMj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Aug 2014 05:48:47 -0700 (PDT)
Date: Mon, 4 Aug 2014 08:48:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/6] xfs: consolidate superblock logging functions
Message-ID: <20140804124836.GA4049@bfoster.bfoster>
References: <1406791995-14723-1-git-send-email-david@fromorbit.com>
	<1406791995-14723-3-git-send-email-david@fromorbit.com>
	<20140801143929.GC3582@laptop.bfoster>
	<20140804080930.GY20518@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140804080930.GY20518@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 04, 2014 at 06:09:30PM +1000, Dave Chinner wrote:
> On Fri, Aug 01, 2014 at 10:39:29AM -0400, Brian Foster wrote:
> > On Thu, Jul 31, 2014 at 05:33:11PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > We now have several superblock loggin functions that are identical
> > > except for the transaction reservation and whether it shoul dbe a
> > > synchronous transaction or not. Consolidate these all into a single
> > > function, a single reserveration and a sync flag and call it
> > > xfs_sync_sb().
> > > 
> > > Also, xfs_mod_sb() is not really a modification function - it's the
> > > operation of logging the superblock buffer. hence change the name of
> > > it to reflect this.
> > > 
> > > Note that we have to change the mp->m_update_flags that are passed
> > > around at mount time to a boolean simply to indicate a superblock
> > > update is needed.
> .....
> > > +
> > > +/*
> > > + * xfs_sync_sb
> > > + *
> > > + * Sync the superblock to disk.
> > > + *
> > > + * Note this code can be called during the process of freezing, so
> > > + * we may need to use the transaction allocator which does not
> > > + * block when the transaction subsystem is in its frozen state.
> > > + */
> > > +int
> > > +xfs_sync_sb(
> > > +	struct xfs_mount	*mp,
> > > +	bool			wait)
> > > +{
> > > +	struct xfs_trans	*tp;
> > > +	int			error;
> > > +
> > > +	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_CHANGE, KM_SLEEP);
> > 
> > We're converting some previous calls of xfs_trans_alloc() to the
> > _xfs_trans_alloc() variant. The only difference is the dropped call to
> > sb_start_intwrite() and I see that technically we handle that with the
> > xfs_fs_writeable() check.
> 
> Writing a change to the superblock is not something that normal
> operations do. They are something that is typically done as a
> standalone management operation, and hence the xfs_fs_writeable()
> check is usually enough.
> 

Fair point, an sb modification is something that should stand out. I
think the characteristic of the new api is somewhat subtle, however.

> So, the callers are:
> 
> 	xfs_fs_log_dummy	-> occurs during freeze
> 	  _xfs_trans_alloc	-> no change
> 
> and
> 	xfs_log_sbcount		-> occurs during freeze, unmount
> 	  _xfs_trans_alloc	-> no change
> 
> and
> 	xfs_mount_reset_sbqflags	-> called only in mount path
> 	  xfs_fs_writable		-> was just a RO check
> 	  _xfs_trans_alloc		-> was xfs_trans_alloc
> 
> and
> 	xfs_mount_log_sb		-> called only in mount path
> 	  _xfs_trans_alloc		-> was xfs_trans_alloc
> 
> and
> 	xfs_qm_write_sb_changes		-> quota on/off syscalls
> 	  _xfs_trans_alloc		-> was xfs_trans_alloc
> 
> So the first 4 are effectively unchanged - there can be no racing
> freeze while we are in the mount path, so the change from
> xfs_trans_alloc to _xfs_trans_alloc makes no difference at all.
> Similarly, the change from an open-coded RO check to
> xfs_fs_writable() makes no difference, either.
> 

Indeed, there wasn't anything technically wrong with the changes that I
could identify.

> It's only the last function - xfs_qm_write_sb_changes() - where
> there is a difference. However, let's walk all the way back up the
> stack to the syscall quotactl():
> 
> 	sys_quotactl
> 	  quotactl_block()
> 	    if (quotactl_cmd_write())
> 	      get_super_thawed()
> 
> which will only proceed with an unfrozen superblock, and it holds
> the sb->s_umount lock in read mode across the quotactl operation.
> Hence it will prevent the filesystem from being frozen during quota
> on/off operations. Hence we don't need or want freeze accounting on
> those operations because they need to complete before a freeze can
> be started.
> 

I didn't catch that one though.

> > Unless I misunderstand, the sb_start_inwrite() call is what will
> > block us on internal transaction allocs once the fs is already
> > frozen.  It seems a little dicey to me to offer up this single
> > helper without much indication that a frozen check might be a
> > requirement, particularly since this is expected to be built into
> > the transaction infrastructure.
> 
> Right, but none of the callers actually are run in a situation where
> they should block on freezes, either complete or in progress. i.e.
> there is no requirement for freeze checks - there is the opposite:
> requirements to avoid freeze checks so the code doesn't deadlock.
> 

Sure, but the codepaths with that requirement were previously explicitly
and exclusively using _xfs_trans_alloc().

> > How would we expect a new caller to identify that?
> 
> Same as we always do: by code review.
> 

Fair enough, but what happens if^Wwhen something is missed? :) I think
that means we can potentially modify a frozen fs. I'd feel better if we
had a BUG_ON() or assert at the very least, but the obvious problem is
the couple of contexts we have where we explicitly make a modification
as part of the freeze sequence.

> > Even the current xfs_fs_writable() check seems like it might be
> > unnecessary, given some brief testing. I don't hit the mount path at all
> > on a frozen fs.
> 
> xfs_fs_writable() checks more than whether the filesystem is
> frozen. ;)
> 

Sure, so there's a new shutdown check before the xfs_trans_commit() that
would fail anyways due to already having a shutdown check. ;)

> > I'm not sure of the mechanics behind that, but I'm
> > guessing some kind of reference remains on the sb of a frozen fs and a
> > subsequent umount/mount is purely namespace magic. Point being... this
> > appears to be implicit and confusing. IMO, using an _xfs_sync_sb()
> > variant that allocates a nonblocking tp if one isn't provided as a
> > parameter (for example) and using that only in the contexts we know it's
> > Ok to avoid freeze interaction issues might be more clear.
> 
> Well, it was pretty clear to me that the code paths were free of
> freeze interactions. Looking at this - especially the quota on/off
> paths - I guess it's not as obvious as I thought it was... :/
> 

My point was more geared towards future use. E.g., we have frozen fs
management built into transaction management, which is nice and clean
and easy to understand. We have a couple freeze path contexts that
require to jump around that interface, which is also fairly
straightforward. That is code that probably shouldn't have to change
that much, and if it does, chances are you're dealing with some kind of
freeze issue and have that context in mind.

Now we have a generic superblock logging/sync mechanism that is built on
top of the shortcut that's been built in for freeze. Technically that's
Ok because sb modifications are special and rare (or already handle
freeze blocking), but freeze management just isn't quite as contained as
it used to be. An API change probably isn't necessary since it appears
that the other uses are all "don't cares" as far as freeze context goes,
but IMO the comment ("we may need to use the transaction allocator that
doesn't block") could be made a little more explicit and point out that
callers are responsible for freeze management. A bug_on() or assert would
help, but looking again it appears we already have a warn_on() in
_xfs_trans_alloc() that I suspect handles the freeze phases correctly. I
didn't notice that before and that should be sufficiently noisy if
something is amiss. :)

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
