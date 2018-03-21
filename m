Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35776 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754166AbeCUX6p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Mar 2018 19:58:45 -0400
Date: Wed, 21 Mar 2018 16:58:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] metadump/restore: don't use errno after fwrite/fread
 failures
Message-ID: <20180321235839.GO4818@magnolia>
References: <f40f7d1b-31b5-e5a0-4077-9480530ebf0d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f40f7d1b-31b5-e5a0-4077-9480530ebf0d@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Mar 21, 2018 at 06:24:09PM -0500, Eric Sandeen wrote:
> fread/fwrite don't set errno, so printing out strerror(errno)
> after a failure leads to incorrect and confusing messages:
> 
> # xfs_mdrestore pre_repair.meta pre_repair.img
> xfs_mdrestore: error reading from file: Success
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 9d62958..231adc6 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -161,7 +161,7 @@ write_index(void)
>  	 */
>  	metablock->mb_count = cpu_to_be16(cur_index);
>  	if (fwrite(metablock, (cur_index + 1) << BBSHIFT, 1, outf) != 1) {
> -		print_warning("error writing to file: %s", strerror(errno));
> +		print_warning("error writing to target file");
>  		return -errno;

return -1?

--D

>  	}
>  
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index c9d4b0c..262a385 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -93,15 +93,14 @@ perform_restore(
>  	block_buffer = (char *)metablock + block_size;
>  
>  	if (fread(block_index, block_size - sizeof(struct xfs_metablock), 1, src_f) != 1)
> -		fatal("error reading from file: %s\n", strerror(errno));
> +		fatal("error reading from metadump file\n");
>  
>  	if (block_index[0] != 0)
>  		fatal("first block is not the primary superblock\n");
>  
>  
> -	if (fread(block_buffer, mb_count << mbp->mb_blocklog,
> -			1, src_f) != 1)
> -		fatal("error reading from file: %s\n", strerror(errno));
> +	if (fread(block_buffer, mb_count << mbp->mb_blocklog, 1, src_f) != 1)
> +		fatal("error reading from metadump file\n");
>  
>  	libxfs_sb_from_disk(&sb, (xfs_dsb_t *)block_buffer);
>  
> @@ -157,7 +156,7 @@ perform_restore(
>  			break;
>  
>  		if (fread(metablock, block_size, 1, src_f) != 1)
> -			fatal("error reading from file: %s\n", strerror(errno));
> +			fatal("error reading from metadump file\n");
>  
>  		mb_count = be16_to_cpu(metablock->mb_count);
>  		if (mb_count == 0)
> @@ -167,7 +166,7 @@ perform_restore(
>  
>  		if (fread(block_buffer, mb_count << mbp->mb_blocklog,
>  								1, src_f) != 1)
> -			fatal("error reading from file: %s\n", strerror(errno));
> +			fatal("error reading from metadump file\n");
>  
>  		bytes_read += block_size + (mb_count << mbp->mb_blocklog);
>  	}
> @@ -253,7 +252,7 @@ main(
>  	}
>  
>  	if (fread(&mb, sizeof(mb), 1, src_f) != 1)
> -		fatal("error reading from file: %s\n", strerror(errno));
> +		fatal("error reading from metadump file\n");
>  	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC))
>  		fatal("specified file is not a metadata dump\n");
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
