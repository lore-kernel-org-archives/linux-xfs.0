Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFAEEC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D05C64FB8
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 03:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhCKDho (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 22:37:44 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:52499 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230409AbhCKDhk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 22:37:40 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id C86EE1ADF6E;
        Thu, 11 Mar 2021 14:37:38 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lKC8o-0018bF-9o; Thu, 11 Mar 2021 14:37:38 +1100
Date:   Thu, 11 Mar 2021 14:37:38 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/45] xfs: pass lv chain length into xlog_write()
Message-ID: <20210311033738.GM74031@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-28-david@fromorbit.com>
 <20210309023644.GO3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309023644.GO3419940@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=SHrOct2lgRc_e7PC7h8A:9 a=ypSYm1edgOLEjvpo:21 a=nqOi9JGc1njDl-rs:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 06:36:44PM -0800, Darrick J. Wong wrote:
> On Fri, Mar 05, 2021 at 04:11:25PM +1100, Dave Chinner wrote:
> > @@ -2306,7 +2282,6 @@ xlog_write(
> >  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> >  	}
> >  
> > -	len = xlog_write_calc_vec_length(ticket, log_vector, optype);
> >  	if (start_lsn)
> >  		*start_lsn = 0;
> >  	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index 7a5e6bdb7876..34abc3bae587 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -710,11 +710,12 @@ xlog_cil_build_trans_hdr(
> >  				sizeof(struct xfs_trans_header);
> >  	hdr->lhdr[1].i_type = XLOG_REG_TYPE_TRANSHDR;
> >  
> > -	tic->t_curr_res -= hdr->lhdr[0].i_len + hdr->lhdr[1].i_len;
> > -
> >  	lvhdr->lv_niovecs = 2;
> >  	lvhdr->lv_iovecp = &hdr->lhdr[0];
> > +	lvhdr->lv_bytes = hdr->lhdr[0].i_len + hdr->lhdr[1].i_len;
> 
> Er... does this code change belong in an earlier patch?  Or if not, why
> wasn't it important to set lv_bytes here?

It belongs in this patch.

It was not necessary to set lv_bytes before this because
xlog_write_calc_vec_length() walked the entire change calculating
the length of the chain by adding up the region lengths itself.
Because this isn't a dynamically allocated log vector associated
with a log item, we never actually use the lv_bytes field in it for
anything.

In the case of this patch, we need to add the size of the data in
the log vector to our accumulated total that xlog_cil_push_work()
now passes in to xlog_write() to replace the chain walk that
xlog_write_calc_vec_length() did to calculate the length. Hence we
have to pass the accumulated region length back to the caller, and
rather than add another parameter we fill out lv_bytes so that it
matches all the other log vectors in the chain....


> > @@ -893,6 +898,9 @@ xlog_cil_push_work(
> >  	 * transaction header here as it is not accounted for in xlog_write().
> >  	 */
> >  	xlog_cil_build_trans_hdr(ctx, &thdr, &lvhdr, num_iovecs);
> > +	num_iovecs += lvhdr.lv_niovecs;
> > +	num_bytes += lvhdr.lv_bytes;
> > +
> >  
> 
> No need to have two blank lines here.

Fixed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
