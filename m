Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92BFEB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 17:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjGLRz2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjGLRz1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 13:55:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823A2199E
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 10:55:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16F4F618A2
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 17:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B0CC433C7;
        Wed, 12 Jul 2023 17:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689184525;
        bh=jPQDrpmflYyeuuHM1TQ3ckEQgItfwaZU1GHjKsJTPlc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tPJ8/qI8zdrbr1ZK+QETMsyv1/jxuuGeqF/ZOlKqj+LQNmUrcjgFdrUcJLMhrYM99
         sqy5K0l6SP+SEoqpqjm+OsIPPDA4Ao/8KI1Ax2yck2cIT4jrpLGOBc5mOoI6fOelh3
         723qc3khP1N8TYsZUJqN9LrorLZ1d0XuC8HEiNlJzz8pBa9FbGjuTFyLE7tDpf8KMI
         MOPOutF+76RtnVVcB4Dre8ufyYmSERzcXWc72HOVoezm1w61h/bSeg43x1Ngcn+S9n
         szgYkF79/KYcfCJvaRQ2SYUbmpzTk/fCXvcws8bQuEBgCZ4y1ggsa+NG6Y05GErISC
         P2nFVVC3oZ8yA==
Date:   Wed, 12 Jul 2023 10:55:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 19/23] mdrestore: Replace metadump header pointer
 argument with generic pointer type
Message-ID: <20230712175524.GO108251@frogsfrogsfrogs>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-20-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606092806.1604491-20-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 02:58:02PM +0530, Chandan Babu R wrote:
> We will need two variants of read_header(), show_info() and restore() helper
> functions to support two versions of metadump formats. To this end, A future
> commit will introduce a vector of function pointers to work with the two
> metadump formats. To have a common function signature for the function
> pointers, this commit replaces the first argument of the previously listed
> function pointers from "struct xfs_metablock *" with "void *".
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  mdrestore/xfs_mdrestore.c | 24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 08f52527..5451a58b 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -87,9 +87,11 @@ open_device(
>  
>  static void
>  read_header(
> -	struct xfs_metablock	*mb,
> +	void			*header,

Should we be using a union here instead of a generic void pointer?

union xfs_mdrestore_headers {
	__be32				magic;
	struct xfs_metablock		v1;
	struct xfs_metadump_header	v2;
};

Then you can do:

	union xfs_mdrestore_headers	headers;

	fread(&headers.magic, sizeof(headers.magic), 1, md_fp));

	switch (be32_to_cpu(headers.magic)) {
	case XFS_MD_MAGIC_V1:
		ret = dosomething_v1(&headers, ...);
		break;
	case XFS_MD_MAGIC_V2:
		ret = dosomething_v2(&headers, ...);
		break;

And there'll be at least *some* typechecking going on here.

>  	FILE			*md_fp)
>  {
> +	struct xfs_metablock	*mb = header;
> +
>  	mb->mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);

And no need for the casting:

static void
read_header_v1(
	union xfs_mdrestore_headers	*h,
	FILE				*md_fp)
{
	fread(&h->v1.mb_count, sizeof(h->v1.mb_count), 1, md_fp);
	...
}

static void
read_header_v2(
	union xfs_mdrestore_headers	*h,
	FILE				*md_fp)
{
	fread(&h->v2.xmh_version,
			sizeof(struct xfs_metadump_header) - offsetof(struct xfs_metadump_header, xmh_version),
			1, md_fp);
	...
}

--D

>  
>  	if (fread((uint8_t *)mb + sizeof(mb->mb_magic),
> @@ -99,9 +101,11 @@ read_header(
>  
>  static void
>  show_info(
> -	struct xfs_metablock	*mb,
> +	void			*header,
>  	const char		*md_file)
>  {
> +	struct xfs_metablock	*mb = header;
> +
>  	if (mb->mb_info & XFS_METADUMP_INFO_FLAGS) {
>  		printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
>  			md_file,
> @@ -125,12 +129,13 @@ show_info(
>   */
>  static void
>  restore(
> +	void			*header,
>  	FILE			*md_fp,
>  	int			ddev_fd,
> -	int			is_target_file,
> -	const struct xfs_metablock	*mbp)
> +	int			is_target_file)
>  {
>  	struct xfs_metablock	*metablock;	/* header + index + blocks */
> +	struct xfs_metablock	*mbp;
>  	__be64			*block_index;
>  	char			*block_buffer;
>  	int			block_size;
> @@ -140,6 +145,8 @@ restore(
>  	xfs_sb_t		sb;
>  	int64_t			bytes_read;
>  
> +	mbp = header;
> +
>  	block_size = 1 << mbp->mb_blocklog;
>  	max_indices = (block_size - sizeof(xfs_metablock_t)) / sizeof(__be64);
>  
> @@ -269,6 +276,7 @@ main(
>  	int		c;
>  	bool		is_target_file;
>  	uint32_t	magic;
> +	void		*header;
>  	struct xfs_metablock	mb;
>  
>  	mdrestore.show_progress = false;
> @@ -321,15 +329,17 @@ main(
>  
>  	switch (be32_to_cpu(magic)) {
>  	case XFS_MD_MAGIC_V1:
> -		read_header(&mb, src_f);
> +		header = &mb;
>  		break;
>  	default:
>  		fatal("specified file is not a metadata dump\n");
>  		break;
>  	}
>  
> +	read_header(header, src_f);
> +
>  	if (mdrestore.show_info) {
> -		show_info(&mb, argv[optind]);
> +		show_info(header, argv[optind]);
>  
>  		if (argc - optind == 1)
>  			exit(0);
> @@ -340,7 +350,7 @@ main(
>  	/* check and open target */
>  	dst_fd = open_device(argv[optind], &is_target_file);
>  
> -	restore(src_f, dst_fd, is_target_file, &mb);
> +	restore(header, src_f, dst_fd, is_target_file);
>  
>  	close(dst_fd);
>  	if (src_f != stdin)
> -- 
> 2.39.1
> 
