Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55E26C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 22:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2291864DA1
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 22:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhA1WBi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 17:01:38 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51872 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229596AbhA1WBi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 17:01:38 -0500
Received: from dread.disaster.area (pa49-181-52-82.pa.nsw.optusnet.com.au [49.181.52.82])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6B9A9827702;
        Fri, 29 Jan 2021 09:00:55 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1l5FLS-003WOy-RT; Fri, 29 Jan 2021 09:00:54 +1100
Date:   Fri, 29 Jan 2021 09:00:54 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: log stripe roundoff is a property of the log
Message-ID: <20210128220054.GS4662@dread.disaster.area>
References: <20210128044154.806715-1-david@fromorbit.com>
 <20210128044154.806715-2-david@fromorbit.com>
 <20210128212511.GC7698@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128212511.GC7698@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=7pwokN52O8ERr2y46pWGmQ==:117 a=7pwokN52O8ERr2y46pWGmQ==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=7-415B0cAAAA:8
        a=jBFjmJOV9qYazyUepgkA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 28, 2021 at 01:25:11PM -0800, Darrick J. Wong wrote:
> On Thu, Jan 28, 2021 at 03:41:50PM +1100, Dave Chinner wrote:
> > @@ -3404,12 +3395,11 @@ xfs_log_ticket_get(
> >   * Figure out the total log space unit (in bytes) that would be
> >   * required for a log ticket.
> >   */
> > -int
> > -xfs_log_calc_unit_res(
> > -	struct xfs_mount	*mp,
> > +static int
> > +xlog_calc_unit_res(
> > +	struct xlog		*log,
> >  	int			unit_bytes)
> >  {
> > -	struct xlog		*log = mp->m_log;
> >  	int			iclog_space;
> >  	uint			num_headers;
> >  
> > @@ -3485,18 +3475,20 @@ xfs_log_calc_unit_res(
> >  	/* for commit-rec LR header - note: padding will subsume the ophdr */
> >  	unit_bytes += log->l_iclog_hsize;
> >  
> > -	/* for roundoff padding for transaction data and one for commit record */
> > -	if (xfs_sb_version_haslogv2(&mp->m_sb) && mp->m_sb.sb_logsunit > 1) {
> > -		/* log su roundoff */
> > -		unit_bytes += 2 * mp->m_sb.sb_logsunit;
> > -	} else {
> > -		/* BB roundoff */
> > -		unit_bytes += 2 * BBSIZE;
> > -        }
> > +	/* roundoff padding for transaction data and one for commit record */
> > +	unit_bytes += log->l_iclog_roundoff;
> 
> I don't understand why the "2 *" disappears here.  It's not a part of
> the roundoff computation when we allocate the log, so AFAICT it's not
> just buried elsewhere?
> 
> Was the old code saying that it added the roundoff factor twice because
> we needed to do so once for the transaction data and the second time for
> the commit record?

Just  a bug. I originally copying this entire chunk into the log
init code (hence the comment), then I found another place it could
be used but it didn't need the "* 2" value. SO i changed the init
site, forgetting to put it back here.

Will fix and resend.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
