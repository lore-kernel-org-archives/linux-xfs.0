Return-Path: <SRS0=6H2z=7S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E00C1C433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 21:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C45742065C
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 21:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgFEVcS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 17:32:18 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33004 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728189AbgFEVcS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jun 2020 17:32:18 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 16DBD3A3E09;
        Sat,  6 Jun 2020 07:32:15 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jhJwg-0000mr-Dz; Sat, 06 Jun 2020 07:32:10 +1000
Date:   Sat, 6 Jun 2020 07:32:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/30] xfs: rework stale inodes in xfs_ifree_cluster
Message-ID: <20200605213210.GE2040@dread.disaster.area>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-25-david@fromorbit.com>
 <20200605182722.GH23747@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605182722.GH23747@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=w4og3I-1AE9Kmp6XOFsA:9 a=dSdfdfH4zrP7Fqlg:21
        a=tQRF3Na-3rpy2DYP:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 05, 2020 at 02:27:22PM -0400, Brian Foster wrote:
> On Thu, Jun 04, 2020 at 05:46:00PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Once we have inodes pinning the cluster buffer and attached whenever
> > they are dirty, we no longer have a guarantee that the items are
> > flush locked when we lock the cluster buffer. Hence we cannot just
> > walk the buffer log item list and modify the attached inodes.
> > 
> > If the inode is not flush locked, we have to ILOCK it first and then
> > flush lock it to do all the prerequisite checks needed to avoid
> > races with other code. This is already handled by
> > xfs_ifree_get_one_inode(), so rework the inode iteration loop and
> > function to update all inodes in cache whether they are attached to
> > the buffer or not.
> > 
> > Note: we also remove the copying of the log item lsn to the
> > ili_flush_lsn as xfs_iflush_done() now uses the XFS_ISTALE flag to
> > trigger aborts and so flush lsn matching is not needed in IO
> > completion for processing freed inodes.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_inode.c | 158 ++++++++++++++++++---------------------------
> >  1 file changed, 62 insertions(+), 96 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 272b54cf97000..fb4c614c64fda 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> ...
> > @@ -2559,43 +2563,53 @@ xfs_ifree_get_one_inode(
> >  	 */
> >  	if (ip != free_ip) {
> >  		if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
> > +			spin_unlock(&ip->i_flags_lock);
> >  			rcu_read_unlock();
> >  			delay(1);
> >  			goto retry;
> >  		}
> > -
> > -		/*
> > -		 * Check the inode number again in case we're racing with
> > -		 * freeing in xfs_reclaim_inode().  See the comments in that
> > -		 * function for more information as to why the initial check is
> > -		 * not sufficient.
> > -		 */
> > -		if (ip->i_ino != inum) {
> > -			xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > -			goto out_rcu_unlock;
> > -		}
> 
> Why is the recheck under ILOCK_EXCL no longer necessary? It looks like
> reclaim decides whether to proceed or not under the ilock and doesn't
> acquire the spinlock until it decides to reclaim. Hm?

Because we now take the ILOCK while still holding the i_flags_lock
instead of dropping the spin lock then trying to get the ILOCK.
Hence with this change, if we get the ILOCK we are guaranteed that
the inode number has not changed and don't need to recheck it.

This is guaranteed by xfs_reclaim_inode() because it locks in
the order of ILOCK -> i_flags_lock and it zeroes the ip->i_ino
while holding both these locks. Hence if we've got the i_flags_lock
and we try to get the ILOCK, the inode is either going to be valid and
reclaim will skip the inode (because we hold locks) or the inode
will already be in reclaim and the ip->i_ino will be zero....


> >  	}
> > +	ip->i_flags |= XFS_ISTALE;
> > +	spin_unlock(&ip->i_flags_lock);
> >  	rcu_read_unlock();
> >  
> > -	xfs_iflock(ip);
> > -	xfs_iflags_set(ip, XFS_ISTALE);
> > +	/*
> > +	 * If we can't get the flush lock, the inode is already attached.  All
> > +	 * we needed to do here is mark the inode stale so buffer IO completion
> > +	 * will remove it from the AIL.
> > +	 */
> 
> To make sure I'm following this correctly, we can assume the inode is
> attached based on an iflock_nowait() failure because we hold the ilock,
> right?

Actually, because we hold the buffer lock. We only flush the inode
to the buffer when we are holding the buffer lock, so all flush
locking shold nest inside the buffer lock. So for taking the flock,
the lock order is bp->b_sema -> ILOCK_EXCL -> iflock. We drop the
flush lock before we drop the buffer lock in IO completion, and
hence if we hold the buffer lock, nothing else can actually unlock
the inode flush lock.

> IOW, any other task doing a similar iflock check would have to do
> so under ilock and release the flush lock first if the inode didn't end
> up flushed, for whatever reason.

Yes, anything taking the flush lock needs to first hold the ILOCK -
that's always been the case and we've always done that because the
ILOCK is needed to provides serialisation against a) other
modifications while we are accessing/flushing the inode, and b)
inode reclaim.

/me checks.

After this patchset nothing calls xfs_iflock() at all - everything
uses xfs_iflock_nowait(), so it might be time to turn this back into
a plain status flag and get rid of the iflock stuff altogether as
it's just a state flag now...

> > +	ASSERT(iip->ili_fields);
> > +	spin_lock(&iip->ili_lock);
> > +	iip->ili_last_fields = iip->ili_fields;
> > +	iip->ili_fields = 0;
> > +	iip->ili_fsync_fields = 0;
> > +	spin_unlock(&iip->ili_lock);
> > +	list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
> > +	ASSERT(iip->ili_last_fields);
> 
> We already asserted ->ili_fields and assigned ->ili_fields to
> ->ili_last_fields, so this assert seems spurious.

Ah, the first ASSERT goes away in the next patch, I think. It was
debug, and I may have removed it from the wrong patch...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
