Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2931FC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 11:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242833AbiDLLpe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 07:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352169AbiDLLo3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 07:44:29 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5B6AC7B577
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 03:25:34 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 29BA310C7888;
        Tue, 12 Apr 2022 20:25:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1neDiG-00GnBI-Vy; Tue, 12 Apr 2022 20:25:33 +1000
Date:   Tue, 12 Apr 2022 20:25:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Alli <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: factor and move some code in xfs_log_cil.c
Message-ID: <20220412102532.GI1544202@dread.disaster.area>
References: <20220314220631.3093283-1-david@fromorbit.com>
 <20220314220631.3093283-6-david@fromorbit.com>
 <b9047c05f26e02136f66ad644a3bb42a3e2b90b2.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9047c05f26e02136f66ad644a3bb42a3e2b90b2.camel@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6255539e
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=dXg9VljsqYohMeu7Bg4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 10, 2022 at 10:24:21PM -0700, Alli wrote:
> On Tue, 2022-03-15 at 09:06 +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > In preparation for adding support for intent item whiteouts.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log_cil.c | 119 ++++++++++++++++++++++++-----------------
> > --
> >  1 file changed, 67 insertions(+), 52 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index 5179436b6603..dda71f1a25c5 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -47,6 +47,38 @@ xlog_cil_ticket_alloc(
> >  	return tic;
> >  }
> >  
> > +/*
> > + * Check if the current log item was first committed in this
> > sequence.
> > + * We can't rely on just the log item being in the CIL, we have to
> > check
> > + * the recorded commit sequence number.
> > + *
> > + * Note: for this to be used in a non-racy manner, it has to be
> > called with
> > + * CIL flushing locked out. As a result, it should only be used
> > during the
> > + * transaction commit process when deciding what to format into the
> > item.
> > + */
> > +static bool
> > +xlog_item_in_current_chkpt(
> > +	struct xfs_cil		*cil,
> > +	struct xfs_log_item	*lip)
> > +{
> > +	if (list_empty(&lip->li_cil))
> > +		return false;
> > +
> > +	/*
> > +	 * li_seq is written on the first commit of a log item to
> > record the
> > +	 * first checkpoint it is written to. Hence if it is different
> > to the
> > +	 * current sequence, we're in a new checkpoint.
> > +	 */
> > +	return lip->li_seq == READ_ONCE(cil->xc_current_sequence);
> > +}
> > +
> > +bool
> > +xfs_log_item_in_current_chkpt(
> > +	struct xfs_log_item *lip)
> > +{
> > +	return xlog_item_in_current_chkpt(lip->li_mountp->m_log-
> > >l_cilp, lip);
> 
> I think this turns into "lip->li_log->l_mp->m_log->l_cilp" in the new
> code base

Should just be lip->li_log->l_cilp.

> 
> > +}
> > +
> >  /*
> >   * Unavoidable forward declaration - xlog_cil_push_work() calls
> >   * xlog_cil_ctx_alloc() itself.
> > @@ -924,6 +956,40 @@ xlog_cil_build_trans_hdr(
> >  	tic->t_curr_res -= lvhdr->lv_bytes;
> >  }
> >  
> > +/*
> > + * Pull all the log vectors off the items in the CIL, and remove the
> > items from
> > + * the CIL. We don't need the CIL lock here because it's only needed
> > on the
> > + * transaction commit side which is currently locked out by the
> > flush lock.
> > + */
> > +static void
> > +xlog_cil_build_lv_chain(
> > +	struct xfs_cil		*cil,
> > +	struct xfs_cil_ctx	*ctx,
> > +	uint32_t		*num_iovecs,
> > +	uint32_t		*num_bytes)
> > +{
> > +	struct xfs_log_vec	*lv = NULL;
> > +
> > +	while (!list_empty(&cil->xc_cil)) {
> > +		struct xfs_log_item	*item;
> > +
> > +		item = list_first_entry(&cil->xc_cil,
> > +					struct xfs_log_item, li_cil);
> > +		list_del_init(&item->li_cil);
> > +		if (!ctx->lv_chain)
> > +			ctx->lv_chain = item->li_lv;
> > +		else
> > +			lv->lv_next = item->li_lv;
> > +		lv = item->li_lv;
> > +		item->li_lv = NULL;
> > +		*num_iovecs += lv->lv_niovecs;
> > 
> 
> This part below does not appear in the new rebase, so this would go
> away in the hoisted helper
> 
> > +
> > +		/* we don't write ordered log vectors */
> > +		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
> > +			*num_bytes += lv->lv_bytes;
> > +	}
> > +}
> > +
> >  /*
> >   * Push the Committed Item List to the log.
> >   *
> > @@ -946,7 +1012,6 @@ xlog_cil_push_work(
> >  		container_of(work, struct xfs_cil_ctx, push_work);
> >  	struct xfs_cil		*cil = ctx->cil;
> >  	struct xlog		*log = cil->xc_log;
> > -	struct xfs_log_vec	*lv;
> >  	struct xfs_cil_ctx	*new_ctx;
> >  	int			num_iovecs = 0;
> 
> For me, I had to add the new num_bytes variable here:
> 	int			num_iovecs, num_bytes;
> 
> I think the new helper does not need the num_bytes parameter in the new
> rebase, so we may be able to just remove num_bytes  entirely.

Right, so this is all stuff that changes in the xlog-write rework
patch series that this was based on. There's a lot of changes
to the CIL push code in that series that this builds on....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
