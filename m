Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13299EB64DA
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 17:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbjGLRqO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbjGLRqN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 13:46:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5457A1FE4
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 10:46:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6BBA6189B
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 17:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33622C433C8;
        Wed, 12 Jul 2023 17:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689183970;
        bh=QZtz9aaD0/qSqwqalKbcwgoSOgpvgJsOnVW8GStiJb4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UbgT2h26Vft3sgtn+z/gFMtRSBXtkeuWvZZuD5BTCc00L00uiMrmnNo8ozK6bchEz
         pJcUqwPOaA57eAmPjIK21KmjW/CigDa8G7er73kcPwlUZIihmw+t+EeFpbJ45cIdf3
         EBlFum+ppcTmIinZtKzjo/F/oxEo3+GmGkEb+0yeP6tgMdg7HoIn4q4uAH/smhzoO4
         8uHYfMIigFwzqNqv27uz4ykwauDHaQ+bXbNUlBgak00S7I7f33ZTnNvcc2jQcZLMhL
         aQttBMdaVbW3ng1is8SHnrJY98vGGpHwuI7SAw+nKE1Xs3Cwz3MxdFTOOKbgzPJWR7
         GoYJgJ5A1wntQ==
Date:   Wed, 12 Jul 2023 10:46:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH V2 17/23] mdrestore: Add open_device(), read_header() and
 show_info() functions
Message-ID: <20230712174609.GN108251@frogsfrogsfrogs>
References: <20230606092806.1604491-1-chandan.babu@oracle.com>
 <20230606092806.1604491-18-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606092806.1604491-18-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 02:58:00PM +0530, Chandan Babu R wrote:
> This commit moves functionality associated with opening the target device,
> reading metadump header information and printing information about the
> metadump into their respective functions. There are no functional changes made
> by this commit.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  mdrestore/xfs_mdrestore.c | 141 +++++++++++++++++++++++---------------
>  1 file changed, 85 insertions(+), 56 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 2a9527b9..61e06598 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -6,6 +6,7 @@
>  
>  #include "libxfs.h"
>  #include "xfs_metadump.h"
> +#include <libfrog/platform.h>
>  
>  static struct mdrestore {
>  	bool	show_progress;
> @@ -40,8 +41,72 @@ print_progress(const char *fmt, ...)
>  	mdrestore.progress_since_warning = true;
>  }
>  
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

	} else if (platform_check_ismounted(...)) ?

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
> +static void
> +read_header(
> +	struct xfs_metablock	*mb,
> +	FILE			*md_fp)
> +{
> +	mb->mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
> +
> +	if (fread((uint8_t *)mb + sizeof(mb->mb_magic),
> +		sizeof(*mb) - sizeof(mb->mb_magic), 1, md_fp) != 1)
> +		fatal("error reading from metadump file\n");
> +}
> +
> +static void
> +show_info(
> +	struct xfs_metablock	*mb,
> +	const char		*md_file)
> +{
> +	if (mb->mb_info & XFS_METADUMP_INFO_FLAGS) {
> +		printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
> +			md_file,
> +			mb->mb_info & XFS_METADUMP_OBFUSCATED ? "":"not ",
> +			mb->mb_info & XFS_METADUMP_DIRTYLOG ? "dirty":"clean",
> +			mb->mb_info & XFS_METADUMP_FULLBLOCKS ? "full":"zeroed");
> +	} else {
> +		printf("%s: no informational flags present\n", md_file);
> +	}
> +}
> +
>  /*
> - * perform_restore() -- do the actual work to restore the metadump
> + * restore() -- do the actual work to restore the metadump
>   *
>   * @src_f: A FILE pointer to the source metadump
>   * @dst_fd: the file descriptor for the target file
> @@ -51,9 +116,9 @@ print_progress(const char *fmt, ...)
>   * src_f should be positioned just past a read the previously validated metablock
>   */
>  static void
> -perform_restore(
> -	FILE			*src_f,
> -	int			dst_fd,
> +restore(
> +	FILE			*md_fp,
> +	int			ddev_fd,
>  	int			is_target_file,
>  	const struct xfs_metablock	*mbp)
>  {
> @@ -81,14 +146,15 @@ perform_restore(
>  	block_index = (__be64 *)((char *)metablock + sizeof(xfs_metablock_t));
>  	block_buffer = (char *)metablock + block_size;
>  
> -	if (fread(block_index, block_size - sizeof(struct xfs_metablock), 1, src_f) != 1)
> +	if (fread(block_index, block_size - sizeof(struct xfs_metablock), 1,
> +		md_fp) != 1)

Something I forgot to comment on in previous patches: Please don't
indent the second line of an if test at the same level as the if body.
It's much harder for me to distinguish the two.  Compare:

	if (fread(block_index, block_size - sizeof(struct xfs_metablock), 1,
		md_fp) != 1)
		fatal("error reading from metadump file\n");
vs:

	if (fread(block_index, block_size - sizeof(struct xfs_metablock), 1,
			md_fp) != 1)
		fatal("error reading from metadump file\n");

Also, previous patches have done things like:

	if (foocondition &&
		barcondition &&
		bazcondition)
		dosomething();

vs.

	if (foocondition &&
	    barcondition &&
	    bazcondition)
		dosomething();

The code structure is easier to see at a glance, right?  That's why the
xfs and kernel style guidelines ask for distinct indentation levels.
Please go back and fix all of that in the new code you're adding.

--D

>  		fatal("error reading from metadump file\n");
>  
>  	if (block_index[0] != 0)
>  		fatal("first block is not the primary superblock\n");
>  
>  
> -	if (fread(block_buffer, mb_count << mbp->mb_blocklog, 1, src_f) != 1)
> +	if (fread(block_buffer, mb_count << mbp->mb_blocklog, 1, md_fp) != 1)
>  		fatal("error reading from metadump file\n");
>  
>  	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
> @@ -111,7 +177,7 @@ perform_restore(
>  	if (is_target_file)  {
>  		/* ensure regular files are correctly sized */
>  
> -		if (ftruncate(dst_fd, sb.sb_dblocks * sb.sb_blocksize))
> +		if (ftruncate(ddev_fd, sb.sb_dblocks * sb.sb_blocksize))
>  			fatal("cannot set filesystem image size: %s\n",
>  				strerror(errno));
>  	} else  {
> @@ -121,7 +187,7 @@ perform_restore(
>  		off64_t		off;
>  
>  		off = sb.sb_dblocks * sb.sb_blocksize - sizeof(lb);
> -		if (pwrite(dst_fd, lb, sizeof(lb), off) < 0)
> +		if (pwrite(ddev_fd, lb, sizeof(lb), off) < 0)
>  			fatal("failed to write last block, is target too "
>  				"small? (error: %s)\n", strerror(errno));
>  	}
> @@ -134,7 +200,7 @@ perform_restore(
>  			print_progress("%lld MB read", bytes_read >> 20);
>  
>  		for (cur_index = 0; cur_index < mb_count; cur_index++) {
> -			if (pwrite(dst_fd, &block_buffer[cur_index <<
> +			if (pwrite(ddev_fd, &block_buffer[cur_index <<
>  					mbp->mb_blocklog], block_size,
>  					be64_to_cpu(block_index[cur_index]) <<
>  						BBSHIFT) < 0)
> @@ -145,7 +211,7 @@ perform_restore(
>  		if (mb_count < max_indices)
>  			break;
>  
> -		if (fread(metablock, block_size, 1, src_f) != 1)
> +		if (fread(metablock, block_size, 1, md_fp) != 1)
>  			fatal("error reading from metadump file\n");
>  
>  		mb_count = be16_to_cpu(metablock->mb_count);
> @@ -155,7 +221,7 @@ perform_restore(
>  			fatal("bad block count: %u\n", mb_count);
>  
>  		if (fread(block_buffer, mb_count << mbp->mb_blocklog,
> -								1, src_f) != 1)
> +			1, md_fp) != 1)
>  			fatal("error reading from metadump file\n");
>  
>  		bytes_read += block_size + (mb_count << mbp->mb_blocklog);
> @@ -172,7 +238,7 @@ perform_restore(
>  				 offsetof(struct xfs_sb, sb_crc));
>  	}
>  
> -	if (pwrite(dst_fd, block_buffer, sb.sb_sectsize, 0) < 0)
> +	if (pwrite(ddev_fd, block_buffer, sb.sb_sectsize, 0) < 0)
>  		fatal("error writing primary superblock: %s\n", strerror(errno));
>  
>  	free(metablock);
> @@ -185,8 +251,6 @@ usage(void)
>  	exit(1);
>  }
>  
> -extern int	platform_check_ismounted(char *, char *, struct stat *, int);
> -
>  int
>  main(
>  	int 		argc,
> @@ -195,9 +259,7 @@ main(
>  	FILE		*src_f;
>  	int		dst_fd;
>  	int		c;
> -	int		open_flags;
> -	struct stat	statbuf;
> -	int		is_target_file;
> +	bool		is_target_file;
>  	uint32_t	magic;
>  	struct xfs_metablock	mb;
>  
> @@ -231,8 +293,8 @@ main(
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
> @@ -251,10 +313,7 @@ main(
>  
>  	switch (be32_to_cpu(magic)) {
>  	case XFS_MD_MAGIC_V1:
> -		mb.mb_magic = cpu_to_be32(XFS_MD_MAGIC_V1);
> -		if (fread((uint8_t *)&mb + sizeof(mb.mb_magic),
> -			sizeof(mb) - sizeof(mb.mb_magic), 1, src_f) != 1)
> -			fatal("error reading from metadump file\n");
> +		read_header(&mb, src_f);
>  		break;
>  	default:
>  		fatal("specified file is not a metadata dump\n");
> @@ -262,16 +321,7 @@ main(
>  	}
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
> @@ -280,30 +330,9 @@ main(
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
