Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8ED324B33
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 21:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768254609; cv=none; b=lvdStYfsCf4OMZZjw5TRm9UJR43AG6TnXYTaIXjd1LivevovW9AqNQpl0LSVPln1au6wmD873qIlqvra88dXM3Xvm40gl6TjB0NMIUyNV7pr7BEvc36QirF9mQIFjmEOJNtyNilkpvHVJkp5sS4ofN7DrDVD7VkTx9Z21mt+8KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768254609; c=relaxed/simple;
	bh=MQy0WBeUOE1LIi1Trnp6w8nfvB/Zup9O2+eEQCVz//s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dcsLS8uxAEf8DzGd/EHU47GWIBqf6p4wxi7dFaYNNQF+RVjnQS8dlcSvFdLgHayQTjNUT9CnsoMcy+181lrlL8kAsu09PCWUuZX1RPE6xE1gMNpeKv3P1XGY/RQ95VJ/IYfel1bffmMTi5cgq2kKv5HrObtCV2gv4r5m5avTYgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tT66Dkzr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tT66Dkzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28148C116D0;
	Mon, 12 Jan 2026 21:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768254609;
	bh=MQy0WBeUOE1LIi1Trnp6w8nfvB/Zup9O2+eEQCVz//s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tT66Dkzr9X2aH2lgGqQecchTRH3YEc0BD33PaFotSlD9KZdk8W2wg2phgMi1Tynzi
	 XDaDPq5HDzgS4DBe/BfibO1Eu+3He5/BC5ZDKc0ptaB+J3709w1caXY1qeLJNy2OAN
	 Z6cp13DqymHL9Y6RTXDibuBJgytPcRcUDtwP6W04AToA13SnLEPAnRCmdMXJj8EWX6
	 JCBMZ38JhTMrNovVktCji7Ixp/X+2nP27XinZl+qaOlthpwbXCFsPZOe2zkRJqJxOf
	 p40v/dGN00jbpisnlvXFP0OnfjxPxj226v/GJIVf1n3sc0zU5tb5mQimG9BYWkEwLo
	 wN/PTd9XeW6qg==
Date: Mon, 12 Jan 2026 13:50:08 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: pass the write pointer to xfs_init_zone
Message-ID: <20260112215008.GD15551@frogsfrogsfrogs>
References: <20260109172139.2410399-1-hch@lst.de>
 <20260109172139.2410399-4-hch@lst.de>
 <ce23e24a-d671-43bc-a5e1-28ccf7083aff@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce23e24a-d671-43bc-a5e1-28ccf7083aff@kernel.org>

On Mon, Jan 12, 2026 at 11:15:07AM +0100, Damien Le Moal wrote:
> On 1/9/26 18:20, Christoph Hellwig wrote:
> > Move the two methods to query the write pointer out of xfs_init_zone into
> > the callers, so that xfs_init_zone doesn't have to bother with the
> > blk_zone structure and instead operates purely at the XFS realtime group
> > level.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_zone_alloc.c | 66 +++++++++++++++++++++++------------------
> >  1 file changed, 37 insertions(+), 29 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> > index bbcf21704ea0..013228eab0ac 100644
> > --- a/fs/xfs/xfs_zone_alloc.c
> > +++ b/fs/xfs/xfs_zone_alloc.c
> > @@ -981,43 +981,43 @@ struct xfs_init_zones {
> >  	uint64_t		reclaimable;
> >  };
> >  
> > +/*
> > + * For sequential write required zones, we restart writing at the hardware write
> > + * pointer.
> > + *
> > + * For conventional zones or conventional devices we have query the rmap to
> > + * find the highest recorded block and set the write pointer to the block after
> > + * that.  In case of a power loss this misses blocks where the data I/O has
> > + * completed but not recorded in the rmap yet, and it also rewrites blocks if
> > + * the most recently written ones got deleted again before unmount, but this is
> > + * the best we can do without hardware support.
> > + */
> 
> I find this comment and the function name confusing since we are not looking at
> a zone write pointer at all. So maybe rename this to something like:
> 
> xfs_rmap_get_highest_rgbno()
> 
> ? Also, I think the comment block should go...
> 
> > +static xfs_rgblock_t
> > +xfs_rmap_write_pointer(
> > +	struct xfs_rtgroup	*rtg)
> > +{
> > +	xfs_rgblock_t		highest_rgbno;
> > +
> > +	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
> > +	highest_rgbno = xfs_rtrmap_highest_rgbno(rtg);
> > +	xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
> > +
> > +	if (highest_rgbno == NULLRGBLOCK)
> > +		return 0;
> > +	return highest_rgbno + 1;
> > +}
> 
> [...]
> 
> >  	/*
> >  	 * If there are no used blocks, but the zone is not in empty state yet
> >  	 * we lost power before the zoned reset.  In that case finish the work
> > @@ -1066,6 +1066,7 @@ xfs_get_zone_info_cb(
> >  	struct xfs_mount	*mp = iz->mp;
> >  	xfs_fsblock_t		zsbno = xfs_daddr_to_rtb(mp, zone->start);
> >  	xfs_rgnumber_t		rgno;
> > +	xfs_rgblock_t		write_pointer;
> >  	struct xfs_rtgroup	*rtg;
> >  	int			error;
> >  
> > @@ -1080,7 +1081,13 @@ xfs_get_zone_info_cb(
> >  		xfs_warn(mp, "realtime group not found for zone %u.", rgno);
> >  		return -EFSCORRUPTED;
> >  	}
> > -	error = xfs_init_zone(iz, rtg, zone);
> 
> ...here.
> This code is also hard to follow without a comment indicating that write_pointer
> is not set by xfs_zone_validate() for conventional zones. Ideally, we should
> move the call to xfs_rmap_write_pointer() in xfs_zone_validate(). That would be
> cleaner, no ?
> 
> > +	if (!xfs_zone_validate(zone, rtg, &write_pointer)) {

I had wondered by the time I got to the end of this series if this
function should be renamed to xfs_validate_hw_zone() or something like
that?

--D

> > +		xfs_rtgroup_rele(rtg);
> > +		return -EFSCORRUPTED;
> > +	}
> > +	if (zone->cond == BLK_ZONE_COND_NOT_WP)
> > +		write_pointer = xfs_rmap_write_pointer(rtg);
> > +	error = xfs_init_zone(iz, rtg, write_pointer);
> >  	xfs_rtgroup_rele(rtg);
> >  	return error;
> >  }
> > @@ -1290,7 +1297,8 @@ xfs_mount_zones(
> >  		struct xfs_rtgroup	*rtg = NULL;
> >  
> >  		while ((rtg = xfs_rtgroup_next(mp, rtg))) {
> > -			error = xfs_init_zone(&iz, rtg, NULL);
> > +			error = xfs_init_zone(&iz, rtg,
> > +					xfs_rmap_write_pointer(rtg));
> >  			if (error) {
> >  				xfs_rtgroup_rele(rtg);
> >  				goto out_free_zone_info;
> 
> 
> -- 
> Damien Le Moal
> Western Digital Research
> 
