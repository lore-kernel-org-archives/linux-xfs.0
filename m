Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Jun 2007 13:55:27 -0700 (PDT)
Received: from astra.simleu.ro (astra.simleu.ro [80.97.18.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5EKtMWt019655
	for <xfs@oss.sgi.com>; Thu, 14 Jun 2007 13:55:24 -0700
Date: Thu, 14 Jun 2007 22:55:18 +0200
From: Iustin Pop <iusty@k1024.org>
Subject: Re: [PATCH] Implement shrink of empty AGs
Message-ID: <20070614205518.GA4327@teal.hq.k1024.org>
References: <20070610164014.GA10936@teal.hq.k1024.org> <20070612024025.GM86004887@sgi.com> <20070614060158.GA12951@teal.hq.k1024.org> <20070614090052.GA86004887@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614090052.GA86004887@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 14, 2007 at 07:00:52PM +1000, David Chinner wrote:
> > > What's the dbdelta part of the reservation for? That's reserving dbdelta
> > > blocks for *allocations*, so I don't think this is right....
> >
> > Well, we'll shrink the filesystem by dbdelta, so the filesystem needs to
> > have enough free space to do it.
> 
> True, but when you look at how much free space we need to make that
> modification, it turns out ot be zero. i.e. we don't need to do any
> allocations *anywhere* to remove an empty AG from the end of the
> filesystem - just log a change to the superblock(s).
> 
> > Whether this space is in the correct
> > place (the AGs we want to shrink) or not is a question answered by the
> > per-AG checking, but since we will reduce the freespace by this amount,
> > I thought that it's safer to mark this space in use. Did I misread the
> > intent of xfs_trans_reserve?
> 
> The transactions reservation takes into account blocks that may need
> to be allocated during a transaction. Normally when we are freeing
> an extent, we may still have to allocate some blocks because a
> btree block might need to be split (and split all the way up the tree
> to the root). The XFS_GROWFS_SPACE_RES(mp) macro reserves the space
> needed for the freeing of a new extent which occurs during growing a
> partial AG to a full AG. We aren't doing such an operation here;
> we don't modify any free space or inode or extent btrees here at
> all.
Ah, finally I understand what the reservation is for. I probably
misunderstood the actual meaning of the transaction also...

Thanks for the clear explanation, will remove this.

> [...]
> Note that I'm just using this as an example piece of existing code that would
> break badly if we simply realloc the perag array. I could point you to the
> filestreams code where there is a perag stream refcount that we'll need to
> ensure is zero.
> 
> What I'm trying to say is that the perag lock may not give us sufficient
> exclusion to be able to shrink the perag array safely.
Interesting conclusion. I'm fail right now to come up with an idea,
except auditing the whole codebase and make sure any down_read is
followed by a check on the perag size. Or something like adding a flag
to the perag structure like 'gone' that is checked (since we won't
k_realloc anymore), after the read lock.

> > > ok, so we have empty ag's here. You might want to check that the
> > > inode btree is empty and that the AGI unlinked list is empty.
> > I thought that inode btree is empty by virtue of pag->pagi_count == 0.
> > Is this not always so?
> 
> It should be. Call me paranoid, but with an operation like this I want
> to make sure we check and double check that it is safe to proceed.
> 
> > Furthermore, also since agi_count == agi_free +
> > actual used inodes + number of unlinked inodes, I think we don't need to
> > check the unlinked list.
> 
> Call me paranoid, but....
> 
> I think at minimum there should be debug code that caters to my paranoia ;)
Ok, I'll look into this then. I understand the paranoia, I just assumed
that logically it's provable that this situation doesn't/can't happen.

> > > Ok, so why not just
> > > 
> > > 	fdbdelta += mp->m_sb.sb_agblocks - XFS_PREALLOC_BLOCKS(mp);
> > Because the last AG can be smaller than the sb_agblocks. It's true
> > that this holds only for the last one, but having two cases is uglier
> > than just always reading this size from the AG.
> 
> But you -EINVAL'd earlier when the shrink size would not leave entire
> AGs behind. So the partial last AG is something that won't happen
> here.....
No, what I meant when I said 'last AG' is the "original" last, not the
"new" last. Consider this fs: AGs 1-8 = 4096 blocks, AG 9 = 3000 blocks.
We can't, in the for loop, make fbdelta += mp->m_sb.sb_agblocks ...
since that is 4096, whereas the for 'last' AG (AG 9) has only 3000
blocks.

What I mean is that for a normal filesystem (non-shrink situation), the
size of the last AG is readable only from the AGF structure on-disk,
but for all the others AG the size is the one from the superblock. So if
you touch the last AG, you have to read the AGF.

> > > This is not really safe - how do we know if all the users of the
> > > higher AGs have gone away? I think we should simply just zero out
> > > the unused AGs and don't worry about a realloc().
> > The problem that I saw is that if you do shrink+grow+shrink+grow+... you
> > will leak a small amount of memory (or corrupt kernel mem allocation?)
> > since the growfs code does a realloc from what it thinks is the size of
> > m_perag, which it computes solely from the current number of AGs. Should
> > we have a size in the mp struct for this and not assume it's the
> > agcount?
> 
> Yup, another size variable in the mount structure is probably the only
> way to fix this.
Ok, noted. Also I get the impression that this ties in with the perag
locking above somehow...

> > updated patch (without the separation of the IOCTL and without the
> > rework of the perag lock) is attached.
> 
> I haven't looked at it yet - i'll try to get to it tomorrow...
No hurry, just small changes.

I'll think about the issues you raised.

thanks,
iustin
