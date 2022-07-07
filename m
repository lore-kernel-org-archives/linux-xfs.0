Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3123FC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jul 2022 12:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbiGGMgk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 08:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235466AbiGGMgj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 08:36:39 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 262872657C
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 05:36:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BA63762CE01;
        Thu,  7 Jul 2022 22:36:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o9QkD-00Fcvc-AG; Thu, 07 Jul 2022 22:36:33 +1000
Date:   Thu, 7 Jul 2022 22:36:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: lockless buffer lookup
Message-ID: <20220707123633.GM227878@dread.disaster.area>
References: <20220627060841.244226-1-david@fromorbit.com>
 <20220627060841.244226-7-david@fromorbit.com>
 <YrzMeZ/mW+yN94Oo@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrzMeZ/mW+yN94Oo@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62c6d354
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=-NNHVb7aK1ZBTxI4bhwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 29, 2022 at 03:04:41PM -0700, Darrick J. Wong wrote:
> On Mon, Jun 27, 2022 at 04:08:41PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that we have a standalone fast path for buffer lookup, we can
> > easily convert it to use rcu lookups. When we continually hammer the
> > buffer cache with trylock lookups, we end up with a huge amount of
> > lock contention on the per-ag buffer hash locks:
> > 
> > -   92.71%     0.05%  [kernel]                  [k] xfs_inodegc_worker
> >    - 92.67% xfs_inodegc_worker
> >       - 92.13% xfs_inode_unlink
> >          - 91.52% xfs_inactive_ifree
> >             - 85.63% xfs_read_agi
> >                - 85.61% xfs_trans_read_buf_map
> >                   - 85.59% xfs_buf_read_map
> >                      - xfs_buf_get_map
> >                         - 85.55% xfs_buf_find
> >                            - 72.87% _raw_spin_lock
> >                               - do_raw_spin_lock
> >                                    71.86% __pv_queued_spin_lock_slowpath
> >                            - 8.74% xfs_buf_rele
> >                               - 7.88% _raw_spin_lock
> >                                  - 7.88% do_raw_spin_lock
> >                                       7.63% __pv_queued_spin_lock_slowpath
> >                            - 1.70% xfs_buf_trylock
> >                               - 1.68% down_trylock
> >                                  - 1.41% _raw_spin_lock_irqsave
> >                                     - 1.39% do_raw_spin_lock
> >                                          __pv_queued_spin_lock_slowpath
> >                            - 0.76% _raw_spin_unlock
> >                                 0.75% do_raw_spin_unlock
> > 
> > This is basically hammering the pag->pag_buf_lock from lots of CPUs
> > doing trylocks at the same time. Most of the buffer trylock
> > operations ultimately fail after we've done the lookup, so we're
> > really hammering the buf hash lock whilst making no progress.
> > 
> > We can also see significant spinlock traffic on the same lock just
> > under normal operation when lots of tasks are accessing metadata
> > from the same AG, so let's avoid all this by converting the lookup
> > fast path to leverages the rhashtable's ability to do rcu protected
> > lookups.
> > 
> > We avoid races with the buffer release path by using
> > atomic_inc_not_zero() on the buffer hold count. Any buffer that is
> > in the LRU will have a non-zero count, thereby allowing the lockless
> > fast path to be taken in most cache hit situations. If the buffer
> > hold count is zero, then it is likely going through the release path
> > so in that case we fall back to the existing lookup miss slow path.
> > 
> > The slow path will then do an atomic lookup and insert under the
> > buffer hash lock and hence serialise correctly against buffer
> > release freeing the buffer.
> > 
> > The use of rcu protected lookups means that buffer handles now need
> > to be freed by RCU callbacks (same as inodes). We still free the
> > buffer pages before the RCU callback - we won't be trying to access
> > them at all on a buffer that has zero references - but we need the
> > buffer handle itself to be present for the entire rcu protected read
> > side to detect a zero hold count correctly.
> 
> Hmm, so what still uses pag_buf_lock?  Are we still using it to
> serialize xfs_buf_rele calls?

slow path lookup/insert and xfs_buf_rele calls.

The only thing we are allowing lockless lookups on are buffers with
at least one reference. With the LRU holding a reference, that means
it the buffer is still actively cached or referenced by something
else so won't disappear from under us. If the ref count is zero,
then it means the buffer is being removed from the cache, so we
need to go the slow way and take the pag_buf_lock to serialise the
lookup against the release of the unreferenced buffer we found in
the cache.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
