Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3920C3A5A2
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 12:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6BBB21848
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 12:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730115AbfHWMdm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Aug 2019 08:33:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727894AbfHWMdm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Aug 2019 08:33:42 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AF70710C051A;
        Fri, 23 Aug 2019 12:33:41 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 58FE252C5;
        Fri, 23 Aug 2019 12:33:41 +0000 (UTC)
Date:   Fri, 23 Aug 2019 08:33:39 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: alignment check bio buffers
Message-ID: <20190823123339.GB53137@bfoster>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-4-david@fromorbit.com>
 <20190821133904.GC19646@bfoster>
 <20190821213930.GP1119@dread.disaster.area>
 <20190822134716.GB24151@bfoster>
 <20190822230357.GD1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822230357.GD1119@dread.disaster.area>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Fri, 23 Aug 2019 12:33:41 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 23, 2019 at 09:03:57AM +1000, Dave Chinner wrote:
> On Thu, Aug 22, 2019 at 09:47:16AM -0400, Brian Foster wrote:
> > On Thu, Aug 22, 2019 at 07:39:30AM +1000, Dave Chinner wrote:
> > > On Wed, Aug 21, 2019 at 09:39:04AM -0400, Brian Foster wrote:
> > > > On Wed, Aug 21, 2019 at 06:38:20PM +1000, Dave Chinner wrote:
> > > Yes, because we really should wait for chained bios to complete
> > > before returning. we can only do that by waiting on completion for
> > > the entire chain, and the simplest way to do that is submit the
> > > bio...
> > > 
> > 
> > Ok. I guess that makes sense here because these are sync I/Os and this
> > appears to be the only way to wait on a partially constructed chain
> > (that I can tell).
> 
> Same here. I can't find any code that manually waits for a partially
> submitted chain to complete...
> 
> > > > If we're already seeing
> > > > weird behavior for bios with unaligned data memory, this seems like a
> > > > recipe for similar weirdness. We'd also end up doing a partial write in
> > > > scenarios where we already know we're returning an error.
> > > 
> > > THe partial write will happen anyway on a chained bio, something we
> > > know already happens from the bug in bio chaining that was found in
> > > this code earlier in the cycle.
> > > 
> > 
> > Sure, a failure in a bio chain is essentially a partial write similar to
> > if one such bio in the chain had failed. What about the non-chaining
> > case? What happens on submission of an empty read/write bio? Does
> > behavior depend on the underlying storage stack?
> 
> Seems to work just fine when I tested the code without the aligned
> allocation patch. I do note that the block layer does allow zero
> length (non-data) bios for things like flush requests.
> Unsurprisingly, theres no checks to disallow completely empty bios
> from being submitted, so I'm asumming that it's handled just fine
> given the code worked when tested...
> 

Yeah, I'm aware of flush requests and such. That's why I was asking
about empty read/write bios, since an empty bio by itself is not some
blatant error.

What exactly does "it works" mean here, though? Does an empty read/write
bio return with an error or just behave as a serialization no-op? It
might not matter for this particular sync I/O case, but it could make a
difference for others.

> > Note that I see this patch is likely going away. I'm just saying I think
> > we should have some confirmation on how the block layer behaves in these
> > situations before we take an approach that relies on it. Is an empty bio
> > essentially a no-op that serves as a serialization mechanism? Does the
> > block layer return an error? Etc.
> 
> submit_bio_wait() didn't return an error, and even if it did it gets
> overridden by the error from misalignment.
> 

I wrote "block layer," not submit_bio_wait() specifically. I'm asking
whether the bio might complete with an error or not.

> > > > Perhaps we
> > > > should create an error path or use a check similar to what is already in
> > > > xfs_buf_ioapply_map() (though I'm not a fan of submitting a partial I/O
> > > > when we already know we're going to return an error) to call bio_endio()
> > > > to undo any chaining.
> 
> bio_endio() doesn't wait for chaining. If there's children chained,
> it just returns immediately and that leads to the use-after-free
> situation I described to Christoph...
> 
> bio chaining just seems incredibly fragile in the face of errors
> during chain building...
> 

(The above is from two mails ago. Not sure why you're replying here..?)
Do note that bio_remaining_done() has special case chaining logic,
though. It's not just a no-op as implied. It looks to me that it behaves
as if the I/O were submitted and completed (async), but I could easily
be missing something as I'm not familiar with the code..

> > > > > --- a/fs/xfs/xfs_buf.c
> > > > > +++ b/fs/xfs/xfs_buf.c
> > > > > @@ -1294,7 +1294,7 @@ xfs_buf_ioapply_map(
> > > > >  		if (nbytes > size)
> > > > >  			nbytes = size;
> > > > >  
> > > > > -		rbytes = bio_add_page(bio, bp->b_pages[page_index], nbytes,
> > > > > +		rbytes = xfs_bio_add_page(bio, bp->b_pages[page_index], nbytes,
> > > > >  				      offset);
> > > > 
> > > > Similar concern here. The higher level code seems written under the
> > > > assumption that bio_add_page() returns success or zero. In this case the
> > > > error is basically tossed so we can also attempt to split/chain an empty
> > > > bio, or even better, submit a partial write and continue operating as if
> > > > nothing happened (outside of the warning). The latter case should be
> > > > handled as a log I/O error one way or another.
> > > 
> > > See above - it does result in a failure when offset/nbytes is not
> > > aligned to the underlying device...
> > > 
> > 
> > Oops, this comment was misplaced. I meant to write this in response to
> > the changes to xlog_map_iclog_data(), not xfs_buf_ioapply_map() (hence
> > the note about handling log I/O errors above).
> > 
> > The former has no such error checks that I can see. AFAICT, if we
> > construct a partial or empty bio here, we'd warn and return.
> > xlog_map_iclog_data() is a void function so the caller has no indication
> > anything went wrong and submits the bio. If an empty (?) or partial bio
> > doesn't return an error on bio completion, we've completely failed to
> > account for the fact that we've written a partial iclog to disk.
> 
> This is more a "make sure we don't get stuck in an endless loop"
> situation. If we've got unaligned iclogs, then a large, multi-page
> allocation (32-256k) has failed to be page aligned. This is not
> memory that comes from the slab, so alignment problems here indicate
> a major problem with the page allocation and/or vmalloc code. It
> just should never happen and if it does, then log writes failing are
> going to be the least of our worries.
> 

There is no infinite loop vector here. That aside, the iclog data buffer
is not a multi-page allocation on all systems. And FWIW, I don't think
all multi-page allocations are non-slab (slab/slub/slob appear to have
different levels of multi-page support, though that probably doesn't
matter on 4k systems for our supported iclog sizes). Otherwise, we're
just making assumptions on current and future failure semantics of an
external subsystem that's out of our control, and doing so to justify
lazy error handling logic that can be trivially fixed. All that's needed
here is to ensure that the new error path eventually translates into a
shutdown like all other log I/O related errors.

My understanding is this patch is being dropped for now so this feedback
is just for reference should this logic re-emerge when we have a
bio_add_page() variant with new error semantics..

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
