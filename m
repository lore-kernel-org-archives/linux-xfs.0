Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51156 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756582AbeEJIZE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 04:25:04 -0400
Date: Thu, 10 May 2018 01:25:03 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/3] xfs: add bmapi nodiscard flag
Message-ID: <20180510082503.GA25140@infradead.org>
References: <20180508172231.53570-1-bfoster@redhat.com>
 <20180508172231.53570-2-bfoster@redhat.com>
 <20180509074629.GC19933@infradead.org>
 <20180509105853.GD64624@bfoster.bfoster>
 <20180509113942.GA17093@infradead.org>
 <20180509120150.GA65322@bfoster.bfoster>
 <20180509120738.GA1050@infradead.org>
 <20180509124756.GB65322@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180509124756.GB65322@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>

On Wed, May 09, 2018 at 08:47:56AM -0400, Brian Foster wrote:
> > 
> > I've read the thread on the original patch now.  While not my preference
> > I'm fine with doing an xfs_itruncate_extents_flags with a single
> > xfs_itruncate_extents wrapper and the same for bmapi, as long as we pass
> > flags instead of the bool, and don't add pointless wrappers for the
> > nodiscard case - those are just trickle down flags in general, so we
> > should keep things as simple as possible.
> 
> Ok, do you mean to include xfs_free_extent() in that as well? E.g.,
> xfs_free_extent_flags(..., XFS_EXTENT_BUSY_SKIP_DISCARD) vs. a single
> wrapper without _flags()? Note that that flag is still sourced from a
> boolean unless we also change the xfs_extent_free_item field, which I'm
> not sure makes sense. Alternatively, I could just kill the
> xfs_free_extent_nodiscard() wrapper and call the internal variant from
> the one place that wants to toggle discard behavior.

I'd store flags in xfs_extent_free_item.  But most importantly
I think the _nodiscard wrappers need to go away.
