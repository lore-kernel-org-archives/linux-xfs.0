Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44032 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932458AbdHWTMF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 Aug 2017 15:12:05 -0400
Subject: Re: [PATCH 4/4] fiemap: Add support for ranged query
References: <5fc15693-7df3-c1bf-9f78-020eed30b567@sandeen.net>
 <1503501082-16983-1-git-send-email-nborisov@suse.com>
 <1503501082-16983-4-git-send-email-nborisov@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9ad449bc-96ff-8b48-275d-1ec49f54cb50@sandeen.net>
Date: Wed, 23 Aug 2017 14:12:04 -0500
MIME-Version: 1.0
In-Reply-To: <1503501082-16983-4-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org

On 8/23/17 10:11 AM, Nikolay Borisov wrote:
> Introduce two optional arguments which can be used to perform fiemap queries
> for a particular range in a file. Those are 'offset' and 'length' they can be
> used like so:
> 
> xfs_io -c "fiemap 0 12k" - query for extents covering the first 12kb of the
> target file.
> 
> Now that such queries are supposed also modify the logic for printing the last
> hole to only cover the range which is asked. So if we ask for 0-10kb and the
> range 8k-12k is actually a whole, then limit the last whole only to this range:
> 
> So for a file which has the following contents :
> 
> |-----hole-------|-------data--------|-----hole-----|
> 0                8k                  12k            16k
> 
> The output would be:
> 
> xfs_io -c "fiemap -v 0 13k" test-dir/fragmented-file
> test-dir/fragmented-file:
>  EXT: FILE-OFFSET      BLOCK-RANGE          TOTAL FLAGS
>    0: [0..15]:         hole                    16
>    1: [16..23]:        897847296..897847303     8   0x0
>    2: [24..25]:        hole                     2
> 
> Furthermore in cases where the queried range is covered by a whole then the
> existing while() loop would have never executed, due to num_exents = 0. Fix this
> by converting it to a do {} while ()
> 
> _
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  io/fiemap.c       | 75 +++++++++++++++++++++++++++++++++++++++----------------
>  man/man8/xfs_io.8 |  6 +++--
>  2 files changed, 57 insertions(+), 24 deletions(-)
> 
> diff --git a/io/fiemap.c b/io/fiemap.c
> index ef54b265ab91..2e03a81dc57a 100644
> --- a/io/fiemap.c
> +++ b/io/fiemap.c
> @@ -27,7 +27,7 @@
>  
>  static cmdinfo_t fiemap_cmd;
>  static const __u64 blocksize = 512;
> -static int max_extents = 0;
> +static int max_extents = -1;
>  
>  static void
>  fiemap_help(void)
> @@ -38,6 +38,7 @@ fiemap_help(void)
>  "\n"
>  " Example:\n"
>  " 'fiemap -v' - tabular format verbose map\n"
> +" 'fiemap 0 4k' - print fiemap extents for 0-4k range\n"
>  "\n"
>  " fiemap prints the map of disk blocks used by the current file.\n"
>  " The map lists each extent used by the file, as well as regions in the\n"
> @@ -231,9 +232,14 @@ fiemap_f(
>  	int		boff_w = 16;
>  	int		tot_w = 5;	/* 5 since its just one number */
>  	int		flg_w = 5;
> -	__u64		last_logical = 0;
> +	__u64		start_offset = 0, last_logical = 0;
> +	__u64		len = -1;
> +	__u64		end_offset = 0, llast;
> +	size_t		fsblocksize, fssectsize;
>  	struct stat	st;
>  
> +	init_cvtnum(&fsblocksize, &fssectsize);
> +
>  	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
>  		switch (c) {
>  		case 'a':
> @@ -253,7 +259,41 @@ fiemap_f(
>  		}
>  	}
>  
> -	ret = get_extent_count(file->fd, last_logical, -1);
> +
> +	if (optind < argc) {
> +	        off64_t start = cvtnum(fsblocksize, fssectsize, argv[optind]);
> +	        if (start_offset < 0) {

This is testing the wrong var.

Ok, I got totally distracted on this; looking to see if it can't just be
cleaned up wholesale... it's still so full of weird special cases :/

-Eric
