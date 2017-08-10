Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18307 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751914AbdHJQNb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Aug 2017 12:13:31 -0400
Date: Thu, 10 Aug 2017 09:13:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] fiemap: Allow to specify range to fiemap
Message-ID: <20170810161322.GV24087@magnolia>
References: <20170810120439.GO21024@dastard>
 <1502368241-8928-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1502368241-8928-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, sandeen@redhat.com

On Thu, Aug 10, 2017 at 03:30:41PM +0300, Nikolay Borisov wrote:
> Add 2 additional, optional, arguments to the embedded fiemap command,
> that way one can specify exact ranges to be fiemapped. This will be used
> for a btrfs test. Since the arguments are optional, omitting them just
> retains the old behavior.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> Changes since v1:
>  * Added help in man describing the new options
>  * Removed whitespace damage
>  * Simplified/dedup the code used to get the parameters in
>  * Updated one line help to indicate that len param can't exist on its own
> 
>  io/fiemap.c       | 28 ++++++++++++++++++++++++++--
>  man/man8/xfs_io.8 |  5 +++--
>  2 files changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/io/fiemap.c b/io/fiemap.c
> index 75e882057362..2a0698e9d1e9 100644
> --- a/io/fiemap.c
> +++ b/io/fiemap.c
> @@ -34,6 +34,7 @@ fiemap_help(void)
>  "\n"
>  " Example:\n"
>  " 'fiemap -v' - tabular format verbose map\n"
> +" 'fiemap 0 4k' - print fiemap extents for 0-4k range\n"
>  "\n"
>  " fiemap prints the map of disk blocks used by the current file.\n"
>  " The map lists each extent used by the file, as well as regions in the\n"
> @@ -216,7 +217,11 @@ fiemap_f(
>  	int		flg_w = 5;
>  	__u64		blocksize = 512;
>  	__u64		last_logical = 0;
> +	__u64		len = -1LL;
>  	struct stat	st;
> +	size_t		fsblocksize, fssectsize;
> +
> +	init_cvtnum(&fsblocksize, &fssectsize);
>  
>  	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
>  		switch (c) {
> @@ -237,6 +242,25 @@ fiemap_f(
>  		}
>  	}
>  
> +	if (optind < argc) {
> +		off64_t start_offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
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
> +	}
> +
>  	if (max_extents)
>  		num_extents = min(num_extents, max_extents);
>  	map_size = sizeof(struct fiemap) +
> @@ -259,7 +283,7 @@ fiemap_f(
>  		memset(fiemap, 0, map_size);
>  		fiemap->fm_flags = fiemap_flags;
>  		fiemap->fm_start = last_logical;
> -		fiemap->fm_length = -1LL;
> +		fiemap->fm_length = len;

We don't decrement len each time through the ioctl loop?  Doesn't that
cause us to request and retrieve rows for ranges we don't want?

--D

>  		fiemap->fm_extent_count = num_extents;
>  
>  		ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
> @@ -350,7 +374,7 @@ fiemap_init(void)
>  	fiemap_cmd.argmin = 0;
>  	fiemap_cmd.argmax = -1;
>  	fiemap_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> -	fiemap_cmd.args = _("[-alv] [-n nx]");
> +	fiemap_cmd.args = _("[-alv] [-n nx] [start offset [len]]");
>  	fiemap_cmd.oneline = _("print block mapping for a file");
>  	fiemap_cmd.help = fiemap_help;
>  
> diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
> index 273b9c54c52d..125db9181851 100644
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
