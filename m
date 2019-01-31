Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36184 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbfAaRv0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 12:51:26 -0500
Date: Thu, 31 Jan 2019 09:51:13 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 7/7] xfs: factor xfs_da3_blkinfo verification into
 common helper
Message-ID: <20190131175113.GB5761@magnolia>
References: <20190131154608.36837-1-bfoster@redhat.com>
 <20190131154608.36837-8-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131154608.36837-8-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 31, 2019 at 10:46:08AM -0500, Brian Foster wrote:
> With the verifier magic value helper in place, we've left a bit more
> duplicate code across the verifiers that involve struct
> xfs_da3_blkinfo. This includes the da node, xattr leaf and dir leaf
> verifiers, all of which perform similar checks for v4 and v5
> filesystems.
> 
> Create a common helper to verify an xfs_da3_blkinfo structure,
> taking care to only access v5 fields where appropriate, and refactor
> the aforementioned verifiers to use the helper. No functional
> changes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 17 +++----------
>  fs/xfs/libxfs/xfs_da_btree.c  | 46 +++++++++++++++++++++++++----------
>  fs/xfs/libxfs/xfs_da_format.h |  2 ++
>  fs/xfs/libxfs/xfs_dir2_leaf.c | 18 +++-----------
>  4 files changed, 43 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index dde3a550d7ce..0c92987f57fc 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -245,23 +245,14 @@ xfs_attr3_leaf_verify(
>  	struct xfs_attr_leaf_entry	*entries;
>  	uint32_t			end;	/* must be 32bit - see below */
>  	int				i;
> +	xfs_failaddr_t			fa;
>  
>  	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
>  
> -	if (!xfs_verify_magic(bp, leaf->hdr.info.magic))
> -		return __this_address;
> -
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> -		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
> +	fa = xfs_da3_blkinfo_verify(bp, bp->b_addr);
> +	if (fa)
> +		return fa;
>  
> -		ASSERT(leaf->hdr.info.magic == hdr3->info.hdr.magic);
> -		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid))
> -			return __this_address;
> -		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
> -			return __this_address;
> -		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->info.lsn)))
> -			return __this_address;
> -	}
>  	/*
>  	 * In recovery there is a transient state where count == 0 is valid
>  	 * because we may have transitioned an empty shortform attr to a leaf
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 6b8ca390eecc..622f88a1b1aa 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -116,6 +116,35 @@ xfs_da_state_free(xfs_da_state_t *state)
>  	kmem_zone_free(xfs_da_state_zone, state);
>  }
>  
> +/*
> + * Verify an xfs_da3_blkinfo structure. Note that the da3 fields are only
> + * accessible on v5 filesystems. This header format is common across da node,
> + * attr leaf and dir leaf blocks.
> + */
> +xfs_failaddr_t
> +xfs_da3_blkinfo_verify(
> +	struct xfs_buf		*bp,
> +	struct xfs_da3_blkinfo	*hdr3)
> +{
> +	struct xfs_mount	*mp = bp->b_target->bt_mount;
> +	struct xfs_da_blkinfo	*hdr = &hdr3->hdr;
> +
> +	if (!xfs_verify_magic(bp, hdr->magic))
> +		return __this_address;
> +
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		ASSERT(hdr3->hdr.magic == hdr->magic);
> +		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
> +			return __this_address;
> +		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
> +			return __this_address;
> +		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->lsn)))
> +			return __this_address;
> +	}
> +
> +	return 0;
> +}
> +
>  static xfs_failaddr_t
>  xfs_da3_node_verify(
>  	struct xfs_buf		*bp)
> @@ -124,25 +153,16 @@ xfs_da3_node_verify(
>  	struct xfs_da_intnode	*hdr = bp->b_addr;
>  	struct xfs_da3_icnode_hdr ichdr;
>  	const struct xfs_dir_ops *ops;
> +	xfs_failaddr_t		fa;
>  
>  	ops = xfs_dir_get_ops(mp, NULL);
>  
>  	ops->node_hdr_from_disk(&ichdr, hdr);
>  
> -	if (!xfs_verify_magic(bp, hdr->hdr.info.magic))
> -		return __this_address;
> +	fa = xfs_da3_blkinfo_verify(bp, bp->b_addr);
> +	if (fa)
> +		return fa;
>  
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> -		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
> -
> -		ASSERT(hdr3->info.hdr.magic == hdr->hdr.info.magic);
> -		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid))
> -			return __this_address;
> -		if (be64_to_cpu(hdr3->info.blkno) != bp->b_bn)
> -			return __this_address;
> -		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->info.lsn)))
> -			return __this_address;
> -	}
>  	if (ichdr.level == 0)
>  		return __this_address;
>  	if (ichdr.level > XFS_DA_NODE_MAXDEPTH)
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index 5d5bf3bffc78..bf0c53bd2e60 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -869,4 +869,6 @@ static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
>  	return 1 << (sbp->sb_blocklog + sbp->sb_dirblklog);
>  }
>  
> +xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *, struct xfs_da3_blkinfo*);

Specify parameter names in the declaration, please.

--D

> +
>  #endif /* __XFS_DA_FORMAT_H__ */
> diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> index a99ae2cd292e..094028b7b162 100644
> --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> @@ -146,21 +146,11 @@ xfs_dir3_leaf_verify(
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  	struct xfs_dir2_leaf	*leaf = bp->b_addr;
> +	xfs_failaddr_t		fa;
>  
> -	if (!xfs_verify_magic(bp, leaf->hdr.info.magic))
> -		return __this_address;
> -
> -	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> -		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
> -
> -		ASSERT(leaf3->info.hdr.magic == leaf->hdr.info.magic);
> -		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid))
> -			return __this_address;
> -		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
> -			return __this_address;
> -		if (!xfs_log_check_lsn(mp, be64_to_cpu(leaf3->info.lsn)))
> -			return __this_address;
> -	}
> +	fa = xfs_da3_blkinfo_verify(bp, bp->b_addr);
> +	if (fa)
> +		return fa;
>  
>  	return xfs_dir3_leaf_check_int(mp, NULL, NULL, leaf);
>  }
> -- 
> 2.17.2
> 
