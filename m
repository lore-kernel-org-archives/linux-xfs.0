Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B98837CA0
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 07:06:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 70D4D30404E
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 05:06:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0Ubiv5N1DnY4TDhC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 May 2016 05:06:16 -0700 (PDT)
Date: Thu, 5 May 2016 08:06:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] metadump: limit permissible sector sizes
Message-ID: <20160505120613.GA22575@bfoster.bfoster>
References: <4914cb9b-be04-94e3-91cf-c1bb71aa37c3@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4914cb9b-be04-94e3-91cf-c1bb71aa37c3@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, May 04, 2016 at 03:42:38PM -0500, Eric Sandeen wrote:
> A metadump is composed of many metablocks, which have the format:
> 
> [header|indices][ ... disk sectors ... ]
> 
> where "disk sectors" are BBSIZE (512) blocks, and the (indices)
> indicate where those disk sectors should land in the restored
> image.
> 
> The header+indices fit within a single BBSIZE sector, and as such
> the number of indices is limited to:
> 
>  num_indices = (BBSIZE - sizeof(xfs_metablock_t)) / sizeof(__be64);
> 
> In practice, this works out to 63 indices; sadly 64 are required
> to store a 32k metadata chunk, if the filesystem was created with
> XFS_MAX_SECTORSIZE.  This leads to more sadness later on, as we
> index past arrays etc.
> 
> For now, just refuse to create a metadump from a 32k sector
> filesystem; that's largely just theoretical at this point anyway.
> 
> Also check this on mdrestore, and check the lower bound as well;
> the AFL fuzzer showed that interesting things happen when the
> metadump image claims to contain a sector size of 0.
> 
> Oh, and spell "indices" correctly while we're at it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Couple nits...

> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 26a3bd5..f366f86 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -66,7 +66,7 @@ static xfs_metablock_t 	*metablock;	/* header + index + buffers */
>  static __be64		*block_index;
>  static char		*block_buffer;
>  
> -static int		num_indicies;
> +static int		num_indices;
>  static int		cur_index;
>  
>  static xfs_ino_t	cur_ino;
> @@ -147,7 +147,7 @@ print_progress(const char *fmt, ...)
>   * A complete dump file will have a "zero" entry in the last index block,
>   * even if the dump is exactly aligned, the last index will be full of
>   * zeros. If the last index entry is non-zero, the dump is incomplete.
> - * Correspondingly, the last chunk will have a count < num_indicies.
> + * Correspondingly, the last chunk will have a count < num_indices.
>   *
>   * Return 0 for success, -1 for failure.
>   */
> @@ -164,7 +164,7 @@ write_index(void)
>  		return -errno;
>  	}
>  
> -	memset(block_index, 0, num_indicies * sizeof(__be64));
> +	memset(block_index, 0, num_indices * sizeof(__be64));
>  	cur_index = 0;
>  	return 0;
>  }
> @@ -184,7 +184,7 @@ write_buf_segment(
>  	for (i = 0; i < len; i++, off++, data += BBSIZE) {
>  		block_index[cur_index] = cpu_to_be64(off);
>  		memcpy(&block_buffer[cur_index << BBSHIFT], data, BBSIZE);
> -		if (++cur_index == num_indicies) {
> +		if (++cur_index == num_indices) {
>  			ret = write_index();
>  			if (ret)
>  				return -EIO;
> @@ -2656,7 +2656,19 @@ metadump_f(
>  
>  	block_index = (__be64 *)((char *)metablock + sizeof(xfs_metablock_t));
>  	block_buffer = (char *)metablock + BBSIZE;
> -	num_indicies = (BBSIZE - sizeof(xfs_metablock_t)) / sizeof(__be64);
> +	num_indices = (BBSIZE - sizeof(xfs_metablock_t)) / sizeof(__be64);
> +
> +	/*
> +	 * A metadump block can hold at most num_indices of BBSIZE sectors;
> +	 * do not try to dump a filesystem with a sector size which does not
> +	 * fit within num_indices (i.e. within a single metablock).
> +	 */
> +	if (mp->m_sb.sb_sectsize > num_indices * BBSIZE) {
> +		print_warning("Cannot dump filesystem with sector size %u",
> +			      mp->m_sb.sb_sectsize);
> +		return 0;
> +	}
> +

I know we're exiting, but we should probably free metablock here (as the
subsequent error checks do).

>  	cur_index = 0;
>  	start_iocur_sp = iocur_sp;
>  
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 70a160c..3ac3e89 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -60,7 +60,7 @@ perform_restore(
>  	__be64			*block_index;
>  	char			*block_buffer;
>  	int			block_size;
> -	int			max_indicies;
> +	int			max_indices;
>  	int			cur_index;
>  	int			mb_count;
>  	xfs_metablock_t		tmb;
> @@ -80,14 +80,14 @@ perform_restore(
>  		fatal("specified file is not a metadata dump\n");
>  
>  	block_size = 1 << tmb.mb_blocklog;
> -	max_indicies = (block_size - sizeof(xfs_metablock_t)) / sizeof(__be64);
> +	max_indices = (block_size - sizeof(xfs_metablock_t)) / sizeof(__be64);
>  
> -	metablock = (xfs_metablock_t *)calloc(max_indicies + 1, block_size);
> +	metablock = (xfs_metablock_t *)calloc(max_indices + 1, block_size);
>  	if (metablock == NULL)
>  		fatal("memory allocation failure\n");
>  
>  	mb_count = be16_to_cpu(tmb.mb_count);
> -	if (mb_count == 0 || mb_count > max_indicies)
> +	if (mb_count == 0 || mb_count > max_indices)
>  		fatal("bad block count: %u\n", mb_count);
>  
>  	block_index = (__be64 *)((char *)metablock + sizeof(xfs_metablock_t));
> @@ -109,6 +109,16 @@ perform_restore(
>  	if (sb.sb_magicnum != XFS_SB_MAGIC)
>  		fatal("bad magic number for primary superblock\n");
>  
> +	/*
> +	 * Normally the upper bound would be simply XFS_MAX_SECTORSIZE
> +	 * but the metadump format has a maximum number of BBSIZE blocks
> +	 * it can store in a single metablock.
> +	 */
> +	if (sb.sb_sectsize < XFS_MIN_SECTORSIZE ||
> +	    sb.sb_sectsize > XFS_MAX_SECTORSIZE ||
> +	    sb.sb_sectsize > max_indices * block_size) 

Trailing whitespace above.

With those fixed:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +		fatal("bad sector size %u in metadump image\n", sb.sb_sectsize);
> +
>  	((xfs_dsb_t*)block_buffer)->sb_inprogress = 1;
>  
>  	if (is_target_file)  {
> @@ -144,7 +154,7 @@ perform_restore(
>  					be64_to_cpu(block_index[cur_index]) << BBSHIFT,
>  					strerror(errno));
>  		}
> -		if (mb_count < max_indicies)
> +		if (mb_count < max_indices)
>  			break;
>  
>  		if (fread(metablock, block_size, 1, src_f) != 1)
> @@ -153,7 +163,7 @@ perform_restore(
>  		mb_count = be16_to_cpu(metablock->mb_count);
>  		if (mb_count == 0)
>  			break;
> -		if (mb_count > max_indicies)
> +		if (mb_count > max_indices)
>  			fatal("bad block count: %u\n", mb_count);
>  
>  		if (fread(block_buffer, mb_count << tmb.mb_blocklog,
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
