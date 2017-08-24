Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55784 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753288AbdHXQEA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 12:04:00 -0400
Subject: Re: [PATCH 6/6] fiemap: Fix semantics of max_extents (-n arguments)
References: <1503575272-28263-1-git-send-email-nborisov@suse.com>
 <1503575272-28263-7-git-send-email-nborisov@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <53c70cbc-1c81-0fc3-6ef8-a9fdd98d89c0@sandeen.net>
Date: Thu, 24 Aug 2017 11:03:58 -0500
MIME-Version: 1.0
In-Reply-To: <1503575272-28263-7-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>, linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com

On 8/24/17 6:47 AM, Nikolay Borisov wrote:
> Currently the semantics of the -n argument are a bit idiosyncratic. We want the
> argument to be the limit of extents that are going to be output by the tool. This
> is clearly broken now as evident from the following example on a fragmented file:
> 
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

In my testing, for a bare fiemap (no -n) we get here with
cur_extent == max_extents == 0 and so nothing happens:

# xfs_io -c fiemap testfile
testfile:
#

(this causes every xfstest which invokes fiemap to fail).

I think initializing max_extents to -1 is a simple way to fix this.

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
                       ^ extra space ;)

Thanks,
-Eric


>  		goto out;
>  
>  	memset(&st, 0, sizeof(st));
> 
