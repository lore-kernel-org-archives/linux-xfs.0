Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6603 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752639AbdDQOTZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Apr 2017 10:19:25 -0400
Date: Mon, 17 Apr 2017 10:19:23 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 04/10] xfs: remove an unsafe retry in xfs_bmbt_alloc_block
Message-ID: <20170417141923.GB41659@bfoster.bfoster>
References: <20170413080517.12564-1-hch@lst.de>
 <20170413080517.12564-5-hch@lst.de>
 <20170413183006.GD25915@bfoster.bfoster>
 <20170414074658.GA24766@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170414074658.GA24766@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Apr 14, 2017 at 09:46:58AM +0200, Christoph Hellwig wrote:
> On Thu, Apr 13, 2017 at 02:30:06PM -0400, Brian Foster wrote:
> > I'm not quite following why this retry is unsafe as noted in the patch
> > title.. do you mean "unnecessary?" AFAICT, the firstblock == NULLFSBLOCK
> > case means we can issue this first allocation from any AG.
> 
> Yes.
> 
> > If no AG can
> > allocate a block while satisfying minleft, then we can still safely
> > allocate from any AG provided any subsequent allocations occur in
> > increasing AG order (i.e., by setting dop_low), right?
> 
> Yes.  But minleft is set exactly because we require this number of
> blocks to be left after the current allocation.  If we could only
> allocate the current allocation, but not satisfy minleft we risk
> shutting the file system during subsequent allocations instead of
> just returning ENOSPC now.
> 

I don't see anything about setting minleft here that says the allocation
is required to come from one AG as opposed to that simply being
preferred.

Also, I think we risk shutdown if this allocation fails at all,
regardless of the firstblock state, because the transaction is likely
already dirty. I have by no means audited all of the possible contexts
that lead here, but a quick tracepoint check shows the transcation as
dirty when punching holes. I'm also guessing this is why we currently
try so hard to allocate here.

> > Also, if this is unnecessary, what exactly verifies that all of the
> > reserved blocks are available within the same AG?
> 
> xfs_alloc_space_available verifies that ->total blocks are available
> in the current AG.  Callers of the allocator need to set it to the
> correct value currently, although I have more xfs_bmapi changes in
> the pipe to get this right automatically - but those aren't 4.12
> material.

Not all bmbt block allocations are tied to extent allocations. This is
the firstblock == NULLFSBLOCK case after all, which I take it means an
allocation hasn't yet occurred. IOW, what about other potentially
record-inserting operations like hole punch, extent conversion, etc.?

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
