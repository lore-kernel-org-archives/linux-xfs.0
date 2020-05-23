Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E107C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 22:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14A3D207CB
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 22:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388094AbgEWW7u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 18:59:50 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:39646 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728671AbgEWW7u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 18:59:50 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id DEF0E1A8252;
        Sun, 24 May 2020 08:59:46 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jcd7I-00011a-13; Sun, 24 May 2020 08:59:44 +1000
Date:   Sun, 24 May 2020 08:59:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/24] xfs: attach inodes to the cluster buffer when
 dirtied
Message-ID: <20200523225943.GL2040@dread.disaster.area>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-20-david@fromorbit.com>
 <20200522234859.GW8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522234859.GW8230@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=bM5bvfDB1HIDGlHheZAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 04:48:59PM -0700, Darrick J. Wong wrote:
> On Fri, May 22, 2020 at 01:50:24PM +1000, Dave Chinner wrote:
> > @@ -2649,53 +2650,12 @@ xfs_ifree_cluster(
> >  		bp->b_ops = &xfs_inode_buf_ops;
> >  
> >  		/*
> > -		 * Walk the inodes already attached to the buffer and mark them
> > -		 * stale. These will all have the flush locks held, so an
> > -		 * in-memory inode walk can't lock them. By marking them all
> > -		 * stale first, we will not attempt to lock them in the loop
> > -		 * below as the XFS_ISTALE flag will be set.
> > -		 */
> > -		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
> > -			if (lip->li_type == XFS_LI_INODE) {
> > -				iip = (struct xfs_inode_log_item *)lip;
> > -				xfs_trans_ail_copy_lsn(mp->m_ail,
> > -							&iip->ili_flush_lsn,
> > -							&iip->ili_item.li_lsn);
> > -				xfs_iflags_set(iip->ili_inode, XFS_ISTALE);
> > -			}
> > -		}
> 
> Hm.  I think I'm a little confused here.  I think the consequence of
> attaching inode items to the buffer whenever we dirty the inode is that
> we no longer need to travel the inode list to set ISTALE because we know
> that the lookup loop below is sufficient to catch all of the inodes that
> are still hanging around in memory?

Yes. The issue here is that we now have inodes on this list that are
not flush locked, and so we can't just walk it assuming we can
change the flush state without holding the ILOCK to first ensure
the inode is not racing with reclaim, etc.

> We don't call xfs_ifree_cluster if any of the inodes in it are
> allocated, which means that all the on-disk inodes are either (a) not
> represented in memory, in which case we don't have to stale them; or (b)
> they're in memory and dirty (because they've recently been freed).  But
> if that's true, then surely you could find them all via b_li_list?

No, we can have inodes that are free but clean in memory when we
free the cluster. do an unlink of an inode, commit, push the AIL, it
gets written back and is now clean in memory with mode == 0 and
state XFS_IRECLAIMABLE. That inode is not reclaimed until memory
reclaim or the background reclaimer finds it and reclaims it. Those
are the inodes we want to mark XFS_ISTALE so they get treated by
lookup correctly if the cluster is reallocated and the inode
reinstantiated before it is reclaimed from memory.

> On the other hand, it seems redundant to iterate the list /and/ do the
> lookups and we no longer need to "set it up for being staled", so the
> second loop survives?

Yeah, the second loop is used because we have to look up the cache
anyway, and there's no point in iterating the buffer list because
it now has to do all the same "is it clean" checks and flush
locking, etc that the cache lookup has to do. A future patchset can
make the cache lookup use a gang lookup on the radix tree to
optimise it if necessary...

> > -
> > -
> > -		/*
> > -		 * For each inode in memory attempt to add it to the inode
> > -		 * buffer and set it up for being staled on buffer IO
> > -		 * completion.  This is safe as we've locked out tail pushing
> > -		 * and flushing by locking the buffer.
> > -		 *
> > -		 * We have already marked every inode that was part of a
> > -		 * transaction stale above, which means there is no point in
> > -		 * even trying to lock them.
> > +		 * Now we need to set all the cached clean inodes as XFS_ISTALE,
> > +		 * too. This requires lookups, and will skip inodes that we've
> > +		 * already marked XFS_ISTALE.
> >  		 */
> > -		for (i = 0; i < igeo->inodes_per_cluster; i++) {
> > -			ip = xfs_ifree_get_one_inode(pag, free_ip, inum + i);
> > -			if (!ip)
> > -				continue;
> > -
> > -			iip = ip->i_itemp;
> > -			spin_lock(&iip->ili_lock);
> > -			iip->ili_last_fields = iip->ili_fields;
> > -			iip->ili_fields = 0;
> > -			iip->ili_fsync_fields = 0;
> > -			spin_unlock(&iip->ili_lock);
> > -			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
> > -						&iip->ili_item.li_lsn);
> > -
> > -			list_add_tail(&iip->ili_item.li_bio_list,
> > -						&bp->b_li_list);
> > -
> > -			if (ip != free_ip)
> > -				xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > -		}
> > +		for (i = 0; i < igeo->inodes_per_cluster; i++)
> > +			xfs_ifree_mark_inode_stale(pag, free_ip, inum + i);
> 
> I get that we're mostly just hoisting everything in the loop body to the
> end of xfs_ifree_get_one_inode, but can that be part of a separate hoist
> patch?

Ok. Not really happy about breaking it up to even more fine grained
patches as this patchset is already a nightmare to keep up to date
against all the random cleanups going into for-next.....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
