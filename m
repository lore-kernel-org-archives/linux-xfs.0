Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39906 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752578AbeDPNmb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Apr 2018 09:42:31 -0400
Date: Mon, 16 Apr 2018 09:42:30 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/7] xfs: defer agfl block frees when dfops is available
Message-ID: <20180416134229.GB21136@bfoster.bfoster>
References: <20180410174631.4915-1-bfoster@redhat.com>
 <20180410174631.4915-4-bfoster@redhat.com>
 <20180415074658.GC5226@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180415074658.GC5226@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Sun, Apr 15, 2018 at 12:46:58AM -0700, Christoph Hellwig wrote:
> > Add the capability to defer AGFL block frees when a deferred ops
> > list is available to the AGFL fixup code.
> 
> When is one available and when not?  Why are we fine not delaying it
> in some cases?
> 

Because not all transactions either have this problem or generally may
not have a need for deferred operations at all. This mechanism doesn't
dictate that all allocator callers must use deferred operations if they
haven't necessarily demonstrated the problem.

> > Note that this patch only adds infrastructure. It does not change
> > behavior because no callers have been updated to pass ->t_dfops into
> > the allocation code.
> 
> So the plan is to eventually have all callers pass it?  If so that is
> another argument to first always pass defer_ops through the transaction,
> then make sure all callers have it where required, and only then move
> to actually use it.
> 

The plan is that ultimately any transaction that already uses deferred
operations or any transaction that explicitly requires deferred agfl
frees (those modified in this patchset) will pass it along to the
allocator context. I wasn't planning to add dfops for any allocator
callers that don't currently use/need one, but we can revisit that
later.

As noted in my previous mail, this is essentially equivalent to passing
down the dfops on the stack and optimizing out the step of immediately
refactoring that code away. Further, doing broader refactoring first
puts the cleanup ahead of the fix, which is backwards. I want to fix the
problem first and clean up the code second.

> > +{
> > +	struct xfs_extent_free_item	*new;		/* new element */
> > +
> > +	ASSERT(xfs_bmap_free_item_zone != NULL);
> > +	ASSERT(oinfo != NULL);
> 
> No need for either assert, we get nice clean NULL ptr dereferences when
> this isn't true.

Ok.

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
