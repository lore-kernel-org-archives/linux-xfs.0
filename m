Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56374 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754131AbdHWPve (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 Aug 2017 11:51:34 -0400
Subject: Re: [PATCH 3/4] fiemap: Simplify internals of fiemap_f.
References: <5fc15693-7df3-c1bf-9f78-020eed30b567@sandeen.net>
 <1503501082-16983-1-git-send-email-nborisov@suse.com>
 <1503501082-16983-3-git-send-email-nborisov@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <17826470-3112-248e-2d89-21c6d532e2ef@sandeen.net>
Date: Wed, 23 Aug 2017 10:51:33 -0500
MIME-Version: 1.0
In-Reply-To: <1503501082-16983-3-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org

On 8/23/17 10:11 AM, Nikolay Borisov wrote:
> So far fiemap used some rather convoluted logic to terminate the iteration and
> calculate the number of extents to pass to fm_extent_count. Simplify this by:
> 
> * Get the whole number of extents that this file has and keep iterating until
> we've printed all extents
> 
> * Always use a hard-coded batch of 32 extents so we don't have to worry about
> any extra calculations

As discussed on IRC, these types of changes:

> -	if ((*cur_extent + 1) == max_extents)
> +	if (*cur_extent == max_extents)
>  		return;

are a functional change not described in the changelog above; they should be
in their own patch with their own changelog, explaining why the test was off by one,
and what this fixes.  This stuff is complex enough that it's not obvious to the
casual reader now, and certainly won't be a few years later.  ;)

Thanks,
-Eric

 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  io/fiemap.c | 37 +++++++++++++++++++++----------------
>  1 file changed, 21 insertions(+), 16 deletions(-)
> 
> diff --git a/io/fiemap.c b/io/fiemap.c
> index 30c49112e089..ef54b265ab91 100644
> --- a/io/fiemap.c
> +++ b/io/fiemap.c
> @@ -23,6 +23,8 @@
>  #include "init.h"
>  #include "io.h"
>  
> +#define EXTENT_BATCH 32
> +
>  static cmdinfo_t fiemap_cmd;
>  static const __u64 blocksize = 512;
>  static int max_extents = 0;
> @@ -95,7 +97,7 @@ print_verbose(
>  		memset(lbuf, 0, sizeof(lbuf));
>  	}
>  
> -	if ((*cur_extent + 1) == max_extents)
> +	if (*cur_extent == max_extents)
>  		return;
>  
>  	snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:", lstart,
> @@ -137,7 +139,7 @@ print_plain(
>  		(*cur_extent)++;
>  	}
>  
> -	if ((*cur_extent + 1) == max_extents)
> +	if (*cur_extent == max_extents)
>  		return;
>  
>  	printf("\t%d: [%llu..%llu]: %llu..%llu", *cur_extent,
> @@ -215,7 +217,7 @@ fiemap_f(
>  	char		**argv)
>  {
>  	struct fiemap	*fiemap;
> -	int		num_extents = 32;
> +	int		num_extents;
>  	int		last = 0;
>  	int		lflag = 0;
>  	int		vflag = 0;
> @@ -251,10 +253,15 @@ fiemap_f(
>  		}
>  	}
>  
> -	if (max_extents)
> -		num_extents = min(num_extents, max_extents);
> +	ret = get_extent_count(file->fd, last_logical, -1);
> +	if (ret < 0) {
> +		exitcode = 1;
> +		return 0;
> +	}
> +	num_extents = ret;
> +
>  	map_size = sizeof(struct fiemap) +
> -		(num_extents * sizeof(struct fiemap_extent));
> +		(EXTENT_BATCH * sizeof(struct fiemap_extent));
>  	fiemap = malloc(map_size);
>  	if (!fiemap) {
>  		fprintf(stderr, _("%s: malloc of %d bytes failed.\n"),
> @@ -265,16 +272,14 @@ fiemap_f(
>  
>  	printf("%s:\n", file->name);
>  
> -	while (!last && ((cur_extent + 1) != max_extents)) {
> -		if (max_extents)
> -			num_extents = min(num_extents,
> -					  max_extents - (cur_extent + 1));
> +	while (!last && num_extents) {
>  
> +		/* Query a batch worth of extents */
>  		memset(fiemap, 0, map_size);
>  		fiemap->fm_flags = fiemap_flags;
>  		fiemap->fm_start = last_logical;
>  		fiemap->fm_length = -1LL;
> -		fiemap->fm_extent_count = num_extents;
> +		fiemap->fm_extent_count = EXTENT_BATCH;
>  
>  		ret = ioctl(file->fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
>  		if (ret < 0) {
> @@ -307,17 +312,17 @@ fiemap_f(
>  				print_plain(extent, lflag, blocksize,
>  					    &cur_extent, &last_logical);
>  
> -			if (extent->fe_flags & FIEMAP_EXTENT_LAST) {
> +			if (extent->fe_flags & FIEMAP_EXTENT_LAST ||
> +			    cur_extent == max_extents) {
>  				last = 1;
>  				break;
>  			}
> -
> -			if ((cur_extent + 1) == max_extents)
> -				break;
>  		}
> +
> +		num_extents -= fiemap->fm_mapped_extents;
>  	}
>  
> -	if ((cur_extent + 1) == max_extents)
> +	if (cur_extent == max_extents)
>  		goto out;
>  
>  	memset(&st, 0, sizeof(st));
> 
