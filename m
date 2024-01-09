Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F43B17C7
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jan 2024 01:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PaCqvbiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7591C433C7;
	Tue,  9 Jan 2024 01:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704763426;
	bh=nA2B9BVuD6du5TPNxCBTnPzfdDoMgrqEyL+5ZpfNQGI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PaCqvbiE6zg2nmbzR1oX8zlDhIdx0MlYV4mR5q9FkKwdEK8B/SnTxbnSNFHjpKjxj
	 srwP/7sr9ukxNnYWfaQdfE/5mXXgG2lLDc5m+nGCBeIJTAzMCBVWg2p4NHidepg6qY
	 oJB4g/d0Q+vQGzjEkhgaIrP8bQbaWeIrlyQ9f1XpXT2BMmXoULyfjP/fiKlAbvF/gu
	 mTBKQLd2Mjb+zEJ7yMwmR2pAt2iEQ9eXH9TCXEBVQ2Mn0aiJrXpXcQq+N5J1Wi4ePy
	 aSdqMxO22UJoZC32bPoat2vw0NaLqHi737UQs1ZP66NjSnnvQug9WAc3XdmmXziXHs
	 Sp8QTlWpjjx4g==
Date: Mon, 8 Jan 2024 17:23:46 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: implement live quotacheck inode scan
Message-ID: <20240109012346.GA722975@frogsfrogsfrogs>
References: <170404827380.1748002.1474710373694082536.stgit@frogsfrogsfrogs>
 <170404827425.1748002.12122438465318717193.stgit@frogsfrogsfrogs>
 <ZZeTrHqhROxcLKEA@infradead.org>
 <20240106011650.GK361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240106011650.GK361584@frogsfrogsfrogs>

On Fri, Jan 05, 2024 at 05:16:50PM -0800, Darrick J. Wong wrote:
> On Thu, Jan 04, 2024 at 09:29:16PM -0800, Christoph Hellwig wrote:
> > Looks good,
> > 
> > but a few nitpick below:
> > 
> > > +int
> > > +xchk_trans_alloc_empty(
> > > +	struct xfs_scrub	*sc)
> > > +{
> > > +	return xfs_trans_alloc_empty(sc->mp, &sc->tp);
> > > +}
> > 
> > Can this and the conversion of an existing not quota related caller
> > of xfs_trans_alloc_empty be split into a separate patch that also
> > documents why this pretty trivial helper is useful?
> 
> Done.
> 
> > > +#ifdef CONFIG_XFS_QUOTA
> > > +void xchk_qcheck_set_corrupt(struct xfs_scrub *sc, unsigned int dqtype,
> > > +		xfs_dqid_t id);
> > > +#endif /* CONFIG_XFS_QUOTA */
> > 
> > No need for the ifdef here.
> 
> Fixed.

...and reverted because I forgot to remove the #ifdef around the
tracepoint in that function.  I tried to fix that, and got a ton of
macro spew over ... something not being defined.  In the end, I decided
that it was better not to waste memory on !CONFIG_XFS_QUOTA and not to
waste time on minor things like this.

(I spent all day rebasing to for-next again because I didn't realize
that Chandan had pulled in a bunch more of your cleanups.)

--D

> > > +	/* Figure out the data / rt device block counts. */
> > > +	xfs_ilock(ip, XFS_IOLOCK_SHARED);
> > > +	if (isreg)
> > > +		xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
> > > +	if (XFS_IS_REALTIME_INODE(ip)) {
> > > +		ilock_flags = xfs_ilock_data_map_shared(ip);
> > > +		error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
> > > +		if (error)
> > > +			goto out_incomplete;
> > > +	} else {
> > > +		ilock_flags = XFS_ILOCK_SHARED;
> > > +		xfs_ilock(ip, XFS_ILOCK_SHARED);
> > > +	}
> > 
> > The need to call xfs_iread_extents only for RT inodes here look good,
> > but I guess it is explained by the logic in xfs_inode_count_blocks.
> > Maybe add a comment?
> 
> 		/*
> 		 * Read in the data fork for rt files so that _count_blocks
> 		 * can count the number of blocks allocated from the rt volume.
> 		 * Inodes do not track that separately.
> 		 */
> 
> > > +/*
> > > + * Load an array element, but zero the buffer if there's no data because we
> > > + * haven't stored to that array element yet.
> > > + */
> > > +static inline int
> > > +xfarray_load_sparse(
> > > +	struct xfarray	*array,
> > > +	uint64_t	idx,
> > > +	void		*rec)
> > > +{
> > > +	int		error = xfarray_load(array, idx, rec);
> > > +
> > > +	if (error == -ENODATA) {
> > > +		memset(rec, 0, array->obj_size);
> > > +		return 0;
> > > +	}
> > > +	return error;
> > > +}
> > 
> > Please split this into a separate prep patch.
> 
> Done.
> 
> > > +/* Compute the number of data and realtime blocks used by a file. */
> > > +void
> > > +xfs_inode_count_blocks(
> > > +	struct xfs_trans	*tp,
> > > +	struct xfs_inode	*ip,
> > > +	xfs_filblks_t		*dblocks,
> > > +	xfs_filblks_t		*rblocks)
> > > +{
> > > +	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
> > > +
> > > +	if (!XFS_IS_REALTIME_INODE(ip)) {
> > > +		*dblocks = ip->i_nblocks;
> > > +		*rblocks = 0;
> > > +		return;
> > > +	}
> > > +
> > > +	*rblocks = 0;
> > > +	xfs_bmap_count_leaves(ifp, rblocks);
> > > +	*dblocks = ip->i_nblocks - *rblocks;
> > > +}
> > 
> > Same for this one.  The flow here also reads a little odd to me,
> > what speaks against:
> > 
> > 	*rblocks = 0;
> > 	if (XFS_IS_REALTIME_INODE(ip))
> > 		xfs_bmap_count_leaves(&ip->i_df, rblocks);
> > 	*dblocks = ip->i_nblocks - *rblocks;
> 
> Yeah, that is more tidy.  Thanks for the suggestion, I'll incorporate
> that.
> 
> --D
> 
