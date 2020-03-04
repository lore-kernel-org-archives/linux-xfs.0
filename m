Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 706E0C3F2D1
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 21:28:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49F9620866
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 21:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387762AbgCDV2W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 16:28:22 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:50321 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726440AbgCDV2W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 16:28:22 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7BE253A27DF;
        Thu,  5 Mar 2020 08:28:19 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9bYw-0004Ma-U5; Thu, 05 Mar 2020 08:28:18 +1100
Date:   Thu, 5 Mar 2020 08:28:18 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/11] xfs: refactor and split xfs_log_done()
Message-ID: <20200304212818.GA10776@dread.disaster.area>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-4-david@fromorbit.com>
 <20200304154955.GB17565@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304154955.GB17565@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=7-415B0cAAAA:8 a=R0vMAowjBP_RU6CrpswA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 07:49:55AM -0800, Christoph Hellwig wrote:
> > +int
> > +xlog_write_done(
> > +	struct xlog		*log,
> >  	struct xlog_ticket	*ticket,
> >  	struct xlog_in_core	**iclog,
> > +	xfs_lsn_t		*lsn)
> >  {
> > +	if (XLOG_FORCED_SHUTDOWN(log))
> > +		return -EIO;
> >  
> > +	return xlog_commit_record(log, ticket, iclog, lsn);
> > +}
> 
> Can we just move the XLOG_FORCED_SHUTDOWN check into xlog_commit_record
> and call xlog_commit_record directly?

Next patch, because merging isn't obvious until the split is done.

> > +/*
> > + * Release or regrant the ticket reservation now the transaction is done with
> > + * it depending on caller context. Rolling transactions need the ticket
> > + * regranted, otherwise we release it completely.
> > + */
> > +void
> > +xlog_ticket_done(
> > +	struct xlog		*log,
> > +	struct xlog_ticket	*ticket,
> > +	bool			regrant)
> > +{
> >  	if (!regrant) {
> >  		trace_xfs_log_done_nonperm(log, ticket);
> >  		xlog_ungrant_log_space(log, ticket);
> >  	} else {
> >  		trace_xfs_log_done_perm(log, ticket);
> >  		xlog_regrant_reserve_log_space(log, ticket);
> >  	}
> 
> >  	xfs_log_ticket_put(ticket);
> 
> I'd move the trace points and the call to xfs_log_ticket_put into
> xlog_ungrant_log_space and xlog_regrant_reserve_log_space, and then call
> the two functions directly from the callers.  There is only a single
> place the ever regrants anyway.

Ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
