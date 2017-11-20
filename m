Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46240 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752797AbdKTUzh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 Nov 2017 15:55:37 -0500
Date: Mon, 20 Nov 2017 14:55:32 -0600
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH] xfs_io: implement ranged fiemap query
Message-ID: <20171120205532.GA19310@redhat.com>
References: <c1bec5de-57de-a451-08b9-80376b635d28@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1bec5de-57de-a451-08b9-80376b635d28@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Nikolay Borisov <nborisov@suse.com>

On Fri, Nov 17, 2017 at 11:22:07AM -0600, Eric Sandeen wrote:
> From: Nikolay Borisov <nborisov@suse.com>
> 
> Currently the fiemap implementation of xfs_io doesn't support making ranged
> queries. This patch implements two optional arguments which take the starting
> offset and the length of the region to be queried.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> [sandeen: simplify/rewrite ranged logic]
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
> 
> I think this is a simpler approach.  There are some questions about how
> the fiemap command should handle holes and ranges, however.
> 
> First and foremost, the kernel will return any extent(s) which overlap(s)
> with the requested range.  Holes are simply inferred by xfs_io from the
> spaces in between.
> 
> So there are questions about what to do if i.e. the range starts or ends
> in a hole.
> 
> This patch (I think!) /will/ describe a hole on either side of the requested
> range, if it exists, with start and end points of the hole(s) based on
> the range start & end.  i.e. with range on boundaries:
> 
> # io/xfs_io -c "fiemap 0 12k"  alternating 
> alternating:
> 	0: [0..7]: hole
> 	1: [8..15]: 60550776..60550783
> 	2: [16..23]: hole
> 
> with range in middle of holes, hole ranges are truncated:
> 
> # io/xfs_io -c "fiemap 1k 10k"  alternating 
> alternating:
> 	0: [2..7]: hole
> 	1: [8..15]: 60550776..60550783
> 	2: [16..21]: hole
> 
> i.e. note that the first hole starts at the requested 1k range, and
> the last hole ends at the end of the requested range.
> 
> Seems reasonable?
> 
> 
> 
> diff --git a/io/fiemap.c b/io/fiemap.c
> index bdcfacd..266d134 100644
> --- a/io/fiemap.c
> +++ b/io/fiemap.c
> @@ -49,6 +49,8 @@ fiemap_help(void)
>  " -l -- also displays the length of each extent in 512-byte blocks.\n"
>  " -n -- query n extents.\n"
>  " -v -- Verbose information\n"
> +" offset is the starting offset to map, and is optional.  If offset is\n"
> +" specified, mapping length may (optionally) be specified as well."
>  "\n"));
>  }
>  
> @@ -118,7 +120,7 @@ print_verbose(
>  			flg_w, _("FLAGS"));
>  	}
>  
> -	if (lstart != llast) {
> +	if (lstart > llast) {
>  		print_hole(foff_w, boff_w, tot_w, cur_extent, 0, false, llast,
>  			   lstart);
>  		cur_extent++;
> @@ -155,7 +157,7 @@ print_plain(
>  	len = BTOBBT(extent->fe_length);
>  	block = BTOBBT(extent->fe_physical);
>  
> -	if (lstart != llast) {
> +	if (lstart > llast) {
>  		print_hole(0, 0, 0, cur_extent, lflag, true, llast, lstart);
>  		cur_extent++;
>  	}
> @@ -235,9 +237,15 @@ fiemap_f(
>  	int		boff_w = 16;
>  	int		tot_w = 5;	/* 5 since its just one number */
>  	int		flg_w = 5;
> -	__u64		last_logical = 0;
> +	__u64		last_logical = 0;	/* last extent offset handled */
> +	off64_t		start_offset = 0;	/* mapping start */
> +	off64_t		length = -1LL;		/* mapping length */
> +	off64_t		range_end = -1LL;	/* mapping end*/
> +	size_t		fsblocksize, fssectsize;
>  	struct stat	st;
>  
> +	init_cvtnum(&fsblocksize, &fssectsize);
> +
>  	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
>  		switch (c) {
>  		case 'a':
> @@ -257,6 +265,27 @@ fiemap_f(
>  		}
>  	}
>  
> +	/* Range start (optional) */
> +	if (optind < argc) {
> +		start_offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
> +		if (start_offset < 0) {
> +			printf("non-numeric offset argument -- %s\n", argv[optind]);
> +			return 0;
> +		}
> +		last_logical = start_offset;
> +		optind++;
> +	}
> +
> +	/* Range length (optional if range start was specified) */
> +	if (optind < argc) {
> +		length = cvtnum(fsblocksize, fssectsize, argv[optind]);
> +		if (length < 0) {
> +			printf("non-numeric len argument -- %s\n", argv[optind]);
> +			return 0;
> +		}
> +		range_end = start_offset + length;
> +	}
> +
>  	map_size = sizeof(struct fiemap) +
>  		(EXTENT_BATCH * sizeof(struct fiemap_extent));
>  	fiemap = malloc(map_size);
> @@ -274,7 +303,7 @@ fiemap_f(
>  		memset(fiemap, 0, map_size);
>  		fiemap->fm_flags = fiemap_flags;
>  		fiemap->fm_start = last_logical;
> -		fiemap->fm_length = -1LL;
> +		fiemap->fm_length = range_end - last_logical;
>  		fiemap->fm_extent_count = EXTENT_BATCH;
>  
>  		ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
> @@ -336,9 +365,12 @@ fiemap_f(
>  		return 0;
>  	}
>  
> -	if (cur_extent && last_logical < st.st_size)
> +	/* Print last hole to EOF or to end of requested range */
> +	range_end = min((uint64_t)range_end, st.st_size);
> +
> +	if (cur_extent && last_logical < range_end)
>  		print_hole(foff_w, boff_w, tot_w, cur_extent, lflag, !vflag,
> -			   BTOBBT(last_logical), BTOBBT(st.st_size));
> +			   BTOBBT(last_logical), BTOBBT(range_end));
>  
>  out:
>  	free(fiemap);
> @@ -353,7 +385,7 @@ fiemap_init(void)
>  	fiemap_cmd.argmin = 0;
>  	fiemap_cmd.argmax = -1;
>  	fiemap_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> -	fiemap_cmd.args = _("[-alv] [-n nx]");
> +	fiemap_cmd.args = _("[-alv] [-n nx] [offset [len]]");
>  	fiemap_cmd.oneline = _("print block mapping for a file");
>  	fiemap_cmd.help = fiemap_help;
>  
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 9bf1a47..7633734 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -304,11 +304,12 @@ Prints the block mapping for the current open file. Refer to the
>  .BR xfs_bmap (8)
>  manual page for complete documentation.
>  .TP
> -.BI "fiemap [ \-alv ] [ \-n " nx " ]"
> +.BI "fiemap [ \-alv ] [ \-n " nx " ] [ " offset " [ " len " ]]"
>  Prints the block mapping for the current open file using the fiemap
>  ioctl.  Options behave as described in the
>  .BR xfs_bmap (8)
> -manual page.
> +manual page. Optionally, this command also supports passing the start offset
> +from where to begin the fiemap and the length of that region.
>  .TP
>  .BI "fsmap [ \-d | \-l | \-r ] [ \-m | \-v ] [ \-n " nx " ] [ " start " ] [ " end " ]
>  Prints the mapping of disk blocks used by the filesystem hosting the current
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
