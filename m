Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:54498 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751555AbdHJMEm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Aug 2017 08:04:42 -0400
Date: Thu, 10 Aug 2017 22:04:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fiemap: Allow to specify range to fiemap
Message-ID: <20170810120439.GO21024@dastard>
References: <1502363264-32659-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1502363264-32659-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, sandeen@redhat.com

On Thu, Aug 10, 2017 at 02:07:44PM +0300, Nikolay Borisov wrote:
> Add 2 additional, optional, arguments to the embedded fiemap command,
> that way one can specify exact ranges to be fiemapped. This will be used
> for a btrfs test. Since the arguments are optional, omitting them just
> retains the old behavior. 
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  io/fiemap.c | 34 ++++++++++++++++++++++++++++++++--
>  1 file changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/io/fiemap.c b/io/fiemap.c
> index 75e8820..a3c0c89 100644
> --- a/io/fiemap.c
> +++ b/io/fiemap.c

Need to update the fiemap_help() text.

And a man page update.

> @@ -216,7 +216,11 @@ fiemap_f(
>  	int		flg_w = 5;
>  	__u64		blocksize = 512;
>  	__u64		last_logical = 0;
> +	__u64		len = -1LL;
>  	struct stat	st;
> +	size_t 		fsblocksize, fssectsize;
              ^

Whitespace damage.
> +
> +	init_cvtnum(&fsblocksize, &fssectsize);
>  
>  	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
>  		switch (c) {
> @@ -237,6 +241,32 @@ fiemap_f(
>  		}
>  	}
>  
> +	if (argc == optind + 2) {
> +		off64_t start_offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
> +		if (start_offset < 0) {
> +			printf("non-numeric offset argument -- %s\n", argv[optind]);
> +			return 0;
> +		}
> +		last_logical = start_offset;
> +		last_logical = strtoull(argv[optind], NULL, 10);

Ah, what?

> +
> +		optind++;
> +
> +		off64_t length = cvtnum(fsblocksize, fssectsize, argv[optind]);
> +		if (length < 0) {
> +			printf("non-numeric len argument -- %s\n", argv[optind]);
> +			return 0;
> +		}
> +		len = length;
> +	} else if (argc == optind + 1) {
> +		off64_t start_offset = cvtnum(fsblocksize, fssectsize, argv[optind]);
> +		if (last_logical < 0) {
> +			printf("non-numeric offset argument -- %s\n", argv[optind]);
> +			return 0;
> +		}
> +		last_logical = start_offset;
> +	}

Duplicate code to get start offset.

	if (optind < argc) {
		/* get start offset */
		...
		optind++
	}
	if (optind < argc) {
		/* get length */
		.....
	}

Cheers,

Dave.
> +
>  	if (max_extents)
>  		num_extents = min(num_extents, max_extents);
>  	map_size = sizeof(struct fiemap) +
> @@ -259,7 +289,7 @@ fiemap_f(
>  		memset(fiemap, 0, map_size);
>  		fiemap->fm_flags = fiemap_flags;
>  		fiemap->fm_start = last_logical;
> -		fiemap->fm_length = -1LL;
> +		fiemap->fm_length = len;
>  		fiemap->fm_extent_count = num_extents;
>  
>  		ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
> @@ -350,7 +380,7 @@ fiemap_init(void)
>  	fiemap_cmd.argmin = 0;
>  	fiemap_cmd.argmax = -1;
>  	fiemap_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
> -	fiemap_cmd.args = _("[-alv] [-n nx]");
> +	fiemap_cmd.args = _("[-alv] [-n nx] [start offset] [len]");

Given that it's {offset, len} or just {offset}, you can't have
length by itself as a parameter. i.e.

	fiemap_cmd.args = _("[-alv] [-n nx] [start offset [len]]");

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
