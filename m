Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07418760B2
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 22:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HlwaCQ2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C07C433C7;
	Mon, 18 Dec 2023 22:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702939161;
	bh=c4q68MZ7UMxzxwqw946pnxIkMNcZ7mvLi1ZMDHKkw6s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HlwaCQ2iIgZNr9KbCWjTDvAcCFkY+6QndVtWzLAYVwuXvoryswhwPUvTH5zlfZHpt
	 9fANr5KNhOF+h5Y7+dcXaMNQtxJsObrn7i7QN+VDDyZNWLNomJPDY9R8akJnr5Ob7Q
	 bHBJlhzi8ZCI0z+IObcl4D6CXIJunMOXxd6qe39g0oq7/dwOz5diHIbfX4C/WLWxfx
	 5hxjOLHJwZPKiYK54k8WMaerfpEKKlFNZc/GkKsQJXcW+YSQA0uenxeUde02lVw24Q
	 GCxrzfrVOrxrJ/EvYxcUinhCHax01jmAIKhvRVo2kJgri98MA5S2OX3fRcc6m1p5wu
	 iCPoELEMGe56A==
Date: Mon, 18 Dec 2023 14:39:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: remove xfs_attr_sf_hdr_t
Message-ID: <20231218223921.GD361584@frogsfrogsfrogs>
References: <20231217170350.605812-1-hch@lst.de>
 <20231217170350.605812-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231217170350.605812-9-hch@lst.de>

On Sun, Dec 17, 2023 at 06:03:50PM +0100, Christoph Hellwig wrote:
> Remove the last two users of the typedef and move the comment next to
> its declaration to a more useful place.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Woo, fewer typedefs.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 4 ++--
>  fs/xfs/libxfs/xfs_attr_sf.h   | 8 --------
>  fs/xfs/libxfs/xfs_da_format.h | 5 ++++-
>  3 files changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index e1281ab413c832..6374bf10724207 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -816,7 +816,7 @@ xfs_attr_sf_removename(
>  	/*
>  	 * Fix up the start offset of the attribute fork
>  	 */
> -	if (totsize == sizeof(xfs_attr_sf_hdr_t) && xfs_has_attr2(mp) &&
> +	if (totsize == sizeof(struct xfs_attr_sf_hdr) && xfs_has_attr2(mp) &&
>  	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
>  	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE))) {
>  		xfs_attr_fork_remove(dp, args->trans);
> @@ -824,7 +824,7 @@ xfs_attr_sf_removename(
>  		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
>  		dp->i_forkoff = xfs_attr_shortform_bytesfit(dp, totsize);
>  		ASSERT(dp->i_forkoff);
> -		ASSERT(totsize > sizeof(xfs_attr_sf_hdr_t) ||
> +		ASSERT(totsize > sizeof(struct xfs_attr_sf_hdr) ||
>  				(args->op_flags & XFS_DA_OP_ADDNAME) ||
>  				!xfs_has_attr2(mp) ||
>  				dp->i_df.if_format == XFS_DINODE_FMT_BTREE);
> diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
> index a1d5ef88ca2673..0600b4e408fa36 100644
> --- a/fs/xfs/libxfs/xfs_attr_sf.h
> +++ b/fs/xfs/libxfs/xfs_attr_sf.h
> @@ -6,14 +6,6 @@
>  #ifndef __XFS_ATTR_SF_H__
>  #define	__XFS_ATTR_SF_H__
>  
> -/*
> - * Attribute storage when stored inside the inode.
> - *
> - * Small attribute lists are packed as tightly as possible so as
> - * to fit into the literal area of the inode.
> - */
> -typedef struct xfs_attr_sf_hdr xfs_attr_sf_hdr_t;
> -
>  /*
>   * We generate this then sort it, attr_list() must return things in hash-order.
>   */
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index 650fedce40449e..dcfe2fe9edc385 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -578,7 +578,10 @@ xfs_dir2_block_leaf_p(struct xfs_dir2_block_tail *btp)
>  #define XFS_ATTR_LEAF_MAPSIZE	3	/* how many freespace slots */
>  
>  /*
> - * Entries are packed toward the top as tight as possible.
> + * Attribute storage when stored inside the inode.
> + *
> + * Small attribute lists are packed as tightly as possible so as
> + * to fit into the literal area of the inode.
>   */
>  struct xfs_attr_sf_hdr {	/* constant-structure header block */
>  	__be16	totsize;	/* total bytes in shortform list */
> -- 
> 2.39.2
> 
> 
