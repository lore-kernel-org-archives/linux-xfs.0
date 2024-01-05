Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E9F53AE
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MZh3tXE+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Z0pssYZsFHbZwjdbh8ZOlAnpB3fP6e3hYsQV/zeP+0Q=; b=MZh3tXE+eP/nCbZxCYXZwoA8sT
	2GWT7SUp7Z1AXSwFanMvfpzPE9Vt/LzvxhWfbEV4TMwYshOVGGSld0zwPh31TOhMgKY8edpMFLnsO
	YUPhVX0iWS5/dsjWyN5dND7fgUzV3su3UnHjREnOntS8QGUa3IQz3fbpCD+Ue5YPnvbdCy+81pUZQ
	L+k+FzbFRSfJFZ73j7cY/opGm/xOUxZa/TN2jctxTEOvTKK11oydj0KR+82UHnTYMYTT2RqUYr9e8
	ylD060fmANEs6ypnXn6dJYYVStp44MtwVgPt9buMthXcMv1z4I4ORsqGJtV9w6/azYIsjtGhDcPlk
	DjRqWzIg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLclg-00Fz7Q-2z;
	Fri, 05 Jan 2024 05:29:16 +0000
Date: Thu, 4 Jan 2024 21:29:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: implement live quotacheck inode scan
Message-ID: <ZZeTrHqhROxcLKEA@infradead.org>
References: <170404827380.1748002.1474710373694082536.stgit@frogsfrogsfrogs>
 <170404827425.1748002.12122438465318717193.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404827425.1748002.12122438465318717193.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good,

but a few nitpick below:

> +int
> +xchk_trans_alloc_empty(
> +	struct xfs_scrub	*sc)
> +{
> +	return xfs_trans_alloc_empty(sc->mp, &sc->tp);
> +}

Can this and the conversion of an existing not quota related caller
of xfs_trans_alloc_empty be split into a separate patch that also
documents why this pretty trivial helper is useful?

> +#ifdef CONFIG_XFS_QUOTA
> +void xchk_qcheck_set_corrupt(struct xfs_scrub *sc, unsigned int dqtype,
> +		xfs_dqid_t id);
> +#endif /* CONFIG_XFS_QUOTA */

No need for the ifdef here.

> +	/* Figure out the data / rt device block counts. */
> +	xfs_ilock(ip, XFS_IOLOCK_SHARED);
> +	if (isreg)
> +		xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
> +	if (XFS_IS_REALTIME_INODE(ip)) {
> +		ilock_flags = xfs_ilock_data_map_shared(ip);
> +		error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
> +		if (error)
> +			goto out_incomplete;
> +	} else {
> +		ilock_flags = XFS_ILOCK_SHARED;
> +		xfs_ilock(ip, XFS_ILOCK_SHARED);
> +	}

The need to call xfs_iread_extents only for RT inodes here look good,
but I guess it is explained by the logic in xfs_inode_count_blocks.
Maybe add a comment?


> +/*
> + * Load an array element, but zero the buffer if there's no data because we
> + * haven't stored to that array element yet.
> + */
> +static inline int
> +xfarray_load_sparse(
> +	struct xfarray	*array,
> +	uint64_t	idx,
> +	void		*rec)
> +{
> +	int		error = xfarray_load(array, idx, rec);
> +
> +	if (error == -ENODATA) {
> +		memset(rec, 0, array->obj_size);
> +		return 0;
> +	}
> +	return error;
> +}

Please split this into a separate prep patch.

> +/* Compute the number of data and realtime blocks used by a file. */
> +void
> +xfs_inode_count_blocks(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	xfs_filblks_t		*dblocks,
> +	xfs_filblks_t		*rblocks)
> +{
> +	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
> +
> +	if (!XFS_IS_REALTIME_INODE(ip)) {
> +		*dblocks = ip->i_nblocks;
> +		*rblocks = 0;
> +		return;
> +	}
> +
> +	*rblocks = 0;
> +	xfs_bmap_count_leaves(ifp, rblocks);
> +	*dblocks = ip->i_nblocks - *rblocks;
> +}

Same for this one.  The flow here also reads a little odd to me,
what speaks against:

	*rblocks = 0;
	if (XFS_IS_REALTIME_INODE(ip))
		xfs_bmap_count_leaves(&ip->i_df, rblocks);
	*dblocks = ip->i_nblocks - *rblocks;

