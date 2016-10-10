Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31744 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752245AbcJJRFo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2016 13:05:44 -0400
Date: Mon, 10 Oct 2016 10:05:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 46/63] xfs: unshare a range of blocks via fallocate
Message-ID: <20161010170524.GD5619@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520503973.29434.3740768854227922973.stgit@birch.djwong.org>
 <20161007180506.GF58659@bfoster.bfoster>
 <20161007202639.GG11241@birch.djwong.org>
 <20161007205838.GH58659@bfoster.bfoster>
 <20161007211540.GI11241@birch.djwong.org>
 <20161007222508.GK9806@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161007222508.GK9806@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Sat, Oct 08, 2016 at 09:25:08AM +1100, Dave Chinner wrote:
> On Fri, Oct 07, 2016 at 02:15:40PM -0700, Darrick J. Wong wrote:
> > On Fri, Oct 07, 2016 at 04:58:38PM -0400, Brian Foster wrote:
> > > On Fri, Oct 07, 2016 at 01:26:39PM -0700, Darrick J. Wong wrote:
> > > > On Fri, Oct 07, 2016 at 02:05:07PM -0400, Brian Foster wrote:
> > > > > On Thu, Sep 29, 2016 at 08:10:39PM -0700, Darrick J. Wong wrote:
> > > > > The code that has been merged is now different from this code :/, but
> > > > > just a heads up that the code in the tree looks like it has another one
> > > > > of those potentially blind transaction commit sequences between
> > > > > xfs_reflink_try_clear_inode_flag() and xfs_reflink_clear_inode_flag().
> > > > 
> > > > _reflink_unshare jumps out if it's not a reflink inode before
> > > > calling _reflink_try_clear_inode_flag -> _reflink_clear_inode_flag.
> > > > We do not call _reflink_clear_inode_flag with a non-reflink inode.
> > > > As for blindly committing a transaction with no dirty data, that's
> > > > fine, _trans_commit checks for that case and simply frees everything
> > > > attached to the transaction.
> > > > 
> > > 
> > > Yeah, I saw that. That's what I was alluding to below wrt to the usage
> > > being fine in the patch. It's just the pattern that's used that stands
> > > out.
> > > 
> > > With regard to the transaction.. sure, that situation may not be broken,
> > > but it's still not ideal if it's a log reservation we didn't have to
> > > make in the first place.
> > 
> > Yeah.  We must hold the ilock from the start of the extent iteration
> > until we clear (or not) the inode flag, but we have to allocate the
> > transaction before grabbing the ilock.  In other words, we don't know if
> > we need the transaction until it's too late to get one, hence this
> > suboptimal thing where we sometimes get a reservation and never commit
> > anything.  I don't know of any way to avoid that.
> 
> Getting a transaction we don't use isn't the end of the world -
> in most cases it's just a bit of wasted CPU time. Similarly to
> committing an empty transaction it has no actual effect except to
> increment the empty transaction stat. In this case, commit is just
> fine as xfs_trans_commit will detect that it is empty and do the
> cancel work directly.

This is going to become a bigger thing once we get to online scrub
because I use empty transactions to avoid deadlock problems.  I observed
that the routine to grab a buffer will lock the buffer and (optionally)
attach it to a transaction.  Subsequent attempts to re-grab a still
locked buffer succeed if the buffer is attached to the transaction, and
are made to wait for the lock if not.

We can use this as a strategy to detect tree cycles:

n0 (root) -> n1 -> n2 -> n3
             ^------------+

By the time we hit the bad pointer in n3, we've locked n0-3 and attached
it to the empty transaction.  Next, we read the bad pointer in n3 and
try to grab n1 again.  Since it's attached and locked to our empty
transaction, we can read the buffer and notice that the level is wrong,
and declare the tree to be corrupt.  On our way out, we call
xfs_trans_cancel to unlock everything.  It's a little uncomfortable to
be (ab)using transactions for their ability to track locked buffers, but
oh well.

Note we can also use this of escaping crosslinked btrees:

bno0 -> b1 -> b2 ---------+
                          V
          rmap0 -> r1 -> r2 -> r3

Let's say we're checking rmap records out of r3 and we want to make sure
that the bnobt does not have a record for this rmapping.  We start down
the bnobt until we hit the bad pointer in b2 that points to a block
we already locked while reading the rmapbt.  Having the transaction
allows the bnobt cursor to read r2 and fail the read verifier, after
which we can cancel the transaction and tell userspace that there's
something wrong.  If we didn't have the transaction, we'd try to lock a
buffer that we already locked, which deadlocks the system.

I suppose I had better write all this down in xfs_scrub.c before I send
out patches for review.

--D

> 
> If I start to see too many empty transaction commits in my
> performance test runs, I'll let you know and we can start to look
> for solutions. But right now I wouldn't worry about it.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
