Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FCA8C6377D
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 597FF61279
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 07:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhGVGvu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 02:51:50 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:49427 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230100AbhGVGvt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jul 2021 02:51:49 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 4CB8E80BCC8;
        Thu, 22 Jul 2021 17:32:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m6TBv-009P1b-Pb; Thu, 22 Jul 2021 17:32:23 +1000
Date:   Thu, 22 Jul 2021 17:32:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: log forces imply data device cache flushes
Message-ID: <20210722073223.GN664593@dread.disaster.area>
References: <20210722015335.3063274-1-david@fromorbit.com>
 <20210722015335.3063274-5-david@fromorbit.com>
 <YPka2FRJAC38RbU+@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPka2FRJAC38RbU+@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=7-415B0cAAAA:8
        a=LtwxpNqEyJ9ujRk-oqMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 08:14:32AM +0100, Christoph Hellwig wrote:
> On Thu, Jul 22, 2021 at 11:53:34AM +1000, Dave Chinner wrote:
> > +static inline int
> > +xlog_force_iclog(
> > +	struct xlog_in_core	*iclog)
> > +{
> > +	atomic_inc(&iclog->ic_refcnt);
> > +	iclog->ic_flags |= XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA;
> > +	if (iclog->ic_state == XLOG_STATE_ACTIVE)
> > +		xlog_state_switch_iclogs(iclog->ic_log, iclog, 0);
> > +	return xlog_state_release_iclog(iclog->ic_log, iclog, 0);
> > +}
> 
> This also combines code move with technical changes.  At least it is
> small enough to be reviewable.

Yup, another split really needed here. And the need to catch
WANT_SYNC iclogs for flushing should really be split out, too,
because that's more than just "oops, I forgot to mark ACTIVE iclogs
we force out for flushing"...

> >  out_err:
> > -	if (error)
> > -		xfs_alert(mp, "%s: unmount record failed", __func__);
> > -
> >  
> 
> > +	if (error)
> > +		xfs_alert(mp, "%s: unmount record failed", __func__);
> > +
> >  }
> 
> This now doesn't print an error when the log reservation or log write
> fails, but only one when the log force fails.  Also there i a spurious
> empty line at the end.

Ah, I thought it caught them - oh, error gets overwritten. Doh! I'll
fix that up.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks for looking at these quickly, Christoph.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
