Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01615C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 02:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9D2B64F8E
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 02:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhCLCaY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 21:30:24 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51180 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229558AbhCLC36 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 21:29:58 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9F7FC828144;
        Fri, 12 Mar 2021 13:29:56 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lKXYq-001V9L-4P; Fri, 12 Mar 2021 13:29:56 +1100
Date:   Fri, 12 Mar 2021 13:29:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 41/45] xfs: move CIL ordering to the logvec chain
Message-ID: <20210312022956.GJ63242@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-42-david@fromorbit.com>
 <20210311013452.GO3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311013452.GO3419940@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=uTbK0inUIfzE9kccKWwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 05:34:52PM -0800, Darrick J. Wong wrote:
> On Fri, Mar 05, 2021 at 04:11:39PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Adding a list_sort() call to the CIL push work while the xc_ctx_lock
> > is held exclusively has resulted in fairly long lock hold times and
> > that stops all front end transaction commits from making progress.
> 
> Heh, nice solution. :)
> 
> > We can move the sorting out of the xc_ctx_lock if we can transfer
> > the ordering information to the log vectors as they are detached
> > from the log items and then we can sort the log vectors. This
> > requires log vectors to use a list_head rather than a single linked
> > list
> 
> Ergh, could pull out the list conversion into a separate piece?
> Some of the lv_chain usage is ... not entirely textbook.

Yes, I can probably do that.

> > diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> > index af54ea3f8c90..0445dd6acbce 100644
> > --- a/fs/xfs/xfs_log.h
> > +++ b/fs/xfs/xfs_log.h
> > @@ -9,7 +9,8 @@
> >  struct xfs_cil_ctx;
> >  
> >  struct xfs_log_vec {
> > -	struct xfs_log_vec	*lv_next;	/* next lv in build list */
> > +	struct list_head	lv_chain;	/* lv chain ptrs */
> > +	int			lv_order_id;	/* chain ordering info */
> 
> uint32_t to match li_order_id?

*nod*

> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index 3d43a5088154..6dcc23829bef 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -72,6 +72,7 @@ xlog_cil_ctx_alloc(void)
> >  	ctx = kmem_zalloc(sizeof(*ctx), KM_NOFS);
> >  	INIT_LIST_HEAD(&ctx->committing);
> >  	INIT_LIST_HEAD(&ctx->busy_extents);
> > +	INIT_LIST_HEAD(&ctx->lv_chain);
> >  	INIT_WORK(&ctx->push_work, xlog_cil_push_work);
> >  	return ctx;
> >  }
> > @@ -237,6 +238,7 @@ xlog_cil_alloc_shadow_bufs(
> >  			lv = kmem_alloc_large(buf_size, KM_NOFS);
> >  			memset(lv, 0, xlog_cil_iovec_space(niovecs));
> >  
> > +			INIT_LIST_HEAD(&lv->lv_chain);
> >  			lv->lv_item = lip;
> >  			lv->lv_size = buf_size;
> >  			if (ordered)
> > @@ -252,7 +254,6 @@ xlog_cil_alloc_shadow_bufs(
> >  			else
> >  				lv->lv_buf_len = 0;
> >  			lv->lv_bytes = 0;
> > -			lv->lv_next = NULL;
> >  		}
> >  
> >  		/* Ensure the lv is set up according to ->iop_size */
> > @@ -379,8 +380,6 @@ xlog_cil_insert_format_items(
> >  		if (lip->li_lv && shadow->lv_size <= lip->li_lv->lv_size) {
> >  			/* same or smaller, optimise common overwrite case */
> >  			lv = lip->li_lv;
> > -			lv->lv_next = NULL;
> 
> What /did/ these null assignments do?

IIRC, at one point they ensured that the lv chain was correctly
terminated when a lv was reused and added to the tail of an existing
chain. I think that became redundant when we added the shadow
buffers to allow allocation outside the CIL lock contexts...

> > -		list_del_init(&item->li_cil);
> > -		item->li_order_id = 0;
> > -		if (!ctx->lv_chain)
> > -			ctx->lv_chain = item->li_lv;
> > -		else
> > -			lv->lv_next = item->li_lv;
> > +
> >  		lv = item->li_lv;
> > -		item->li_lv = NULL;
> > +		lv->lv_order_id = item->li_order_id;
> >  		num_iovecs += lv->lv_niovecs;
> > -
> >  		/* we don't write ordered log vectors */
> >  		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
> >  			num_bytes += lv->lv_bytes;
> > +		list_add_tail(&lv->lv_chain, &ctx->lv_chain);
> > +
> > +		list_del_init(&item->li_cil);
> 
> Do the list manipulations need moving, or could they have stayed further
> up in the loop body for a cleaner patch?

I moved them so the code was structured as:

		<transfer item state to log vec>
		<manipulate lists>
		<clear item state>

Because there was no clear separation between state and list
manipulations. This will clean up if I separate the list
manipulations into their own patch...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
