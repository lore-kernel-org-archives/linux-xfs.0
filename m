Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B72E9C77B75
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 17:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238264AbjEWRo1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 13:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238270AbjEWRoY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 13:44:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095AC129
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 10:44:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AF4E63547
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 17:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E91C433D2;
        Tue, 23 May 2023 17:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684863855;
        bh=SjBjC4qAmbvdhcgJ+TX7rlP8elrt/pOimqBHQB+OIf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iU7RrSTQxpNqYtqdQYUPdC+lI863sEKafPRBbKpv4hqqVv+OlGUSpEeX2K/37cJci
         tIwuSIY8rbfzu/rVpusUBKqcgKate+x+gddYdLBJGtosTXKz+Eiqe4i9Vxs/QdT7z5
         4DQROxpGlbiHHnq9fvBXYIl2lfRjX1K/xiJ3ZA3BzqeZ0is7jCtl6UPtGbmRidL2hM
         LRvktWynfqjeLjIFPcmJp0DSjVOSCRoVarqyUUsLZ4qrc9Dq8NZe9q/iVLuFaWj76N
         HIS8Li3UiAZQatuBLfpKlbBHOuSY6j+hY9CHEPJ74BLO5Frq5SpmkDXMuRbuSl1D1q
         UOFgxrm9G6dHw==
Date:   Tue, 23 May 2023 10:44:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/24] mdrestore: Add open_device(), read_header() and
 show_info() functions
Message-ID: <20230523174415.GX11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-18-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-18-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:30:43PM +0530, Chandan Babu R wrote:
> This commit moves functionality associated with opening the target device,
> reading metadump header information and printing information about the
> metadump into their respective functions.

"No functional changes"?

> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  mdrestore/xfs_mdrestore.c | 114 +++++++++++++++++++++++---------------
>  1 file changed, 68 insertions(+), 46 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index de9175a08..8c847c5a3 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -40,8 +40,67 @@ print_progress(const char *fmt, ...)
>  	mdrestore.progress_since_warning = 1;
>  }
>  
> +extern int	platform_check_ismounted(char *, char *, struct stat *, int);

#include <libfrog/platform.h> ?

--D

> +
> +static int
> +open_device(
> +	char		*path,
> +	bool		*is_file)
> +{
> +	struct stat	statbuf;
> +	int		open_flags;
> +	int		fd;
> +
> +	open_flags = O_RDWR;
> +	*is_file = false;
> +
> +	if (stat(path, &statbuf) < 0)  {
> +		/* ok, assume it's a file and create it */
> +		open_flags |= O_CREAT;
> +		*is_file = true;
> +	} else if (S_ISREG(statbuf.st_mode))  {
> +		open_flags |= O_TRUNC;
> +		*is_file = true;
> +	} else  {
> +		/*
> +		 * check to make sure a filesystem isn't mounted on the device
> +		 */
> +		if (platform_check_ismounted(path, NULL, &statbuf, 0))
> +			fatal("a filesystem is mounted on target device \"%s\","
> +				" cannot restore to a mounted filesystem.\n",
> +				path);
> +	}
> +
> +	fd = open(path, open_flags, 0644);
> +	if (fd < 0)
> +		fatal("couldn't open \"%s\"\n", path);
> +
> +	return fd;
> +}
> +
> +static void read_header(struct xfs_metablock *mb, FILE *src_f)
> +{
> +	if (fread(mb, sizeof(*mb), 1, src_f) != 1)
> +		fatal("error reading from metadump file\n");
> +	if (mb->mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
> +		fatal("specified file is not a metadata dump\n");
> +}
> +
> +static void show_info(struct xfs_metablock *mb, const char *mdfile)
> +{
> +	if (mb->mb_info & XFS_METADUMP_INFO_FLAGS) {
> +		printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
> +			mdfile,
> +			mb->mb_info & XFS_METADUMP_OBFUSCATED ? "":"not ",
> +			mb->mb_info & XFS_METADUMP_DIRTYLOG ? "dirty":"clean",
> +			mb->mb_info & XFS_METADUMP_FULLBLOCKS ? "full":"zeroed");
> +	} else {
> +		printf("%s: no informational flags present\n", mdfile);
> +	}
> +}
> +
>  /*
> - * perform_restore() -- do the actual work to restore the metadump
> + * restore() -- do the actual work to restore the metadump
>   *
>   * @src_f: A FILE pointer to the source metadump
>   * @dst_fd: the file descriptor for the target file
> @@ -51,7 +110,7 @@ print_progress(const char *fmt, ...)
>   * src_f should be positioned just past a read the previously validated metablock
>   */
>  static void
> -perform_restore(
> +restore(
>  	FILE			*src_f,
>  	int			dst_fd,
>  	int			is_target_file,
> @@ -185,8 +244,6 @@ usage(void)
>  	exit(1);
>  }
>  
> -extern int	platform_check_ismounted(char *, char *, struct stat *, int);
> -
>  int
>  main(
>  	int 		argc,
> @@ -195,9 +252,7 @@ main(
>  	FILE		*src_f;
>  	int		dst_fd;
>  	int		c;
> -	int		open_flags;
> -	struct stat	statbuf;
> -	int		is_target_file;
> +	bool		is_target_file;
>  	struct xfs_metablock	mb;
>  
>  	mdrestore.show_progress = 0;
> @@ -230,8 +285,8 @@ main(
>  		usage();
>  
>  	/*
> -	 * open source and test if this really is a dump. The first metadump block
> -	 * will be passed to perform_restore() which will continue to read the
> +	 * open source and test if this really is a dump. The first metadump
> +	 * block will be passed to restore() which will continue to read the
>  	 * file from this point. This avoids rewind the stream, which causes
>  	 * restore to fail when source was being read from stdin.
>   	 */
> @@ -245,22 +300,10 @@ main(
>  			fatal("cannot open source dump file\n");
>  	}
>  
> -	if (fread(&mb, sizeof(mb), 1, src_f) != 1)
> -		fatal("error reading from metadump file\n");
> -	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
> -		fatal("specified file is not a metadata dump\n");
> +	read_header(&mb, src_f);
>  
>  	if (mdrestore.show_info) {
> -		if (mb.mb_info & XFS_METADUMP_INFO_FLAGS) {
> -			printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
> -			argv[optind],
> -			mb.mb_info & XFS_METADUMP_OBFUSCATED ? "":"not ",
> -			mb.mb_info & XFS_METADUMP_DIRTYLOG ? "dirty":"clean",
> -			mb.mb_info & XFS_METADUMP_FULLBLOCKS ? "full":"zeroed");
> -		} else {
> -			printf("%s: no informational flags present\n",
> -				argv[optind]);
> -		}
> +		show_info(&mb, argv[optind]);
>  
>  		if (argc - optind == 1)
>  			exit(0);
> @@ -269,30 +312,9 @@ main(
>  	optind++;
>  
>  	/* check and open target */
> -	open_flags = O_RDWR;
> -	is_target_file = 0;
> -	if (stat(argv[optind], &statbuf) < 0)  {
> -		/* ok, assume it's a file and create it */
> -		open_flags |= O_CREAT;
> -		is_target_file = 1;
> -	} else if (S_ISREG(statbuf.st_mode))  {
> -		open_flags |= O_TRUNC;
> -		is_target_file = 1;
> -	} else  {
> -		/*
> -		 * check to make sure a filesystem isn't mounted on the device
> -		 */
> -		if (platform_check_ismounted(argv[optind], NULL, &statbuf, 0))
> -			fatal("a filesystem is mounted on target device \"%s\","
> -				" cannot restore to a mounted filesystem.\n",
> -				argv[optind]);
> -	}
> -
> -	dst_fd = open(argv[optind], open_flags, 0644);
> -	if (dst_fd < 0)
> -		fatal("couldn't open target \"%s\"\n", argv[optind]);
> +	dst_fd = open_device(argv[optind], &is_target_file);
>  
> -	perform_restore(src_f, dst_fd, is_target_file, &mb);
> +	restore(src_f, dst_fd, is_target_file, &mb);
>  
>  	close(dst_fd);
>  	if (src_f != stdin)
> -- 
> 2.39.1
> 
