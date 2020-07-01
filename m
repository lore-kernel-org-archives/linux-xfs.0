Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D3FC433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 23:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D105C2077D
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 23:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgGAXes (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 19:34:48 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:58274 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726438AbgGAXes (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 19:34:48 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id C50D5D7A014;
        Thu,  2 Jul 2020 09:34:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jqmFV-0001Dy-Fe; Thu, 02 Jul 2020 09:34:41 +1000
Date:   Thu, 2 Jul 2020 09:34:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 14/18] xfs: refactor quota exceeded test
Message-ID: <20200701233441.GE2005@dread.disaster.area>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353180004.2864738.3571543752803090361.stgit@magnolia>
 <20200701085621.GN25171@infradead.org>
 <20200701175134.GU7606@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701175134.GU7606@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=3pUzYYSMGETwjZHzPfIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 10:51:34AM -0700, Darrick J. Wong wrote:
> On Wed, Jul 01, 2020 at 09:56:21AM +0100, Christoph Hellwig wrote:
> > On Tue, Jun 30, 2020 at 08:43:20AM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Refactor the open-coded test for whether or not we're over quota.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/xfs_dquot.c |   95 ++++++++++++++++------------------------------------
> > >  1 file changed, 30 insertions(+), 65 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > > index 35a113d1b42b..ef34c82c28a0 100644
> > > --- a/fs/xfs/xfs_dquot.c
> > > +++ b/fs/xfs/xfs_dquot.c
> > > @@ -97,6 +97,33 @@ xfs_qm_adjust_dqlimits(
> > >  		xfs_dquot_set_prealloc_limits(dq);
> > >  }
> > >  
> > > +/*
> > > + * Determine if this quota counter is over either limit and set the quota
> > > + * timers as appropriate.
> > > + */
> > > +static inline void
> > > +xfs_qm_adjust_res_timer(
> > > +	struct xfs_dquot_res	*res,
> > > +	struct xfs_def_qres	*dres)
> > > +{
> > > +	bool			over;
> > > +
> > > +#ifdef DEBUG
> > > +	if (res->hardlimit)
> > > +		ASSERT(res->softlimit <= res->hardlimit);
> > > +#endif
> > 
> > Maybe:
> > 	ASSERRT(!res->hardlimit || res->softlimit <= res->hardlimit);
> 
> Changed.
> 
> > 
> > > +
> > > +	over = (res->softlimit && res->count > res->softlimit) ||
> > > +	       (res->hardlimit && res->count > res->hardlimit);
> > > +
> > > +	if (over && res->timer == 0)
> > > +		res->timer = ktime_get_real_seconds() + dres->timelimit;
> > > +	else if (!over && res->timer != 0)
> > > +		res->timer = 0;
> > > +	else if (!over && res->timer == 0)
> > > +		res->warnings = 0;
> > 
> > What about:
> > 
> > 	if ((res->softlimit && res->count > res->softlimit) ||
> > 	    (res->hardlimit && res->count > res->hardlimit)) {
> > 		if (res->timer == 0)	
> > 			res->timer = ktime_get_real_seconds() + dres->timelimit;
> > 	} else {
> > 		if (res->timer)
> > 			res->timer = 0;
> > 		else
> > 			res->warnings = 0;
> > 	}
> 
> I don't care either way, but the last time I sent this patch out, Eric
> and Amir seemed to want a flatter if structure:

I much prefer Christoph's version - I was going to suggest the same
sort of thing myself as the "flatter" version just looks needlessly
convoluted to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
