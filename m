Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52624 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752438AbeBCRcY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Feb 2018 12:32:24 -0500
Date: Sat, 3 Feb 2018 09:32:19 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_mdrestore: Don't rewind source file stream
Message-ID: <20180203173219.GE4849@magnolia>
References: <20180202202729.GC4849@magnolia>
 <1517663796-89208-1-git-send-email-marco.antonio.780@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1517663796-89208-1-git-send-email-marco.antonio.780@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Marco A Benatto <marco.antonio.780@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Feb 03, 2018 at 11:16:36AM -0200, Marco A Benatto wrote:
> Today, xfs_mdrestore from stdin will fail if the -i flag is
> specified, because it attempts to rewind the stream after
> the initial read of the metablock.  This fails, and
> results in an abort with "specified file is not a metadata
> dump."
> 
> Read the metablock exactly once in main(), validate the magic,
> print informational flags if requested, and then pass it to
> perform_restore() which will then continue the restore process.
> 
> Reported-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Marco A Benatto <marco.antonio.780@gmail.com>
> ---
>  mdrestore/xfs_mdrestore.c | 55 +++++++++++++++++++++++------------------------
>  1 file changed, 27 insertions(+), 28 deletions(-)
> 
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 0bb4ac8..3db740d 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -51,35 +51,34 @@ print_progress(const char *fmt, ...)
>  	progress_since_warning = 1;
>  }
>  
> +/*
> + * perform_restore() -- do the actual work to restore the metadump 
> + *
> + * @src_f: A FILE pointer to the source metadump
> + * @dst_fd: the file descriptor for the target file
> + * @is_target_file: designates whether the target is a regular file
> + * @mbp: pointer to metadump's first xfs_metablock, read and verified by the caller
> + *  
> + * src_f should be positioned just past a read the previously validated metablock
> + */
>  static void
>  perform_restore(
>  	FILE			*src_f,
>  	int			dst_fd,
> -	int			is_target_file)
> +	int			is_target_file,
> +	const struct xfs_metablock	*mbp)
>  {
> -	xfs_metablock_t 	*metablock;	/* header + index + blocks */
> +	struct xfs_metablock 	*metablock, tmb;	/* header + index + blocks */
>  	__be64			*block_index;
>  	char			*block_buffer;
>  	int			block_size;
>  	int			max_indices;
>  	int			cur_index;
>  	int			mb_count;
> -	xfs_metablock_t		tmb;
>  	xfs_sb_t		sb;
>  	int64_t			bytes_read;
>  
> -	/*
> -	 * read in first blocks (superblock 0), set "inprogress" flag for it,
> -	 * read in the rest of the file, and if complete, clear SB 0's
> -	 * "inprogress flag"
> -	 */
> -
> -	if (fread(&tmb, sizeof(tmb), 1, src_f) != 1)
> -		fatal("error reading from file: %s\n", strerror(errno));
> -
> -	if (be32_to_cpu(tmb.mb_magic) != XFS_MD_MAGIC)
> -		fatal("specified file is not a metadata dump\n");
> -
> +	tmb = *mbp;
>  	block_size = 1 << tmb.mb_blocklog;

Why not avoid the structure copy and dereference the pointer directly?

block_size = 1 << mbp->mb_blocklog;

etc.

>  	max_indices = (block_size - sizeof(xfs_metablock_t)) / sizeof(__be64);
>  
> @@ -211,6 +210,7 @@ main(
>  	int		open_flags;
>  	struct stat	statbuf;
>  	int		is_target_file;
> +	xfs_metablock_t		mb;

struct xfs_metablock	mb;

--D

>  
>  	progname = basename(argv[0]);
>  
> @@ -237,7 +237,12 @@ main(
>  	if (!show_info && argc - optind != 2)
>  		usage();
>  
> -	/* open source */
> +	/*
> +	 * open source and test if this really is a dump. The first metadump block
> +	 * will be passed to perform_restore() which will continue to read the
> +	 * file from this point. This avoids rewind the stream, which causes
> +	 * restore to fail when source was being read from stdin.
> + 	 */
>  	if (strcmp(argv[optind], "-") == 0) {
>  		src_f = stdin;
>  		if (isatty(fileno(stdin)))
> @@ -248,15 +253,12 @@ main(
>  			fatal("cannot open source dump file\n");
>  	}
>  
> -	if (show_info) {
> -		xfs_metablock_t		mb;
> -
> -		if (fread(&mb, sizeof(mb), 1, src_f) != 1)
> -			fatal("error reading from file: %s\n", strerror(errno));
> -
> -		if (be32_to_cpu(mb.mb_magic) != XFS_MD_MAGIC)
> -			fatal("specified file is not a metadata dump\n");
> +	if (fread(&mb, sizeof(mb), 1, src_f) != 1)
> +		fatal("error reading from file: %s\n", strerror(errno));
> +	if (mb.mb_magic != cpu_to_be32(XFS_MD_MAGIC))
> +		fatal("specified file is not a metadata dump\n");
>  
> +	if (show_info) {
>  		if (mb.mb_info & XFS_METADUMP_INFO_FLAGS) {
>  			printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
>  			argv[optind],
> @@ -270,9 +272,6 @@ main(
>  
>  		if (argc - optind == 1)
>  			exit(0);
> -
> -		/* Go back to the beginning for the restore function */
> -		fseek(src_f, 0L, SEEK_SET);
>  	}
>  
>  	optind++;
> @@ -301,7 +300,7 @@ main(
>  	if (dst_fd < 0)
>  		fatal("couldn't open target \"%s\"\n", argv[optind]);
>  
> -	perform_restore(src_f, dst_fd, is_target_file);
> +	perform_restore(src_f, dst_fd, is_target_file, &mb);
>  
>  	close(dst_fd);
>  	if (src_f != stdin)
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
