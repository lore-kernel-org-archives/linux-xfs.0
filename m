Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D6E7C47080
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0154661026
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbhFBAgf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 20:36:35 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:39702 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229586AbhFBAgf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Jun 2021 20:36:35 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 569F21141C89;
        Wed,  2 Jun 2021 10:34:50 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1loEqL-007uRO-TT; Wed, 02 Jun 2021 10:34:45 +1000
Date:   Wed, 2 Jun 2021 10:34:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/23 V2] xfs: convert xfs_iwalk to use perag references
Message-ID: <20210602003445.GI664593@dread.disaster.area>
References: <20210519012102.450926-1-david@fromorbit.com>
 <20210519012102.450926-7-david@fromorbit.com>
 <20210527221648.GV2402049@locust>
 <20210601220054.GE664593@dread.disaster.area>
 <20210601233216.GF26380@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601233216.GF26380@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=Ht2_HAE20jwxD2X_WvsA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 01, 2021 at 04:32:16PM -0700, Darrick J. Wong wrote:
> On Wed, Jun 02, 2021 at 08:00:54AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Rather than manually walking the ags and passing agnunbers around,
> > pass the perag for the AG we are currently working on around in the
> > iwalk structure.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > ---
> > V2: convert next_agno -> agno in perag walk macros
> > 
> >  fs/xfs/libxfs/xfs_ag.h | 20 +++++++-----
> >  fs/xfs/xfs_iwalk.c     | 86 +++++++++++++++++++++++++++++++-------------------
> >  2 files changed, 66 insertions(+), 40 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> > index 33783120263c..2e02ec3693c5 100644
> > --- a/fs/xfs/libxfs/xfs_ag.h
> > +++ b/fs/xfs/libxfs/xfs_ag.h
> > @@ -117,19 +117,23 @@ void	xfs_perag_put(struct xfs_perag *pag);
> >  /*
> >   * Perag iteration APIs
> >   */
> > -#define for_each_perag(mp, next_agno, pag) \
> > -	for ((next_agno) = 0, (pag) = xfs_perag_get((mp), 0); \
> > +#define for_each_perag_from(mp, agno, pag) \
> > +	for ((pag) = xfs_perag_get((mp), (agno)); \
> 
> Er... I guess I wasn't clear enough.  I was ok with the "next_agno" name
> for for_each_perag_from to reinforce the idea that the caller is
> required to initialize the variable before using the macro.
> 
> It's the other variants (for_each_perag and for_each_perag_tag) where
> the macro initializes @agno so it's not necessary for the caller to have
> provided any value at all.
> 
> IOWS,
> 
> #define for_each_perag_from(mp, next_agno, pag) \
> 	for ((pag) = xfs_perag_get((mp), (next_agno)); \
> 		(pag) != NULL; \
> 		(next_agno) = (pag)->pag_agno + 1, \
> 		xfs_perag_put(pag), \
> 		(pag) = xfs_perag_get((mp), (next_agno)))
> 
> #define for_each_perag(mp, agno, pag) \
> 	(agno) = 0; \
> 	for_each_perag_from((mp), (agno), (pag))
> 
> #define for_each_perag_tag(mp, agno, pag, tag) \
> 	for ((agno) = 0, (pag) = xfs_perag_get_tag((mp), 0, (tag)); \
> 		(pag) != NULL; \
> 		(agno) = (pag)->pag_agno + 1, \
> 		xfs_perag_put(pag), \
> 		(pag) = xfs_perag_get_tag((mp), (agno), (tag)))

Ok, let me go change that back...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
