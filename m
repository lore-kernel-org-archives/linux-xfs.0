Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 405B6C77B75
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 17:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbjEWRtA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 13:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237814AbjEWRs5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 13:48:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EC718B
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 10:48:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF03C63570
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 17:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088C0C433D2;
        Tue, 23 May 2023 17:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684864092;
        bh=R7FYfCf/x/WUJruzBCDcuVQGUBqPKB8OGOX4djnNyDM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TuVqFvnYXI5nXEHhmVCI9tI1qx5B/kniKIoonu+XbjCCx5pbzQJvOla1GPhtr/sg7
         AFntSJ99SN7xLs4Vjk76a0FdroWAg/Ak23MJqDm8szCClSPA1Dx0gkZ5AG6Q7TFs5J
         OJOB69WkCm4oJZ628GshO1B4KzwTRc5YmYVPKwe7p9/pbM2bpyK0N3sjdkbUCYxt+Y
         iaIJL2VDJkoK0pgA02VHtk4WR3ss/ckRDWC16XNAaNjwRscxCJvxqG2edU1HMwcWyz
         AHzKHckm83nS1u0nyhPX5To/aCoM6r4D1qKm6Zod/p/WAog1k8fEAMuv5yK9BDXxbw
         ++XPQjh3KBvcw==
Date:   Tue, 23 May 2023 10:48:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/24] mdrestore: Introduce mdrestore v1 operations
Message-ID: <20230523174811.GZ11620@frogsfrogsfrogs>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
 <20230523090050.373545-20-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523090050.373545-20-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 23, 2023 at 02:30:45PM +0530, Chandan Babu R wrote:
> In order to indicate the version of metadump files that they can work with,
> this commit renames read_header(), show_info() and restore() functions to
> read_header_v1(), show_info_v1() and restore_v1() respectively.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  mdrestore/xfs_mdrestore.c | 76 ++++++++++++++++++++++-----------------
>  1 file changed, 43 insertions(+), 33 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 895e5cdab..5ec1a47b0 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -86,16 +86,26 @@ open_device(
>  	return fd;
>  }
>  
> -static void read_header(struct xfs_metablock *mb, FILE *src_f)
> +static void
> +read_header_v1(
> +	void			*header,
> +	FILE			*mdfp)
>  {
> -	if (fread(mb, sizeof(*mb), 1, src_f) != 1)
> +	struct xfs_metablock	*mb = header;
> +
> +	if (fread(mb, sizeof(*mb), 1, mdfp) != 1)
>  		fatal("error reading from metadump file\n");
>  	if (mb->mb_magic != cpu_to_be32(XFS_MD_MAGIC_V1))
>  		fatal("specified file is not a metadata dump\n");
>  }
>  
> -static void show_info(struct xfs_metablock *mb, const char *mdfile)
> +static void
> +show_info_v1(
> +	void			*header,
> +	const char		*mdfile)
>  {
> +	struct xfs_metablock	*mb = header;
> +
>  	if (mb->mb_info & XFS_METADUMP_INFO_FLAGS) {
>  		printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
>  			mdfile,
> @@ -107,24 +117,15 @@ static void show_info(struct xfs_metablock *mb, const char *mdfile)
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
> -	FILE			*src_f,
> -	int			dst_fd,
> -	int			is_target_file,
> -	const struct xfs_metablock	*mbp)
> +restore_v1(
> +	void		*header,
> +	FILE		*mdfp,
> +	int		data_fd,

Umm.  mdfp == "FILE * stream for reading the source" and "data_fd" == "fd
pointing to data device for writing the filesystem"?

I think I'd prefer md_fp and ddev_fd...

> +	bool		is_target_file)
>  {
> -	struct xfs_metablock	*metablock;	/* header + index + blocks */
> +	struct xfs_metablock	*mbp = header;
> +	struct xfs_metablock	*metablock;
>  	__be64			*block_index;
>  	char			*block_buffer;
>  	int			block_size;
> @@ -148,14 +149,15 @@ restore(
>  	block_index = (__be64 *)((char *)metablock + sizeof(xfs_metablock_t));
>  	block_buffer = (char *)metablock + block_size;
>  
> -	if (fread(block_index, block_size - sizeof(struct xfs_metablock), 1, src_f) != 1)
> +	if (fread(block_index, block_size - sizeof(struct xfs_metablock), 1,
> +			mdfp) != 1)
>  		fatal("error reading from metadump file\n");
>  
>  	if (block_index[0] != 0)
>  		fatal("first block is not the primary superblock\n");
>  
>  
> -	if (fread(block_buffer, mb_count << mbp->mb_blocklog, 1, src_f) != 1)
> +	if (fread(block_buffer, mb_count << mbp->mb_blocklog, 1, mdfp) != 1)
>  		fatal("error reading from metadump file\n");
>  
>  	libxfs_sb_from_disk(&sb, (struct xfs_dsb *)block_buffer);
> @@ -178,7 +180,7 @@ restore(
>  	if (is_target_file)  {
>  		/* ensure regular files are correctly sized */
>  
> -		if (ftruncate(dst_fd, sb.sb_dblocks * sb.sb_blocksize))
> +		if (ftruncate(data_fd, sb.sb_dblocks * sb.sb_blocksize))
>  			fatal("cannot set filesystem image size: %s\n",
>  				strerror(errno));
>  	} else  {
> @@ -188,7 +190,7 @@ restore(
>  		off64_t		off;
>  
>  		off = sb.sb_dblocks * sb.sb_blocksize - sizeof(lb);
> -		if (pwrite(dst_fd, lb, sizeof(lb), off) < 0)
> +		if (pwrite(data_fd, lb, sizeof(lb), off) < 0)
>  			fatal("failed to write last block, is target too "
>  				"small? (error: %s)\n", strerror(errno));
>  	}
> @@ -201,7 +203,7 @@ restore(
>  			print_progress("%lld MB read", bytes_read >> 20);
>  
>  		for (cur_index = 0; cur_index < mb_count; cur_index++) {
> -			if (pwrite(dst_fd, &block_buffer[cur_index <<
> +			if (pwrite(data_fd, &block_buffer[cur_index <<
>  					mbp->mb_blocklog], block_size,
>  					be64_to_cpu(block_index[cur_index]) <<
>  						BBSHIFT) < 0)
> @@ -212,7 +214,7 @@ restore(
>  		if (mb_count < max_indices)
>  			break;
>  
> -		if (fread(metablock, block_size, 1, src_f) != 1)
> +		if (fread(metablock, block_size, 1, mdfp) != 1)
>  			fatal("error reading from metadump file\n");
>  
>  		mb_count = be16_to_cpu(metablock->mb_count);
> @@ -222,7 +224,7 @@ restore(
>  			fatal("bad block count: %u\n", mb_count);
>  
>  		if (fread(block_buffer, mb_count << mbp->mb_blocklog,
> -								1, src_f) != 1)
> +				1, mdfp) != 1)
>  			fatal("error reading from metadump file\n");
>  
>  		bytes_read += block_size + (mb_count << mbp->mb_blocklog);
> @@ -239,12 +241,18 @@ restore(
>  				 offsetof(struct xfs_sb, sb_crc));
>  	}
>  
> -	if (pwrite(dst_fd, block_buffer, sb.sb_sectsize, 0) < 0)
> +	if (pwrite(data_fd, block_buffer, sb.sb_sectsize, 0) < 0)
>  		fatal("error writing primary superblock: %s\n", strerror(errno));
>  
>  	free(metablock);
>  }
>  
> +static struct mdrestore_ops mdrestore_ops_v1 = {
> +	.read_header = read_header_v1,
> +	.show_info = show_info_v1,
> +	.restore = restore_v1,
> +};
> +
>  static void
>  usage(void)
>  {
> @@ -294,9 +302,9 @@ main(
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
> @@ -308,10 +316,12 @@ main(
>  			fatal("cannot open source dump file\n");
>  	}
>  
> -	read_header(&mb, src_f);
> +	mdrestore.mdrops = &mdrestore_ops_v1;
> +
> +	mdrestore.mdrops->read_header(&mb, src_f);

Starting to wonder if it's a mistake to continue to declare a struct
xfs_metablock directly on the stack in main() but I guess I'll see what
happens when you introduce the v2 code.

--D

>  
>  	if (mdrestore.show_info) {
> -		show_info(&mb, argv[optind]);
> +		mdrestore.mdrops->show_info(&mb, argv[optind]);
>  
>  		if (argc - optind == 1)
>  			exit(0);
> @@ -322,7 +332,7 @@ main(
>  	/* check and open target */
>  	dst_fd = open_device(argv[optind], &is_target_file);
>  
> -	restore(src_f, dst_fd, is_target_file, &mb);
> +	mdrestore.mdrops->restore(&mb, src_f, dst_fd, is_target_file);
>  
>  	close(dst_fd);
>  	if (src_f != stdin)
> -- 
> 2.39.1
> 
