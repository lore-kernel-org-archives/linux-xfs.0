Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43802 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732660AbeLTWUY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Dec 2018 17:20:24 -0500
Subject: Re: [PATCH 1/5] xfs_metadump: Extend data zapping to
 XFS_DIR{2,3}_LEAFN_MAGIC blocks
References: <20181105213145.7560-1-stefanrin@gmail.com>
 <20181105213145.7560-2-stefanrin@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <42f07e6e-3625-0b89-7506-617c12a3f40f@sandeen.net>
Date: Thu, 20 Dec 2018 16:20:22 -0600
MIME-Version: 1.0
In-Reply-To: <20181105213145.7560-2-stefanrin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>, linux-xfs@vger.kernel.org

On 11/5/18 3:31 PM, Stefan Ring wrote:
> Signed-off-by: Stefan Ring <stefanrin@gmail.com>

Sorry this took so long.  I didn't forget about you!
And I really appreciate the work.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  db/metadump.c | 27 +++++++++++++++++++++++----
>  1 file changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index cc2ae9af..97d2a490 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -1426,7 +1426,7 @@ process_dir_leaf_block(
>  	char				*block)
>  {
>  	struct xfs_dir2_leaf		*leaf;
> -	struct xfs_dir3_icleaf_hdr 	leafhdr;
> +	struct xfs_dir3_icleaf_hdr	leafhdr;
>  
>  	if (!zero_stale_data)
>  		return;
> @@ -1435,20 +1435,39 @@ process_dir_leaf_block(
>  	leaf = (struct xfs_dir2_leaf *)block;
>  	M_DIROPS(mp)->leaf_hdr_from_disk(&leafhdr, leaf);
>  
> -	/* Zero out space from end of ents[] to bests */
> -	if (leafhdr.magic == XFS_DIR2_LEAF1_MAGIC ||
> -	    leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) {
> +	switch (leafhdr.magic) {
> +	case XFS_DIR2_LEAF1_MAGIC:
> +	case XFS_DIR3_LEAF1_MAGIC: {
>  		struct xfs_dir2_leaf_tail	*ltp;
>  		__be16				*lbp;
>  		struct xfs_dir2_leaf_entry	*ents;
>  		char				*free; /* end of ents */
>  
> +		/* Zero out space from end of ents[] to bests */
>  		ents = M_DIROPS(mp)->leaf_ents_p(leaf);
>  		free = (char *)&ents[leafhdr.count];
>  		ltp = xfs_dir2_leaf_tail_p(mp->m_dir_geo, leaf);
>  		lbp = xfs_dir2_leaf_bests_p(ltp);
>  		memset(free, 0, (char *)lbp - free);
>  		iocur_top->need_crc = 1;
> +		break;
> +	}
> +	case XFS_DIR2_LEAFN_MAGIC:
> +	case XFS_DIR3_LEAFN_MAGIC: {
> +		struct xfs_dir2_leaf_entry	*ents;
> +		char				*free;
> +		int				used;
> +
> +		/* Zero out space from end of ents[] to end of block */
> +		ents = M_DIROPS(mp)->leaf_ents_p(leaf);
> +		free = (char *)&ents[leafhdr.count];
> +		used = free - (char*)leaf;
> +		memset(free, 0, mp->m_dir_geo->blksize - used);
> +		iocur_top->need_crc = 1;
> +		break;
> +	}
> +	default:
> +		break;
>  	}
>  }
>  
> 
