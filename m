Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208C1C433C1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 04:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB1A561929
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 04:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbhC3EGc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 00:06:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhC3EG3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 00:06:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB1FA61929;
        Tue, 30 Mar 2021 04:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617077188;
        bh=LtAidxOp8/ruVLDtsFHpwtQbFdW+ZCPn6C+XSibVUIw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uq7K71f3KkbU4rSfxFFYyt87H+EifFzRRUOwWI0X0cHyY2LeFi51HolNovnG2uUMt
         M3wqsjykON5LiCL63LQCGnRojWVJ6Fe3eGT/MmN9l54kTEyb2AIDh4d7JmJz7Hpi5p
         w31xN6EqQg4+sW2y2js3xQ/jEAUdiVuKCQAkrT9jOfDQ5SOumUGRYjkiky5Gg3A1z3
         AgyZRAMkdz8+9Er8X3d9Jt0nUQMQZo2JbRqtj9fUo9DdnvXyZNxsXUWBvvYnzAR9FE
         HoysADhfWS6DZccKTKgi2qyJfGM12vlKBGqRwXgmZNnCVb4WA1n8aSzoZ3/SW4dy5z
         TuDiqSEDjIm7g==
Date:   Mon, 29 Mar 2021 21:06:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 1/6] xfs: use s_inodes in xfs_qm_dqrele_all_inodes
Message-ID: <20210330040625.GL4090233@magnolia>
References: <161671807287.621936.13471099564526590235.stgit@magnolia>
 <161671807853.621936.16639622639548774275.stgit@magnolia>
 <20210330004407.GS63242@dread.disaster.area>
 <20210330023656.GK4090233@magnolia>
 <20210330030747.GT63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330030747.GT63242@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 02:07:47PM +1100, Dave Chinner wrote:
> On Mon, Mar 29, 2021 at 07:36:56PM -0700, Darrick J. Wong wrote:
> > On Tue, Mar 30, 2021 at 11:44:07AM +1100, Dave Chinner wrote:
> > > On Thu, Mar 25, 2021 at 05:21:18PM -0700, Darrick J. Wong wrote:
> > > > From: Christoph Hellwig <hch@lst.de>
> > > > 
> > > > Using xfs_inode_walk in xfs_qm_dqrele_all_inodes is complete overkill,
> > > > given that function simplify wants to iterate all live inodes known
> > > > to the VFS.  Just iterate over the s_inodes list.
> > > 
> > > I'm not sure that assertion is true. We attach dquots during inode
> > > inactivation after the VFS has removed the inode from the s_inodes
> > > list and evicted the inode. Hence there is a window between the
> > > inode being removed from the sb->s_inodes lists and it being marked
> > > XFS_IRECLAIMABLE where we can attach dquots to the inode.
> > > 
> > > Indeed, an inode marked XFS_IRECLAIMABLE that has gone through
> > > evict -> destroy -> inactive -> nlink != 0 -> xfs_free_ eofblocks()
> > > can have referenced dquots attached to it and require dqrele() to be
> > > called to release them.
> > 
> > Why do the dquots need to remain attached after destroy_inode?
> 
> They don't. But that's not the problem here.

Actually, they do need to remain attached nowadays, because COW blocks
are accounted as incore dquot reservations so we can't let the dquots
drop until the COW fork gets cleaned out.

Granted I guess I did have a patch that changed the dquot lifecycle so
that they would stay in memory after the refcount dropped to zero, even
if they had incore reservations.

...and now I finally see the plot twist that turns this into the
*Fourth* part of Yet Another Quota Restructuring.  This time I get to
reimplement quotaoff! :P

> > We can
> > easily reattach them during inactivation (v3 did this), and I don't know
> > why an inode needs dquots once we're through making metadata updates.
> 
> Yes, they get re-attached for truncation, attr removal, EOF block
> freeing, etc. Only on the unlinked inode path in inactivation do
> they get removed once all the work tha tmodifies the dquots is done.
> 
> But many of the paths don't detach them again because they are
> multi-use.  e.g xfs_free_eofblocks() will attach dquots, but doesn't
> detatch them because it's called from more placed than than the
> inactivation path.
> 
> I'm sure this can all be cleaned up, but I *really* don't like the
> idea of a "walk all XFS inodes" scan that actually only walks the
> inodes with VFS references and not -all XFS inodes-.
> 
> And there's other problems with doing sb->s_inodes list walks -
> namely the global lock. While we are doing this walk (might be tens
> of millions of inodes!) we can hold the s_inode_list_lock for a long
> time and we cannot instantiate new inodes or evict inodes to/from
> the cache while that lock is held. The XFS inode walk is lockless
> and we don't hold off anything to do wiht cache instantiation and
> freeing, so it has less impact on the running system.
> 
> If everything is clean and don't block on locks anywhere, the
> s_inodes list walk needs a cond_resched() in it. Again, tens
> (hundreds) of millions of inodes can be on that list mean it can
> hold the CPU for a long time.

Yeah, I had wondered how good an idea it was to replace batch lookups
with a list walk...

> Next, igrab() takes a reference to the inode which will mark them
> referenced. THis walk grabs every inode in the filesysetm cache,
> so marks them all referenced and makes it harder to reclaim them
> under memory pressure. This perturbs working set behaviour.
> 
> inode list walks and igrab/iput don't come for free - they perturb
> the working set, LRU orders, cause lock contention, long tail
> latencies, etc. The XFS inode cache walk might not be the prettiest
> thing, but it doesn't have any of these nasty side effects.
> 
> So, in general, I don't think we should be adding new inode list
> walks anywhere, not even deep in XFS where nobody else might care...

...but the current quotaoff behavior has /all/ of these problems too.

I think you and I hashed out on IRC that quotaoff could simply take the
ILOCK and the i_flags lock of every inode that isn't INEW, RECLAIMING,
or INACTIVATING; drop the dquots, and drop the locks, and then dqpurge
would only have to wait for the inodes that are actively being reclaimed
or inactivated.

I'll give that a try ... eventually, but I wouldn't be too confident
that I'll get all this turned around before I have to shut the door next
next Thursday.

> > > Hence I think that xfs_qm_dqrele_all_inodes() is broken if all it is
> > > doing is walking vfs referenced inodes, because it doesn't actually
> > > release the dquots attached to reclaimable inodes. If this did
> > > actually release all dquots, then there wouldn't be a need for the
> > > xfs_qm_dqdetach() call in xfs_reclaim_inode() just before it's
> > > handed to RCU to be freed....
> > 
> > Why does it work now, then?  The current code /also/ leaves the dquots
> > attached to reclaimable inodes, and the quotaoff scan ignores
> > IRECLAIMABLE inodes.
> 
> Luck, I think.
> 
> > Has it simply been the case that the dqpurge spins
> > until reclaim runs, and reclaim gets run quickly enough (or quotaoff runs
> > infrequently enough) that nobody's complained?
> 
> Yup, that's my assumption - quotaoff is rare, inode reclaim runs
> every 5s - and so we haven't noticed it because nobody has looked
> closely at how dquots vs inode reclaim works recently...

Yes, that does explain some of the weird test duration quirks I see in
xfs/305....

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
