Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD66AC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 04:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357724AbiD0Ezp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Apr 2022 00:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237234AbiD0Ezp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 00:55:45 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AFB7B54692
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 21:52:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id F294410E5FDD;
        Wed, 27 Apr 2022 14:52:31 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njZfC-0051YR-U9; Wed, 27 Apr 2022 14:52:30 +1000
Date:   Wed, 27 Apr 2022 14:52:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: don't commit the first deferred transaction
 without intents
Message-ID: <20220427045230.GM1098723@dread.disaster.area>
References: <20220427022259.695399-1-david@fromorbit.com>
 <20220427022259.695399-3-david@fromorbit.com>
 <20220427030330.GA17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427030330.GA17025@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6268cc10
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=xiwRu6C07EpFLK0dadMA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 08:03:30PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 27, 2022 at 12:22:53PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > If the first operation in a string of defer ops has no intents,
> > then there is no reason to commit it before running the first call
> > to xfs_defer_finish_one(). This allows the defer ops to be used
> > effectively for non-intent based operations without requiring an
> > unnecessary extra transaction commit when first called.
> > 
> > This fixes a regression in per-attribute modification transaction
> > count when delayed attributes are not being used.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_defer.c | 29 +++++++++++++++++------------
> >  1 file changed, 17 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index 0805ade2d300..66b4555bda8e 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
> > @@ -186,7 +186,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
> >  	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
> >  };
> >  
> > -static void
> > +static bool
> >  xfs_defer_create_intent(
> >  	struct xfs_trans		*tp,
> >  	struct xfs_defer_pending	*dfp,
> > @@ -197,6 +197,7 @@ xfs_defer_create_intent(
> >  	if (!dfp->dfp_intent)
> >  		dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
> >  						     dfp->dfp_count, sort);
> > +	return dfp->dfp_intent;
> 
> Same comment as last time -- please make it more obvious that we're
> returning whether or not ->create_intent actually added a log item:
> 
> 	return dfp->dfp_intent != NULL;

Oh, sorry, I must have missed that. My fault! Fixed.

> and not returning the log intent item itself.
> 
> Otherwise looks ok, so with that fixed,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
