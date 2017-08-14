Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752253AbdHNMkk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Aug 2017 08:40:40 -0400
Date: Mon, 14 Aug 2017 08:40:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V2] xfs_metadump: zap stale date in DIR2_LEAF1 dirs
Message-ID: <20170814124034.GB39742@bfoster.bfoster>
References: <37cd41d1-335f-a3af-d92c-c0b4b6d1356a@redhat.com>
 <5f60ef75-8481-872e-91ac-76ea62588773@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f60ef75-8481-872e-91ac-76ea62588773@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Stefan Ring <stefanrin@gmail.com>

On Thu, Aug 10, 2017 at 02:30:10PM -0700, Eric Sandeen wrote:
> xfs_metadump attempts to zero out unused regions of metadata
> blocks to prevent data leaks when sharing metadata images.
> 
> However, Stefan Ring reported a significant number of leaked
> strings when dumping his 1T filesystem.  Based on a reduced
> metadata set, I was able to identify "leaf" directories
> (with XFS_DIR2_LEAF1_MAGIC magic) as the primary culprit;
> the region between the end of the entries array and the start
> of the bests array was not getting zeroed out.  This patch
> seems to remedy that problem.
> 
> Reported-by: Stefan Ring <stefanrin@gmail.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> V2:
> 
> - factor into new function, process_dir_leaf_block
> - add DIR3_LEAF1_MAGIC
> - don't add count+stale; count includes stale entries
> - move ltp into code block
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 3967df6..a8756d6 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -1442,6 +1442,37 @@ process_sf_attr(
>  }
>  
>  static void
> +process_dir_leaf_block(
> +	char				*block)
> +{
> +	struct xfs_dir2_leaf		*leaf;
> +	struct xfs_dir3_icleaf_hdr 	leafhdr;
> +
> +	if (!zero_stale_data)
> +		return;
> +
> +	/* Yes, this works for dir2 & dir3.  Difference is padding. */
> +	leaf = (struct xfs_dir2_leaf *)block;
> +	M_DIROPS(mp)->leaf_hdr_from_disk(&leafhdr, leaf);
> +
> +	/* Zero out space from end of ents[] to bests */
> +	if (leafhdr.magic == XFS_DIR2_LEAF1_MAGIC ||
> +	    leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) {
> +		struct xfs_dir2_leaf_tail	*ltp;
> +		__be16				*lbp;
> +		struct xfs_dir2_leaf_entry	*ents;
> +		char				*free; /* end of ents */
> +
> +		ents = M_DIROPS(mp)->leaf_ents_p(leaf);
> +		free = (char *)&ents[leafhdr.count];
> +		ltp = xfs_dir2_leaf_tail_p(mp->m_dir_geo, leaf);
> +		lbp = xfs_dir2_leaf_bests_p(ltp);
> +		memset(free, 0, (char *)lbp - free);
> +		iocur_top->need_crc = 1;
> +	}
> +}
> +
> +static void
>  process_dir_data_block(
>  	char		*block,
>  	xfs_fileoff_t	offset,
> @@ -1801,11 +1832,15 @@ process_single_fsb_objects(
>  		dp = iocur_top->data;
>  		switch (btype) {
>  		case TYP_DIR2:
> -			if (o >= mp->m_dir_geo->leafblk)
> +			if (o >= mp->m_dir_geo->freeblk) {
> +				/* TODO, zap any stale data */
>  				break;
> -
> -			process_dir_data_block(dp, o,
> +			} else if (o >= mp->m_dir_geo->leafblk) {
> +				process_dir_leaf_block(dp);
> +			} else {
> +				process_dir_data_block(dp, o,
>  					 last == mp->m_dir_geo->fsbcount);
> +			}
>  			iocur_top->need_crc = 1;
>  			break;
>  		case TYP_SYMLINK:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
