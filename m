Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE4F6C3A59E
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 00:38:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 867E0216F4
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 00:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbfHVAi6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 20:38:58 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58089 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727291AbfHVAi6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Aug 2019 20:38:58 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5849143E43C;
        Thu, 22 Aug 2019 10:38:52 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0b6n-0004U6-2z; Thu, 22 Aug 2019 10:37:45 +1000
Date:   Thu, 22 Aug 2019 10:37:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: alignment check bio buffers
Message-ID: <20190822003745.GS1119@dread.disaster.area>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-4-david@fromorbit.com>
 <20190821232945.GC24904@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821232945.GC24904@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=rU67Zy6-Q7zb79vJh6YA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 21, 2019 at 04:29:45PM -0700, Christoph Hellwig wrote:
> On Wed, Aug 21, 2019 at 06:38:20PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Add memory buffer alignment validation checks to bios built in XFS
> > to catch bugs that will result in silent data corruption in block
> > drivers that cannot handle unaligned memory buffers but don't
> > validate the incoming buffer alignment is correct.
> > 
> > Known drivers with these issues are xenblk, brd and pmem.
> > 
> > Despite there being nothing XFS specific to xfs_bio_add_page(), this
> > function was created to do the required validation because the block
> > layer developers that keep telling us that is not possible to
> > validate buffer alignment in bio_add_page(), and even if it was
> > possible it would be too much overhead to do at runtime.
> 
> I really don't think we should life this to XFS, but instead fix it
> in the block layer.  And that is not only because I have a pending
> series lifting bits you are touching to the block layer..

I agree, but....

> 
> > +int
> > +xfs_bio_add_page(
> > +	struct bio	*bio,
> > +	struct page	*page,
> > +	unsigned int	len,
> > +	unsigned int	offset)
> > +{
> > +	struct request_queue	*q = bio->bi_disk->queue;
> > +	bool		same_page = false;
> > +
> > +	if (WARN_ON_ONCE(!blk_rq_aligned(q, len, offset)))
> > +		return -EIO;
> > +
> > +	if (!__bio_try_merge_page(bio, page, len, offset, &same_page)) {
> > +		if (bio_full(bio, len))
> > +			return 0;
> > +		__bio_add_page(bio, page, len, offset);
> > +	}
> > +	return len;
> 
> I know Jens disagree, but with the amount of bugs we've been hitting
> thangs to slub (and I'm pretty sure we have a more hiding outside of
> XFS) I think we need to add the blk_rq_aligned check to bio_add_page.

... I'm not prepared to fight this battle to get this initial fix
into the code. Get the fix merged, then we can 

> Note that all current callers of bio_add_page can only really check
> for the return value != the added len anyway, so it is not going to
> make anything worse.

It does make things worse - it turns multi-bio chaining loops like
the one xfs_rw_bdev() into an endless loop as they don't make
progress - they just keep allocating a new bio and retrying the same
badly aligned buffer and failing. So if we want an alignment failure
to error out, callers need to handle the failure, not treat it like
a full bio.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
