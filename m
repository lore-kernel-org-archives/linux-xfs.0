Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43316 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753388AbcLNTg2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Dec 2016 14:36:28 -0500
Date: Wed, 14 Dec 2016 20:36:26 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] xfs: fix bogus minleft manipulations
Message-ID: <20161214193626.GA12106@lst.de>
References: <1481644767-9098-1-git-send-email-hch@lst.de> <1481644767-9098-2-git-send-email-hch@lst.de> <20161214173507.GA24645@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161214173507.GA24645@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On Wed, Dec 14, 2016 at 12:35:07PM -0500, Brian Foster wrote:
> I'm still trying to grok the minleft/dop_low stuff, but doesn't this
> increase the risk of bmbt block allocation failure?

No.  If working correctly it reduces the chance of a failing bmbt block
allocation in transaction to zero, at the expense of potentially
failing whole block allocations while we still have a few blocks left.
But given that the first leads to a fs shutdown and the latter just to
an ENOSPC it seems worthwhile.

> E.g., args.minleft
> is set to the transaction reservation earlier in the function. AFAIK the
> res is not guaranteed to be in a particular AG, but in that case we're
> just setting a start AG and ultimately cycling through the AGs. If that
> fails, this hunk resets minleft, restarts at fsbno 0 and activates the
> sequential agno allocation requirement for subsequent allocs. Doesn't
> removing this logic mean we can successfully reserve blocks in a write
> transaction that will never ultimately be able to allocate bmbt blocks,
> even if the data blocks can all be allocated..?

We only set it to res if no firstblock was set.  The only case where
that is possible during the first bmbt block allocation in a reflink
operation - for actual direct I/O writes, fallocate calls or unwritten
extent conversion we will always have firstblock set from the allocation
of the actual data extent.  And that allocation now has the proper minleft
set after this series so that we are guaranteed we have enough space
in one single AG for the whole allocation.

In the reflink case where firstblock wasn't set the minleft ensures
that we fail the first allocation if we don't have enough blocks
in a single AG.
retryloop to try the allocation 

> The other thing to note here is that minleft is initialized to 0 and
> only set to the transaction res conditionally, so if firstblock is
> already set we won't use minleft at all.

Yes, that's intentional - we already did our minleft check when allocating
the data extent.
