Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56114 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753872AbeGHPhL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jul 2018 11:37:11 -0400
Date: Sun, 8 Jul 2018 08:37:08 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 25/25] xfs: remove xfs_defer_init() firstblock param
Message-ID: <20180708153708.GC14847@infradead.org>
References: <20180703172319.24509-1-bfoster@redhat.com>
 <20180703172319.24509-26-bfoster@redhat.com>
 <20180704012743.GY32415@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180704012743.GY32415@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, Allison Henderson <allison.henderson@oracle.com>

On Tue, Jul 03, 2018 at 06:27:43PM -0700, Darrick J. Wong wrote:
> Moving on to the question of whether or not to embed a struct
> xfs_defer_ops into struct xfs_trans instead of just a pointer, it looks
> to me like that should be a pretty straightforward conversion.  Most of
> the defer_ops users keep it within the scope of a single
> xfs_trans_{alloc,commit} pair so we can pass *tp instead of *dfops into
> the helpers.

I'd like to see that happen eventually, probably rather sooner than
later.

> The one big exception to that of course is the log item replay where we
> don't want to finish any of the new defer_ops until we're done with
> replay, for which we'll need to have a xfs_defer_move to transfer all
> the items and [bi]join'd state from one dfops to another.  This is
> probably the same mechanism that you'd have to use to preserve dfops
> state in xfs_defer_trans_roll.

Yes.  As far as I can tell we can just list_split_init the two lists
over, copy over the inodes and bufs arrays (at least if we are rolling
the transaction) and mostly ignore dop_low and dop_commited.

Now the transaction itself actually already has a list of items joined
to them, which must include dop_inodes and dop_bufs, and I suspect
we should just look at the items and rejoin all inodes and bufs instead
of separately keeping track of them for the normal roll case.  We'd
just need some special outside storage for the log recovery case.

> The other area of trickiness I anticipate is Allison's reworking of the
> xattr code's usage of defer_ops to eliminate the repeated creation and
> finishing of defer ops.  Even if attribute operations can still allocate
> and commit multiple transactions, we'll have to find a way to carry the
> defer_ops state (the attr intent item and presumably a _defer_ijoin'd
> inode) across every one of those transactions.  I'm not sure how far
> she's gotten with that, but some coordination is needed.

In general attribute operations should be rolling transactions, and
if they aren't we probably found a bug.  Once it is a rolling
transaction we've already got all the state coverted by the
xfs_defer_trans_roll equivalent case.
