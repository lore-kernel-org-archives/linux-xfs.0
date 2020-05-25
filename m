Return-Path: <SRS0=1/fZ=7H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77E6FC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 25 May 2020 03:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59A31207DA
	for <linux-xfs@archiver.kernel.org>; Mon, 25 May 2020 03:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbgEYDts (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 May 2020 23:49:48 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:57824 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728324AbgEYDts (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 23:49:48 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id D5D20D797FA;
        Mon, 25 May 2020 13:49:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jd47U-0002Vc-05; Mon, 25 May 2020 13:49:44 +1000
Date:   Mon, 25 May 2020 13:49:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/24] xfs: remove IO submission from xfs_reclaim_inode()
Message-ID: <20200525034943.GW2040@dread.disaster.area>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-15-david@fromorbit.com>
 <20200522230642.GR8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522230642.GR8230@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=TaHxQE5r6flcalJ-jzQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 04:06:42PM -0700, Darrick J. Wong wrote:
> On Fri, May 22, 2020 at 01:50:19PM +1000, Dave Chinner wrote:
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
> > ---
> >  fs/xfs/xfs_icache.c | 116 +++++++++++---------------------------------
> >  1 file changed, 29 insertions(+), 87 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index 0f0f8fcd61b03..ee9bc82a0dfbe 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -1130,24 +1130,17 @@ xfs_reclaim_inode_grab(
> >   *	dirty, async	=> requeue
> >   *	dirty, sync	=> flush, wait and reclaim
> >   */
> 
> The function comment probably ought to describe what the two return
> values mean.  true when the inode was freed and false if we need to try
> again, right?

The comments are all updated in a later patch. It seemed better to
do that than to have to rewrite the repeatedly as behaviour changes
in each patch.

> > @@ -1272,20 +1219,17 @@ xfs_reclaim_inode(
> >   * then a shut down during filesystem unmount reclaim walk leak all the
> >   * unreclaimed inodes.
> >   */
> > -STATIC int
> > +static int
> 
> The function comment /really/ needs to note that the return value
> here is number of inodes that were skipped, and not just some negative
> error code.

OK, done.

> > @@ -1398,8 +1329,18 @@ xfs_reclaim_inodes(
> >  	int		mode)
> >  {
> >  	int		nr_to_scan = INT_MAX;
> > +	int		skipped;
> >  
> > -	return xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
> > +	skipped = xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
> > +	if (!(mode & SYNC_WAIT))
> > +		return 0;
> > +
> > +	do {
> > +		xfs_ail_push_all_sync(mp->m_ail);
> > +		skipped = xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
> > +	} while (skipped > 0);
> > +
> > +	return 0;
> 
> Might as well kill the return value here since none of the callers care.

I think I did that in the SYNC_WAIT futzing patches that were
causing me problems and I dropped. It was in a separate patch,
anyway.

> >  }
> >  
> >  /*
> > @@ -1420,7 +1361,8 @@ xfs_reclaim_inodes_nr(
> >  	xfs_reclaim_work_queue(mp);
> >  	xfs_ail_push_all(mp->m_ail);
> >  
> > -	return xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);
> 
> So the old code was returning negative error codes here?  Given that the
> only caller is free_cached_objects which adds it to the 'freed' count...
> wow.

Actually, no. the error from xfs_reclaim_inodes_ag() can only come
from xfs_reclaim_inode(), which always returned 0.

> > +	xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);
> > +	return 0;
> 
> Why do we return zero freed items here?  The VFS asked us to clear
> shrink_control->nr_to_scan (passed in here as nr_to_scan) and we're
> supposed to report what we did, right?

It's the same behaviour as we currently have.

ISTR that I did the accounting this way originally so we didn't
double count inodes being freed. The inode has already been
accounted as freed by the VFS inode shrinker when it runs
->destroy_inode, so double counting every inode that is freed (once
for the VFS cache removal, once for the XFS cache removal) seemed
like a bad thing to be doing...

> Or is there some odd subtlety here where we hate the shrinker and that's
> why we return zero?

Oh, that too :P

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
