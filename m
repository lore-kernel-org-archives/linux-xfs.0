Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5A89C4332B
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 20:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B03864EC4
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 20:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhBYU60 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 15:58:26 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41574 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234426AbhBYU40 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 15:56:26 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 893351041250;
        Fri, 26 Feb 2021 07:55:39 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lFNff-004FYg-05; Fri, 26 Feb 2021 07:55:39 +1100
Date:   Fri, 26 Feb 2021 07:55:38 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs: remove need_start_rec parameter from
 xlog_write()
Message-ID: <20210225205538.GL4662@dread.disaster.area>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-7-david@fromorbit.com>
 <YDdkkPyKSnPfll3n@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDdkkPyKSnPfll3n@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=7-415B0cAAAA:8
        a=hYdNAdRPGuuYHEvWrQgA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 09:49:20AM +0100, Christoph Hellwig wrote:
> > +	if (optype & XLOG_START_TRANS)
> > +		headers++;
> 
> This deserves a comment.

It gets killed off later, so it's a waste of time to prettify this.

> > +	len = xlog_write_calc_vec_length(ticket, log_vector, optype);
> > +	if (start_lsn)
> > +		*start_lsn = 0;
> 
> I'd slightly prefer that allowing a NULL start_lsn was a separate prep
> patch.  As-is it really clutters the patch and detracts from the real
> change.

No, I've already got enough patches in this whole series to deal
with. I'm not splitting out simple, obvious changes into tiny two
line patches that require me to do more work for zero gain.

> >  			int			copy_len;
> >  			int			copy_off;
> >  			bool			ordered = false;
> > +			bool			wrote_start_rec = false;
> >  
> >  			/* ordered log vectors have no regions to write */
> >  			if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED) {
> > @@ -2502,13 +2501,15 @@ xlog_write(
> >  			 * write a start record. Only do this for the first
> >  			 * iclog we write to.
> >  			 */
> > -			if (need_start_rec) {
> > +			if (optype & XLOG_START_TRANS) {
> 
> So this relies on the fact that the only callers that passes an optype of
> XLOG_START_TRANS only writes a single lv.  I think we want an assert for
> that somewhere to avoid a bad surprise later.

This also gets killed off later, so again such things are largely a
waste of my time as all it does is cause rebase conflicts in
multiple patches  and doesn't actually change the end result. So,
again, no.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
