Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19494 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753487AbdHXRxH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2017 13:53:07 -0400
Date: Thu, 24 Aug 2017 10:51:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/6] fiemap: Fix semantics of max_extents (-n arguments)
Message-ID: <20170824175159.GH4796@magnolia>
References: <1503575272-28263-1-git-send-email-nborisov@suse.com>
 <1503575272-28263-7-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1503575272-28263-7-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, sandeen@redhat.com

On Thu, Aug 24, 2017 at 02:47:52PM +0300, Nikolay Borisov wrote:
> Currently the semantics of the -n argument are a bit idiosyncratic. We want the
> argument to be the limit of extents that are going to be output by the tool. This
> is clearly broken now as evident from the following example on a fragmented file:

Please update the documentation, since the xfs_io fiemap section refers
readers to xfs_bmap(8), which says:

"If this [-n] option is given, xfs_bmap obtains the extent list of the
file in groups of num_extents extents."

Which is no longer correct, because now -n limits the number of records
output, if I'm reading this patch correctly.  TBH I think -n for bmap is
also wrong...

The other patches leading up to this one have been
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> xfs_io -c "fiemap -v -n 5" test-dir/fragmented-file
> test-dir/fragmented-file:
>  EXT: FILE-OFFSET      BLOCK-RANGE          TOTAL FLAGS
>    0: [0..15]:         hole                    16
>    1: [16..23]:        897847296..897847303     8   0x0
>    2: [24..31]:        hole                     8
>    3: [32..39]:        897851392..897851399     8   0x0
> 
> So we want at most 5 extents printed, yet we get 4. So we always print n - 1
> extents.
> 
> With this modification the output looks like:
> 
> xfs_io -c "fiemap -v -n 5" test-dir/fragmented-file
> test-dir/fragmented-file:
>  EXT: FILE-OFFSET      BLOCK-RANGE          TOTAL FLAGS
>    0: [0..15]:         hole                    16
>    1: [16..23]:        897847296..897847303     8   0x0
>    2: [24..31]:        hole                     8
>    3: [32..39]:        897851392..897851399     8   0x0
>    4: [40..47]:        hole                     8
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  io/fiemap.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/io/fiemap.c b/io/fiemap.c
> index 44a64870d711..7b275275465d 100644
> --- a/io/fiemap.c
> +++ b/io/fiemap.c
> @@ -122,7 +122,7 @@ print_verbose(
>  		cur_extent++;
>  	}
>  
> -	if ((cur_extent + 1) == max_extents)
> +	if (cur_extent == max_extents)
>  		return 1;
>  
>  	snprintf(lbuf, sizeof(lbuf), "[%llu..%llu]:", lstart,
> @@ -157,7 +157,7 @@ print_plain(
>  		cur_extent++;
>  	}
>  
> -	if ((cur_extent + 1) == max_extents)
> +	if (cur_extent == max_extents)
>  		return 1;
>  
>  	printf("\t%d: [%llu..%llu]: %llu..%llu", cur_extent,
> @@ -264,7 +264,7 @@ fiemap_f(
>  
>  	printf("%s:\n", file->name);
>  
> -	while (!last && ((cur_extent + 1) != max_extents)) {
> +	while (!last && (cur_extent != max_extents)) {
>  
>  		memset(fiemap, 0, map_size);
>  		fiemap->fm_flags = fiemap_flags;
> @@ -314,12 +314,12 @@ fiemap_f(
>  				break;
>  			}
>  
> -			if ((cur_extent + 1) == max_extents)
> +			if (cur_extent == max_extents)
>  				break;
>  		}
>  	}
>  
> -	if ((cur_extent + 1) == max_extents)
> +	if (cur_extent  == max_extents)
>  		goto out;
>  
>  	memset(&st, 0, sizeof(st));
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
