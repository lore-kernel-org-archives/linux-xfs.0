Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F7DC3A5A1
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 23:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDB38233A0
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 23:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389289AbfHVXFk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 19:05:40 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:56582 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731575AbfHVXFk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 19:05:40 -0400
Received: from dread.disaster.area (pa49-181-142-13.pa.nsw.optusnet.com.au [49.181.142.13])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7D239361098;
        Fri, 23 Aug 2019 09:05:36 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0w7Z-0006df-Rm; Fri, 23 Aug 2019 09:03:57 +1000
Date:   Fri, 23 Aug 2019 09:03:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: alignment check bio buffers
Message-ID: <20190822230357.GD1119@dread.disaster.area>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-4-david@fromorbit.com>
 <20190821133904.GC19646@bfoster>
 <20190821213930.GP1119@dread.disaster.area>
 <20190822134716.GB24151@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822134716.GB24151@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=pdRIKMFd4+xhzJrg6WzXNA==:117 a=pdRIKMFd4+xhzJrg6WzXNA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=Eu_smMOfIVYlMVOBZEgA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 22, 2019 at 09:47:16AM -0400, Brian Foster wrote:
> On Thu, Aug 22, 2019 at 07:39:30AM +1000, Dave Chinner wrote:
> > On Wed, Aug 21, 2019 at 09:39:04AM -0400, Brian Foster wrote:
> > > On Wed, Aug 21, 2019 at 06:38:20PM +1000, Dave Chinner wrote:
> > Yes, because we really should wait for chained bios to complete
> > before returning. we can only do that by waiting on completion for
> > the entire chain, and the simplest way to do that is submit the
> > bio...
> > 
> 
> Ok. I guess that makes sense here because these are sync I/Os and this
> appears to be the only way to wait on a partially constructed chain
> (that I can tell).

Same here. I can't find any code that manually waits for a partially
submitted chain to complete...

> > > If we're already seeing
> > > weird behavior for bios with unaligned data memory, this seems like a
> > > recipe for similar weirdness. We'd also end up doing a partial write in
> > > scenarios where we already know we're returning an error.
> > 
> > THe partial write will happen anyway on a chained bio, something we
> > know already happens from the bug in bio chaining that was found in
> > this code earlier in the cycle.
> > 
> 
> Sure, a failure in a bio chain is essentially a partial write similar to
> if one such bio in the chain had failed. What about the non-chaining
> case? What happens on submission of an empty read/write bio? Does
> behavior depend on the underlying storage stack?

Seems to work just fine when I tested the code without the aligned
allocation patch. I do note that the block layer does allow zero
length (non-data) bios for things like flush requests.
Unsurprisingly, theres no checks to disallow completely empty bios
from being submitted, so I'm asumming that it's handled just fine
given the code worked when tested...

> Note that I see this patch is likely going away. I'm just saying I think
> we should have some confirmation on how the block layer behaves in these
> situations before we take an approach that relies on it. Is an empty bio
> essentially a no-op that serves as a serialization mechanism? Does the
> block layer return an error? Etc.

submit_bio_wait() didn't return an error, and even if it did it gets
overridden by the error from misalignment.

> > > Perhaps we
> > > should create an error path or use a check similar to what is already in
> > > xfs_buf_ioapply_map() (though I'm not a fan of submitting a partial I/O
> > > when we already know we're going to return an error) to call bio_endio()
> > > to undo any chaining.

bio_endio() doesn't wait for chaining. If there's children chained,
it just returns immediately and that leads to the use-after-free
situation I described to Christoph...

bio chaining just seems incredibly fragile in the face of errors
during chain building...

> > > > --- a/fs/xfs/xfs_buf.c
> > > > +++ b/fs/xfs/xfs_buf.c
> > > > @@ -1294,7 +1294,7 @@ xfs_buf_ioapply_map(
> > > >  		if (nbytes > size)
> > > >  			nbytes = size;
> > > >  
> > > > -		rbytes = bio_add_page(bio, bp->b_pages[page_index], nbytes,
> > > > +		rbytes = xfs_bio_add_page(bio, bp->b_pages[page_index], nbytes,
> > > >  				      offset);
> > > 
> > > Similar concern here. The higher level code seems written under the
> > > assumption that bio_add_page() returns success or zero. In this case the
> > > error is basically tossed so we can also attempt to split/chain an empty
> > > bio, or even better, submit a partial write and continue operating as if
> > > nothing happened (outside of the warning). The latter case should be
> > > handled as a log I/O error one way or another.
> > 
> > See above - it does result in a failure when offset/nbytes is not
> > aligned to the underlying device...
> > 
> 
> Oops, this comment was misplaced. I meant to write this in response to
> the changes to xlog_map_iclog_data(), not xfs_buf_ioapply_map() (hence
> the note about handling log I/O errors above).
> 
> The former has no such error checks that I can see. AFAICT, if we
> construct a partial or empty bio here, we'd warn and return.
> xlog_map_iclog_data() is a void function so the caller has no indication
> anything went wrong and submits the bio. If an empty (?) or partial bio
> doesn't return an error on bio completion, we've completely failed to
> account for the fact that we've written a partial iclog to disk.

This is more a "make sure we don't get stuck in an endless loop"
situation. If we've got unaligned iclogs, then a large, multi-page
allocation (32-256k) has failed to be page aligned. This is not
memory that comes from the slab, so alignment problems here indicate
a major problem with the page allocation and/or vmalloc code. It
just should never happen and if it does, then log writes failing are
going to be the least of our worries.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
