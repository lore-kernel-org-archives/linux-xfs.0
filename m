Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC0E1D61B1
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 20:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738875329; cv=none; b=UbNj/IJFyUkFwoITNQE8mSLYxQK8Ba2IpB9XSm1VAmWzHNwU354ShKO5Q1aK7RhQa0moSwjbX2MyksgtB0tp+bHIVusq/mx5jIuSeppYgEyFqaWONpP0DJ1wx0VO5Yw98Ma5clTOAk66UbKflbg/sBx9NrtgsEhnBP657cv4ilM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738875329; c=relaxed/simple;
	bh=GlnMINDa+aoZyArDtzg/QRdruKc85IOJmeWTan5204c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WVvsBVtAdEvZHt0mX0doF/iYhLG9TabzKUx8rHThm+Cigd+QXFlGCM4dSdGFnE2zJy/xuvM1iDh0By0/4i7f9TbS+EZC5Pp4ntf+uBS1su/G+Mqq0L0Ze+jiffKm5pmDJLXuvnef+NfmcckJRVA3xUQk+q4ZR/ZkgmRfDQy+i34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ckYqLv/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ckYqLv/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C390DC4CEDD;
	Thu,  6 Feb 2025 20:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738875328;
	bh=GlnMINDa+aoZyArDtzg/QRdruKc85IOJmeWTan5204c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ckYqLv/gA2fTcg8dDWpghSh6z0wETG3GM/mtBXVPz8nNdjlkkpmpC/ThTRVlldQxc
	 MbBdtKJUc5JLotiyrs6Hh0PFxWMPKPCGsGQjJeXoqN0YFOTXI1YIfri0+WMZ88SnWK
	 nCHJAIW8eRioJMsVuNsho2Kc9eMawht34QnTVM20o2V1DGL7KXioRa80E3m9LNgTY2
	 FhmI16fOoqrEm7MTJ9AZDKeSvUYt1NYs/3iYvQLiiFkKDuQ1CUDKGgxCjrg5ngi8IT
	 gAAxL1TAaytehrP43Cf2c6ugFZ3Y7D3kFDu6BR3WCPAWo3ndMt73ULK3ZXTqEJsh0g
	 HAVt7kjjq7vbA==
Date: Thu, 6 Feb 2025 12:55:28 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/43] xfs: add a xfs_rtrmap_highest_rgbno helper
Message-ID: <20250206205528.GO21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-14-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206064511.2323878-14-hch@lst.de>

On Thu, Feb 06, 2025 at 07:44:29AM +0100, Christoph Hellwig wrote:
> Add a helper to find the last offset mapped in the rtrmap.  This will be
> used by the zoned code to find out where to start writing again on
> conventional devices without hardware zone support.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_rtrmap_btree.c | 19 +++++++++++++++++++
>  fs/xfs/libxfs/xfs_rtrmap_btree.h |  2 ++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
> index e4ec36943cb7..9bdc2cbfc113 100644
> --- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
> @@ -1033,3 +1033,22 @@ xfs_rtrmapbt_init_rtsb(
>  	xfs_btree_del_cursor(cur, error);
>  	return error;
>  }
> +
> +/*
> + * Return the highest rgbno currently tracked by the rmap for this rtg.
> + */
> +xfs_rgblock_t
> +xfs_rtrmap_highest_rgbno(
> +	struct xfs_rtgroup	*rtg)
> +{
> +	struct xfs_btree_block	*block = rtg_rmap(rtg)->i_df.if_broot;
> +	union xfs_btree_key	key = {};
> +	struct xfs_btree_cur	*cur;
> +
> +	if (block->bb_numrecs == 0)
> +		return NULLRGBLOCK;
> +	cur = xfs_rtrmapbt_init_cursor(NULL, rtg);
> +	xfs_btree_get_keys(cur, block, &key);
> +	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
> +	return be32_to_cpu(key.__rmap_bigkey[1].rm_startblock);
> +}
> diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
> index 9d0915089891..e328fd62a149 100644
> --- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
> @@ -207,4 +207,6 @@ struct xfs_btree_cur *xfs_rtrmapbt_mem_cursor(struct xfs_rtgroup *rtg,
>  int xfs_rtrmapbt_mem_init(struct xfs_mount *mp, struct xfbtree *xfbtree,
>  		struct xfs_buftarg *btp, xfs_rgnumber_t rgno);
>  
> +xfs_rgblock_t xfs_rtrmap_highest_rgbno(struct xfs_rtgroup *rtg);
> +
>  #endif /* __XFS_RTRMAP_BTREE_H__ */
> -- 
> 2.45.2
> 
> 
