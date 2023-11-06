Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D52A3C4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 22:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbjKFWPr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 17:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233132AbjKFWPq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 17:15:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87DB1BC
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 14:15:43 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B82FC433C7;
        Mon,  6 Nov 2023 22:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699308943;
        bh=fgvuO5L0hB+twEXGinULeBkM1xNJqAlYywaEUaw9wH8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qNp2AWUNPb0fhXhuob74Avw4LTrNeQIO1N8WNtAHzlMFiGM8qcaXZnYVqqZ616T1V
         IbspyWSTmQIYsKkzbc9T4CULa51ocIi1LEJ0422UsH0pe7+UIAMlW1KHlyWWhxaFjA
         JxxgqczIetn3ZxBQ463dwhTcPjixH6hRQDUkVVShqvDbvq8Uy2/FBQxxvP6HzG+DVj
         UdER54jixGdyOrPLjgfPYyOPuBsU1naMNVlrkDRAUfrEQ001P3oP0R2LW5lO7a4ev6
         TtS+p2v0ZCu2SNi3nwLLSA8VVRM+h6XRJyUHhnrGgA7N95q469IC2h/TJ2ySa/lGFZ
         ZyvjkZcjSkGag==
Date:   Mon, 6 Nov 2023 14:15:42 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Chandan Babu R <chandanbabu@kernel.org>,
        cem@kernel.org
Subject: Re: [PATCH V4 17/21] mdrestore: Replace metadump header pointer
 argument with a union pointer
Message-ID: <20231106221542.GI1205143@frogsfrogsfrogs>
References: <20231106131054.143419-1-chandan.babu@oracle.com>
 <20231106131054.143419-18-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231106131054.143419-18-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 06, 2023 at 06:40:50PM +0530, Chandan Babu R wrote:
> From: Chandan Babu R <chandanbabu@kernel.org>
> 
> We will need two variants of read_header(), show_info() and restore() helper
> functions to support two versions of metadump formats. To this end, A future
> commit will introduce a vector of function pointers to work with the two
> metadump formats. To have a common function signature for the function
> pointers, this commit replaces the first argument of the previously listed
> function pointers from "struct xfs_metablock *" with "union
> mdrestore_headers *".
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Looks pretty straightfoward now; thanks for fixing this...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  mdrestore/xfs_mdrestore.c | 66 ++++++++++++++++++++-------------------
>  1 file changed, 34 insertions(+), 32 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index d67a0629..40de0d1e 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -8,6 +8,11 @@
>  #include "xfs_metadump.h"
>  #include <libfrog/platform.h>
>  
> +union mdrestore_headers {
> +	__be32			magic;
> +	struct xfs_metablock	v1;
> +};
> +
>  static struct mdrestore {
>  	bool	show_progress;
>  	bool	show_info;
> @@ -78,27 +83,25 @@ open_device(
>  
>  static void
>  read_header(
> -	struct xfs_metablock	*mb,
> +	union mdrestore_headers	*h,
>  	FILE			*md_fp)
>  {
> -	mb->mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
> -
> -	if (fread((uint8_t *)mb + sizeof(mb->mb_magic),
> -			sizeof(*mb) - sizeof(mb->mb_magic), 1, md_fp) != 1)
> +	if (fread((uint8_t *)&(h->v1.mb_count),
> +			sizeof(h->v1) - sizeof(h->magic), 1, md_fp) != 1)
>  		fatal("error reading from metadump file\n");
>  }
>  
>  static void
>  show_info(
> -	struct xfs_metablock	*mb,
> +	union mdrestore_headers	*h,
>  	const char		*md_file)
>  {
> -	if (mb->mb_info & XFS_METADUMP_INFO_FLAGS) {
> +	if (h->v1.mb_info & XFS_METADUMP_INFO_FLAGS) {
>  		printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
>  			md_file,
> -			mb->mb_info & XFS_METADUMP_OBFUSCATED ? "":"not ",
> -			mb->mb_info & XFS_METADUMP_DIRTYLOG ? "dirty":"clean",
> -			mb->mb_info & XFS_METADUMP_FULLBLOCKS ? "full":"zeroed");
> +			h->v1.mb_info & XFS_METADUMP_OBFUSCATED ? "":"not ",
> +			h->v1.mb_info & XFS_METADUMP_DIRTYLOG ? "dirty":"clean",
> +			h->v1.mb_info & XFS_METADUMP_FULLBLOCKS ? "full":"zeroed");
>  	} else {
>  		printf("%s: no informational flags present\n", md_file);
>  	}
> @@ -116,10 +119,10 @@ show_info(
>   */
>  static void
>  restore(
> +	union mdrestore_headers *h,
>  	FILE			*md_fp,
>  	int			ddev_fd,
> -	int			is_target_file,
> -	const struct xfs_metablock	*mbp)
> +	int			is_target_file)
>  {
>  	struct xfs_metablock	*metablock;	/* header + index + blocks */
>  	__be64			*block_index;
> @@ -131,14 +134,14 @@ restore(
>  	xfs_sb_t		sb;
>  	int64_t			bytes_read;
>  
> -	block_size = 1 << mbp->mb_blocklog;
> +	block_size = 1 << h->v1.mb_blocklog;
>  	max_indices = (block_size - sizeof(xfs_metablock_t)) / sizeof(__be64);
>  
>  	metablock = (xfs_metablock_t *)calloc(max_indices + 1, block_size);
>  	if (metablock == NULL)
>  		fatal("memory allocation failure\n");
>  
> -	mb_count = be16_to_cpu(mbp->mb_count);
> +	mb_count = be16_to_cpu(h->v1.mb_count);
>  	if (mb_count == 0 || mb_count > max_indices)
>  		fatal("bad block count: %u\n", mb_count);
>  
> @@ -152,8 +155,7 @@ restore(
>  	if (block_index[0] != 0)
>  		fatal("first block is not the primary superblock\n");
>  
> -
> -	if (fread(block_buffer, mb_count << mbp->mb_blocklog, 1, md_fp) != 1)
> +	if (fread(block_buffer, mb_count << h->v1.mb_blocklog, 1, md_fp) != 1)
>  		fatal("error reading from metadump file\n");
>  
>  	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
> @@ -200,7 +202,7 @@ restore(
>  
>  		for (cur_index = 0; cur_index < mb_count; cur_index++) {
>  			if (pwrite(ddev_fd, &block_buffer[cur_index <<
> -					mbp->mb_blocklog], block_size,
> +					h->v1.mb_blocklog], block_size,
>  					be64_to_cpu(block_index[cur_index]) <<
>  						BBSHIFT) < 0)
>  				fatal("error writing block %llu: %s\n",
> @@ -219,11 +221,11 @@ restore(
>  		if (mb_count > max_indices)
>  			fatal("bad block count: %u\n", mb_count);
>  
> -		if (fread(block_buffer, mb_count << mbp->mb_blocklog,
> +		if (fread(block_buffer, mb_count << h->v1.mb_blocklog,
>  				1, md_fp) != 1)
>  			fatal("error reading from metadump file\n");
>  
> -		bytes_read += block_size + (mb_count << mbp->mb_blocklog);
> +		bytes_read += block_size + (mb_count << h->v1.mb_blocklog);
>  	}
>  
>  	if (mdrestore.progress_since_warning)
> @@ -252,15 +254,14 @@ usage(void)
>  
>  int
>  main(
> -	int 		argc,
> -	char 		**argv)
> +	int			argc,
> +	char			**argv)
>  {
> -	FILE		*src_f;
> -	int		dst_fd;
> -	int		c;
> -	bool		is_target_file;
> -	uint32_t	magic;
> -	struct xfs_metablock	mb;
> +	union mdrestore_headers headers;
> +	FILE			*src_f;
> +	int			dst_fd;
> +	int			c;
> +	bool			is_target_file;
>  
>  	mdrestore.show_progress = false;
>  	mdrestore.show_info = false;
> @@ -307,20 +308,21 @@ main(
>  			fatal("cannot open source dump file\n");
>  	}
>  
> -	if (fread(&magic, sizeof(magic), 1, src_f) != 1)
> +	if (fread(&headers.magic, sizeof(headers.magic), 1, src_f) != 1)
>  		fatal("Unable to read metadump magic from metadump file\n");
>  
> -	switch (be32_to_cpu(magic)) {
> +	switch (be32_to_cpu(headers.magic)) {
>  	case XFS_MD_MAGIC_V1:
> -		read_header(&mb, src_f);
>  		break;
>  	default:
>  		fatal("specified file is not a metadata dump\n");
>  		break;
>  	}
>  
> +	read_header(&headers, src_f);
> +
>  	if (mdrestore.show_info) {
> -		show_info(&mb, argv[optind]);
> +		show_info(&headers, argv[optind]);
>  
>  		if (argc - optind == 1)
>  			exit(0);
> @@ -331,7 +333,7 @@ main(
>  	/* check and open target */
>  	dst_fd = open_device(argv[optind], &is_target_file);
>  
> -	restore(src_f, dst_fd, is_target_file, &mb);
> +	restore(&headers, src_f, dst_fd, is_target_file);
>  
>  	close(dst_fd);
>  	if (src_f != stdin)
> -- 
> 2.39.1
> 
