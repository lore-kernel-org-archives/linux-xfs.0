Return-Path: <SRS0=8d1d=7V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D8ADC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 21:37:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FD272068D
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 21:37:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgFHVhz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 17:37:55 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:40763 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726723AbgFHVhz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jun 2020 17:37:55 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id AEB49D59F4A;
        Tue,  9 Jun 2020 07:37:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jiPSo-0000Yx-Ok; Tue, 09 Jun 2020 07:37:50 +1000
Date:   Tue, 9 Jun 2020 07:37:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/30] xfs: xfs_iflush() is no longer necessary
Message-ID: <20200608213750.GH2040@dread.disaster.area>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-27-david@fromorbit.com>
 <20200608164551.GD36278@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608164551.GD36278@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=l_4DmKW4r_5qnYS-eCAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 08, 2020 at 12:45:51PM -0400, Brian Foster wrote:
> On Thu, Jun 04, 2020 at 05:46:02PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now we have a cached buffer on inode log items, we don't need
> > to do buffer lookups when flushing inodes anymore - all we need
> > to do is lock the buffer and we are ready to go.
> > 
> > This largely gets rid of the need for xfs_iflush(), which is
> > essentially just a mechanism to look up the buffer and flush the
> > inode to it. Instead, we can just call xfs_iflush_cluster() with a
> > few modifications to ensure it also flushes the inode we already
> > hold locked.
> > 
> > This allows the AIL inode item pushing to be almost entirely
> > non-blocking in XFS - we won't block unless memory allocation
> > for the cluster inode lookup blocks or the block device queues are
> > full.
> > 
> > Writeback during inode reclaim becomes a little more complex because
> > we now have to lock the buffer ourselves, but otherwise this change
> > is largely a functional no-op that removes a whole lot of code.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> Looks mostly reasonable..
> 
> >  fs/xfs/xfs_inode.c      | 106 ++++++----------------------------------
> >  fs/xfs/xfs_inode.h      |   2 +-
> >  fs/xfs/xfs_inode_item.c |  54 +++++++++-----------
> >  3 files changed, 37 insertions(+), 125 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index af65acd24ec4e..61c872e4ee157 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> ...
> > @@ -3688,6 +3609,7 @@ xfs_iflush_int(
> >  	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
> >  	       ip->i_df.if_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
> >  	ASSERT(iip != NULL && iip->ili_fields != 0);
> > +	ASSERT(iip->ili_item.li_buf == bp);
> 
> FWIW, the previous assert includes an iip NULL check.

If iip is NULL in this function, we are going to oops anyway. We've
slowly been weeding these types of "<x> must not be null" asserts
out of the code because it doesn't add any value. Especially as the
assert doesn't tell you exactly what failed and that's kinda
important here.

FWIW, this assert is largely redundant, anyway, because it's just an
open coded xfs_inode_clean() check, and we check that in all cases
before calling xfs_iflush_int(). So I'd be tempted to remove it
if it really mattered...

> 
> >  
> >  	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);
> >  
> ...
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index 697248b7eb2be..326547e89cb6b 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
> > @@ -485,53 +485,42 @@ xfs_inode_item_push(
> >  	uint			rval = XFS_ITEM_SUCCESS;
> >  	int			error;
> >  
> > -	if (xfs_ipincount(ip) > 0)
> > +	ASSERT(iip->ili_item.li_buf);
> > +
> > +	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp) ||
> > +	    (ip->i_flags & XFS_ISTALE))
> >  		return XFS_ITEM_PINNED;
> >  
> > -	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
> > -		return XFS_ITEM_LOCKED;
> > +	/* If the inode is already flush locked, we're already flushing. */
> 
> Or we're racing with reclaim (since we don't have the ilock here any
> longer)?

Possible, but unlikely. The 99.999% case here is the inode was flush
locked by a push of another item on the same cluster buffer, and
that happens so often it's worth adding a racy check ahead of the
flushing to avoid trying to lock the cluster buffer...

> >  
> > -	/*
> > -	 * Re-check the pincount now that we stabilized the value by
> > -	 * taking the ilock.
> > -	 */
> > -	if (xfs_ipincount(ip) > 0) {
> > -		rval = XFS_ITEM_PINNED;
> > -		goto out_unlock;
> > -	}
> > +	if (!xfs_buf_trylock(bp))
> > +		return XFS_ITEM_LOCKED;
> >  
> > -	/*
> > -	 * Stale inode items should force out the iclog.
> > -	 */
> > -	if (ip->i_flags & XFS_ISTALE) {
> > -		rval = XFS_ITEM_PINNED;
> > -		goto out_unlock;
> > +	if (bp->b_flags & _XBF_DELWRI_Q) {
> > +		xfs_buf_unlock(bp);
> > +		return XFS_ITEM_FLUSHING;
> 
> Hmm, what's the purpose of this check? I would expect that we'd still be
> able to flush to a buffer even though it's delwri queued. We drop the
> buffer lock after queueing it (and then it's reacquired on delwri
> submit).

Yes, we can. I did this when tracking down whacky inode flushing
issues and AIL deadlocks this patch exposed to simplify the
behaviour, and I'd completely forgotten about it once I'd found the
underlying problem a week and a half later. It seems harmless at
this point, I'll see what happens if I remove it...

> > -out_unlock:
> > -	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> >  	return rval;
> >  }
> >  
> > @@ -548,6 +537,7 @@ xfs_inode_item_release(
> >  
> >  	ASSERT(ip->i_itemp != NULL);
> >  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> > +	ASSERT(lip->li_buf || !test_bit(XFS_LI_DIRTY, &lip->li_flags));
> 
> This is the transaction cancel/abort path, so seems like this should be
> part of the patch that attaches the ili on logging the inode?

Again, likely left over from debugging some whacky inode
flushing/writeback/completion issue this patch exposed. I'll remove
it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
