Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25427 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751421AbdJES0x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2017 14:26:53 -0400
Date: Thu, 5 Oct 2017 11:26:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/25] xfs: scrub inode btrees
Message-ID: <20171005182649.GG7122@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706333138.19351.1481631767118687082.stgit@magnolia>
 <20171005020810.GJ3666@dastard>
 <20171005054714.GF7122@magnolia>
 <20171005072245.GO3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171005072245.GO3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 05, 2017 at 06:22:45PM +1100, Dave Chinner wrote:
> On Wed, Oct 04, 2017 at 10:47:14PM -0700, Darrick J. Wong wrote:
> > On Thu, Oct 05, 2017 at 01:08:10PM +1100, Dave Chinner wrote:
> > > On Tue, Oct 03, 2017 at 01:42:11PM -0700, Darrick J. Wong wrote:
> > > > +/* Count the number of free inodes. */
> > > > +static unsigned int
> > > > +xfs_scrub_iallocbt_freecount(
> > > > +	xfs_inofree_t			freemask)
> > > > +{
> > > > +	int				bits = XFS_INODES_PER_CHUNK;
> > > > +	unsigned int			ret = 0;
> > > > +
> > > > +	while (bits--) {
> > > > +		if (freemask & 1)
> > > > +			ret++;
> > > > +		freemask >>= 1;
> > > > +	}
> > > 
> > > 
> > > Seems a little cumbersome. Perhaps a loop using xfs_next_bit()
> > > might be a bit faster, something like:
> > > 
> > > 	nextbit = xfs_next_bit(&freemask, 1, 0); 
> > > 	while (nextbit != -1) {
> > > 		ret++;
> > > 		nextbit = xfs_next_bit(&freemask, 1, nextbit + 1);
> > > 	}
> > 
> > <nod>  A pity there's no popcnt()...
> 
> Oh, hweight64().
> 
> > > > +	error = xfs_icache_inode_is_allocated(mp, bs->cur->bc_tp,
> > > > +			fsino + clusterino, &inuse);
> > > > +	if (error == -ENODATA) {
> > > > +		/* Not cached, just read the disk buffer */
> > > 
> > > I think that is wrong. xfs_icache_inode_is_allocated() returns
> > > -ENOENT if the inode is not in cache....
> > 
> > I changed it to ENODATA so that we can tell the difference between
> > inode not in cache (ENODATA) and inode racing with unlink (ENOENT).
> > 
> > (Patch was sent to the ML a while ago and I omitted it from this posting...)
> 
> Ah, if it's not committed upstream yet, include it in the next
> posting, please :)
> 
> > > > +	/* Make sure the freemask matches the inode records. */
> > > > +	blks_per_cluster = xfs_icluster_size_fsb(mp);
> > > > +	nr_inodes = XFS_OFFBNO_TO_AGINO(mp, blks_per_cluster, 0);
> > > 
> > > Does this setup and loop work for the case where we have 64k
> > > filesystem blocks and so two or more inode chunks per filesystem
> > > block (i.e. ppc64)? 
> > 
> > I think the answer is yes, at worst case we end up processing a block's
> > worth of inodes at a time.  The last time I ran scrub on ppc64 (last
> > week) it worked fine.
> 
> Hmmm - there's nothing to count how many inodes are scrubbed, is
> there? Perhaps it would be good to gcount as we go so we know if
> we've scrubbed all the inodes?

Userspace will count the number of inodes scrubbed (since it's
initiating all the scrub requests) and check it against statfs.

> Hmmm - I might have missed it, but is there anywhere in this code
> where we check the inode number in the inode that we have read
> actually matches the agino we are attempting to validate?

The dinode verifier checks di_ino, so if they don't match then xfs_iread
-> xfs_iget return -EFSCORRUPTED.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
