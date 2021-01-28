Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49496C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 21:00:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17FFC64DE0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 21:00:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhA1VAY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 16:00:24 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:58233 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229595AbhA1VAX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 16:00:23 -0500
Received: from dread.disaster.area (pa49-181-52-82.pa.nsw.optusnet.com.au [49.181.52.82])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id DADC6A0B3;
        Fri, 29 Jan 2021 07:59:33 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1l5EO4-003VOw-7r; Fri, 29 Jan 2021 07:59:32 +1100
Date:   Fri, 29 Jan 2021 07:59:32 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: log stripe roundoff is a property of the log
Message-ID: <20210128205932.GN4662@dread.disaster.area>
References: <20210128044154.806715-1-david@fromorbit.com>
 <20210128044154.806715-2-david@fromorbit.com>
 <20210128145703.GA2599027@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128145703.GA2599027@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=7pwokN52O8ERr2y46pWGmQ==:117 a=7pwokN52O8ERr2y46pWGmQ==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=xMF8KYC1z1xeMgMhAlYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 28, 2021 at 09:57:03AM -0500, Brian Foster wrote:
> On Thu, Jan 28, 2021 at 03:41:50PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We don't need to look at the xfs_mount and superblock every time we
> > need to do an iclog roundoff calculation. The property is fixed for
> > the life of the log, so store the roundoff in the log at mount time
> > and use that everywhere.
> > 
> > On a debug build:
> > 
> > $ size fs/xfs/xfs_log.o.*
> >    text	   data	    bss	    dec	    hex	filename
> >   27360	    560	      8	  27928	   6d18	fs/xfs/xfs_log.o.orig
> >   27219	    560	      8	  27787	   6c8b	fs/xfs/xfs_log.o.patched
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_log_format.h |  3 --
> >  fs/xfs/xfs_log.c               | 60 +++++++++++++++-------------------
> >  fs/xfs/xfs_log_priv.h          |  2 ++
> >  3 files changed, 28 insertions(+), 37 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 58699881c100..c5f507c24577 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -1400,6 +1400,12 @@ xlog_alloc_log(
> >  	xlog_assign_atomic_lsn(&log->l_last_sync_lsn, 1, 0);
> >  	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
> >  
> > +	/* roundoff padding for transaction data and one for commit record */
> 
> I don't follow this comment. What do you mean by "... and one for commit
> record?"

I just copied the comment from the code I lifted it from. I will
remove it.

> > +int
> > +xfs_log_calc_unit_res(
> > +	struct xfs_mount	*mp,
> > +	int			unit_bytes)
> > +{
> > +	return xlog_calc_unit_res(mp->m_log, unit_bytes);
> > +}
> > +
> 
> Could this be moved to the header as an inline? Otherwise looks
> reasonable.

Not without making everything that includes the header file this is
added to first including all the log header files.

We really need to clean up the mess that are external log interfaces
xfs_log_...(mp...) vs internal  log interfaces xlog_...(log...) and
the random distribution of such functions through xfs_log.c,
xfs_log_recover.c, xfs_mount.c, xfs_log.h, xfs_log_priv.h,
xfs_trans.h, and xfs_log_format.h....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
