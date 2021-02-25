Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 842CEC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 22:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C54A64E7A
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 22:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhBYWSS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 17:18:18 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:45980 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234499AbhBYWRU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 17:17:20 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 53FF9FA6EA6;
        Fri, 26 Feb 2021 09:16:34 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lFOvx-004Kr9-O9; Fri, 26 Feb 2021 09:16:33 +1100
Date:   Fri, 26 Feb 2021 09:16:33 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/13] xfs: reserve space and initialise xlog_op_header
 in item formatting
Message-ID: <20210225221633.GS4662@dread.disaster.area>
References: <20210224063459.3436852-1-david@fromorbit.com>
 <20210224063459.3436852-8-david@fromorbit.com>
 <YDfsCAlkD45J1BF6@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDfsCAlkD45J1BF6@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=7-415B0cAAAA:8
        a=rQH6UluJlDWiWOcTWbYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 07:27:20PM +0100, Christoph Hellwig wrote:
> > +			if (optype && index) {
> > +				optype &= ~XLOG_START_TRANS;
> > +			} else if (partial_copy) {
> >                                  ophdr = xlog_write_setup_ophdr(ptr, ticket);
> 
> This line uses whitespaces for indentation, we should probably fix that
> up somewhere in the series.

It goes away entirely so, yes, it is fixed up :)

> >  static inline void *
> >  xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
> >  		uint type)
> >  {
> > -	struct xfs_log_iovec *vec = *vecp;
> > +	struct xfs_log_iovec	*vec = *vecp;
> > +	struct xlog_op_header	*oph;
> > +	uint32_t		len;
> > +	void			*buf;
> >  
> >  	if (vec) {
> >  		ASSERT(vec - lv->lv_iovecp < lv->lv_niovecs);
> > @@ -44,21 +54,36 @@ xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
> >  		vec = &lv->lv_iovecp[0];
> >  	}
> >  
> > -	if (!IS_ALIGNED(lv->lv_buf_len, sizeof(uint64_t)))
> > -		lv->lv_buf_len = round_up(lv->lv_buf_len, sizeof(uint64_t));
> > +	len = lv->lv_buf_len + sizeof(struct xlog_op_header);
> > +	if (!IS_ALIGNED(len, sizeof(uint64_t))) {
> > +		lv->lv_buf_len = round_up(len, sizeof(uint64_t)) -
> > +					sizeof(struct xlog_op_header);
> > +	}
> >  
> >  	vec->i_type = type;
> >  	vec->i_addr = lv->lv_buf + lv->lv_buf_len;
> >  
> > -	ASSERT(IS_ALIGNED((unsigned long)vec->i_addr, sizeof(uint64_t)));
> > +	oph = vec->i_addr;
> > +	oph->oh_clientid = XFS_TRANSACTION;
> > +	oph->oh_res2 = 0;
> > +	oph->oh_flags = 0;
> > +
> > +	buf = vec->i_addr + sizeof(struct xlog_op_header);
> > +	ASSERT(IS_ALIGNED((unsigned long)buf, sizeof(uint64_t)));
> >  
> >  	*vecp = vec;
> > -	return vec->i_addr;
> > +	return buf;
> >  }
> 
> I think this function is growing a little too larger to stay inlined.

Possibly. let me have a look at code size and if it does make a
difference I'll move it out of line in another patch.

> 
> > -		nbytes += niovecs * sizeof(uint64_t);
> > +		nbytes += niovecs * (sizeof(uint64_t) +
> > +					sizeof(struct xlog_op_header));;
> 
> Is it just me, or would
> 
> 		nbytes += niovecs *
> 			(sizeof(uint64_t) + sizeof(struct xlog_op_header));
> 
> be a little easier to read?

Yes, that's better.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
