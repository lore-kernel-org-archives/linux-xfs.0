Return-Path: <SRS0=uikP=7R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1781C433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 22:53:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9264B2074B
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 22:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgFDWxx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 18:53:53 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:57538 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726221AbgFDWxx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jun 2020 18:53:53 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id DD3491A87EB;
        Fri,  5 Jun 2020 08:53:49 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jgyk2-00013v-Uj; Fri, 05 Jun 2020 08:53:42 +1000
Date:   Fri, 5 Jun 2020 08:53:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/30] xfs: remove IO submission from xfs_reclaim_inode()
Message-ID: <20200604225342.GT2040@dread.disaster.area>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-19-david@fromorbit.com>
 <20200604180814.GG17815@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604180814.GG17815@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=ghcLlnSk2UpMdDNeCa0A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 04, 2020 at 02:08:14PM -0400, Brian Foster wrote:
> On Thu, Jun 04, 2020 at 05:45:54PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We no longer need to issue IO from shrinker based inode reclaim to
> > prevent spurious OOM killer invocation. This leaves only the global
> > filesystem management operations such as unmount needing to
> > writeback dirty inodes and reclaim them.
> > 
> > Instead of using the reclaim pass to write dirty inodes before
> > reclaiming them, use the AIL to push all the dirty inodes before we
> > try to reclaim them. This allows us to remove all the conditional
> > SYNC_WAIT locking and the writeback code from xfs_reclaim_inode()
> > and greatly simplify the checks we need to do to reclaim an inode.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_icache.c | 117 ++++++++++++--------------------------------
> >  1 file changed, 31 insertions(+), 86 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index a6780942034fc..74032316ce5cc 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> ...
> > @@ -1341,9 +1288,8 @@ xfs_reclaim_inodes_ag(
> >  			for (i = 0; i < nr_found; i++) {
> >  				if (!batch[i])
> >  					continue;
> > -				error = xfs_reclaim_inode(batch[i], pag, flags);
> > -				if (error && last_error != -EFSCORRUPTED)
> > -					last_error = error;
> > +				if (!xfs_reclaim_inode(batch[i], pag, flags))
> > +					skipped++;
> 
> Just a note that I find it a little bit of a landmine that skipped is
> bumped on trylock failure of the perag reclaim lock when the
> xfs_reclaim_inodes() caller can now spin on that.

Intentional, because without bumping skipped on perag reclaim lock
failure we can silently skip entire AGs when doing blocking reclaim
and xfs_reclaim_inodes() fails to reclaim all inodes in the cache.

It's only necessary to work around fatal bugs this patch exposes
for the brief period that this infrastructure is being torn down by
this patchset....

> It doesn't appear to
> be an issue with current users, though (xfs_reclaim_workers() passes
> SYNC_TRYLOCK but not SYNC_WAIT).

xfs_reclaim_workers() is optimisitic, background reclaim, so we
just don't care if it skips over things. We just don't want it to
block.

> >  			}
> >  
> >  			*nr_to_scan -= XFS_LOOKUP_BATCH;
> ...
> > @@ -1380,8 +1314,18 @@ xfs_reclaim_inodes(
> >  	int		mode)
> >  {
> >  	int		nr_to_scan = INT_MAX;
> > +	int		skipped;
> >  
> > -	return xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
> > +	xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
> > +	if (!(mode & SYNC_WAIT))
> > +		return 0;
> > +
> 
> Any reason we fall into the loop below if SYNC_WAIT was passed but the
> above xfs_reclaim_inodes_ag() call would have returned 0?

Same thing again. It's temporary to maintain correctness while one
thing at time is removed from the reclaim code. This code goes away
in the same patch that makes SYNC_WAIT go away.

> Looks reasonable other than that inefficiency:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
