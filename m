Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2324D35C181;
	Fri, 25 Sep 2026 06:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790316637; cv=none; b=a6FHXg+LDK+WXb21dZx/PcwlF5jVdmh0Tt5EEZVXoh1PDEC5c/JNK3ef3IAtc+PKc4b+Adx/xeNhs7x0FcYtLO/riMh4hxaDnL15nLONsu9hOr2K3ZSB+Tu6ubbBSrEJOlcxhF8GlpDFvKOP0kOYn1uq6RR6hm9hNmseqMVYJDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790316637; c=relaxed/simple;
	bh=TXNRC9iE/GGy0yRkhs4xNjZpz/PGWDmSri9US6WW3As=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M3UBDbLCC0cYJbd+Frmmfc2pVxlD0v8GFoK4n/zWPAhGEP5GAG+80P2O4u0sym89VNpPG+ApzDMDdYy17KNwhjgjH1JH3IAMHQNpMSFVWdH3TKOIa2jGsF+qnkI7x87Z/bvMbGuoaUsKns3RQDThXfEPz9DGXvPi1QLsJdI6Hjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 189DA68BFE; Fri, 25 Sep 2026 08:10:32 +0200 (CEST)
Date: Fri, 25 Sep 2026 08:10:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 09/21] xfs: add support for per-RTG csum files
Message-ID: <20260925061031.GF3193@lst.de>
References: <20260924100032.2733101-1-hch@lst.de> <20260924100032.2733101-10-hch@lst.de> <20260924222442.GJ2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924222442.GJ2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 24, 2026 at 03:24:42PM -0700, Darrick J. Wong wrote:
> > +	if (XFS_IS_CORRUPT(mp, ifp->if_nextents != 1))
> > +		goto sick;
> > +
> > +	/*
> > +	 * We can do an unlocked lookup here because the bmap btree for the
> > +	 * csum files is immutable once created.
> > +	 */
> 
> This might be problematic if we ever want online repair to be able to
> rebuild the checksum file data fork at runtime.  That would probably
> cause catastrophic loss of file data integrity guarantees, but that
> might be better than the filesystem dying.

repair is still on my todo list, but the plan would be to use a static_call
to introduce looking if/when we have to online repair to add locking.

> > +/* Convert an rgbno to the csum byte position in the csum file. */
> > +static inline xfs_off_t
> > +xfs_rgb_to_rtcsumpos(
> 
> rgbno_to_ ?

Yeah.

> 
> > +	struct xfs_mount	*mp,
> > +	xfs_rtblock_t		rgbno)
> 
> Shouldn't ^^^^ this be an xfs_rgblock_t given the name and comment?

Yes.

> I don't think you support checksums on !rtgroups filesystems, so you'll
> never have to deal with a rt block address larger than 2^32.

Yes, this is zoned only and zoned requires rtgroups.  Even if for some
reason we want to support non-zoned, requiring rtgroups is required for
the per-group file infrastucture.

> 
> > +{
> > +	return (xfs_off_t)rgbno << mp->m_rtcsum_shift;
> 
> Hrm.  What's the difference between this and +xfs_extlen_to_rtcsum_len?
> I guess one describes a quantity of fsblocks, whereas another describes
> an address?

Yes, which implies 32 vs 64bit values.
> > +static inline xfs_filblks_t
> > +xfs_rtcsum_max_len(
> > +	struct xfs_mount	*mp,
> > +	xfs_fsblock_t		fsbno)
> > +{
> > +	return xfs_rtcsum_len_to_extlen(mp,
> > +			mp->m_rtcsum_bsize - xfs_rtb_to_rtcsumoff(mp, fsbno));
> > +}
> 
> What does this do?  Does it compute the number of checksums you can
> write to the rest of a single csum file block given a fsblock address?

Yes, although the limiting factor is reads where the code wants to deal
with a single buffer per read.  For writes the data is logged where
we can trivially loop over buffers.

> > +union xfs_csum {
> > +	uint32_t		crc32c;
> > +	uint64_t		crc64;
> > +};
> > +
> > +static __always_inline void
> > +xfs_csum_seed(
> > +	struct xfs_mount	*mp,
> > +	union xfs_csum		*csum)
> > +{
> > +	if (mp->m_sb.sb_rtcsum_type == XFS_CSUM_TYPE_CRC32C)
> > +		csum->crc32c = XFS_CRC_SEED;
> > +	else
> > +		csum->crc64 = XFS_CRC64_SEED;
> 
> I was expecting a switch() here. ;)

That would require coming up with something for the impossible case,
so I'd rather side-step it.

