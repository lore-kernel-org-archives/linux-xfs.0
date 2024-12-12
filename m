Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D1E2F2F
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 21:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734040132; cv=none; b=utBBoCR4qJwqkZ4w3eYxo8jFbFsrRf6xDDVub0yM+zrhIGlxgLqc9HQuioxr1DIuwZwIGkNhaI+gV2wBuT5GapK4FgCZdZmPan5iOKKYDOip4YXuCBpka/g7p82cIVVaStDmqyXt4EeiUnTrorulIPjL5zsIdzG42pdMZoW2Nm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734040132; c=relaxed/simple;
	bh=KaNUkg7WyDx9k34osLATVV8W/PnDJw4yvKD4eJeU4zo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gNAA6Rv9jqGk1MpArNcfbo4JnCXggs0CXrbWTGEU/RiRKxDhFecONXfFOuXndHdnq3nCGmWt8U4AAF/DVwJ2cnnYLJmu8EDq6m35ADXdBCkmaiCHeS2kUD/69U4q8vX1Djyg2BLG3KepLJ3GrWp2srWdD/fNu/SGGtPeLGh3k2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qsg5Sd13; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qsg5Sd13"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3358C4CECE;
	Thu, 12 Dec 2024 21:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734040131;
	bh=KaNUkg7WyDx9k34osLATVV8W/PnDJw4yvKD4eJeU4zo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qsg5Sd13yyBadMdM3pOuJ1a2uWkEzptd49jLnZ+z7eip1XI0JDLxpnrGHG6t+K49S
	 tdEcJ7zCo56qqqRRxUXZGLq2sgWPkRsCOMwN5FOK8WVHvsasyS7iqvEHXALMOe/sKR
	 xcvVdAjnAh/rywawQTeXMzZBW0KNzp+43eKCDjS9vXuKUlfVGia9IVGWxHu3MjncHP
	 0ykZbtGZJPbolowf0tZKksB1qSHPuZB22115Pt2GxFFRHBwyWYu8F6wcj50ysECvbv
	 HiHlpeLX1QZcnx/Ak9+7XGbS4PdSzTZFofx244eof9e851DNIX1KGrGzv8iWshQxAm
	 x1TjeM1eeRATg==
Date: Thu, 12 Dec 2024 13:48:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/43] xfs: add a xfs_rtrmap_first_unwritten_rgbno helper
Message-ID: <20241212214851.GA6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-15-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:39AM +0100, Christoph Hellwig wrote:
> Add a helper to find the last offset mapped in the rtrmap.  This will be
> used by the zoned code to find out where to start writing again on
> conventional devices without hardware zone support.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_rtrmap_btree.c | 16 ++++++++++++++++
>  fs/xfs/libxfs/xfs_rtrmap_btree.h |  2 ++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
> index 04b9c76380ad..b2bb0dd53b00 100644
> --- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
> @@ -1033,3 +1033,19 @@ xfs_rtrmapbt_init_rtsb(
>  	xfs_btree_del_cursor(cur, error);
>  	return error;
>  }
> +
> +xfs_rgblock_t
> +xfs_rtrmap_first_unwritten_rgbno(
> +	struct xfs_rtgroup	*rtg)

Might want to leave a comment here saying that this only applies to
zoned realtime devices because they are written start to end, not
randomly.  Otherwise this looks ok to me, having peered into the future
to see how it got used. :)

--D

> +{
> +	struct xfs_btree_block	*block = rtg_rmap(rtg)->i_df.if_broot;
> +	union xfs_btree_key	key = {};
> +	struct xfs_btree_cur	*cur;
> +
> +	if (block->bb_numrecs == 0)
> +		return 0;
> +	cur = xfs_rtrmapbt_init_cursor(NULL, rtg);
> +	xfs_btree_get_keys(cur, block, &key);
> +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> +	return be32_to_cpu(key.__rmap_bigkey[1].rm_startblock) + 1;
> +}
> diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
> index 6a2d432b55ad..d5cca8fcf4a3 100644
> --- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
> @@ -207,4 +207,6 @@ struct xfs_btree_cur *xfs_rtrmapbt_mem_cursor(struct xfs_rtgroup *rtg,
>  int xfs_rtrmapbt_mem_init(struct xfs_mount *mp, struct xfbtree *xfbtree,
>  		struct xfs_buftarg *btp, xfs_rgnumber_t rgno);
>  
> +xfs_rgblock_t xfs_rtrmap_first_unwritten_rgbno(struct xfs_rtgroup *rtg);
> +
>  #endif	/* __XFS_RTRMAP_BTREE_H__ */
> -- 
> 2.45.2
> 
> 
