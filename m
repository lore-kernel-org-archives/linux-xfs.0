Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC3410E5
	for <linux-xfs@vger.kernel.org>; Sat,  6 Jan 2024 01:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iuHKkxwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288EDC433C7;
	Sat,  6 Jan 2024 01:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704503811;
	bh=tcs2Qx5DniR6rhV8A7Do+u5YyHxbCSqV6ij6f7/aQ1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iuHKkxwAbzPMudMtRqW1Y+Zq/SGqjWNnovjARvoh4acgw4btlPAgqbPZvMqmQJ8RZ
	 9wCOW+hUeoJhCV5WlHaz7Q7x8onH4ON/k5vH0GLTWJa1wwYxgN3mMFjpWoN/1G/SP1
	 hWj8W5DIkJZSQ9cKvsHbIBhWyn7z25Xwl1jGTi6BFWwvNMRKoMsMWDuTeBuDJeBgz/
	 3C784wusAabheJzHxChcSLxQG2H7sKUCjKT9oiJAB8UwU2bgATraV1gbg79QEUeDD2
	 DFYGFQLynI1EnJcKSNxfh0xu976D7GNldkEQcDSyxVpv2MqPqcM+I3/0gyjzYruPJC
	 dI2cxdA8NAT6w==
Date: Fri, 5 Jan 2024 17:16:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: implement live quotacheck inode scan
Message-ID: <20240106011650.GK361584@frogsfrogsfrogs>
References: <170404827380.1748002.1474710373694082536.stgit@frogsfrogsfrogs>
 <170404827425.1748002.12122438465318717193.stgit@frogsfrogsfrogs>
 <ZZeTrHqhROxcLKEA@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZeTrHqhROxcLKEA@infradead.org>

On Thu, Jan 04, 2024 at 09:29:16PM -0800, Christoph Hellwig wrote:
> Looks good,
> 
> but a few nitpick below:
> 
> > +int
> > +xchk_trans_alloc_empty(
> > +	struct xfs_scrub	*sc)
> > +{
> > +	return xfs_trans_alloc_empty(sc->mp, &sc->tp);
> > +}
> 
> Can this and the conversion of an existing not quota related caller
> of xfs_trans_alloc_empty be split into a separate patch that also
> documents why this pretty trivial helper is useful?

Done.

> > +#ifdef CONFIG_XFS_QUOTA
> > +void xchk_qcheck_set_corrupt(struct xfs_scrub *sc, unsigned int dqtype,
> > +		xfs_dqid_t id);
> > +#endif /* CONFIG_XFS_QUOTA */
> 
> No need for the ifdef here.

Fixed.

> > +	/* Figure out the data / rt device block counts. */
> > +	xfs_ilock(ip, XFS_IOLOCK_SHARED);
> > +	if (isreg)
> > +		xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
> > +	if (XFS_IS_REALTIME_INODE(ip)) {
> > +		ilock_flags = xfs_ilock_data_map_shared(ip);
> > +		error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
> > +		if (error)
> > +			goto out_incomplete;
> > +	} else {
> > +		ilock_flags = XFS_ILOCK_SHARED;
> > +		xfs_ilock(ip, XFS_ILOCK_SHARED);
> > +	}
> 
> The need to call xfs_iread_extents only for RT inodes here look good,
> but I guess it is explained by the logic in xfs_inode_count_blocks.
> Maybe add a comment?

		/*
		 * Read in the data fork for rt files so that _count_blocks
		 * can count the number of blocks allocated from the rt volume.
		 * Inodes do not track that separately.
		 */

> > +/*
> > + * Load an array element, but zero the buffer if there's no data because we
> > + * haven't stored to that array element yet.
> > + */
> > +static inline int
> > +xfarray_load_sparse(
> > +	struct xfarray	*array,
> > +	uint64_t	idx,
> > +	void		*rec)
> > +{
> > +	int		error = xfarray_load(array, idx, rec);
> > +
> > +	if (error == -ENODATA) {
> > +		memset(rec, 0, array->obj_size);
> > +		return 0;
> > +	}
> > +	return error;
> > +}
> 
> Please split this into a separate prep patch.

Done.

> > +/* Compute the number of data and realtime blocks used by a file. */
> > +void
> > +xfs_inode_count_blocks(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_inode	*ip,
> > +	xfs_filblks_t		*dblocks,
> > +	xfs_filblks_t		*rblocks)
> > +{
> > +	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
> > +
> > +	if (!XFS_IS_REALTIME_INODE(ip)) {
> > +		*dblocks = ip->i_nblocks;
> > +		*rblocks = 0;
> > +		return;
> > +	}
> > +
> > +	*rblocks = 0;
> > +	xfs_bmap_count_leaves(ifp, rblocks);
> > +	*dblocks = ip->i_nblocks - *rblocks;
> > +}
> 
> Same for this one.  The flow here also reads a little odd to me,
> what speaks against:
> 
> 	*rblocks = 0;
> 	if (XFS_IS_REALTIME_INODE(ip))
> 		xfs_bmap_count_leaves(&ip->i_df, rblocks);
> 	*dblocks = ip->i_nblocks - *rblocks;

Yeah, that is more tidy.  Thanks for the suggestion, I'll incorporate
that.

--D
