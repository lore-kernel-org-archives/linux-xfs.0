Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B3CC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Apr 2022 21:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbiD1VmP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 17:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbiD1VmO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Apr 2022 17:42:14 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CAE22C1CB6
        for <linux-xfs@vger.kernel.org>; Thu, 28 Apr 2022 14:38:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-32-1.pa.nsw.optusnet.com.au [49.180.32.1])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 167D953454D;
        Fri, 29 Apr 2022 07:38:56 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nkBqg-005hQO-Rp; Fri, 29 Apr 2022 07:38:54 +1000
Date:   Fri, 29 Apr 2022 07:38:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: intent item whiteouts
Message-ID: <20220428213854.GU1098723@dread.disaster.area>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-9-david@fromorbit.com>
 <YmqU/n4qkuI3XAlq@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmqU/n4qkuI3XAlq@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=626b0972
        a=0Ysg4n7SwsYHWQMxibB6iw==:117 a=0Ysg4n7SwsYHWQMxibB6iw==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
        a=P5ex43M3xyvNYIySgn4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 28, 2022 at 06:22:06AM -0700, Christoph Hellwig wrote:
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> > @@ -39,6 +39,7 @@ STATIC void
> >  xfs_bui_item_free(
> >  	struct xfs_bui_log_item	*buip)
> >  {
> > +	kmem_free(buip->bui_item.li_lv_shadow);
> >  	kmem_cache_free(xfs_bui_cache, buip);
> >  }
> 
> Based on the discussion with Darrick:  what about splitting adding
> the frees of the shadow buffers into a separate prep patch?

Ok, I can do that easily enough.

> > +	/* clean up log items that had whiteouts */
> > +	while (!list_empty(&whiteouts)) {
> > +		struct xfs_log_item *item = list_first_entry(&whiteouts,
> > +						struct xfs_log_item, li_cil);
> > +		list_del_init(&item->li_cil);
> > +		trace_xfs_cil_whiteout_unpin(item);
> > +		item->li_ops->iop_unpin(item, 1);
> > +	}
> >  	return;
> >  
> >  out_skip:
> > @@ -1212,6 +1236,14 @@ xlog_cil_push_work(
> >  out_abort_free_ticket:
> >  	xfs_log_ticket_ungrant(log, ctx->ticket);
> >  	ASSERT(xlog_is_shutdown(log));
> > +	while (!list_empty(&whiteouts)) {
> > +		struct xfs_log_item *item = list_first_entry(&whiteouts,
> > +						struct xfs_log_item, li_cil);
> > +		list_del_init(&item->li_cil);
> > +		trace_xfs_cil_whiteout_unpin(item);
> > +		item->li_ops->iop_unpin(item, 1);
> > +	}
> 
> Sees like this would benefit from a little helper instead of
> duplicating the logic?

Yeah, when I looked over this yesterday I was in two minds whether a
helper was justified or not. Seeing as you've suggested it too, I'll
factor it out....

> Otherwise this does look surprisingly nice and simple:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
