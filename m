Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D4E9C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 04:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 527AF60232
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 04:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhBSE5o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 23:57:44 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:46204 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229544AbhBSE5m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Feb 2021 23:57:42 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id B766CFEADB7;
        Fri, 19 Feb 2021 15:56:59 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lCxqc-00BWj7-VF; Fri, 19 Feb 2021 15:56:58 +1100
Date:   Fri, 19 Feb 2021 15:56:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't call into blockgc scan with freeze protection
Message-ID: <20210219045658.GF4662@dread.disaster.area>
References: <20210218201458.718889-1-bfoster@redhat.com>
 <20210219032309.GX7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219032309.GX7193@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=zd4SFoCUPE_noexpNpgA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 07:23:09PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 18, 2021 at 03:14:58PM -0500, Brian Foster wrote:
> > fstest xfs/167 produced a lockdep splat that complained about a
> > nested transaction acquiring freeze protection during an eofblocks
> > scan. Drop freeze protection around the block reclaim scan in the
> > transaction allocation code to avoid this problem.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> I think it seems reasonable, though I really wish that other patchset to
> clean up all the "modify thread state when we start/end transactions"
> had landed.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
> > ---
> >  fs/xfs/xfs_trans.c | 19 ++++++++++++++-----
> >  1 file changed, 14 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 44f72c09c203..c32c62d3b77a 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -261,6 +261,7 @@ xfs_trans_alloc(
> >  {
> >  	struct xfs_trans	*tp;
> >  	int			error;
> > +	bool			retried = false;
> >  
> >  	/*
> >  	 * Allocate the handle before we do our freeze accounting and setting up
> > @@ -288,19 +289,27 @@ xfs_trans_alloc(
> >  	INIT_LIST_HEAD(&tp->t_dfops);
> >  	tp->t_firstblock = NULLFSBLOCK;
> >  
> > +retry:
> >  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > -	if (error == -ENOSPC) {
> > +	if (error == -ENOSPC && !retried) {
> >  		/*
> >  		 * We weren't able to reserve enough space for the transaction.
> >  		 * Flush the other speculative space allocations to free space.
> >  		 * Do not perform a synchronous scan because callers can hold
> >  		 * other locks.
> >  		 */
> > +		retried = true;
> > +		if (!(flags & XFS_TRANS_NO_WRITECOUNT))
> > +			sb_end_intwrite(mp->m_super);
> >  		error = xfs_blockgc_free_space(mp, NULL);
> > -		if (!error)
> > -			error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > -	}
> > -	if (error) {
> > +		if (error) {
> > +			kmem_cache_free(xfs_trans_zone, tp);
> > +			return error;
> > +		}

This seems dangerous to me. If xfs_trans_reserve() adds anything to
the transaction even if it fails, this will fail to free it. e.g.
xfs_log_reserve() call allocate a ticket and attach it to the
transaction and *then fail*. This code will now leak that ticket.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
