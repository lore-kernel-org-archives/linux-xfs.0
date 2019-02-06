Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:40262 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfBFRId (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Feb 2019 12:08:33 -0500
Date: Wed, 6 Feb 2019 09:08:26 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 2/9] xfs: always check magic values in on-disk byte
 order
Message-ID: <20190206170826.GN7991@magnolia>
References: <20190204145231.47034-1-bfoster@redhat.com>
 <20190204145231.47034-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190204145231.47034-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 04, 2019 at 09:52:24AM -0500, Brian Foster wrote:
> Most verifiers that check on-disk magic values convert the CPU
> endian magic value constant to disk endian to facilitate compile
> time optimization of the byte swap and reduce the need for runtime
> byte swaps in buffer verifiers. Several buffer verifiers do not
> follow this pattern. Update those verifiers for consistency.
> 
> Also fix up a random typo in the inode readahead verifier name.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c     | 2 +-
>  fs/xfs/libxfs/xfs_attr_leaf.c | 4 ++--
>  fs/xfs/libxfs/xfs_da_btree.c  | 4 ++--
>  fs/xfs/libxfs/xfs_inode_buf.c | 2 +-
>  fs/xfs/libxfs/xfs_sb.c        | 3 ++-
>  5 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index b715668886a4..48aab07e7138 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -570,7 +570,7 @@ xfs_agfl_verify(
>  
>  	if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid))
>  		return __this_address;
> -	if (be32_to_cpu(agfl->agfl_magicnum) != XFS_AGFL_MAGIC)
> +	if (agfl->agfl_magicnum != cpu_to_be32(XFS_AGFL_MAGIC))
>  		return __this_address;
>  	/*
>  	 * during growfs operations, the perag is not fully initialised,
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 2652d00842d6..e60eba7f129c 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -251,7 +251,7 @@ xfs_attr3_leaf_verify(
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
>  
> -		if (ichdr.magic != XFS_ATTR3_LEAF_MAGIC)
> +		if (hdr3->info.hdr.magic != cpu_to_be16(XFS_ATTR3_LEAF_MAGIC))
>  			return __this_address;
>  
>  		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid))
> @@ -261,7 +261,7 @@ xfs_attr3_leaf_verify(
>  		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->info.lsn)))
>  			return __this_address;
>  	} else {
> -		if (ichdr.magic != XFS_ATTR_LEAF_MAGIC)
> +		if (leaf->hdr.info.magic != cpu_to_be16(XFS_ATTR_LEAF_MAGIC))
>  			return __this_address;
>  	}
>  	/*
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 376bee94b5dd..355322688c9f 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -132,7 +132,7 @@ xfs_da3_node_verify(
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  		struct xfs_da3_node_hdr *hdr3 = bp->b_addr;
>  
> -		if (ichdr.magic != XFS_DA3_NODE_MAGIC)
> +		if (hdr3->info.hdr.magic != cpu_to_be16(XFS_DA3_NODE_MAGIC))
>  			return __this_address;
>  
>  		if (!uuid_equal(&hdr3->info.uuid, &mp->m_sb.sb_meta_uuid))
> @@ -142,7 +142,7 @@ xfs_da3_node_verify(
>  		if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr3->info.lsn)))
>  			return __this_address;
>  	} else {
> -		if (ichdr.magic != XFS_DA_NODE_MAGIC)
> +		if (hdr->hdr.info.magic != cpu_to_be16(XFS_DA_NODE_MAGIC))
>  			return __this_address;
>  	}
>  	if (ichdr.level == 0)
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 09d9c8cfa4a0..fd2df5747a3a 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -152,7 +152,7 @@ const struct xfs_buf_ops xfs_inode_buf_ops = {
>  };
>  
>  const struct xfs_buf_ops xfs_inode_buf_ra_ops = {
> -	.name = "xxfs_inode_ra",
> +	.name = "xfs_inode_ra",
>  	.verify_read = xfs_inode_buf_readahead_verify,
>  	.verify_write = xfs_inode_buf_write_verify,
>  };
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index b5a82acd7dfe..a2f52a958091 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -225,10 +225,11 @@ xfs_validate_sb_common(
>  	struct xfs_buf		*bp,
>  	struct xfs_sb		*sbp)
>  {
> +	struct xfs_dsb		*dsb = XFS_BUF_TO_SBP(bp);
>  	uint32_t		agcount = 0;
>  	uint32_t		rem;
>  
> -	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
> +	if (dsb->sb_magicnum != cpu_to_be32(XFS_SB_MAGIC)) {
>  		xfs_warn(mp, "bad magic number");
>  		return -EWRONGFS;
>  	}
> -- 
> 2.17.2
> 
