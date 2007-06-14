Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Jun 2007 15:16:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5EMGbWt005302
	for <xfs@oss.sgi.com>; Thu, 14 Jun 2007 15:16:39 -0700
Received: from snort.melbourne.sgi.com (snort.melbourne.sgi.com [134.14.54.149]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id IAA29418 for <xfs@oss.sgi.com>; Fri, 15 Jun 2007 08:16:37 +1000
Received: from snort.melbourne.sgi.com (localhost [127.0.0.1])
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id l5EMGaAf123473244
	for <xfs@oss.sgi.com>; Fri, 15 Jun 2007 08:16:37 +1000 (AEST)
Received: (from dgc@localhost)
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id l5EMGZnm123551665
	for xfs@oss.sgi.com; Fri, 15 Jun 2007 08:16:35 +1000 (AEST)
Date: Fri, 15 Jun 2007 08:16:35 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Implement shrink of empty AGs
Message-ID: <20070614221635.GZ85884050@sgi.com>
References: <20070610164014.GA10936@teal.hq.k1024.org> <20070612024025.GM86004887@sgi.com> <20070614060158.GA12951@teal.hq.k1024.org> <20070614090052.GA86004887@sgi.com> <20070614205518.GA4327@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614205518.GA4327@teal.hq.k1024.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Thu, Jun 14, 2007 at 10:55:18PM +0200, Iustin Pop wrote:
> On Thu, Jun 14, 2007 at 07:00:52PM +1000, David Chinner wrote:
> > [...]
> > Note that I'm just using this as an example piece of existing code that would
> > break badly if we simply realloc the perag array. I could point you to the
> > filestreams code where there is a perag stream refcount that we'll need to
> > ensure is zero.
> > 
> > What I'm trying to say is that the perag lock may not give us sufficient
> > exclusion to be able to shrink the perag array safely.
> Interesting conclusion. I'm fail right now to come up with an idea,
> except auditing the whole codebase

Yup.

> and make sure any down_read is followed by a check on the perag size. 

That doesn't help, really, because at some points we won't be
able to back out and select another AG. i.e. once we've selected
an AG and ensured the perag structure is initialised, it is
assumed it will remain that way forever.

More likely we need reference counting on the AGs as we do operations
(e.g. when we select an AG for an operation we take a reference
and then drop it when we are done) and prevent new references
from being taken on an AG at some point (i.e. once it's been emptied).

> Or something like adding a flag
> to the perag structure like 'gone' that is checked (since we won't
> k_realloc anymore), after the read lock.

Clear the pag[if]_init flags and ensure failure to initialise is
treated correctly i.e. fall back to selecting another AG.

> > > > ok, so we have empty ag's here. You might want to check that the
> > > > inode btree is empty and that the AGI unlinked list is empty.
> > > I thought that inode btree is empty by virtue of pag->pagi_count == 0.
> > > Is this not always so?
> > 
> > It should be. Call me paranoid, but with an operation like this I want
> > to make sure we check and double check that it is safe to proceed.
> > 
> > > Furthermore, also since agi_count == agi_free +
> > > actual used inodes + number of unlinked inodes, I think we don't need to
> > > check the unlinked list.
> > 
> > Call me paranoid, but....
> > 
> > I think at minimum there should be debug code that caters to my paranoia ;)
> Ok, I'll look into this then. I understand the paranoia, I just assumed
> that logically it's provable that this situation doesn't/can't happen.

At some point we'll have a bug that breaks that logic - we need code
to catch that....

> > > > Ok, so why not just
> > > > 
> > > > 	fdbdelta += mp->m_sb.sb_agblocks - XFS_PREALLOC_BLOCKS(mp);
> > > Because the last AG can be smaller than the sb_agblocks. It's true
> > > that this holds only for the last one, but having two cases is uglier
> > > than just always reading this size from the AG.
> > 
> > But you -EINVAL'd earlier when the shrink size would not leave entire
> > AGs behind. So the partial last AG is something that won't happen
> > here.....
> No, what I meant when I said 'last AG' is the "original" last, not the
> "new" last. Consider this fs: AGs 1-8 = 4096 blocks, AG 9 = 3000 blocks.

Ok, gotcha. Makes sense now.

> We can't, in the for loop, make fbdelta += mp->m_sb.sb_agblocks ...
> since that is 4096, whereas the for 'last' AG (AG 9) has only 3000
> blocks.
> 
> What I mean is that for a normal filesystem (non-shrink situation), the
> size of the last AG is readable only from the AGF structure on-disk,
> but for all the others AG the size is the one from the superblock. So if
> you touch the last AG, you have to read the AGF.

I'd still special case it, like the growing of a partial last AG is
special cased in xfs_growfs_data_private().

> > > > This is not really safe - how do we know if all the users of the
> > > > higher AGs have gone away? I think we should simply just zero out
> > > > the unused AGs and don't worry about a realloc().
> > > The problem that I saw is that if you do shrink+grow+shrink+grow+... you
> > > will leak a small amount of memory (or corrupt kernel mem allocation?)
> > > since the growfs code does a realloc from what it thinks is the size of
> > > m_perag, which it computes solely from the current number of AGs. Should
> > > we have a size in the mp struct for this and not assume it's the
> > > agcount?
> > 
> > Yup, another size variable in the mount structure is probably the only
> > way to fix this.
> Ok, noted. Also I get the impression that this ties in with the perag
> locking above somehow...

*nod*

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
