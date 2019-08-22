Return-Path: <SRS0=94LY=WS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C1E7C3A59E
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 00:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 743CD22CE3
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Aug 2019 00:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfHVAqH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 20:46:07 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50543 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729081AbfHVAqH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Aug 2019 20:46:07 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 01FEE43D738;
        Thu, 22 Aug 2019 10:46:04 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0bDl-0004Ug-TS; Thu, 22 Aug 2019 10:44:57 +1000
Date:   Thu, 22 Aug 2019 10:44:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: alignment check bio buffers
Message-ID: <20190822004457.GT1119@dread.disaster.area>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-4-david@fromorbit.com>
 <20190821133904.GC19646@bfoster>
 <20190821233041.GD24904@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821233041.GD24904@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=oHf9qcJ02pf2Py10R3AA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 21, 2019 at 04:30:41PM -0700, Christoph Hellwig wrote:
> On Wed, Aug 21, 2019 at 09:39:04AM -0400, Brian Foster wrote:
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
> > and have failed to add any pages to the bio? If we're already seeing
> > weird behavior for bios with unaligned data memory, this seems like a
> > recipe for similar weirdness. We'd also end up doing a partial write in
> > scenarios where we already know we're returning an error. Perhaps we
> > should create an error path or use a check similar to what is already in
> > xfs_buf_ioapply_map() (though I'm not a fan of submitting a partial I/O
> > when we already know we're going to return an error) to call bio_endio()
> > to undo any chaining.
> 
> It is not the right thing to do.  Calling bio_endio after setting
> an error is the right thing to do (modulo any other cleanup needed).

bio_endio() doesn't wait for completion or all the IO in progress.

In fact, if we have chained bios still in progress, it does
absolutely nothing:

void bio_endio(struct bio *bio)
{
again:
>>>>>   if (!bio_remaining_done(bio))
                return;

and so we return still with the memory we've put into the buffers in
active use by the chained bios under IO. On error, we'll free the
allocated buffer immediately, and that means we've got a
use-after-free as the bios in progress still have references to it.
If it's heap memory we are using here, then that's a memory
corruption (read) or kernel memory leak (write) vector.

So we have to wait for IO completion before we return from this
function, and AFAICT, the only way to do that is to call
submit_bio_wait() on the parent of the bio chain to wait for all
child bios to drop their references and call bio_endio() on the
parent of the chain....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
