Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 18E557F4E
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 02:43:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 048E5304039
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 00:43:51 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jI3DaGiNO3EZFE8U for <xfs@oss.sgi.com>;
	Tue, 30 Apr 2013 00:43:50 -0700 (PDT)
Date: Tue, 30 Apr 2013 17:43:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests shared/298: various fixes
Message-ID: <20130430074348.GK23072@dastard>
References: <517AE12C.2050902@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <517AE12C.2050902@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Apr 26, 2013 at 03:18:52PM -0500, Eric Sandeen wrote:
> fix shared/298:
> 
> * don't include common/config, not needed and breaks
>   stuff when $SCRATCH_DEV_POOL is defined:
>     Error: $SCRATCH_DEV should be unset when $SCRATCH_DEV_POOL is set
> * make sure xfs_io has fiemap, we'll need it
> * add -F to the xfs_io invocation, again

What's it needed for this time?

> * ignore ENOSPC errors from "garbage" loop; the only goal
>   is to fill it, ENOSPC doesn't matter.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Wondering if we should just add " -F" to $XFS_IO_PROG . . . 
> 
> diff --git a/tests/shared/298 b/tests/shared/298
> index f1a3432..e2eddda 100755
> --- a/tests/shared/298
> +++ b/tests/shared/298
> @@ -28,12 +28,12 @@ echo "QA output created by $seq"
>  status=1	# failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
> -. common/config
>  . common/rc
>  
>  _supported_fs ext4 xfs
>  _supported_os Linux
>  _require_fstrim
> +_require_xfs_io_fiemap
>  _require_fs_space $TEST_DIR 307200
>  [ "$FSTYP" = "ext4" ] && _require_dumpe2fs
>  
> @@ -49,7 +49,7 @@ _cleanup()
>  
>  get_holes()
>  {
> -	$XFS_IO_PROG -c fiemap $1 | grep hole | $SED_PROG 's/.*\[\(.*\)\.\.\(.*\)\].*/\1 \2/'
> +	$XFS_IO_PROG -F -c fiemap $1 | grep hole | $SED_PROG 's/.*\[\(.*\)\.\.\(.*\)\].*/\1 \2/'
>  }
>  
>  get_free_sectors()
> @@ -136,9 +136,10 @@ $MKFS_PROG -t $FSTYP $MKFS_OPTIONS $loop_dev &> /dev/null
>  $MOUNT_PROG $loop_dev $loop_mnt
>  
>  echo -n "Generating garbage on loop..."
> +# Goal is to fill it up, ignore any errors.
>  for i in `seq 1 10`; do
> -	mkdir $loop_mnt/$i
> -	cp -r $here/* $loop_mnt/$i
> +	mkdir $loop_mnt/$i &> /dev/null
> +	cp -r $here/* $loop_mnt/$i &> /dev/null

Can you break out of the loop once cp fails with an error? There's
no point hammering the filesystem for several loops after the first
ENOSPC occurs....

-Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
