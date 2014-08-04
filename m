Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 452C77F74
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2014 17:15:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 135BF30406B
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2014 15:15:46 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	PMgBnv6BGYNecUfB for <xfs@oss.sgi.com>;
	Mon, 04 Aug 2014 15:15:41 -0700 (PDT)
Date: Tue, 5 Aug 2014 08:15:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] xfs: consolidate superblock logging functions
Message-ID: <20140804221526.GZ20518@dastard>
References: <1406791995-14723-1-git-send-email-david@fromorbit.com>
	<1406791995-14723-3-git-send-email-david@fromorbit.com>
	<20140801143929.GC3582@laptop.bfoster>
	<20140804080930.GY20518@dastard>
	<20140804124836.GA4049@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140804124836.GA4049@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 04, 2014 at 08:48:36AM -0400, Brian Foster wrote:
> On Mon, Aug 04, 2014 at 06:09:30PM +1000, Dave Chinner wrote:
> > On Fri, Aug 01, 2014 at 10:39:29AM -0400, Brian Foster wrote:
> > > On Thu, Jul 31, 2014 at 05:33:11PM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > We now have several superblock loggin functions that are identical
> > > > except for the transaction reservation and whether it shoul dbe a
> > > > synchronous transaction or not. Consolidate these all into a single
> > > > function, a single reserveration and a sync flag and call it
> > > > xfs_sync_sb().
> > > > 
> > > > Also, xfs_mod_sb() is not really a modification function - it's the
> > > > operation of logging the superblock buffer. hence change the name of
> > > > it to reflect this.
> > > > 
> > > > Note that we have to change the mp->m_update_flags that are passed
> > > > around at mount time to a boolean simply to indicate a superblock
> > > > update is needed.
> > .....
> > > > +
> > > > +/*
> > > > + * xfs_sync_sb
> > > > + *
> > > > + * Sync the superblock to disk.
> > > > + *
> > > > + * Note this code can be called during the process of freezing, so
> > > > + * we may need to use the transaction allocator which does not
> > > > + * block when the transaction subsystem is in its frozen state.
> > > > + */
> > > > +int
> > > > +xfs_sync_sb(
> > > > +	struct xfs_mount	*mp,
> > > > +	bool			wait)
> > > > +{
> > > > +	struct xfs_trans	*tp;
> > > > +	int			error;
> > > > +
> > > > +	tp = _xfs_trans_alloc(mp, XFS_TRANS_SB_CHANGE, KM_SLEEP);
> > > 
> > > We're converting some previous calls of xfs_trans_alloc() to the
> > > _xfs_trans_alloc() variant. The only difference is the dropped call to
> > > sb_start_intwrite() and I see that technically we handle that with the
> > > xfs_fs_writeable() check.
> > 
> > Writing a change to the superblock is not something that normal
> > operations do. They are something that is typically done as a
> > standalone management operation, and hence the xfs_fs_writeable()
> > check is usually enough.
> > 
> 
> Fair point, an sb modification is something that should stand out. I
> think the characteristic of the new api is somewhat subtle, however.

Which is why there's a comment explaining it. Is there anything I
can add to that comment to make it clearer?

> > > Unless I misunderstand, the sb_start_inwrite() call is what will
> > > block us on internal transaction allocs once the fs is already
> > > frozen.  It seems a little dicey to me to offer up this single
> > > helper without much indication that a frozen check might be a
> > > requirement, particularly since this is expected to be built into
> > > the transaction infrastructure.
> > 
> > Right, but none of the callers actually are run in a situation where
> > they should block on freezes, either complete or in progress. i.e.
> > there is no requirement for freeze checks - there is the opposite:
> > requirements to avoid freeze checks so the code doesn't deadlock.
> > 
> 
> Sure, but the codepaths with that requirement were previously explicitly
> and exclusively using _xfs_trans_alloc().

And they still are. It's just now explicit for a bunch more use
cases that previously weren't....

> > > How would we expect a new caller to identify that?
> > 
> > Same as we always do: by code review.
> > 
> 
> Fair enough, but what happens if^Wwhen something is missed? :) I think
> that means we can potentially modify a frozen fs.

Sure, but that can happen if we make any number of mistakes.....

> I'd feel better if we
> had a BUG_ON() or assert at the very least, but the obvious problem is
> the couple of contexts we have where we explicitly make a modification
> as part of the freeze sequence.

Yup, and that's why I put a comment there instead of trying to add
asserts - there is no single freeze condition we can actually assert
on because the code is called from non-freeze situations where the
s_umount is held as well as situations where the freeze is in
progress. I guess that the only thing we might see as common is that
the s_umount is held in all these code paths, but I'm not sure that
we should be looking at that lock this deep inside the XFS code...

> > > Even the current xfs_fs_writable() check seems like it might be
> > > unnecessary, given some brief testing. I don't hit the mount path at all
> > > on a frozen fs.
> > 
> > xfs_fs_writable() checks more than whether the filesystem is
> > frozen. ;)
> > 
> 
> Sure, so there's a new shutdown check before the xfs_trans_commit() that
> would fail anyways due to already having a shutdown check. ;)

There isn't any new check before a transaction commit in this patch.
The only change involving xfs_fs_writeable() was this in
xfs_mount_reset_sbqflags():

-       if (mp->m_flags & XFS_MOUNT_RDONLY)
+       if (!xfs_fs_writable(mp))

I can revert that if you're really concerned about it....

> > > I'm not sure of the mechanics behind that, but I'm
> > > guessing some kind of reference remains on the sb of a frozen fs and a
> > > subsequent umount/mount is purely namespace magic. Point being... this
> > > appears to be implicit and confusing. IMO, using an _xfs_sync_sb()
> > > variant that allocates a nonblocking tp if one isn't provided as a
> > > parameter (for example) and using that only in the contexts we know it's
> > > Ok to avoid freeze interaction issues might be more clear.
> > 
> > Well, it was pretty clear to me that the code paths were free of
> > freeze interactions. Looking at this - especially the quota on/off
> > paths - I guess it's not as obvious as I thought it was... :/
> > 
> 
> My point was more geared towards future use. E.g., we have frozen fs
> management built into transaction management, which is nice and clean
> and easy to understand.

Actually, it's nowhere near as clean as you think. :/

e.g. did you know that the xfs_fs_writable() check in
xfs_log_sbcount() is to prevent it from writing anything when
unmounting a fully frozen filesystem? i.e. xfs_log_sbcount needs to
succeed while a freeze is in progress, but fail when a freeze is
fully complete?

i.e. we *already have* micro-management of frozen state for
superblock writes, even if it's not explicitly stated.

Factoring the logging implementation does not change the fact we
already have higher level management of freeze state and will
continue to need it in the future. I realise that all the freeze
complexities are not exactly obvious, so if there are new comments
that would help please suggest what you'd like to see ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
