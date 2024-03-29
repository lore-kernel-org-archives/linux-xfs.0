Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DECEEAA
	for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2024 16:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711729470; cv=none; b=bDLNAUL92DLDv/d/u6pJ61SnjgpBSVjmkBNdm9La3J7Bfukcy6buUtntb8T3zDdOIPU1PQT90d1DqTX5wo1Y4p1k2Up4SBdWWXraZ0lcXm6/s5vMyPk4jYS1LUhyoZD0ICPs7kESOLUugCYTMZDeknEB5rcyAfCqcIqnNKgvT58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711729470; c=relaxed/simple;
	bh=O3rNmArbPzUZq6A5lIz/Zz8divVHESgMmtUf4n+rYE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ut3zcNxNizB/Ldg+LMBAlVfrmRu6GPUoQY+SLWIburL21e6EZn4QhXA4iG4Htc1LYDI5d1AcjBmgFY1PwDPHh+e+Ei0kU5Iium70rRwiCc6EP4vNHS1xK4EcOPGnAX9RuEGXE41xbJR5QIKTxSF4vFoVtnnQvpTZD+u/VvDQ51w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rBxfYkZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rBxfYkZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05916C433C7;
	Fri, 29 Mar 2024 16:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711729470;
	bh=O3rNmArbPzUZq6A5lIz/Zz8divVHESgMmtUf4n+rYE8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rBxfYkZqpo63Ar0k5q1mmC5ZlNW0f+9wkdGIw7iE89wjYwMztEgE9SSTstxVHP23q
	 u9v8PXicueWl9QLR0+B5aDTOliOirycUX/mP4lnREAU/xvP3doArmmr9pH3LJhj6SK
	 on/4kxE6HpqPyr6jm5rQMoivwTfDkin0q7o/GRia0p2YHWobtnY7GJ9rlzJeS8TgkL
	 s+c23tNJh2Xf/2qlbpjKCs20GBZMSdZXtWnju4+QXE0TiSQf4fCfXSOnueRCfwSavd
	 bCdBdf0yFqHYL/V1HfMmmIov1W/o4Fc7lMYazFMVL0QeMjNy4LmGEK+bSP79jVJ7jX
	 Zxxng1EYg4q0w==
Date: Fri, 29 Mar 2024 09:24:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: simplify iext overflow checking and upgrade
Message-ID: <20240329162429.GH6390@frogsfrogsfrogs>
References: <20240328070256.2918605-1-hch@lst.de>
 <20240328070256.2918605-5-hch@lst.de>
 <ZgXpewa/XiT7w4wY@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgXpewa/XiT7w4wY@dread.disaster.area>

On Fri, Mar 29, 2024 at 09:04:43AM +1100, Dave Chinner wrote:
> On Thu, Mar 28, 2024 at 08:02:54AM +0100, Christoph Hellwig wrote:
> > Currently the calls to xfs_iext_count_may_overflow and
> > xfs_iext_count_upgrade are always paired.  Merge them into a single
> > function to simplify the callers and the actual check and upgrade
> > logic itself.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c       |  5 +--
> >  fs/xfs/libxfs/xfs_bmap.c       |  5 +--
> >  fs/xfs/libxfs/xfs_inode_fork.c | 62 ++++++++++++++++------------------
> >  fs/xfs/libxfs/xfs_inode_fork.h |  4 +--
> >  fs/xfs/xfs_bmap_item.c         |  4 +--
> >  fs/xfs/xfs_bmap_util.c         | 24 +++----------
> >  fs/xfs/xfs_dquot.c             |  5 +--
> >  fs/xfs/xfs_iomap.c             |  9 ++---
> >  fs/xfs/xfs_reflink.c           |  9 ++---
> >  fs/xfs/xfs_rtalloc.c           |  5 +--
> >  10 files changed, 44 insertions(+), 88 deletions(-)
> 
> ....
> 
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > index 7d660a9739090a..235c41eca5edd7 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -765,53 +765,49 @@ xfs_ifork_verify_local_attr(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Check if the inode fork supports adding nr_to_add more extents.
> > + *
> > + * If it doesn't but we can upgrade it to large extent counters, do the upgrade.
> > + * If we can't upgrade or are already using big counters but still can't fit the
> > + * additional extents, return -EFBIG.
> > + */
> >  int
> > -xfs_iext_count_may_overflow(
> > +xfs_iext_count_upgrade(
> > +	struct xfs_trans	*tp,
> >  	struct xfs_inode	*ip,
> >  	int			whichfork,
> > -	int			nr_to_add)
> > +	uint			nr_to_add)
> >  {
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	bool			has_large =
> > +		xfs_inode_has_large_extent_counts(ip);
> >  	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
> >  	uint64_t		max_exts;
> >  	uint64_t		nr_exts;
> >  
> > +	ASSERT(nr_to_add <= XFS_MAX_EXTCNT_UPGRADE_NR);
> > +
> >  	if (whichfork == XFS_COW_FORK)
> >  		return 0;
> >  
> > -	max_exts = xfs_iext_max_nextents(xfs_inode_has_large_extent_counts(ip),
> > -				whichfork);
> > -
> > -	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
> > -		max_exts = 10;
> > -
> >  	nr_exts = ifp->if_nextents + nr_to_add;
> > -	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
> > +	if (nr_exts < ifp->if_nextents) {
> > +		/* no point in upgrading if if_nextents overflows */
> >  		return -EFBIG;
> > +	}
> >  
> > -	return 0;
> > -}
> > -
> > -/*
> > - * Upgrade this inode's extent counter fields to be able to handle a potential
> > - * increase in the extent count by nr_to_add.  Normally this is the same
> > - * quantity that caused xfs_iext_count_may_overflow() to return -EFBIG.
> > - */
> > -int
> > -xfs_iext_count_upgrade(
> > -	struct xfs_trans	*tp,
> > -	struct xfs_inode	*ip,
> > -	uint			nr_to_add)
> > -{
> > -	ASSERT(nr_to_add <= XFS_MAX_EXTCNT_UPGRADE_NR);
> > -
> > -	if (!xfs_has_large_extent_counts(ip->i_mount) ||
> > -	    xfs_inode_has_large_extent_counts(ip) ||
> > -	    XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
> > -		return -EFBIG;
> > -
> > -	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
> > -	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> > -
> > +	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
> > +		max_exts = 10;
> > +	else
> > +		max_exts = xfs_iext_max_nextents(has_large, whichfork);
> > +	if (nr_exts > max_exts) {
> > +		if (has_large || !xfs_has_large_extent_counts(mp) ||
> > +		    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
> > +			return -EFBIG;
> > +		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
> > +		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> > +	}
> 
> IIUC, testing the error tag twice won't always give the same result.
> I think this will be more reliable, and it self-documents the error
> injection case better:
> 
> 	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS) &&
> 	    nr_exts > 10))
> 		return -EFBIG;
> 
> 	if (nr_exts > xfs_iext_max_nextents(has_large, whichfork)) {
> 		if (has_large || !xfs_has_large_extent_counts(mp))
> 			return -EFBIG;
> 		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
> 		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> 	}
> 	return 0;

Agreed, that looks better to me than sampling the errtag twice.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
