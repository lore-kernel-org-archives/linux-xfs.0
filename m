Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0VMfu5o118977 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 16:41:56 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	UBETDA6aYsnflliW for <xfs@oss.sgi.com>;
	Tue, 31 Jan 2012 14:41:54 -0800 (PST)
Date: Wed, 1 Feb 2012 09:41:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: several 274 fixups
Message-ID: <20120131224152.GP9090@dastard>
References: <4F271967.10308@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F271967.10308@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: WuBo <wu.bo@cn.fujitsu.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jan 30, 2012 at 04:27:51PM -0600, Eric Sandeen wrote:
> This changes quite a few things about 274 to make it more robust
> and useful.
> 
> * More comments
> * Use xfs_io for falloc (not all systems have /usr/bin/fallocate)
> * use _require_xfs_io_falloc to be sure system & fs support preallocation
> * Do not remove all of the files in $SCRATCH_MNT/ post-mkfs
> * Do not remove all of the files in $SCRATCH_MNT/ on completion
>   (this breaks e2fsck when lost+found/ goes missing)

FWIW, can't e2fsck be fixed to handle this case?

......
>  _cleanup()
>  {
>  	cd /
> -	rm -f $SCRATCH_MNT/* $tmp.*
> +	rm -f $tmp.*
>  	_scratch_unmount
>  }
>  
> @@ -46,6 +48,7 @@ _cleanup()
>  _supported_fs generic
>  _supported_os IRIX Linux
>  _require_scratch
> +_require_xfs_io_falloc
>  
>  echo "------------------------------"
>  echo "preallocation test"
> @@ -57,32 +60,39 @@ umount $SCRATCH_DEV 2>/dev/null
>  _scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
>  _scratch_mount
>  
> -rm -rf $SCRATCH_MNT/*
> -cd $SCRATCH_MNT
> -dd if=/dev/zero of=test bs=4K count=1 >/dev/null 2>&1
> +# Create a 4k file
> +dd if=/dev/zero of=$SCRATCH_MNT/test bs=4K count=1 >>$seq.full 2>&1
>  if [ $? -ne 0 ]
>  then
> -	echo "create file err"
> +	echo "create file error"
>  	status=1
>  	exit
>  fi
>  
> -fallocate -n -o 4K -l 1M test >/dev/null 2>&1
> +# Allocate 4M past EOF on that file
> +xfs_io -F -c "falloc -k 4k 4m" $SCRATCH_MNT/test >>$seq.full 2>&1
>  if [ $? -ne 0 ]
>  then
> -	echo "fallocate file err"
> +	echo "fallocate file error"
>  	status=1
>  	exit
>  fi

That whole create and falloc step can be done with one command:

xfs_io -F -c "write 0 4k" -c "falloc -k 4k 4m" $SCRATCH_MNT/test

The output of xfs_io will tell us what failed if it does.

Also, failure handling is as simple as appending:

	|| _fail "failure string"

to the command. It handles setting status appropriately, tees the
failure string to $seq.full, and tells the user to go look at
$seq.full for why the test failed. hence that 16 lines of script can
be simply replaced with these 2 lines:

xfs_io -F -c "write 0 4k" -c "falloc -k 4k 4m" $SCRATCH_MNT/test \
	>>$seq.full 2>&1 || _fail "failed to create test file"

> -dd if=/dev/zero of=tmp1 bs=1M >/dev/null 2>&1
> -dd if=/dev/zero of=tmp2 bs=4K >/dev/null 2>&1
> +# Fill the rest of the fs completely
> +dd if=/dev/zero of=$SCRATCH_MNT/tmp1 bs=1M >>$seq.full 2>&1
> +dd if=/dev/zero of=$SCRATCH_MNT/tmp2 bs=4K >>$seq.full 2>&1
>  sync
> +# Last effort, use O_SYNC
> +dd if=/dev/zero of=$SCRATCH_MNT/tmp3 bs=4K oflag=sync >>$seq.full 2>&1
> +# Save space usage info
> +echo "Post-fill space:" >> $seq.full
> +df $SCRATCH_MNT >>$seq.full 2>&1
>  
> -dd if=/dev/zero of=test seek=1 bs=4K count=2 conv=notrunc >/dev/null 2>&1
> +# Now attempt a write into all of the preallocated space 
> +dd if=/dev/zero of=$SCRATCH_MNT/test seek=1 bs=4K count=1024 conv=notrunc >>$seq.full 2>&1
>  if [ $? -ne 0 ]
>  then
> -	echo "fill prealloc range err"
> +	echo "fill prealloc range error"
>  	status=1
>  	exit
>  fi

I'd still like to see this write attempt to trigger nasty behaviours
like needing to allocate a metadata block for the extent list. I
suggested randholes, but perhaps this would be easier:

for i in `seq 1 2 1023`; do
	dd if=/dev/zero of=$SCRATCH_MNT/test seek=$i bs=4K count=1 conv=notrunc \
		>>$seq.full 2>&1 || _fail "failed to write test file"
done

which will write every second block and so only convert every second
block from unwritten to written and hence blow out the size of the
extent list and require extent map block allocation and potentially
trigger ENOSPC that way....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
