Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:55448 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727575AbeGSNHS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Jul 2018 09:07:18 -0400
Date: Thu, 19 Jul 2018 08:24:21 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/8] xfs: check leaf attribute block freemap in verifier
Message-ID: <20180719122421.GC25672@bfoster>
References: <153192902811.31685.11590100183112248407.stgit@magnolia>
 <153192903434.31685.282625226695514597.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153192903434.31685.282625226695514597.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <djwong@maple.djwong.org>
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org

On Wed, Jul 18, 2018 at 08:50:34AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check the leaf attribute freemap when we we're verifying the block.
> 

s/we//

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 76e90046731c..b3c19339e1b5 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -244,6 +244,8 @@ xfs_attr3_leaf_verify(
>  	struct xfs_attr_leafblock	*leaf = bp->b_addr;
>  	struct xfs_perag		*pag = bp->b_pag;
>  	struct xfs_attr_leaf_entry	*entries;
> +	uint16_t			end;
> +	int				i;
>  
>  	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
>  
> @@ -289,6 +291,22 @@ xfs_attr3_leaf_verify(
>  	/* XXX: need to range check rest of attr header values */
>  	/* XXX: hash order check? */
>  
> +	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
> +		if (ichdr.freemap[i].base > mp->m_attr_geo->blksize)
> +			return __this_address;
> +		if (ichdr.freemap[i].base & 0x3)
> +			return __this_address;

Same question as Carlos.. can you elaborate on the 0x3 magic number? (A
one-liner comment might be useful).

Brian

> +		if (ichdr.freemap[i].size > mp->m_attr_geo->blksize)
> +			return __this_address;
> +		if (ichdr.freemap[i].size & 0x3)
> +			return __this_address;
> +		end = ichdr.freemap[i].base + ichdr.freemap[i].size;
> +		if (end < ichdr.freemap[i].base)
> +			return __this_address;
> +		if (end > mp->m_attr_geo->blksize)
> +			return __this_address;
> +	}
> +
>  	return NULL;
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
