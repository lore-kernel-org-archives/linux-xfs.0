Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B3B5C47083
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 00:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E36E2613DC
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 00:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhFCAkV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 20:40:21 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53765 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229541AbhFCAkU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jun 2021 20:40:20 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BBF798616DB;
        Thu,  3 Jun 2021 10:38:19 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lobNL-008IG5-1I; Thu, 03 Jun 2021 10:38:19 +1000
Date:   Thu, 3 Jun 2021 10:38:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 35/39] xfs: convert log vector chain to use list heads
Message-ID: <20210603003819.GB664593@dread.disaster.area>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-36-david@fromorbit.com>
 <20210527191319.GM2402049@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527191319.GM2402049@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=7-415B0cAAAA:8
        a=OzPRqEPzYDW4dVJEsfgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 12:13:19PM -0700, Darrick J. Wong wrote:
> On Wed, May 19, 2021 at 10:13:13PM +1000, Dave Chinner wrote:
.....
> > @@ -913,25 +912,23 @@ xlog_cil_push_work(
> >  	xlog_cil_pcp_aggregate(cil, ctx);
> >  
> >  	list_sort(NULL, &ctx->log_items, xlog_cil_order_cmp);
> > -
> >  	while (!list_empty(&ctx->log_items)) {
> >  		struct xfs_log_item	*item;
> >  
> >  		item = list_first_entry(&ctx->log_items,
> >  					struct xfs_log_item, li_cil);
> > +		lv = item->li_lv;
> >  		list_del_init(&item->li_cil);
> >  		item->li_order_id = 0;
> > -		if (!ctx->lv_chain)
> > -			ctx->lv_chain = item->li_lv;
> > -		else
> > -			lv->lv_next = item->li_lv;
> > -		lv = item->li_lv;
> >  		item->li_lv = NULL;
> > -		num_iovecs += lv->lv_niovecs;
> >  
> > +		num_iovecs += lv->lv_niovecs;
> 
> Not sure why "lv = item->li_lv" needed to move up?
>
> I think the only change needed here is replacing the lv_chain/lv_next
> business with the list_add_tail?

Yes, but someone complained about the awful diff in the next patch,
so moving the "lv = item->li_lv" made the diff in the next patch
much, much cleaner...

<shrug>

I can move it back to the next patch if you really want, but it's
really just shuffling deck chairs at this point...

> > @@ -985,8 +985,14 @@ xlog_cil_push_work(
> >  	 * use the commit record lsn then we can move the tail beyond the grant
> >  	 * write head.
> >  	 */
> > -	error = xlog_write(log, &lvhdr, ctx->ticket, &ctx->start_lsn, NULL,
> > -				num_bytes);
> > +	error = xlog_write(log, &ctx->lv_chain, ctx->ticket, &ctx->start_lsn,
> > +				NULL, num_bytes);
> > +
> > +	/*
> > +	 * Take the lvhdr back off the lv_chain as it should not be passed
> > +	 * to log IO completion.
> > +	 */
> > +	list_del(&lvhdr.lv_list);
> 
> Seems a little clunky, but I guess I see why it's needed.

I could replace the stack structure with a memory allocation and
then we wouldn't need to care, but I'm trying to keep memory
allocation out of this fast path as much as possible....

> I /think/ I don't see any place where the onstack lvhdr can escape out
> of the chain after _push_work returns, so this is safe enough.

It can't, because we own the chain here and are completely
responsible for cleaning it up on failure.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
