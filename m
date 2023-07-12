Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F11EB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 17:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbjGLR5M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjGLR5L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 13:57:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0CB12F
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 10:57:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E129618A0
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 17:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE262C433C7;
        Wed, 12 Jul 2023 17:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689184629;
        bh=Tfbk7owU8FXLMwdZ5Qc6yFuks5tmXLAuaMddbvVbvQw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T3B8vw+EevERkbXX9+uj5jNbZlYsL88+c6JSfgKrS9AY9bP67WDiXIC/ZmCgm1GpU
         jTiBdYt6ZISmWxJlyTU9/Ge400M4E2eMTAnihsA9+JRApNXKCqsibeNx7Wn7ipkb4i
         zFK7HIjZOuPhXz86hP39h7MOhzOwbG6xI2cxeh97yNcTUCju57RorsJHsGjZfydF2P
         MOZ7KJKCLIFwFwelVvo76Ikbqnm5tT5wvfxg370t8Vrg+J9oOGZDst2sG44vmiT15+
         yv5BooeRgv4AGy0rhqTfwqMx3xrgUsBnb+k0oUs21lqExnkjKDf2hHSbJCWj2ctm6j
         bPkp8wPqnG8Hw==
Date:   Wed, 12 Jul 2023 10:57:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 20/23] mdrestore: Introduce mdrestore v1 operations
Message-ID: <20230712175709.GP108251@frogsfrogsfrogs>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-21-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606092806.1604491-21-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 02:58:03PM +0530, Chandan Babu R wrote:
> In order to indicate the version of metadump files that they can work with,
> this commit renames read_header(), show_info() and restore() functions to
> read_header_v1(), show_info_v1() and restore_v1() respectively.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  mdrestore/xfs_mdrestore.c | 39 ++++++++++++++++++---------------------
>  1 file changed, 18 insertions(+), 21 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 5451a58b..b34eda2c 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -86,7 +86,7 @@ open_device(
>  }
>  
>  static void
> -read_header(
> +read_header_v1(
>  	void			*header,
>  	FILE			*md_fp)
>  {
> @@ -100,7 +100,7 @@ read_header(
>  }
>  
>  static void
> -show_info(
> +show_info_v1(
>  	void			*header,
>  	const char		*md_file)
>  {
> @@ -117,24 +117,14 @@ show_info(
>  	}
>  }
>  
> -/*
> - * restore() -- do the actual work to restore the metadump
> - *
> - * @src_f: A FILE pointer to the source metadump
> - * @dst_fd: the file descriptor for the target file
> - * @is_target_file: designates whether the target is a regular file
> - * @mbp: pointer to metadump's first xfs_metablock, read and verified by the caller
> - *
> - * src_f should be positioned just past a read the previously validated metablock
> - */
>  static void
> -restore(
> +restore_v1(
>  	void			*header,
>  	FILE			*md_fp,
>  	int			ddev_fd,
> -	int			is_target_file)
> +	bool			is_target_file)
>  {
> -	struct xfs_metablock	*metablock;	/* header + index + blocks */
> +	struct xfs_metablock	*metablock;
>  	struct xfs_metablock	*mbp;
>  	__be64			*block_index;
>  	char			*block_buffer;
> @@ -259,6 +249,12 @@ restore(
>  	free(metablock);
>  }
>  
> +static struct mdrestore_ops mdrestore_ops_v1 = {
> +	.read_header	= read_header_v1,
> +	.show_info	= show_info_v1,
> +	.restore	= restore_v1,
> +};
> +
>  static void
>  usage(void)
>  {
> @@ -310,9 +306,9 @@ main(
>  
>  	/*
>  	 * open source and test if this really is a dump. The first metadump
> -	 * block will be passed to restore() which will continue to read the
> -	 * file from this point. This avoids rewind the stream, which causes
> -	 * restore to fail when source was being read from stdin.
> +	 * block will be passed to mdrestore_ops->restore() which will continue
> +	 * to read the file from this point. This avoids rewind the stream,
> +	 * which causes restore to fail when source was being read from stdin.
>   	 */
>  	if (strcmp(argv[optind], "-") == 0) {
>  		src_f = stdin;
> @@ -330,16 +326,17 @@ main(
>  	switch (be32_to_cpu(magic)) {
>  	case XFS_MD_MAGIC_V1:
>  		header = &mb;
> +		mdrestore.mdrops = &mdrestore_ops_v1;
>  		break;
>  	default:
>  		fatal("specified file is not a metadata dump\n");
>  		break;
>  	}
>  
> -	read_header(header, src_f);
> +	mdrestore.mdrops->read_header(header, src_f);
>  
>  	if (mdrestore.show_info) {
> -		show_info(header, argv[optind]);
> +		mdrestore.mdrops->show_info(header, argv[optind]);
>  
>  		if (argc - optind == 1)
>  			exit(0);
> @@ -350,7 +347,7 @@ main(
>  	/* check and open target */
>  	dst_fd = open_device(argv[optind], &is_target_file);
>  
> -	restore(header, src_f, dst_fd, is_target_file);
> +	mdrestore.mdrops->restore(header, src_f, dst_fd, is_target_file);
>  
>  	close(dst_fd);
>  	if (src_f != stdin)
> -- 
> 2.39.1
> 
