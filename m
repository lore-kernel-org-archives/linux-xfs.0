Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33EF0C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 08:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C9D1233A1
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 08:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfH2Ipe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 04:45:34 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:52217 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726417AbfH2Ipe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 04:45:34 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 78D0F43CEF5;
        Thu, 29 Aug 2019 18:45:32 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3G3e-0002I8-Ot; Thu, 29 Aug 2019 18:45:30 +1000
Date:   Thu, 29 Aug 2019 18:45:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: speed up directory bestfree block scanning
Message-ID: <20190829084530.GP1119@dread.disaster.area>
References: <20190829063042.22902-1-david@fromorbit.com>
 <20190829063042.22902-5-david@fromorbit.com>
 <20190829081822.GD18195@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829081822.GD18195@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=8Y9nZHUPy7GPshHu2nAA:9 a=RQO7YIQPXt1mDet7:21
        a=hoifpHtEMtUlgY3f:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 29, 2019 at 01:18:22AM -0700, Christoph Hellwig wrote:
> On Thu, Aug 29, 2019 at 04:30:41PM +1000, Dave Chinner wrote:
> > +		bests = dp->d_ops->free_bests_p(free);
> > +		dp->d_ops->free_hdr_from_disk(&freehdr, free);
> >  		if (findex >= 0) {
> >  			/* caller already found the freespace for us. */
> > -			bests = dp->d_ops->free_bests_p(free);
> > -			dp->d_ops->free_hdr_from_disk(&freehdr, free);
> > -
> 
> I don't see any way how this is needed or helpful with this patch,
> we are just going to ovewrite bests and freehdr before even looking
> at them if the branch is not taken.

*nod*

The change is not useful anymore as a result of folding in your
previous suggestions. I'll revert it.

> >  			ASSERT(findex < freehdr.nvalid);
> >  			ASSERT(be16_to_cpu(bests[findex]) != NULLDATAOFF);
> >  			ASSERT(be16_to_cpu(bests[findex]) >= length);
> >  			dbno = freehdr.firstdb + findex;
> > -			goto out;
> > +			goto found_block;
> 
> The label rename while more descriptive also seems entirely unrelated.

That was one of your previous suggestions :)

I'll push it back up one patch into the cleanup patch and leave this
as an optimisation only patch.

> > +		findex = 0;
> > +		free = fbp->b_addr;
> >  		bests = dp->d_ops->free_bests_p(free);
> >  		dp->d_ops->free_hdr_from_disk(&freehdr, free);
> > +
> > +		/* Scan the free entry array for a large enough free space. */
> > +		do {
> > +			if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
> > +			    be16_to_cpu(bests[findex]) >= length) {
> > +				dbno = freehdr.firstdb + findex;
> > +				goto found_block;
> >  			}
> > +		} while (++findex < freehdr.nvalid);
> 
> Nit: wou;dn't this be better written as a for loop also taking the
> initialization of findex into the loop?

Agreed - the next patch does that with the reversal of the search
order. The end result is what you're asking for, so I'll leave this
alone for now....

> Otherwise this looks good.  I always like it when a speedup removes
> code..

I hadn't noticed that - I was more concerned with ending up with
readable code :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
