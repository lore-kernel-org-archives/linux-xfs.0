Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3050C4BEE38
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 19:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790276537; cv=none; b=XrswWQYPxWccpPNzwA3aGWvdx3AkBEoGuMoGeq6Zq24enAMDrT7jXn3CB/QDDkbxHicR79gcV96kx6ar+JaQeoKUWz2N1jdbUS29SZ/TV98xxu7j0KZ4ln9IPc/doksKdbbEEqT5tuHtcK7lz3B0/qL2eEUHUrT5kbBcJnbqzVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790276537; c=relaxed/simple;
	bh=U5J/aqbLE6L9jVaesEfrKK3azhnAwQmiU2+W/s1nzLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nP+gAyB1xqSrO7HYS3/kPcgH3RY8Aq6mLb1cjy5hPgxK9KQMLCOY6vqkHcEyMBePApQP14bTNf0mMwXHHdgd2sHP5RENcl34sTWwp4kcw8R3bmz5187+YZscFDski9pRfuTa5Il9MbjdzguWRqZg9GIx3jfK/oHdhwh9xiLfDkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fiunHmI5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fiunHmI5"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 14E8D1F000FF;
	Thu, 24 Sep 2026 19:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790276527;
	bh=ntXYavwTfs5OyVnXulaJYyBpBcUIrjsPMqgH5JppJAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fiunHmI5yr4VvAvyFlDn9IkuDQqy83qnZ2NCrUxPHH4aNZQXc9KNk0bpkYR7H5E13
	 15ILAGXSeil8Sm9k6aMiwUsicacqtYwNyxKv/5uLj7MT8JQkvd4c5ug5zesfS0UjiQ
	 p3Xb45xZYGK8yMjDgQy9ea9qO+JejoPv0OnGaDtHysKOlWIAeSQxm691GxkILbmVam
	 /wXHQhGzqxNcuQbyNv/mfHrsSiTxinqQy78FrArznkbQKASr9xCyJiULAuhf35Lzk2
	 ggJsraYM+fiERVOC2A7uqNGhzcjP+pIl0G8wQ/Ny9g+yp4DaMe3L974LPGuLMPiT+W
	 GuI3bbzKfzflA==
Date: Thu, 24 Sep 2026 12:02:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: factor out a xfs_rtfile_initialize_buf helper
Message-ID: <20260924190206.GP2705364@frogsfrogsfrogs>
References: <20260924095740.2732474-1-hch@lst.de>
 <20260924095740.2732474-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924095740.2732474-3-hch@lst.de>

On Thu, Sep 24, 2026 at 11:57:03AM +0200, Christoph Hellwig wrote:
> Share the code to initialize the header and buf ops for rtfile blocks
> into a single helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_rtbitmap.c    | 38 +++++++++++++++++++++------------
>  fs/xfs/libxfs/xfs_rtbitmap.h    |  3 +++
>  fs/xfs/scrub/rtbitmap_repair.c  | 15 +------------
>  fs/xfs/scrub/rtsummary_repair.c | 15 +------------
>  4 files changed, 29 insertions(+), 42 deletions(-)

Nice cleanup!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 3f7877220e05..5cadde81b5da 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -1378,6 +1378,27 @@ xfs_rtfile_alloc_blocks(
>  	return error;
>  }
>  
> +void
> +xfs_rtfile_initialize_buf(
> +	struct xfs_rtgroup	*rtg,
> +	enum xfs_rtg_inodes	type,
> +	struct xfs_buf		*bp,
> +	struct xfs_trans	*tp)
> +{
> +	bp->b_ops = xfs_rtblock_ops(bp->b_mount, type);
> +	if (tp)
> +		xfs_trans_buf_set_type(tp, bp, xfs_rtblock_buf_types[type]);
> +	if (xfs_has_rtgroups(bp->b_mount)) {
> +		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
> +
> +		hdr->rt_magic = bp->b_ops->magic[1];
> +		hdr->rt_owner = cpu_to_be64(I_INO(rtg->rtg_inodes[type]));
> +		hdr->rt_blkno = cpu_to_be64(xfs_buf_daddr(bp));
> +		hdr->rt_lsn = 0;
> +		uuid_copy(&hdr->rt_uuid, &bp->b_mount->m_sb.sb_meta_uuid);
> +	}
> +}
> +
>  /* Get a buffer for the block. */
>  static int
>  xfs_rtfile_initialize_block(
> @@ -1408,21 +1429,10 @@ xfs_rtfile_initialize_block(
>  	}
>  	bufdata = bp->b_addr;
>  
> -	xfs_trans_buf_set_type(tp, bp, xfs_rtblock_buf_types[type]);
> -	bp->b_ops = xfs_rtblock_ops(mp, type);
> -
> -	if (xfs_has_rtgroups(mp)) {
> -		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
> -
> -		hdr->rt_magic = bp->b_ops->magic[1];
> -		hdr->rt_owner = cpu_to_be64(I_INO(ip));
> -		hdr->rt_blkno = cpu_to_be64(XFS_FSB_TO_DADDR(mp, fsbno));
> -		hdr->rt_lsn = 0;
> -		uuid_copy(&hdr->rt_uuid, &mp->m_sb.sb_meta_uuid);
> -
> -		bufdata += sizeof(*hdr);
> -	}
> +	xfs_rtfile_initialize_buf(rtg, type, bp, tp);
>  
> +	if (xfs_has_rtgroups(mp))
> +		bufdata += sizeof(struct xfs_rtbuf_blkinfo);
>  	if (data)
>  		memcpy(bufdata, data, copylen);
>  	else
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
> index 375cc48e1a53..4a87e1fd3e99 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.h
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.h
> @@ -408,6 +408,9 @@ xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
>  
>  const struct xfs_buf_ops *xfs_rtblock_ops(struct xfs_mount *mp,
>  		enum xfs_rtg_inodes type);
> +void xfs_rtfile_initialize_buf(struct xfs_rtgroup *rtg,
> +		enum xfs_rtg_inodes type, struct xfs_buf *bp,
> +		struct xfs_trans *tp);
>  int xfs_rtfile_initialize_blocks(struct xfs_rtgroup *rtg,
>  		enum xfs_rtg_inodes type, xfs_fileoff_t offset_fsb,
>  		xfs_fileoff_t end_fsb, void *data);
> diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
> index 442a17bf9720..6a2efe3115f4 100644
> --- a/fs/xfs/scrub/rtbitmap_repair.c
> +++ b/fs/xfs/scrub/rtbitmap_repair.c
> @@ -383,21 +383,8 @@ xrep_rtbitmap_prep_buf(
>  	if (error)
>  		return error;
>  
> -	if (xfs_has_rtgroups(sc->mp)) {
> -		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
> -
> -		hdr->rt_magic = cpu_to_be32(XFS_RTBITMAP_MAGIC);
> -		hdr->rt_owner = cpu_to_be64(I_INO(sc->ip));
> -		hdr->rt_blkno = cpu_to_be64(xfs_buf_daddr(bp));
> -		hdr->rt_lsn = 0;
> -		uuid_copy(&hdr->rt_uuid, &sc->mp->m_sb.sb_meta_uuid);
> -		bp->b_ops = &xfs_rtbitmap_buf_ops;
> -	} else {
> -		bp->b_ops = &xfs_rtbuf_ops;
> -	}
> -
> +	xfs_rtfile_initialize_buf(sc->sr.rtg, XFS_RTGI_BITMAP, bp, sc->tp);
>  	rtb->prep_wordoff += mp->m_blockwsize;
> -	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_RTBITMAP_BUF);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
> index f065c3e51ce2..6a66113f6562 100644
> --- a/fs/xfs/scrub/rtsummary_repair.c
> +++ b/fs/xfs/scrub/rtsummary_repair.c
> @@ -87,21 +87,8 @@ xrep_rtsummary_prep_buf(
>  	if (error)
>  		return error;
>  
> -	if (xfs_has_rtgroups(sc->mp)) {
> -		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
> -
> -		hdr->rt_magic = cpu_to_be32(XFS_RTSUMMARY_MAGIC);
> -		hdr->rt_owner = cpu_to_be64(I_INO(sc->ip));
> -		hdr->rt_blkno = cpu_to_be64(xfs_buf_daddr(bp));
> -		hdr->rt_lsn = 0;
> -		uuid_copy(&hdr->rt_uuid, &sc->mp->m_sb.sb_meta_uuid);
> -		bp->b_ops = &xfs_rtsummary_buf_ops;
> -	} else {
> -		bp->b_ops = &xfs_rtbuf_ops;
> -	}
> -
> +	xfs_rtfile_initialize_buf(sc->sr.rtg, XFS_RTGI_SUMMARY, bp, sc->tp);
>  	rts->prep_wordoff += mp->m_blockwsize;
> -	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_RTSUMMARY_BUF);
>  	return 0;
>  }
>  
> -- 
> 2.53.0
> 
> 
