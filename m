Return-Path: <SRS0=dccG=B5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6905C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAA3B20772
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Aug 2020 00:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgHSAwg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 20:52:36 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:43162 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726469AbgHSAwe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 20:52:34 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0E8513A67DE;
        Wed, 19 Aug 2020 10:52:28 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k8CL5-0007dJ-ED; Wed, 19 Aug 2020 10:52:27 +1000
Date:   Wed, 19 Aug 2020 10:52:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/13] xfs: replace iunlink backref lookups with list
 lookups
Message-ID: <20200819005227.GH21744@dread.disaster.area>
References: <20200812092556.2567285-1-david@fromorbit.com>
 <20200812092556.2567285-7-david@fromorbit.com>
 <20200819001322.GT6096@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819001322.GT6096@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=zTSfXKxNWo3u5nlMKbMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 05:13:22PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 12, 2020 at 07:25:49PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now we have an in memory linked list of all the inodes on the
> > unlinked list, use that to look up inodes in the list that we need
> > to modify when adding or removing from the list.
> > 
> > This means we are no longer using the backref cache to maintain the
> > previous inode lookups, so we can remove all that infrastructure
> > now.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>

....

> > @@ -2354,70 +2186,24 @@ xfs_iunlink_map_prev(
> >  	xfs_agnumber_t		agno,
> >  	xfs_agino_t		head_agino,
> >  	xfs_agino_t		target_agino,
> > -	xfs_agino_t		*agino,
> > +	xfs_agino_t		agino,
> >  	struct xfs_imap		*imap,
> >  	struct xfs_dinode	**dipp,
> >  	struct xfs_buf		**bpp,
> >  	struct xfs_perag	*pag)
> >  {
> > -	struct xfs_mount	*mp = tp->t_mountp;
> > -	xfs_agino_t		next_agino;
> >  	int			error;
> >  
> >  	ASSERT(head_agino != target_agino);
> >  	*bpp = NULL;
> >  
> > -	/* See if our backref cache can find it faster. */
> > -	*agino = xfs_iunlink_lookup_backref(pag, target_agino);
> > -	if (*agino != NULLAGINO) {
> > -		error = xfs_iunlink_map_ino(tp, agno, *agino, imap, dipp, bpp);
> > -		if (error)
> > -			return error;
> > -
> > -		if (be32_to_cpu((*dipp)->di_next_unlinked) == target_agino)
> > -			return 0;
> > -
> > -		/*
> > -		 * If we get here the cache contents were corrupt, so drop the
> > -		 * buffer and fall back to walking the bucket list.
> > -		 */
> > -		xfs_trans_brelse(tp, *bpp);
> > -		*bpp = NULL;
> > -		WARN_ON_ONCE(1);
> > -	}
> > -
> > -	trace_xfs_iunlink_map_prev_fallback(mp, agno);
> > -
> > -	/* Otherwise, walk the entire bucket until we find it. */
> > -	next_agino = head_agino;
> > -	while (next_agino != target_agino) {
> > -		xfs_agino_t	unlinked_agino;
> > -
> > -		if (*bpp)
> > -			xfs_trans_brelse(tp, *bpp);
> > -
> > -		*agino = next_agino;
> > -		error = xfs_iunlink_map_ino(tp, agno, next_agino, imap, dipp,
> > -				bpp);
> > -		if (error)
> > -			return error;
> > -
> > -		unlinked_agino = be32_to_cpu((*dipp)->di_next_unlinked);
> > -		/*
> > -		 * Make sure this pointer is valid and isn't an obvious
> > -		 * infinite loop.
> > -		 */
> > -		if (!xfs_verify_agino(mp, agno, unlinked_agino) ||
> > -		    next_agino == unlinked_agino) {
> > -			XFS_CORRUPTION_ERROR(__func__,
> > -					XFS_ERRLEVEL_LOW, mp,
> > -					*dipp, sizeof(**dipp));
> > -			error = -EFSCORRUPTED;
> > -			return error;
> > -		}
> > -		next_agino = unlinked_agino;
> > -	}
> > +	ASSERT(agino != NULLAGINO);
> > +	error = xfs_iunlink_map_ino(tp, agno, agino, imap, dipp, bpp);
> > +	if (error)
> > +		return error;
> >  
> > +	if (be32_to_cpu((*dipp)->di_next_unlinked) != target_agino)
> > +		return -EFSCORRUPTED;
> 
> Why drop the corruption report here?

For simplicity of refactoring. It comes back later on in the series
as this check gets recombined with another similar function. i.e.
See xfs_iunlink_log_inode() at the end of the series....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
