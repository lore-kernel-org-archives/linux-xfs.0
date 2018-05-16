Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:34825 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751155AbeEPVTz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 17:19:55 -0400
Date: Thu, 17 May 2018 07:19:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/22] xfs: add helpers to deal with transaction
 allocation and rolling
Message-ID: <20180516211951.GU23861@dastard>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642362544.1556.12056546958129943758.stgit@magnolia>
 <20180516065103.GP23861@dastard>
 <20180516164645.GF23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180516164645.GF23858@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 16, 2018 at 09:46:45AM -0700, Darrick J. Wong wrote:
> On Wed, May 16, 2018 at 04:51:03PM +1000, Dave Chinner wrote:
> > On Tue, May 15, 2018 at 03:33:45PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > For repairs, we need to reserve at least as many blocks as we think
> > > we're going to need to rebuild the data structure, and we're going to
> > > need some helpers to roll transactions while maintaining locks on the AG
> > > headers so that other threads cannot wander into the middle of a repair.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/scrub/bmap.c   |    2 -
> > >  fs/xfs/scrub/common.c |   21 ++++++-
> > >  fs/xfs/scrub/common.h |    2 -
> > >  fs/xfs/scrub/inode.c  |    4 +
> > >  fs/xfs/scrub/repair.c |  152 +++++++++++++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/scrub/repair.h |   12 ++++
> > >  6 files changed, 186 insertions(+), 7 deletions(-)
> > 
> > mostly looks good.
> > 
> > [...]
> > > +			freelen, usedlen);
> > > +
> > > +	/*
> > > +	 * Figure out how many blocks we'd need worst case to rebuild
> > > +	 * each type of btree.  Note that we can only rebuild the
> > > +	 * bnobt/cntbt or inobt/finobt as pairs.
> > > +	 */
> > > +	bnobt_sz = 2 * xfs_allocbt_calc_size(mp, freelen);
> > > +	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
> > > +		inobt_sz = xfs_iallocbt_calc_size(mp, icount /
> > > +				XFS_INODES_PER_HOLEMASK_BIT);
> > > +	else
> > > +		inobt_sz = xfs_iallocbt_calc_size(mp, icount /
> > > +				XFS_INODES_PER_CHUNK);
> > > +	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> > > +		inobt_sz *= 2;
> > > +	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> > > +		rmapbt_sz = xfs_rmapbt_calc_size(mp, aglen);
> > > +		refcbt_sz = xfs_refcountbt_calc_size(mp, usedlen);
> > > +	} else {
> > > +		rmapbt_sz = xfs_rmapbt_calc_size(mp, usedlen);
> > > +		refcbt_sz = 0;
> > > +	}
> > > +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> > > +		rmapbt_sz = 0;
> > 
> > This looks kinda whacky. reflink and rmapbt are different features,
> > maybe a comment to explain why the rmapbt size calc is done all
> > back to front?
> 
> Yeah.  Replace that whole section with:
> 
> 	if (xfs_sb_version_hasreflink(&mp->m_sb))
> 		refcbt_sz = xfs_refcountbt_calc_size(mp, usedlen);
> 	else
> 		refcbt_sz = 0;
> 	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> 		/*
> 		 * Guess how many blocks we need to rebuild the rmapbt.
> 		 * For non-reflink filesystems we can't have more
> 		 * records than used blocks.  However, with reflink it's
> 		 * possible to have more than one rmap record per AG
> 		 * block.  We don't know how many rmaps there could be
> 		 * in the AG, so we start off with what we hope is an
> 		 * generous over-estimation.
> 		 */
> 		if (xfs_sb_version_hasreflink(&mp->m_sb))
> 			rmapbt_sz = xfs_rmapbt_calc_size(mp,
> 					(unsigned long long)aglen * 2);
> 		else
> 			rmapbt_sz = xfs_rmapbt_calc_size(mp, usedlen);
> 	} else {
> 		rmapbt_sz = 0;
> 	}

Yup, that's much better :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
