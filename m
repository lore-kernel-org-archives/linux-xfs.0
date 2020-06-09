Return-Path: <SRS0=Wnnb=7W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA003C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 22:01:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A79A206D5
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 22:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgFIWBu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 18:01:50 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58381 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726992AbgFIWBs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jun 2020 18:01:48 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8A2BC3A3F09;
        Wed, 10 Jun 2020 08:01:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jimJP-0000m8-9K; Wed, 10 Jun 2020 08:01:39 +1000
Date:   Wed, 10 Jun 2020 08:01:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 28/30] xfs: rework xfs_iflush_cluster() dirty inode
 iteration
Message-ID: <20200609220139.GJ2040@dread.disaster.area>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-29-david@fromorbit.com>
 <20200609131155.GB40899@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609131155.GB40899@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=grvvCSvOF4VobsV8KrcA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 09, 2020 at 09:11:55AM -0400, Brian Foster wrote:
> On Thu, Jun 04, 2020 at 05:46:04PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that we have all the dirty inodes attached to the cluster
> > buffer, we don't actually have to do radix tree lookups to find
> > them. Sure, the radix tree is efficient, but walking a linked list
> > of just the dirty inodes attached to the buffer is much better.
> > 
> > We are also no longer dependent on having a locked inode passed into
> > the function to determine where to start the lookup. This means we
> > can drop it from the function call and treat all inodes the same.
> > 
> > We also make xfs_iflush_cluster skip inodes marked with
> > XFS_IRECLAIM. This we avoid races with inodes that reclaim is
> > actively referencing or are being re-initialised by inode lookup. If
> > they are actually dirty, they'll get written by a future cluster
> > flush....
> > 
> > We also add a shutdown check after obtaining the flush lock so that
> > we catch inodes that are dirty in memory and may have inconsistent
> > state due to the shutdown in progress. We abort these inodes
> > directly and so they remove themselves directly from the buffer list
> > and the AIL rather than having to wait for the buffer to be failed
> > and callbacks run to be processed correctly.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_inode.c      | 148 ++++++++++++++++------------------------
> >  fs/xfs/xfs_inode.h      |   2 +-
> >  fs/xfs/xfs_inode_item.c |   2 +-
> >  3 files changed, 62 insertions(+), 90 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 8566bd0f4334d..931a483d5b316 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -3611,117 +3611,94 @@ xfs_iflush(
> >   */
> >  int
> >  xfs_iflush_cluster(
> > -	struct xfs_inode	*ip,
> >  	struct xfs_buf		*bp)
> >  {
> ...
> > +	/*
> > +	 * We must use the safe variant here as on shutdown xfs_iflush_abort()
> > +	 * can remove itself from the list.
> > +	 */
> > +	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
> > +		iip = (struct xfs_inode_log_item *)lip;
> > +		ip = iip->ili_inode;
> >  
> >  		/*
> > -		 * because this is an RCU protected lookup, we could find a
> > -		 * recently freed or even reallocated inode during the lookup.
> > -		 * We need to check under the i_flags_lock for a valid inode
> > -		 * here. Skip it if it is not valid or the wrong inode.
> > +		 * Quick and dirty check to avoid locks if possible.
> >  		 */
> > -		spin_lock(&cip->i_flags_lock);
> > -		if (!cip->i_ino ||
> > -		    __xfs_iflags_test(cip, XFS_ISTALE)) {
> > -			spin_unlock(&cip->i_flags_lock);
> > +		if (__xfs_iflags_test(ip, XFS_IRECLAIM | XFS_IFLOCK))
> > +			continue;
> > +		if (xfs_ipincount(ip))
> >  			continue;
> > -		}
> >  
> >  		/*
> > -		 * Once we fall off the end of the cluster, no point checking
> > -		 * any more inodes in the list because they will also all be
> > -		 * outside the cluster.
> > +		 * The inode is still attached to the buffer, which means it is
> > +		 * dirty but reclaim might try to grab it. Check carefully for
> > +		 * that, and grab the ilock while still holding the i_flags_lock
> > +		 * to guarantee reclaim will not be able to reclaim this inode
> > +		 * once we drop the i_flags_lock.
> >  		 */
> > -		if ((XFS_INO_TO_AGINO(mp, cip->i_ino) & mask) != first_index) {
> > -			spin_unlock(&cip->i_flags_lock);
> > -			break;
> > +		spin_lock(&ip->i_flags_lock);
> > +		ASSERT(!__xfs_iflags_test(ip, XFS_ISTALE));
> 
> What prevents a race with staling an inode here?

xfs_buf_item_release() does not drop the buffer lock when stale
buffers are committed. Hence the buffer it held locked until it is
committed to the journal, and unpinning the buffer on journal IO
completion runs xfs_iflush_done() -> xfs_iflush_abort() on all the
stale attached inodes. At which point, they are removed from the
buffer and the buffer is unlocked..

Hence we cannot run here with stale inodes attached to the buffer
because the buffer is locked the entire time stale inodes are
attached.

> The push open codes an
> unlocked (i.e. no memory barrier) check before it acquires the buffer
> lock, so afaict it's technically possible to race and grab the buffer
> immediately after the cluster was freed. If that could happen, it looks
> like we'd also queue the buffer for write.

Not that I can tell, because we'll fail to get the buffer lock under
the AIL lock until the stale buffer is unpinned, but the unpin
occurs under the buffer lock and that removes the buffer from the
AIL. Hence there's no way the AIL pushing can actually push an inode
cluster buffer that has stale inodes attached to it...

> That also raises the question.. between this patch and the earlier push
> rework, why do we queue the buffer for write when nothing might have
> been flushed by this call?

Largely because I never observed a failure to flush at least one
inode so I didn't really consider it worth the additional complexity
in error handling in the push code. I've really been concerned about
the other end of the scale where we try to push the same buffer 30+
times for each IO.

You are right in that it could happen - perhaps just returning EAGAIN
if clcount == 0 at the end of the function is all that is necessary
and translating that to XFS_ITEM_LOCKED in the push function would
work.

> > -		 * check is not sufficient.
> > +		 * If we are shut down, unpin and abort the inode now as there
> > +		 * is no point in flushing it to the buffer just to get an IO
> > +		 * completion to abort the buffer and remove it from the AIL.
> >  		 */
> > -		if (!cip->i_ino) {
> > -			xfs_ifunlock(cip);
> > -			xfs_iunlock(cip, XFS_ILOCK_SHARED);
> > +		if (XFS_FORCED_SHUTDOWN(mp)) {
> > +			xfs_iunpin_wait(ip);
> 
> Note that we have an unlocked check above that skips pinned inodes.

Right, but we could be racing with a transaction commit that pinned
the inode and a shutdown. As the comment says: it's a quick and
dirty check to avoid trying to get locks when we know that it is
unlikely we can flush the inode without blocking. We still have to
recheck that state once we have the ILOCK....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
