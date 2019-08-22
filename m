Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A0BC3A5A1
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 13:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92B72233FC
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 13:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730877AbfHVNrT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 09:47:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60842 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbfHVNrT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Aug 2019 09:47:19 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4371610C6974;
        Thu, 22 Aug 2019 13:47:18 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CD8595D6A7;
        Thu, 22 Aug 2019 13:47:17 +0000 (UTC)
Date:   Thu, 22 Aug 2019 09:47:16 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: alignment check bio buffers
Message-ID: <20190822134716.GB24151@bfoster>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-4-david@fromorbit.com>
 <20190821133904.GC19646@bfoster>
 <20190821213930.GP1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821213930.GP1119@dread.disaster.area>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Thu, 22 Aug 2019 13:47:18 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 22, 2019 at 07:39:30AM +1000, Dave Chinner wrote:
> On Wed, Aug 21, 2019 at 09:39:04AM -0400, Brian Foster wrote:
> > On Wed, Aug 21, 2019 at 06:38:20PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Add memory buffer alignment validation checks to bios built in XFS
> > > to catch bugs that will result in silent data corruption in block
> > > drivers that cannot handle unaligned memory buffers but don't
> > > validate the incoming buffer alignment is correct.
> > > 
> > > Known drivers with these issues are xenblk, brd and pmem.
> > > 
> > > Despite there being nothing XFS specific to xfs_bio_add_page(), this
> > > function was created to do the required validation because the block
> > > layer developers that keep telling us that is not possible to
> > > validate buffer alignment in bio_add_page(), and even if it was
> > > possible it would be too much overhead to do at runtime.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_bio_io.c | 32 +++++++++++++++++++++++++++++---
> > >  fs/xfs/xfs_buf.c    |  2 +-
> > >  fs/xfs/xfs_linux.h  |  3 +++
> > >  fs/xfs/xfs_log.c    |  6 +++++-
> > >  4 files changed, 38 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
> > > index e2148f2d5d6b..fbaea643c000 100644
> > > --- a/fs/xfs/xfs_bio_io.c
> > > +++ b/fs/xfs/xfs_bio_io.c
> > > @@ -9,6 +9,27 @@ static inline unsigned int bio_max_vecs(unsigned int count)
> > >  	return min_t(unsigned, howmany(count, PAGE_SIZE), BIO_MAX_PAGES);
> > >  }
> > >  
> > > +int
> > > +xfs_bio_add_page(
> > > +	struct bio	*bio,
> > > +	struct page	*page,
> > > +	unsigned int	len,
> > > +	unsigned int	offset)
> > > +{
> > > +	struct request_queue	*q = bio->bi_disk->queue;
> > > +	bool		same_page = false;
> > > +
> > > +	if (WARN_ON_ONCE(!blk_rq_aligned(q, len, offset)))
> > > +		return -EIO;
> > > +
> > > +	if (!__bio_try_merge_page(bio, page, len, offset, &same_page)) {
> > > +		if (bio_full(bio, len))
> > > +			return 0;
> > > +		__bio_add_page(bio, page, len, offset);
> > > +	}
> > > +	return len;
> > > +}
> > > +
> > 
> > Seems reasonable to me. Looks like bio_add_page() with an error check.
> > ;)
> 
> It is exactly that.
> 
> > Given that, what's the need to open-code bio_add_page() here rather
> > than just call it after the check?
> 
> Largely because I wasn't sure exactly where the best place was to
> add the check. Copy first, hack to pieces, make work, then worry
> about other stuff :)
> 
> I could change it to calling calling bio_add_page() directly. Not
> really that fussed as it's all exported functionality...
> 
> 
> > >  int
> > >  xfs_rw_bdev(
> > >  	struct block_device	*bdev,
> > ...
> > > @@ -36,9 +57,12 @@ xfs_rw_bdev(
> > >  		unsigned int	off = offset_in_page(data);
> > >  		unsigned int	len = min_t(unsigned, left, PAGE_SIZE - off);
> > >  
> > > -		while (bio_add_page(bio, page, len, off) != len) {
> > > +		while ((ret = xfs_bio_add_page(bio, page, len, off)) != len) {
> > >  			struct bio	*prev = bio;
> > >  
> > > +			if (ret < 0)
> > > +				goto submit;
> > > +
> > 
> > Hmm.. is submitting the bio really the right thing to do if we get here
> > and have failed to add any pages to the bio?
> 
> Yes, because we really should wait for chained bios to complete
> before returning. we can only do that by waiting on completion for
> the entire chain, and the simplest way to do that is submit the
> bio...
> 

Ok. I guess that makes sense here because these are sync I/Os and this
appears to be the only way to wait on a partially constructed chain
(that I can tell).

> > If we're already seeing
> > weird behavior for bios with unaligned data memory, this seems like a
> > recipe for similar weirdness. We'd also end up doing a partial write in
> > scenarios where we already know we're returning an error.
> 
> THe partial write will happen anyway on a chained bio, something we
> know already happens from the bug in bio chaining that was found in
> this code earlier in the cycle.
> 

Sure, a failure in a bio chain is essentially a partial write similar to
if one such bio in the chain had failed. What about the non-chaining
case? What happens on submission of an empty read/write bio? Does
behavior depend on the underlying storage stack?

Note that I see this patch is likely going away. I'm just saying I think
we should have some confirmation on how the block layer behaves in these
situations before we take an approach that relies on it. Is an empty bio
essentially a no-op that serves as a serialization mechanism? Does the
block layer return an error? Etc.

> > Perhaps we
> > should create an error path or use a check similar to what is already in
> > xfs_buf_ioapply_map() (though I'm not a fan of submitting a partial I/O
> > when we already know we're going to return an error) to call bio_endio()
> > to undo any chaining.
> 
> xfs_buf_ioapply_map() only fails with an error if it occurs on the
> first bio_add_page() call to a bio. If it fails on the second, then
> it submits the bio, allocates a new bio, and tries again. If that
> fails, then it frees the bio and does error processing.
> 
> That code can get away with such behaviour because it is not
> chaining bios. each bio is it's own IO, and failures there already
> result in partial IO completion with an error onthe buffer. This
> code here will fail with a partial IO completion and return an error.
> 

Right, that is the behavior I was referring to above.

> So, in effect, this code provides exactly the same behaviour and
> result as the xfs_buf_ioapply_map() code does...
> 

In this case, we return an error that the caller will handle and
shutdown the fs. That's reasonable behavior here since these are sync
I/Os.

> > 
> > >  			bio = bio_alloc(GFP_KERNEL, bio_max_vecs(left));
> > >  			bio_copy_dev(bio, prev);
> > >  			bio->bi_iter.bi_sector = bio_end_sector(prev);
> > ...
> > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > index 7bd1f31febfc..a2d499baee9c 100644
> > > --- a/fs/xfs/xfs_buf.c
> > > +++ b/fs/xfs/xfs_buf.c
> > > @@ -1294,7 +1294,7 @@ xfs_buf_ioapply_map(
> > >  		if (nbytes > size)
> > >  			nbytes = size;
> > >  
> > > -		rbytes = bio_add_page(bio, bp->b_pages[page_index], nbytes,
> > > +		rbytes = xfs_bio_add_page(bio, bp->b_pages[page_index], nbytes,
> > >  				      offset);
> > 
> > Similar concern here. The higher level code seems written under the
> > assumption that bio_add_page() returns success or zero. In this case the
> > error is basically tossed so we can also attempt to split/chain an empty
> > bio, or even better, submit a partial write and continue operating as if
> > nothing happened (outside of the warning). The latter case should be
> > handled as a log I/O error one way or another.
> 
> See above - it does result in a failure when offset/nbytes is not
> aligned to the underlying device...
> 

Oops, this comment was misplaced. I meant to write this in response to
the changes to xlog_map_iclog_data(), not xfs_buf_ioapply_map() (hence
the note about handling log I/O errors above).

The former has no such error checks that I can see. AFAICT, if we
construct a partial or empty bio here, we'd warn and return.
xlog_map_iclog_data() is a void function so the caller has no indication
anything went wrong and submits the bio. If an empty (?) or partial bio
doesn't return an error on bio completion, we've completely failed to
account for the fact that we've written a partial iclog to disk.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
