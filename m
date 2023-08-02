Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F50EB64DD
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Aug 2023 00:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbjHBABv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Aug 2023 20:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjHBABt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Aug 2023 20:01:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EA9170D
        for <linux-xfs@vger.kernel.org>; Tue,  1 Aug 2023 17:01:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9F496177E
        for <linux-xfs@vger.kernel.org>; Wed,  2 Aug 2023 00:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEA1C433C8;
        Wed,  2 Aug 2023 00:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690934507;
        bh=oxUpTF3xrTZiumyUegpRbF8+GuLMr0VI/wefCsUFxIc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qnc+HxmA8jXEsZGZkQxiN7FSovYSQi7Zht9EHJOVwih5BqhhhRUfYzkDQCsWE48nu
         8/Ri0VMC0Vc+3TE7ra6DJbGJ7pfw2Lz+BxPdQw7Z1pDIUXyB4IOVL0YGtNnAOZEr7J
         huci7UIKrBaiYCoTMNorCj2+2PDleUD/deuIUo52Mly2X6t3mOxeE6+BECEPEXKONP
         RmzRXWneYj2vARITx6ftdYpv3H3vcw1Nl1LEoBl8eTqy3pEEa6jRe3YMppu8eMhGNt
         ugE75hYyvfX6xOKHBpk41+pFhj7NqcpANzv4SFGia2M3e9y79IfqEWS6qZm5NRkieE
         mc04akHAw914g==
Date:   Tue, 1 Aug 2023 17:01:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V3 19/23] mdrestore: Replace metadump header pointer
 argument with a union pointer
Message-ID: <20230802000146.GE11336@frogsfrogsfrogs>
References: <20230724043527.238600-1-chandan.babu@oracle.com>
 <20230724043527.238600-20-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230724043527.238600-20-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 24, 2023 at 10:05:23AM +0530, Chandan Babu R wrote:
> We will need two variants of read_header(), show_info() and restore() helper
> functions to support two versions of metadump formats. To this end, A future
> commit will introduce a vector of function pointers to work with the two
> metadump formats. To have a common function signature for the function
> pointers, this commit replaces the first argument of the previously listed
> function pointers from "struct xfs_metablock *" with "union
> mdrestore_headers *".
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

The overall code changes look fine to me, but I'm a little mystified why
the *previous* patch introduces union mdrestore_headers and the
mdrestore ops without using either of them.

IOWs, I think you could delete patch 18, move the union definition into
this patch, and move the mdrestore ops definitions that used to be in
patch 18 into patch 20.

--D

> ---
>  mdrestore/xfs_mdrestore.c | 61 +++++++++++++++++++--------------------
>  1 file changed, 29 insertions(+), 32 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 53c5f68e..4d1bbf28 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -91,27 +91,25 @@ open_device(
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
> @@ -129,10 +127,10 @@ show_info(
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
> @@ -144,14 +142,14 @@ restore(
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
> @@ -165,8 +163,7 @@ restore(
>  	if (block_index[0] != 0)
>  		fatal("first block is not the primary superblock\n");
>  
> -
> -	if (fread(block_buffer, mb_count << mbp->mb_blocklog, 1, md_fp) != 1)
> +	if (fread(block_buffer, mb_count << h->v1.mb_blocklog, 1, md_fp) != 1)
>  		fatal("error reading from metadump file\n");
>  
>  	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
> @@ -213,7 +210,7 @@ restore(
>  
>  		for (cur_index = 0; cur_index < mb_count; cur_index++) {
>  			if (pwrite(ddev_fd, &block_buffer[cur_index <<
> -					mbp->mb_blocklog], block_size,
> +					h->v1.mb_blocklog], block_size,
>  					be64_to_cpu(block_index[cur_index]) <<
>  						BBSHIFT) < 0)
>  				fatal("error writing block %llu: %s\n",
> @@ -232,11 +229,11 @@ restore(
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
> @@ -265,15 +262,14 @@ usage(void)
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
> @@ -320,20 +316,21 @@ main(
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
> @@ -344,7 +341,7 @@ main(
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
