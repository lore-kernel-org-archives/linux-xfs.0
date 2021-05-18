Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2789AC433ED
	for <linux-xfs@archiver.kernel.org>; Tue, 18 May 2021 01:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A1E461073
	for <linux-xfs@archiver.kernel.org>; Tue, 18 May 2021 01:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240047AbhERBCQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 May 2021 21:02:16 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:51190 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239539AbhERBCQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 May 2021 21:02:16 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 81D4080B020;
        Tue, 18 May 2021 11:00:56 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lio6R-002Dd7-Cs; Tue, 18 May 2021 11:00:55 +1000
Date:   Tue, 18 May 2021 11:00:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/22] xfs: pass perags around in fsmap data dev functions
Message-ID: <20210518010055.GF2893@dread.disaster.area>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-11-david@fromorbit.com>
 <20210512222323.GF8582@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512222323.GF8582@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=4_1jAfQqztRYwE8QY_gA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 12, 2021 at 03:23:23PM -0700, Darrick J. Wong wrote:
> On Thu, May 06, 2021 at 05:20:42PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Needs a [from, to] ranged AG walk, and the perag to be stuffed into
> > the info structure for callouts to use.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_ag.h | 14 ++++++--
> >  fs/xfs/xfs_fsmap.c     | 75 ++++++++++++++++++++++++++----------------
> >  2 files changed, 58 insertions(+), 31 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> > index 3fa88222dacd..bebbe1bfce27 100644
> > --- a/fs/xfs/libxfs/xfs_ag.h
> > +++ b/fs/xfs/libxfs/xfs_ag.h
> > @@ -116,14 +116,24 @@ void	xfs_perag_put(struct xfs_perag *pag);
> >  
> >  /*
> >   * Perag iteration APIs
> > + *
> > + * XXX: for_each_perag_range() usage really needs an iterator to clean up when
> > + * we terminate at end_agno because we may have taken a reference to the perag
> > + * beyond end_agno. RIght now callers have to be careful to catch and clean that
> > + * up themselves. This is not necessary for the callers of for_each_perag() and
> > + * for_each_perag_from() because they terminate at sb_agcount where there are
> > + * no perag structures in tree beyond end_agno.
> 
> I think I'll wait and see what this becomes with the next iteration
> before RVBing things.  The conversions look correct in this patch.

I wasn't planning on addressing this immediately (i.e. in this patch
set), so it's not actually going to change yet. I'll do this as a
standalone conversion in the next series of changes leading up to
active references...

-Dave.

-- 
Dave Chinner
david@fromorbit.com
