Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DBB29ACC5
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 04:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780375802; cv=none; b=AJvz9YSriIfsJEmi/1NKXEFjFNqfHjQiNatMvGjMAUB7/0mh2O2g2oo5ffpN6aO0DQDFEZbkbTNnp4iMtVDs6+SrC1YG4Xvkdu/IstiTS4Gb15pF1X1Vq1pbiw7js7NaVjm0MBXUx36lYxEB0v4X2Ff6RuDIeo0uaXXQizo0fWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780375802; c=relaxed/simple;
	bh=McjaCDUJOSm7/B0OD6tY+CBjzWWYXSM74wbMf0NFqJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K+3Udo5mVEN9szV/KBQxIvSaTMfpofQ+/gGs16zeCNfONhzm0Wx5BlWvJd3eOPh4LUIm8HiqY2jo5wxqD+a4EdsxUC9pfecSv2SrQwM2853pqipUGwhvaq6TftWd/DZvPW5+5IHw+iiUTnlJmlMfbyKtyWzQlPN5dw10PhrLdAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cFiT48Db; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cFiT48Db"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E14D61F00893;
	Tue,  2 Jun 2026 04:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780375801;
	bh=JSsJTtpEhS/ipRg3bXgt5dz5tMFCP86l2DvO64IYhfI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cFiT48DblEMfg/oTeq+4Iwyu/bF3Mzxa+Es2YM6BULOE0w5qmfkHRAgGwL42M6qmM
	 lXLmvHqLciQssCq72ImQ2VhrYl+hkG4LP8ewjRFbWhOb+zA/Pup//rsBmMH0lczDDK
	 uEDakX0jhWeLx65Lmnay6zpRXebapQbqf9qx7+16dUV5dPrUcmzEXiinquZmRdvcSN
	 lSmU4yldhBEbhMQELInY3jBitHj82IWkbVw+WhVI9OfBpfF8n1VkJGYb24gH/9/tXa
	 EDCw9U0reMeiZ3XODVhTZ42h9NG+/RFFiChMrUjpVBWne1Vgc5jmKErE34KE/NxGZm
	 p99n04NdPPi3A==
Date: Mon, 1 Jun 2026 21:50:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: cleanup xfs_imap
Message-ID: <20260602045000.GS6078@frogsfrogsfrogs>
References: <20260601124410.3508980-1-hch@lst.de>
 <20260601124410.3508980-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601124410.3508980-2-hch@lst.de>

On Mon, Jun 01, 2026 at 02:43:47PM +0200, Christoph Hellwig wrote:
> Reshuffle the code a bit so that the imap_lookup and filling out of the
> xfs_imap structure aren't duplicated.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This is pretty straightforward so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 64 +++++++++++++++++---------------------
>  1 file changed, 29 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 8d6a4fe4228c..a3fe4e5b1cdd 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2511,44 +2511,38 @@ xfs_imap(
>  	 * inodes in stale state on disk. Hence we have to do a btree lookup
>  	 * in all cases where an untrusted inode number is passed.
>  	 */
> -	if (flags & XFS_IGET_UNTRUSTED) {
> -		error = xfs_imap_lookup(pag, tp, agino, agbno,
> -					&chunk_agbno, &offset_agbno, flags);
> -		if (error)
> -			return error;
> -		goto out_map;
> -	}
> +	if (!(flags & XFS_IGET_UNTRUSTED)) {
> +		/*
> +		 * If the inode cluster size is the same or smaller than the
> +		 * blocksize, get to the buffer by simple arithmetics.
> +		 */
> +		if (M_IGEO(mp)->blocks_per_cluster == 1) {
> +			cluster_agbno = agbno;
> +			offset = XFS_INO_TO_OFFSET(mp, ino);
> +			ASSERT(offset < mp->m_sb.sb_inopblock);
> +			goto out;
> +		}
>  
> -	/*
> -	 * If the inode cluster size is the same as the blocksize or
> -	 * smaller we get to the buffer by simple arithmetics.
> -	 */
> -	if (M_IGEO(mp)->blocks_per_cluster == 1) {
> -		offset = XFS_INO_TO_OFFSET(mp, ino);
> -		ASSERT(offset < mp->m_sb.sb_inopblock);
> -
> -		imap->im_blkno = xfs_agbno_to_daddr(pag, agbno);
> -		imap->im_len = XFS_FSB_TO_BB(mp, 1);
> -		imap->im_boffset = (unsigned short)(offset <<
> -							mp->m_sb.sb_inodelog);
> -		return 0;
> -	}
> +		/*
> +		 * If the inode chunks are aligned, use simple maths to find the
> +		 * location.
> +		 */
> +		if (M_IGEO(mp)->inoalign_mask) {
> +			offset_agbno = agbno & M_IGEO(mp)->inoalign_mask;
> +			chunk_agbno = agbno - offset_agbno;
> +			goto out_map;
> +		}
>  
> -	/*
> -	 * If the inode chunks are aligned then use simple maths to
> -	 * find the location. Otherwise we have to do a btree
> -	 * lookup to find the location.
> -	 */
> -	if (M_IGEO(mp)->inoalign_mask) {
> -		offset_agbno = agbno & M_IGEO(mp)->inoalign_mask;
> -		chunk_agbno = agbno - offset_agbno;
> -	} else {
> -		error = xfs_imap_lookup(pag, tp, agino, agbno,
> -					&chunk_agbno, &offset_agbno, flags);
> -		if (error)
> -			return error;
> +		/*
> +		 * Otherwise we have to do a btree lookup to find the location.
> +		 */
>  	}
>  
> +	error = xfs_imap_lookup(pag, tp, agino, agbno, &chunk_agbno,
> +			&offset_agbno, flags);
> +	if (error)
> +		return error;
> +
>  out_map:
>  	ASSERT(agbno >= chunk_agbno);
>  	cluster_agbno = chunk_agbno +
> @@ -2556,7 +2550,7 @@ xfs_imap(
>  		 M_IGEO(mp)->blocks_per_cluster);
>  	offset = ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock) +
>  		XFS_INO_TO_OFFSET(mp, ino);
> -
> +out:
>  	imap->im_blkno = xfs_agbno_to_daddr(pag, cluster_agbno);
>  	imap->im_len = XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster);
>  	imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);
> -- 
> 2.53.0
> 
> 
