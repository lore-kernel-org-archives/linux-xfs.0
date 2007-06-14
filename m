Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Jun 2007 02:01:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5E90wWt023159
	for <xfs@oss.sgi.com>; Thu, 14 Jun 2007 02:01:01 -0700
Date: Thu, 14 Jun 2007 19:00:52 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Implement shrink of empty AGs
Message-ID: <20070614090052.GA86004887@sgi.com>
References: <20070610164014.GA10936@teal.hq.k1024.org> <20070612024025.GM86004887@sgi.com> <20070614060158.GA12951@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614060158.GA12951@teal.hq.k1024.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Iustin Pop <iusty@k1024.org>

On Thu, Jun 14, 2007 at 08:01:58AM +0200, Iustin Pop wrote:
> On Tue, Jun 12, 2007 at 12:40:25PM +1000, David Chinner wrote:
> > > diff -X ignore -urN linux-2.6-xfs.cvs-orig/fs/xfs/xfs_fsops.c linux-2.6-xfs.shrink/fs/xfs/xfs_fsops.c
> > > --- linux-2.6-xfs.cvs-orig/fs/xfs/xfs_fsops.c	2007-06-09 18:56:21.509308225 +0200
> > > +++ linux-2.6-xfs.shrink/fs/xfs/xfs_fsops.c	2007-06-10 18:32:36.074856477 +0200
> > > @@ -112,6 +112,53 @@
> > >  	return 0;
> > >  }
> > >  
> > > +static void xfs_update_sb(
> > 
> > STATIC void
> > xfs_growfs_update_sb(
> this was because xfs_growfs_private is also static and not STATIC.
> Should I change the def for it also?

Yes, probably should.

> > > +	xfs_mount_t		*mp,		/* mount point for filesystem */
> > > +	xfs_agnumber_t		nagimax,
> > > +	xfs_agnumber_t		nagcount)       /* new number of a.g. */
> > 
> > tabs, not spaces (and tabs are 8 spaces).
> sorry, I though I got all of these. There are some more in the def of
> xfs_reserve_blocks, btw.

Ok, I'll clean them up in the current fix-reserve-blocks-yet-again
patch I have.

> > > +xfs_shrinkfs_data_private(
> > > +			  xfs_mount_t		*mp,		/* mount point for filesystem */
> > > +			  xfs_growfs_data_t	*in)		/* growfs data input struct */
> > 
> > whitespace issues
> fixed (I think you were referring to the alignement of the two argument
> lines).

Yes.

> > > +	/* dbdelta starts at the diff and must become zero */
> > > +	dbdelta = mp->m_sb.sb_dblocks - nb;
> > > +	tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFS);
> > > +	printk("reserving %d\n", XFS_GROWFS_SPACE_RES(mp) + dbdelta);
> > > +	if ((error = xfs_trans_reserve(tp, XFS_GROWFS_SPACE_RES(mp) + dbdelta,
> > > +				       XFS_GROWDATA_LOG_RES(mp), 0, 0, 0))) {
> > > +		xfs_trans_cancel(tp, 0);
> > > +		return error;
> > > +	}
> > 
> > What's the dbdelta part of the reservation for? That's reserving dbdelta
> > blocks for *allocations*, so I don't think this is right....
>
> Well, we'll shrink the filesystem by dbdelta, so the filesystem needs to
> have enough free space to do it.

True, but when you look at how much free space we need to make that
modification, it turns out ot be zero. i.e. we don't need to do any
allocations *anywhere* to remove an empty AG from the end of the
filesystem - just log a change to the superblock(s).

> Whether this space is in the correct
> place (the AGs we want to shrink) or not is a question answered by the
> per-AG checking, but since we will reduce the freespace by this amount,
> I thought that it's safer to mark this space in use. Did I misread the
> intent of xfs_trans_reserve?

The transactions reservation takes into account blocks that may need
to be allocated during a transaction. Normally when we are freeing
an extent, we may still have to allocate some blocks because a
btree block might need to be split (and split all the way up the tree
to the root). The XFS_GROWFS_SPACE_RES(mp) macro reserves the space
needed for the freeing of a new extent which occurs during growing a
partial AG to a full AG. We aren't doing such an operation here;
we don't modify any free space or inode or extent btrees here at
all.

> Also, unless I'm mistaken and don't remember correctly, you have to
> reserve the amount of space one will pass to xfs_trans_mod_sb(tp,
> XFS_TRANS_SB_FDBLOCKS, ...) otherwise the transaction code complains
> about exceeding your reservation.

xfs_trans_mod_sb:

    459         case XFS_TRANS_SB_FDBLOCKS:
    460                 /*
    461                  * Track the number of blocks allocated in the
    462                  * transaction.  Make sure it does not exceed the
    463                  * number reserved.
    464                  */
    465                 if (delta < 0) {
    466                         tp->t_blk_res_used += (uint)-delta;
    467                         ASSERT(tp->t_blk_res_used <= tp->t_blk_res);
    468                 }
    469                 tp->t_fdblocks_delta += delta;
    470                 if (xfs_sb_version_haslazysbcount(&mp->m_sb))
    471                         flags &= ~XFS_TRANS_SB_DIRTY;
    472                 break;

So, delta < 0 (i.e. allocating blocks) requires a transaction reservation,
but freeing blocks (delta > 0) does not.


> > > +	/* I think that since we do read and write to the m_perag
> > > +	 * stuff, we should be holding the lock for the entire walk &
> > > +	 * modify of the fs
> > > +	 */
> > 
> > Deadlock warning! holding the m_peraglock in write mode will cause
> > allocation deadlocks if you are not careful as all allocation/free
> > operations take the m_peraglock in read mode. (And yes, growing
> > an active, loaded filesystem can deadlock because of this.)
>
> How can we ensure then that no one modifies the AGs while we walk them?

It's not even modify - how do you prevent any *reference* to the perag
while we are doing this.

> I hoped that we can do it without the per-AG not-avail flag, by just
> holding the perag lock.

The per-AG not-available flag will prevent new allocations, but it doesn't prevent
access to the AGs as we still need access to the AGs to copy the data and
metadata out. The m_peraglock in write mode will prevent *simultaneous*
access to the per-ag, but the code waiting on a read lock may still try
to access the bit of the perag structure we're about to remove.

See, for example, xfs_bmap_btalloc(). It gets and AG it is supposed to
use from somewhere external, and then before it goes to use the perag
structure for that AG, it waits on the peraglock in read mode. If that
blocks waiting on a shrink and after the shrink ag > sb_agcount, we're
in a world of pain.....

Note that I'm just using this as an example piece of existing code that would
break badly if we simply realloc the perag array. I could point you to the
filestreams code where there is a perag stream refcount that we'll need to
ensure is zero.

What I'm trying to say is that the perag lock may not give us sufficient
exclusion to be able to shrink the perag array safely.

> > ok, so we have empty ag's here. You might want to check that the
> > inode btree is empty and that the AGI unlinked list is empty.
> I thought that inode btree is empty by virtue of pag->pagi_count == 0.
> Is this not always so?

It should be. Call me paranoid, but with an operation like this I want
to make sure we check and double check that it is safe to proceed.

> Furthermore, also since agi_count == agi_free +
> actual used inodes + number of unlinked inodes, I think we don't need to
> check the unlinked list.

Call me paranoid, but....

I think at minimum there should be debug code that caters to my paranoia ;)

> > > +
> > > +		freeblks = pag->pagf_freeblks;
> > > +		printk("Usage: %d prealloc, %d flcount\n",
> > > +		       XFS_PREALLOC_BLOCKS(mp), pag->pagf_flcount);
> > > +
> > > +		/* Done gathering data, check sizes */
> > > +		usedblks = XFS_PREALLOC_BLOCKS(mp) + pag->pagf_flcount;
> > > +		printk("agno=%d agf_length=%d computed used=%d"
> > > +		       " known free=%d\n", agno, aglen, usedblks, freeblks);
> > > +
> > > +		if(usedblks + freeblks != aglen) {
> > > +			printk("agno %d is not free (%d blocks allocated)\n",
> > > +			       agno, aglen-usedblks-freeblks);
> > > +			error = XFS_ERROR(ENOSPC);
> > > +			goto error0;
> > > +		}
> > > +		dbdelta -= aglen;
> > > +		printk("will lower with %d\n",
> > > +		       aglen - XFS_PREALLOC_BLOCKS(mp));
> > > +		fdbdelta += aglen - XFS_PREALLOC_BLOCKS(mp);
> > 
> > Ok, so why not just
> > 
> > 	fdbdelta += mp->m_sb.sb_agblocks - XFS_PREALLOC_BLOCKS(mp);
> Because the last AG can be smaller than the sb_agblocks. It's true
> that this holds only for the last one, but having two cases is uglier
> than just always reading this size from the AG.

But you -EINVAL'd earlier when the shrink size would not leave entire
AGs behind. So the partial last AG is something that won't happen
here.....

> > > +	}
> > > +	/*
> > > +	 * Check that we removed all blocks
> > > +	 */
> > > +	ASSERT(!dbdelta);
> > > +	ASSERT(nagcount < oagcount);
> > 
> > Error out, not assert, because at this point we have not changed anything.
> Actually here, !dbdelta or nacount < oagacount are programming errors
> and not possible correct conditions.  They could be removed, sine the
> checks before the per-AG for loop ensure these conditions are not met.
> But I used them just to be sure.

Ok - I misinterpreted what they were catching.


> > > +	/* Free memory as the number of AG has changed */
> > > +	for (agno = nagcount; agno < oagcount; agno++)
> > > +		if (mp->m_perag[agno].pagb_list)
> > > +			kmem_free(mp->m_perag[agno].pagb_list,
> > > +				  sizeof(xfs_perag_busy_t) *
> > > +				  XFS_PAGB_NUM_SLOTS);
> > > +
> > > +	mp->m_perag = kmem_realloc(mp->m_perag,
> > > +				   sizeof(xfs_perag_t) * nagcount,
> > > +				   sizeof(xfs_perag_t) * oagcount,
> > > +				   KM_SLEEP);
> > 
> > This is not really safe - how do we know if all the users of the
> > higher AGs have gone away? I think we should simply just zero out
> > the unused AGs and don't worry about a realloc().
> The problem that I saw is that if you do shrink+grow+shrink+grow+... you
> will leak a small amount of memory (or corrupt kernel mem allocation?)
> since the growfs code does a realloc from what it thinks is the size of
> m_perag, which it computes solely from the current number of AGs. Should
> we have a size in the mp struct for this and not assume it's the
> agcount?

Yup, another size variable in the mount structure is probably the only
way to fix this.

> > > +	if(in->newblocks < mp->m_sb.sb_dblocks)
> > > +		error = xfs_shrinkfs_data_private(mp, in);
> > > +	else
> > > +		error = xfs_growfs_data_private(mp, in);
> > 
> > Hmmm - that's using the one ioctl to do both grow and shrink. I'd
> > prefer a new shrink ioctl rather than changing the behaviour of an
> > existing ioctl.
> Well, I chose this way because I see it as the ioctl that changes the
> data size of the filesystem. It may be lower or higher than the current
> size, but that is not so important :), and if another ioctl there would
> be the need for another tool.

True, put that way i think you're right.

> updated patch (without the separation of the IOCTL and without the
> rework of the perag lock) is attached.

I haven't looked at it yet - i'll try to get to it tomorrow...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
