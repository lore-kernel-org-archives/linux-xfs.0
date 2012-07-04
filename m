Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6439ZEa157346 for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 22:09:35 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id xsIZGybGMkuLsDaL for <xfs@oss.sgi.com>;
	Tue, 03 Jul 2012 20:09:34 -0700 (PDT)
Message-ID: <4FF3B3EE.30005@sandeen.net>
Date: Tue, 03 Jul 2012 22:09:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: common.attr: get block size of test fs not
	root fs
References: <1341226215-16674-1-git-send-email-eguan@redhat.com>
In-Reply-To: <1341226215-16674-1-git-send-email-eguan@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On 7/2/12 5:50 AM, Eryu Guan wrote:
> stat -f $TEST_DEV shows block size of the fs where $TEST_DEV
> resides, usually it is the root fs. This will fail 020 on non-4096 block
> size ext2/3/4, also 4096 block size ext2/3/4 on ppc64.
> 
> Instead, stat -f $TEST_DIR will show block size of the fs to be tested.
> 
> Tested and passed on ext2/3/4, xfs, btrfs with all supported block size.
> 
> Cc: Eric Sandeen <esandeen@redhat.com>
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Whoops, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

I'll merge it shortly

> ---
>  common.attr |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/common.attr b/common.attr
> index 0f1e789..6e2c004 100644
> --- a/common.attr
> +++ b/common.attr
> @@ -187,7 +187,7 @@ _sort_getfattr_output()
>  if [ "$FSTYP" == "xfs" -o "$FSTYP" == "udf" ]; then
>  	MAX_ATTRS=1000
>  else # Assume max ~1 block of attrs
> -	BLOCK_SIZE=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
> +	BLOCK_SIZE=`stat -f $TEST_DIR | grep "Block size" | cut -d " " -f3`
>  	# user.attribute_XXX="value.XXX" is about 32 bytes; leave some overhead
>  	let MAX_ATTRS=$BLOCK_SIZE/40
>  fi
> @@ -198,7 +198,7 @@ export MAX_ATTRS
>  if [ "$FSTYP" == "xfs" -o "$FSTYP" == "udf" -o "$FSTYP" == "btrfs" ]; then
>  	MAX_ATTRVAL_SIZE=64
>  else # Assume max ~1 block of attrs
> -	BLOCK_SIZE=`stat -f $TEST_DEV | grep "Block size" | cut -d " " -f3`
> +	BLOCK_SIZE=`stat -f $TEST_DIR | grep "Block size" | cut -d " " -f3`
>  	# leave a little overhead
>  	let MAX_ATTRVAL_SIZE=$BLOCK_SIZE-256
>  fi
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
