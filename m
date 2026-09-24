Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E67C3B2D0D;
	Thu, 24 Sep 2026 22:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790287393; cv=none; b=XL7QznA2hRtp9OXj5JPRxQAFqgKo6PwYt5KoeZPid/19gbTWD1vnDwGzI4u+UfvuXeDkTzpNZ+d25t7GfNh2srYeNT4HSeFgrrsEfVxbNMsyrBORGtsVQ0GDiBo6yUTZ7VghYh0xMDHxuUmkaUVNF6MuX7j3M0G5uzf1EE32rwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790287393; c=relaxed/simple;
	bh=tz+qpaM2JnUMEf43xkteuukCsiaU2NTQMd4INUfXVNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LaHrDIHAd/vqrKk87FnRZ/zSAq59rEeW5I/67Mitpt6d4HF4JcBbdYl14F+CM/WuTORY/+NASIzi+5VaMsZkjw+A9ZKvH2J1N9LzoGU8/XlnhdZTmZaH50jcaTiSxkm441ahNmbJWwuz6Hzq7RAFCkUFMxdzL7UyKtHlGf7ILWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EWPHTDpF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EWPHTDpF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DFB7A1F000FF;
	Thu, 24 Sep 2026 22:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790287392;
	bh=WXYRDdar3vFNmRMNuhMB8UoRV+HE29QIVdfqwrd6rYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EWPHTDpFVpP3U6egHSAixmbjpHqW7SdrCeVYq7wyQhuYdcS/28ofQ7PT/qE2bKncp
	 SsZsjLTahrgyvXN28EQlm+2bCzeZHGNxgX+kp6Fep0FaTpW80NPD44J/Z3s3Seco2w
	 TxDUlVSSp+x4YXH8eBePjzpyvyHbxpgQJtt09KZpcd2xeG4d5xiBT1bPmiAQD1mrnU
	 XO/YIMXjjP2IUSTxdBvk253cq9Z101j3T80UHvRhK7RGVoYuOoy9YbMp+u0rMtQK1G
	 9osHGmHO0tWmsunwtC6/zTMaOMDiaM1/jAsOEfOlarqVynlImX4mXWx1NXw64EktKo
	 zvi2IUxsLUjHg==
Date: Thu, 24 Sep 2026 15:03:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/21] xfs: prepare xfs_rtfile_initialize_blocks for
 larger than FSB blocks
Message-ID: <20260924220311.GH2705364@frogsfrogsfrogs>
References: <20260924100032.2733101-1-hch@lst.de>
 <20260924100032.2733101-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100032.2733101-7-hch@lst.de>

On Thu, Sep 24, 2026 at 11:59:38AM +0200, Christoph Hellwig wrote:
> The upcoming RT data checksum feature will use larger than FSB blocks.
> Prepare xfs_rtfile_initialize_blocks to pass the number of FSBs per
> RT blocks, and to pass bmapi_flags to ask for contiguous allocation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_rtbitmap.c | 44 +++++++++++++++++++++---------------
>  fs/xfs/libxfs/xfs_rtbitmap.h |  3 ++-
>  fs/xfs/xfs_rtalloc.c         |  4 ++--
>  3 files changed, 30 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 01536f4fb386..db6a22b4506a 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -1346,6 +1346,7 @@ xfs_rtfile_alloc_blocks(
>  	struct xfs_inode	*ip,
>  	xfs_fileoff_t		offset_fsb,
>  	xfs_filblks_t		count_fsb,
> +	uint32_t		bmapi_flags,
>  	struct xfs_bmbt_irec	*map)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> @@ -1367,7 +1368,7 @@ xfs_rtfile_alloc_blocks(
>  		goto out_trans_cancel;
>  
>  	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
> -			XFS_BMAPI_METADATA, 0, map, &nmap);
> +			XFS_BMAPI_METADATA | bmapi_flags, 0, map, &nmap);
>  	if (error)
>  		goto out_trans_cancel;
>  
> @@ -1405,34 +1406,43 @@ xfs_rtfile_initialize_block(
>  	struct xfs_rtgroup	*rtg,
>  	enum xfs_rtg_inodes	type,
>  	xfs_fsblock_t		fsbno,
> -	void			*data)
> +	xfs_filblks_t		nblks,
> +	void			**data)
>  {
>  	struct xfs_mount	*mp = rtg_mount(rtg);
>  	struct xfs_inode	*ip = rtg->rtg_inodes[type];
> +	size_t			len = XFS_FSB_TO_B(mp, nblks);
> +	size_t			copylen = len;
> +	struct xfs_trans_res	tres = M_RES(mp)->tr_growrtzero;
>  	struct xfs_trans	*tp;
>  	struct xfs_buf		*bp;
> -	const size_t		copylen = mp->m_blockwsize << XFS_WORDLOG;
>  	int			error;
>  
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtzero, 0, 0, 0, &tp);
> +	tres.tr_logres *= nblks;

Hmm.  Is it safe to multiply the log reservation by an arbitrary
block count?  I would think we'd want *some* guarantee that we can't
create a transaction that's larger than the log can support.

It might suffice to put in a safeguard like:

	/* Log should always be able to handle 64k of logged buffers */
	ASSERT(nblks <= XFS_B_TO_FSB(mp, SZ_64K));

> +	error = xfs_trans_alloc(mp, &tres, 0, 0, 0, &tp);
>  	if (error)
>  		return error;
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  
>  	error = xfs_trans_get_buf(tp, mp->m_ddev_targp,
> -			XFS_FSB_TO_DADDR(mp, fsbno), mp->m_bsize, 0, &bp);
> +			XFS_FSB_TO_DADDR(mp, fsbno), BTOBB(len), 0, &bp);
>  	if (error) {
>  		xfs_trans_cancel(tp);
>  		return error;
>  	}
>  
> +	if (xfs_has_rtgroups(mp))
> +		copylen -= sizeof(struct xfs_rtbuf_blkinfo);

This is how we maintain copylen as the amount of non-header data to copy
out of *data, correct?  I suppose that means that the checksum file
blocks also have a header?

--D

> +
>  	xfs_rtfile_initialize_buf(rtg, type, bp, tp);
> -	if (data)
> -		memcpy(xfs_rtblock_payload(bp), data, copylen);
> -	else
> +	if (*data) {
> +		memcpy(xfs_rtblock_payload(bp), *data, copylen);
> +		*data += copylen;
> +	} else {
>  		memset(xfs_rtblock_payload(bp), 0, copylen);
> -	xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
> +	}
> +	xfs_trans_log_buf(tp, bp, 0, len - 1);
>  	return xfs_trans_commit(tp);
>  }
>  
> @@ -1447,33 +1457,31 @@ xfs_rtfile_initialize_blocks(
>  	enum xfs_rtg_inodes	type,
>  	xfs_fileoff_t		offset_fsb,	/* offset to start from */
>  	xfs_fileoff_t		end_fsb,	/* offset to allocate to */
> +	xfs_filblks_t		bsize,
> +	uint32_t		bmapi_flags,
>  	void			*data)		/* data to fill the blocks */
>  {
> -	struct xfs_mount	*mp = rtg_mount(rtg);
> -	const size_t		copylen = mp->m_blockwsize << XFS_WORDLOG;
> -
>  	while (offset_fsb < end_fsb) {
>  		struct xfs_bmbt_irec	map;
>  		xfs_filblks_t		i;
>  		int			error;
>  
>  		error = xfs_rtfile_alloc_blocks(rtg->rtg_inodes[type],
> -				offset_fsb, end_fsb - offset_fsb, &map);
> +				offset_fsb, end_fsb - offset_fsb, bmapi_flags,
> +				&map);
>  		if (error)
>  			return error;
>  
>  		/*
> -		 * Now we need to clear the allocated blocks.
> +		 * Now we need to clear or initialize the allocated blocks.
>  		 *
>  		 * Do this one block per transaction, to keep it simple.
>  		 */
> -		for (i = 0; i < map.br_blockcount; i++) {
> +		for (i = 0; i < map.br_blockcount; i += bsize) {
>  			error = xfs_rtfile_initialize_block(rtg, type,
> -					map.br_startblock + i, data);
> +					map.br_startblock + i, bsize, &data);
>  			if (error)
>  				return error;
> -			if (data)
> -				data += copylen;
>  		}
>  
>  		offset_fsb = map.br_startoff + map.br_blockcount;
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
> index 750d74fbf4ed..e9e3378d15aa 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.h
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.h
> @@ -410,7 +410,8 @@ void xfs_rtfile_initialize_buf(struct xfs_rtgroup *rtg,
>  		struct xfs_trans *tp);
>  int xfs_rtfile_initialize_blocks(struct xfs_rtgroup *rtg,
>  		enum xfs_rtg_inodes type, xfs_fileoff_t offset_fsb,
> -		xfs_fileoff_t end_fsb, void *data);
> +		xfs_fileoff_t end_fsb, xfs_filblks_t bsize,
> +		uint32_t bmapi_flags, void *data);
>  int xfs_rtbitmap_create(struct xfs_rtgroup *rtg, struct xfs_inode *ip,
>  		struct xfs_trans *tp, bool init);
>  int xfs_rtsummary_create(struct xfs_rtgroup *rtg, struct xfs_inode *ip,
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 84efe5a8fb11..78a1c066c7eb 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1191,11 +1191,11 @@ xfs_growfs_rt_alloc_blocks(
>  	}
>  
>  	error = xfs_rtfile_initialize_blocks(rtg, XFS_RTGI_BITMAP, orbmblocks,
> -			nmp->m_sb.sb_rbmblocks, NULL);
> +			nmp->m_sb.sb_rbmblocks, 1, 0, NULL);
>  	if (error)
>  		goto out_free;
>  	error = xfs_rtfile_initialize_blocks(rtg, XFS_RTGI_SUMMARY, orsumblocks,
> -			nmp->m_rsumblocks, NULL);
> +			nmp->m_rsumblocks, 1, 0, NULL);
>  out_free:
>  	kfree(nmp);
>  	return error;
> -- 
> 2.53.0
> 
> 
