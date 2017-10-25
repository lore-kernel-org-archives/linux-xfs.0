Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20752 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932273AbdJYHBI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2017 03:01:08 -0400
Date: Wed, 25 Oct 2017 00:00:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] fiemap: Implement ranged query
Message-ID: <20171025070001.GR5483@magnolia>
References: <1508409281-7183-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508409281-7183-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Thu, Oct 19, 2017 at 01:34:41PM +0300, Nikolay Borisov wrote:
> Currently the fiemap implementation of xfs_io doesn't support making ranged
> queries. This patch implements two optional arguments which take the starting
> offset and the length of the region to be queried. The impelmentation also
> calculates printed holes as an extent for the purpose of terminating the query.
> 
> I.e. if we create a file with the following layout :
> 
> xfs_io -f -c "falloc 0 32k" -c "fpunch 0 4k" -c "fpunch 8k 4k" \
> -c "fpunch 28k 4k" -c "fiemap" fragmented-file
> 
>        H     D         H           D                    H
> |--------|--------|---------|--------------|-----------------|
> 0         4k       8k        12k            28k                32k
> 
> Then the output is :
> 
> xfs_io -c "fiemap 0 10k" fragmented-file
> fragmented-file:
> 	0: [0..7]: hole
> 	1: [8..15]: 897844104..897844111
> 	2: [16..23]: hole
> 
> xfs_io -c "fiemap 0" fragmented-file
> fragmented-file:
> 	0: [0..7]: hole
> 	1: [8..15]: 897844104..897844111
> 	2: [16..23]: hole
> 	3: [24..55]: 897844120..897844151
> 	4: [56..63]: hole
> 
> xfs_io -c "fiemap 10k 5k" fragmented-file
> fragmented-file:
> 	0: [20..23]: hole
> 	1: [24..55]: 897844120..897844151
> 
> xfs_io -c "fiemap 10k 18k" fragmented-file
> fragmented-file:
> 	0: [20..23]: hole
> 	1: [24..55]: 897844120..897844151
> 	2: [56..63]: hole
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  io/fiemap.c       | 61 ++++++++++++++++++++++++++++++++++++++++++++++---------
>  man/man8/xfs_io.8 |  5 +++--
>  2 files changed, 54 insertions(+), 12 deletions(-)
> 
> diff --git a/io/fiemap.c b/io/fiemap.c
> index e6fd66da753d..844741cb07d3 100644
> --- a/io/fiemap.c
> +++ b/io/fiemap.c
> @@ -27,6 +27,8 @@
>  
>  static cmdinfo_t fiemap_cmd;
>  static int max_extents = -1;
> +static __u64 covered_length = 0;
> +static bool range_limit = false;
>  
>  static void
>  fiemap_help(void)
> @@ -79,7 +81,7 @@ print_hole(
>  		       boff_w, _("hole"), tot_w, lstart - llast);
>  	   }
>  
> -
> +	   covered_length += BBTOB(lstart - llast);
>  }
>  
>  static int
> @@ -90,7 +92,8 @@ print_verbose(
>  	int			tot_w,
>  	int			flg_w,
>  	int			cur_extent,
> -	__u64			last_logical)
> +	__u64			last_logical,
> +	__u64			limit)
>  {
>  	__u64			lstart;
>  	__u64			llast;
> @@ -122,7 +125,7 @@ print_verbose(
>  		cur_extent++;
>  	}
>  
> -	if (cur_extent == max_extents)
> +	if (cur_extent == max_extents || (range_limit && covered_length >= limit))
>  		return 1;
>  
>  	snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:", lstart,
> @@ -140,7 +143,8 @@ print_plain(
>  	struct fiemap_extent	*extent,
>  	int			lflag,
>  	int			cur_extent,
> -	__u64			last_logical)
> +	__u64			last_logical,
> +	__u64			limit)
>  {
>  	__u64			lstart;
>  	__u64			llast;
> @@ -157,7 +161,7 @@ print_plain(
>  		cur_extent++;
>  	}
>  
> -	if (cur_extent == max_extents)
> +	if (cur_extent == max_extents || (range_limit && covered_length >= limit))

As mentioned on IRC, I don't think it's correct to compare
covered_length against limit here.   If we want to fiemap blocks 200-300
we'd issue the command "fiemap 200k 100k", after which start_offset =
200, len = 100, and stop_offset = 300.  We start the loop and
covered_length = 0, and at this point we end up comparing
(range_limit && covered_length >= limit) => (true && 0 >= 300)....

>  		return 1;
>  
>  	printf("\t%d: [%llu..%llu]: %llu..%llu", cur_extent,
> @@ -211,6 +215,7 @@ calc_print_format(
>  	}
>  }
>  
> +
>  int
>  fiemap_f(
>  	int		argc,
> @@ -231,8 +236,14 @@ fiemap_f(
>  	int		tot_w = 5;	/* 5 since its just one number */
>  	int		flg_w = 5;
>  	__u64		last_logical = 0;
> +	__u64		len = -1LL;
> +	__u64		stop_offset = -1LL;
> +	off64_t		start_offset = 0;
> +	size_t		fsblocksize, fssectsize;
>  	struct stat	st;
>  
> +	init_cvtnum(&fsblocksize, &fssectsize);
> +
>  	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
>  		switch (c) {
>  		case 'a':
> @@ -252,6 +263,27 @@ fiemap_f(
>  		}
>  	}
>  
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
> +	if (optind < argc) {
> +		off64_t length = cvtnum(fsblocksize, fssectsize, argv[optind]);
> +		if (length < 0) {
> +			printf("non-numeric len argument -- %s\n", argv[optind]);
> +			return 0;
> +		}
> +		len = length;
> +		stop_offset = start_offset + len;
> +		range_limit = true;
> +	}
> +
>  	map_size = sizeof(struct fiemap) +
>  		(EXTENT_BATCH * sizeof(struct fiemap_extent));
>  	fiemap = malloc(map_size);
> @@ -269,7 +301,7 @@ fiemap_f(
>  		memset(fiemap, 0, map_size);
>  		fiemap->fm_flags = fiemap_flags;
>  		fiemap->fm_start = last_logical;
> -		fiemap->fm_length = -1LL;
> +		fiemap->fm_length = len;

Need to shorten len as we go around the loop.

>  		fiemap->fm_extent_count = EXTENT_BATCH;
>  
>  		ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
> @@ -300,14 +332,18 @@ fiemap_f(
>  				num_printed = print_verbose(extent, foff_w,
>  							    boff_w, tot_w,
>  							    flg_w, cur_extent,
> -							    last_logical);
> +							    last_logical,
> +							    stop_offset);
>  			} else
>  				num_printed = print_plain(extent, lflag,
>  							  cur_extent,
> -							  last_logical);
> +							  last_logical,
> +							  stop_offset);
>  
>  			cur_extent += num_printed;
>  			last_logical = extent->fe_logical + extent->fe_length;
> +			if (num_printed == 2)
> +				covered_length += extent->fe_length;
>  
>  			if (extent->fe_flags & FIEMAP_EXTENT_LAST) {
>  				last = 1;
> @@ -316,6 +352,9 @@ fiemap_f(
>  
>  			if (cur_extent == max_extents)
>  				break;
> +
> +			if (range_limit && covered_length >= start_offset + len)
> +				goto out;
>  		}
>  	}
>  
> @@ -331,9 +370,11 @@ fiemap_f(
>  		return 0;
>  	}
>  
> -	if (cur_extent && last_logical < st.st_size)
> +	if (cur_extent && last_logical < st.st_size &&
> +	    (!range_limit || covered_length < start_offset + len)) {

covered_length < stop_offset?

>  		print_hole(foff_w, boff_w, tot_w, cur_extent, lflag, !vflag,
>  			   BTOBBT(last_logical), BTOBBT(st.st_size));
> +	}
>  
>  out:
>  	free(fiemap);
> @@ -348,7 +389,7 @@ fiemap_init(void)
>  	fiemap_cmd.argmin = 0;
>  	fiemap_cmd.argmax = -1;
>  	fiemap_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> -	fiemap_cmd.args = _("[-alv] [-n nx]");
> +	fiemap_cmd.args = _("[-alv] [-n nx] [start offset [len]]");

[offset [len]]

Otherwise it sounds like fiemap takes three parameters.

>  	fiemap_cmd.oneline = _("print block mapping for a file");
>  	fiemap_cmd.help = fiemap_help;
>  
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 0fd9b951199c..27f1ae163913 100644
> --- a/man/man8/xfs_io.8
> +++ b/man/man8/xfs_io.8
> @@ -295,11 +295,12 @@ Prints the block mapping for the current open file. Refer to the
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

New sentences should start on their own line, per linux-manpages custom.

(Or maybe not; we violate that plenty in xfsprogs land...)

Also, fstests testcases needed.

--D

>  .TP
>  .BI "fsmap [ \-d | \-l | \-r ] [ \-m | \-v ] [ \-n " nx " ] [ " start " ] [ " end " ]
>  Prints the mapping of disk blocks used by the filesystem hosting the current
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
