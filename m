Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A9919A
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 00:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728950642; cv=none; b=EYdhGgxugsh9RoQ9EjPv8iSauzcBzphvEow2PDrVcjIVEUrIZO2ipWJwvQ4FdlFHBTmw4TeN/AyhDSWuEd25wBTHnzgEFaMY6vfzWzm5MoeCekmME5Gj+80Z/GzlMgs1fqdlaIRj/Ol1vGFIXg2Px2Lwk0YsGzN5e7kDLOdn3QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728950642; c=relaxed/simple;
	bh=jULkWzT5UyVyfjlL033qlLg79hfVYEvHcm9OHAO+JXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bqxz44XEhmDpE6/862NMHUQVU2k+f7eGQvROyZZ4v7OPX3tAVGw66nvfvCKOOEwH1kN1/DgHeGQZj/A9cUOUNBFg0/jH0grH1a7iW8gm6/6780W+GZ6fwR4yEWqWjvkq65CRy747orHTs1DUP2UhA6bNFDjypaFVemlkWl3xJxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L6EE81cw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L6EE81cw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F0DC4CEC3;
	Tue, 15 Oct 2024 00:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728950642;
	bh=jULkWzT5UyVyfjlL033qlLg79hfVYEvHcm9OHAO+JXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L6EE81cwwIm6hLvBBE09rfplO/PUvzFKfieWCRKOiMFtXBvzKusEG8ho70RYrgjKa
	 b9DYVIpANTiP37y3fgSFoVm9jM7y2rj7s7KjBQFQhtaLTuqOnLOyVAE8WGqEGkIMJt
	 gQxsb/lrsoZKtTOWLfAVZXChv0pkg3j2nbZGwyYV/2VQuxOtONPmbeD4I3QKH8E3Oz
	 IjMdADs+9U/SYoWlEQFybf8Ie6rC0BH/ERrw45j0Zhj3CDrzTds8FhXN9DsB2AL6og
	 H9vWiDE0JuKOhKd8DXJUpYt2zRK4Y8ajnw9u/f0LRHdk4Gwh63HqIVmvkmT6QNcSlc
	 uBQVR3zMXJc0w==
Date: Mon, 14 Oct 2024 17:04:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 15/36] xfs: store rtgroup information with a bmap intent
Message-ID: <20241015000401.GK21853@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644500.4178701.5897856828553646962.stgit@frogsfrogsfrogs>
 <ZwzQcYRPCPAchgjY@infradead.org>
 <20241015000216.GJ21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015000216.GJ21853@frogsfrogsfrogs>

On Mon, Oct 14, 2024 at 05:02:16PM -0700, Darrick J. Wong wrote:
> On Mon, Oct 14, 2024 at 01:04:01AM -0700, Christoph Hellwig wrote:
> > The actual intent code looks good:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > but while re-reviewing I noticed a minor thing in the tracing code:
> > 
> > > +		__entry->dev = mp->m_super->s_dev;
> > > +		__entry->type = bi->bi_group->xg_type;
> > > +		__entry->agno = bi->bi_group->xg_index;
> > > +		switch (__entry->type) {
> > > +		case XG_TYPE_RTG:
> > > +			/*
> > > +			 * Use the 64-bit version of xfs_rtb_to_rgbno because
> > > +			 * legacy rt filesystems can have group block numbers
> > > +			 * that exceed the size of an xfs_rgblock_t.
> > > +			 */
> > > +			__entry->gbno = __xfs_rtb_to_rgbno(mp,
> > >  						bi->bi_bmap.br_startblock);
> > > +			break;
> > > +		case XG_TYPE_AG:
> > > +			__entry->gbno = XFS_FSB_TO_AGBNO(mp,
> > >  						bi->bi_bmap.br_startblock);
> > > +			break;
> > > +		default:
> > > +			/* should never happen */
> > > +			__entry->gbno = -1ULL;
> > > +			break;
> > 
> > Maybe just make this an
> > 
> > 		if (type == XG_TYPE_RTG)
> > 			__xfs_rtb_to_rgbno()
> > 		else
> > 			xfs_fsb_to_gbno()
> > 
> > ?
> 
> Hmmm that *would* get rid of that __entry->gbno = -1ULL ugliness above.
> 
> Ok let's do it.
> 
> Until we get to patch, the helper looks like:

I meant to write:

Until we get to "xfs: move the group geometry into struct xfs_groups",
the helper will look like:

--D

> xfs_agblock_t
> xfs_fsb_to_gbno(
> 	struct xfs_mount	*mp,
> 	xfs_fsblock_t		fsbno,
> 	enum xfs_group_type	type)
> {
> 	if (type == XG_TYPE_RTG)
> 		return xfs_rtb_to_rgbno(mp, fsbno);
> 	return XFS_FSB_TO_AGBNO(mp, fsbno);
> }
> 
> and the tracepoint code become:
> 
> 		__entry->type = bi->bi_group->xg_type;
> 		__entry->agno = bi->bi_group->xg_index;
> 		if (bi->bi_group->xg_type == XG_TYPE_RTG &&
> 		    !xfs_has_rtgroups(mp)) {
> 			/*
> 			 * Legacy rt filesystems do not have allocation
> 			 * groups ondisk.  We emulate this incore with
> 			 * one gigantic rtgroup whose size can exceed a
> 			 * 32-bit block number.  For this tracepoint, we
> 			 * report group 0 and a 64-bit group block
> 			 * number.
> 			 */
> 			__entry->gbno = bi->bi_bmap.br_startblock;
> 		} else {
> 			__entry->gbno = xfs_fsb_to_gbno(mp,
> 						bi->bi_bmap.br_startblock,
> 						bi->bi_group->xg_type);
> 		}
> 		__entry->ino = ip->i_ino;
> 
> --D
> 
> > >  		  __entry->l_len,
> > > 
> > > 
> > ---end quoted text---
> > 
> 
