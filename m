Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4572C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 03:08:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71985600EF
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 03:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhC3DIZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:08:25 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:57339 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231224AbhC3DHw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 23:07:52 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id B1B8A1AEA32;
        Tue, 30 Mar 2021 14:07:48 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lR4jL-008Kgc-6i; Tue, 30 Mar 2021 14:07:47 +1100
Date:   Tue, 30 Mar 2021 14:07:47 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 1/6] xfs: use s_inodes in xfs_qm_dqrele_all_inodes
Message-ID: <20210330030747.GT63242@dread.disaster.area>
References: <161671807287.621936.13471099564526590235.stgit@magnolia>
 <161671807853.621936.16639622639548774275.stgit@magnolia>
 <20210330004407.GS63242@dread.disaster.area>
 <20210330023656.GK4090233@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330023656.GK4090233@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=ono8tqymbedS6lgMxLIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 29, 2021 at 07:36:56PM -0700, Darrick J. Wong wrote:
> On Tue, Mar 30, 2021 at 11:44:07AM +1100, Dave Chinner wrote:
> > On Thu, Mar 25, 2021 at 05:21:18PM -0700, Darrick J. Wong wrote:
> > > From: Christoph Hellwig <hch@lst.de>
> > > 
> > > Using xfs_inode_walk in xfs_qm_dqrele_all_inodes is complete overkill,
> > > given that function simplify wants to iterate all live inodes known
> > > to the VFS.  Just iterate over the s_inodes list.
> > 
> > I'm not sure that assertion is true. We attach dquots during inode
> > inactivation after the VFS has removed the inode from the s_inodes
> > list and evicted the inode. Hence there is a window between the
> > inode being removed from the sb->s_inodes lists and it being marked
> > XFS_IRECLAIMABLE where we can attach dquots to the inode.
> > 
> > Indeed, an inode marked XFS_IRECLAIMABLE that has gone through
> > evict -> destroy -> inactive -> nlink != 0 -> xfs_free_ eofblocks()
> > can have referenced dquots attached to it and require dqrele() to be
> > called to release them.
> 
> Why do the dquots need to remain attached after destroy_inode?

They don't. But that's not the problem here.

> We can
> easily reattach them during inactivation (v3 did this), and I don't know
> why an inode needs dquots once we're through making metadata updates.

Yes, they get re-attached for truncation, attr removal, EOF block
freeing, etc. Only on the unlinked inode path in inactivation do
they get removed once all the work tha tmodifies the dquots is done.

But many of the paths don't detach them again because they are
multi-use.  e.g xfs_free_eofblocks() will attach dquots, but doesn't
detatch them because it's called from more placed than than the
inactivation path.

I'm sure this can all be cleaned up, but I *really* don't like the
idea of a "walk all XFS inodes" scan that actually only walks the
inodes with VFS references and not -all XFS inodes-.

And there's other problems with doing sb->s_inodes list walks -
namely the global lock. While we are doing this walk (might be tens
of millions of inodes!) we can hold the s_inode_list_lock for a long
time and we cannot instantiate new inodes or evict inodes to/from
the cache while that lock is held. The XFS inode walk is lockless
and we don't hold off anything to do wiht cache instantiation and
freeing, so it has less impact on the running system.

If everything is clean and don't block on locks anywhere, the
s_inodes list walk needs a cond_resched() in it. Again, tens
(hundreds) of millions of inodes can be on that list mean it can
hold the CPU for a long time.

Next, igrab() takes a reference to the inode which will mark them
referenced. THis walk grabs every inode in the filesysetm cache,
so marks them all referenced and makes it harder to reclaim them
under memory pressure. This perturbs working set behaviour.

inode list walks and igrab/iput don't come for free - they perturb
the working set, LRU orders, cause lock contention, long tail
latencies, etc. The XFS inode cache walk might not be the prettiest
thing, but it doesn't have any of these nasty side effects.

So, in general, I don't think we should be adding new inode list
walks anywhere, not even deep in XFS where nobody else might care...

> > Hence I think that xfs_qm_dqrele_all_inodes() is broken if all it is
> > doing is walking vfs referenced inodes, because it doesn't actually
> > release the dquots attached to reclaimable inodes. If this did
> > actually release all dquots, then there wouldn't be a need for the
> > xfs_qm_dqdetach() call in xfs_reclaim_inode() just before it's
> > handed to RCU to be freed....
> 
> Why does it work now, then?  The current code /also/ leaves the dquots
> attached to reclaimable inodes, and the quotaoff scan ignores
> IRECLAIMABLE inodes.

Luck, I think.

> Has it simply been the case that the dqpurge spins
> until reclaim runs, and reclaim gets run quickly enough (or quotaoff runs
> infrequently enough) that nobody's complained?

Yup, that's my assumption - quotaoff is rare, inode reclaim runs
every 5s - and so we haven't noticed it because nobody has looked
closely at how dquots vs inode reclaim works recently...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
