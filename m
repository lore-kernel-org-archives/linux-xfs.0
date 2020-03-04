Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C8EDC3F2CE
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 21:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7131E20838
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 21:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388364AbgCDV0z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 16:26:55 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:43295 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387762AbgCDV0y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 16:26:54 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7BC163A2923;
        Thu,  5 Mar 2020 08:26:50 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9bXU-0004Jl-Ox; Thu, 05 Mar 2020 08:26:48 +1100
Date:   Thu, 5 Mar 2020 08:26:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/11] xfs: don't try to write a start record into every
 iclog
Message-ID: <20200304212648.GZ10776@dread.disaster.area>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-2-david@fromorbit.com>
 <20200304154421.GA17565@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304154421.GA17565@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=7-415B0cAAAA:8 a=G4MrZ8rAqdhwFF6TXlIA:9 a=BXScohDqB2jR35AV:21
        a=yPfBKcgCJXb-vl5D:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 07:44:21AM -0800, Christoph Hellwig wrote:
> >  /*
> > - * Calculate the potential space needed by the log vector.  Each region gets
> > - * its own xlog_op_header_t and may need to be double word aligned.
> > + * Calculate the potential space needed by the log vector.  We may need a
> > + * start record, and each region gets its own xlog_op_header_t and may need to
> > + * be double word aligned.
> 
> s/xlog_op_header_t/struct xlog_op_header/ while you're at it.
> 
> > @@ -2404,25 +2391,29 @@ xlog_write(
> >  	int			record_cnt = 0;
> >  	int			data_cnt = 0;
> >  	int			error = 0;
> > +	int			start_rec_size = sizeof(struct xlog_op_header);
> >  
> >  	*start_lsn = 0;
> >  
> > -	len = xlog_write_calc_vec_length(ticket, log_vector);
> >  
> >  	/*
> >  	 * Region headers and bytes are already accounted for.
> >  	 * We only need to take into account start records and
> >  	 * split regions in this function.
> >  	 */
> > -	if (ticket->t_flags & XLOG_TIC_INITED)
> > +	if (ticket->t_flags & XLOG_TIC_INITED) {
> >  		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> > +		ticket->t_flags &= ~XLOG_TIC_INITED;
> > +	}
> >  
> >  	/*
> >  	 * Commit record headers need to be accounted for. These
> >  	 * come in as separate writes so are easy to detect.
> >  	 */
> > -	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
> > +	if (flags & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
> >  		ticket->t_curr_res -= sizeof(xlog_op_header_t);
> > +		start_rec_size = 0;
> > +	}
> >  
> >  	if (ticket->t_curr_res < 0) {
> >  		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
> > @@ -2431,6 +2422,8 @@ xlog_write(
> >  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> >  	}
> >  
> > +	len = xlog_write_calc_vec_length(ticket, log_vector, start_rec_size);
> 
> The last arg is used as a boolean in xlog_write_calc_vec_length. I
> think it would make sense to have a need_start_rec boolean in this
> function as well, and just hardcode the sizeof in the two places that
> actually need the size.

I originally had that and while the code looked kinda weird
opencoding an ophdr everywhere we wanted the size of a start record,
that wasn't an issue. The biggest problem was that using a boolean
resulted in _several_ logic bugs that I only tracked down once I
realised I'd forgotten to replace existing the start record size
variable that now wasn't initialised inside the inner loop.

So, yes, it gets converted to a boolean inside that function call,
but I think the code in this set of nested loops is more reliable if
it carries the size of the structure rather than open coding it
everywhere. Making it a boolean doesn't improve the readability of
the code at all.

> > +			copy_len += sizeof(xlog_op_header_t);
> 
> s/xlog_op_header_t/struct xlog_op_header/

Ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
