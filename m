Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 Nov 2007 18:15:20 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAQ2FAYN002308
	for <xfs@oss.sgi.com>; Sun, 25 Nov 2007 18:15:14 -0800
Date: Mon, 26 Nov 2007 13:15:15 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH, RFC] Delayed logging of file sizes
Message-ID: <20071126021515.GH114266761@sgi.com>
References: <47467B87.2000000@sgi.com> <20071125225928.GE114266761@sgi.com> <474A112D.2040006@sgi.com> <20071126011044.GG114266761@sgi.com> <474A2180.7000605@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474A2180.7000605@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Nov 26, 2007 at 12:29:36PM +1100, Lachlan McIlroy wrote:
> David Chinner wrote:
> >On Mon, Nov 26, 2007 at 11:19:57AM +1100, Lachlan McIlroy wrote:
> >>David Chinner wrote:
> >>>On Fri, Nov 23, 2007 at 06:04:39PM +1100, Lachlan McIlroy wrote:
> >>>>The easy solution is to log everything so that log replay doesn't need
> >>>>to check if the on-disk version is newer - it can just replay the log.
> >>>>But logging everything would cause too much log traffic so this patch
> >>>>is a compromise and it logs a transaction before we flush an inode to
> >>>>disk only if it has changes that have not yet been logged.
> >>>The problem with this is that the inode will be marked dirty during the
> >>>transaction, so we'll never be able to clean an inode if we issue a
> >>>transaction during inode writeback.
> >>Ah, yeah, good point.  I wrote this patch back before that "dirty inode
> >>on transaction" patch went in.
> >
> >Wouldn't have made aany difference - the inode woul dbe marked dirty
> >at transaction completion...
> >
> >>For this transaction though the changes
> >>to the inode have already been made (ie when we set i_update_core and
> >>called mark_inode_dirty_sync()) so there is no need to dirty it in this
> >>transaction.  I'll keep digging.  Thanks.
> >
> >I wouldn't worry too much about this problem right now - I'm working
> >on moving the dirty state into the inode radix trees so i_update_core
> >might even go away completely soon....
> >
> 
> Which problem?  Just the bit about dirtying the inode or will your changes
> allow us to log all inode changes?

Trying to change XFS to logging all updates.

> What's the motivation for moving the dirty state?

Better inode writeback clustering. i.e. it's easy to find all the dirty
inodes and then we can write them in larger contiguous chunks. The first
"hack" at this I did tracked only inodes in the AIL. Sequential create
of small files improved by about 20% with better clustering during
tail pushing operations. I'm trying to make it track all dirty inodes
at this point (via ->dirty_inode). This may mean that i_update_core
is not needed to track whether an inode needs writeback or not.

Not to mention all that horrible IPOINTER crap can get removed from 
xfs_sync_inodes() because finding dirty inodes is now a lockless radix
tree traverse based on a dirty tag lookup.

That also means the global mount inodes list can be replaced by a lockless radix
tree traverse, so we can lose another 2 pointers in the xfs_inode_t and lock
operations out of the inode get and reclaim paths.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
