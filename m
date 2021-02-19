Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04258C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 20:43:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE0A7601FC
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 20:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbhBSUnc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Feb 2021 15:43:32 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:58954 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229515AbhBSUnc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Feb 2021 15:43:32 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 3B5B31AD7FB;
        Sat, 20 Feb 2021 07:42:49 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lDCbw-00CXpm-9I; Sat, 20 Feb 2021 07:42:48 +1100
Date:   Sat, 20 Feb 2021 07:42:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't call into blockgc scan with freeze protection
Message-ID: <20210219204248.GH4662@dread.disaster.area>
References: <20210218201458.718889-1-bfoster@redhat.com>
 <20210219032309.GX7193@magnolia>
 <20210219045658.GF4662@dread.disaster.area>
 <20210219130932.GA757814@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219130932.GA757814@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=XFqOzkKcdQMw8VH05A0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 19, 2021 at 08:09:32AM -0500, Brian Foster wrote:
> On Fri, Feb 19, 2021 at 03:56:58PM +1100, Dave Chinner wrote:
> > On Thu, Feb 18, 2021 at 07:23:09PM -0800, Darrick J. Wong wrote:
> > > On Thu, Feb 18, 2021 at 03:14:58PM -0500, Brian Foster wrote:
> > > > fstest xfs/167 produced a lockdep splat that complained about a
> > > > nested transaction acquiring freeze protection during an eofblocks
> > > > scan. Drop freeze protection around the block reclaim scan in the
> > > > transaction allocation code to avoid this problem.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> ...
> > > >  fs/xfs/xfs_trans.c | 19 ++++++++++++++-----
> > > >  1 file changed, 14 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > > index 44f72c09c203..c32c62d3b77a 100644
> > > > --- a/fs/xfs/xfs_trans.c
> > > > +++ b/fs/xfs/xfs_trans.c
> ...
> > > > @@ -288,19 +289,27 @@ xfs_trans_alloc(
> > > >  	INIT_LIST_HEAD(&tp->t_dfops);
> > > >  	tp->t_firstblock = NULLFSBLOCK;
> > > >  
> > > > +retry:
> > > >  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > > > -	if (error == -ENOSPC) {
> > > > +	if (error == -ENOSPC && !retried) {
> > > >  		/*
> > > >  		 * We weren't able to reserve enough space for the transaction.
> > > >  		 * Flush the other speculative space allocations to free space.
> > > >  		 * Do not perform a synchronous scan because callers can hold
> > > >  		 * other locks.
> > > >  		 */
> > > > +		retried = true;
> > > > +		if (!(flags & XFS_TRANS_NO_WRITECOUNT))
> > > > +			sb_end_intwrite(mp->m_super);
> > > >  		error = xfs_blockgc_free_space(mp, NULL);
> > > > -		if (!error)
> > > > -			error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > > > -	}
> > > > -	if (error) {
> > > > +		if (error) {
> > > > +			kmem_cache_free(xfs_trans_zone, tp);
> > > > +			return error;
> > > > +		}
> > 
> > This seems dangerous to me. If xfs_trans_reserve() adds anything to
> > the transaction even if it fails, this will fail to free it. e.g.
> > xfs_log_reserve() call allocate a ticket and attach it to the
> > transaction and *then fail*. This code will now leak that ticket.
> > 
> 
> xfs_trans_reserve() ungrants the log ticket (which frees it, at least in
> the allocation case) and disassociates from the transaction on error, so
> I don't see how this causes any problems.

It ungrants the log ticket when it jumps to "undo_log" on error.
When xfs_log_reserve() fails, it jumps to "undo_blocks" and doesn't
ungrant the ticket. Hence potentially leaving an allocated ticket
attached to the transaction on error.  xfs_trans_cancel() handles
this just fine, just freeing the transaction doesn't.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
