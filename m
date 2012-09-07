Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q87Jtc3Z191370 for <xfs@oss.sgi.com>; Fri, 7 Sep 2012 14:55:38 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id B7KsqyzViaE2PYjl for <xfs@oss.sgi.com>;
	Fri, 07 Sep 2012 12:56:38 -0700 (PDT)
Message-ID: <504A5176.5020302@sandeen.net>
Date: Fri, 07 Sep 2012 14:56:38 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V3] xfstests: make 275 pass
References: <4F04A6E6.1090304@redhat.com> <4F04BC81.1000207@redhat.com>
	<20120104231725.GB24466@dastard> <4F207079.6050401@sandeen.net>
In-Reply-To: <4F207079.6050401@sandeen.net>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, ext4 development <linux-ext4@vger.kernel.org>, Eryu Guan <eguan@redhat.com>, Zach Brown <zab@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 1/25/12 3:13 PM, Eric Sandeen wrote:
> Ok, this is a significant rework of 275, which made too many
> assumptions about details of space usage and failed on several
> filesystems (it passed on xfs, but only by accident).
> 
> This new version tries to leave about 256k free, then tries
> a single 1M IO, and fails only if 0 bytes are written.
> 
> It also sends a lot more to $seq.full for debugging on failure
> and fixes a few other stylistic things.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Poor Zach ran into this one again.  Can I get a review of this
version, and I'll merge it if it looks good?

Thanks,

-Eric

> V2: bunch of fixups from V1 ;)
> V3: use ls for size check, and 2g fs size
> 
> diff --git a/275 b/275
> index 214262e..69b2895 100755
> --- a/275
> +++ b/275
> @@ -1,8 +1,8 @@
>  #! /bin/bash
>  # FS QA Test No. 275
>  #
> -# The posix write test. when write size is larger than disk free size,
> -# should write as more as possible
> +# The posix write test.  When write size is larger than disk free size,
> +# should write as much as possible until ENOSPC.
>  #
>  #-----------------------------------------------------------------------
>  # Copyright (c) 2011-2012 Fujitsu, Inc.  All Rights Reserved.
> @@ -30,13 +30,12 @@ echo "QA output created by $seq"
>  
>  here=`pwd`
>  tmp=/tmp/$$
> -status=0    # success is the default!
> +status=1    # failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  _cleanup()
>  {
>  	cd /
> -	rm -f $SCRATCH_MNT/* $tmp.*
>  	_scratch_unmount
>  }
>  
> @@ -49,41 +48,48 @@ _supported_os IRIX Linux
>  _require_scratch
>  
>  echo "------------------------------"
> -echo "write lack test"
> +echo "write until ENOSPC test"
>  echo "------------------------------"
>  
>  rm -f $seq.full
>  
>  umount $SCRATCH_DEV 2>/dev/null
> -_scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
> +_scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
>  _scratch_mount
>  
>  rm -rf $SCRATCH_MNT/*
> -cd $SCRATCH_MNT
>  
> -dd if=/dev/zero of=tmp1 bs=4K count=1 >/dev/null 2>&1
> -if [ $? -ne 0 ]
> -then
> -	echo "create file err"
> -	status=1
> -	exit
> -fi
> +dd if=/dev/zero of=$SCRATCH_MNT/tmp1 bs=256K count=1 >>$seq.full 2>&1
> +[ $? -ne 0 ] && _fail "Error creating file"
>  
> -dd if=/dev/zero of=tmp2 bs=1M >/dev/null 2>&1
> -dd if=/dev/zero of=tmp3 bs=4K >/dev/null 2>&1
> +# Attempt to completely fill fs
> +dd if=/dev/zero of=$SCRATCH_MNT/tmp2 bs=1M >>$seq.full 2>&1
>  sync
> +dd if=/dev/zero of=$SCRATCH_MNT/tmp3 bs=4K >>$seq.full 2>&1
> +sync
> +# Last effort, use O_SYNC
> +dd if=/dev/zero of=$SCRATCH_MNT/tmp4 bs=4K oflag=sync >>$seq.full 2>&1
> +# Save space usage info to the full file
> +echo "Pre rm space:" >> $seq.full
> +df $SCRATCH_MNT >>$seq.full 2>&1
>  
> -rm -f tmp1
> +# Should leave approx 256k free
> +rm -f $SCRATCH_MNT/tmp1
>  sync
> +echo "Post rm space:" >> $seq.full
> +df $SCRATCH_MNT >>$seq.full 2>&1
> +_freespace=`df -k $SCRATCH_MNT | tail -n 1 | awk '{print $4}'`
> +[ $_freespace -gt 1024 ] && _fail "could not sufficiently fill filesystem"
> +
> +# Try a write larger than available space
> +dd if=/dev/zero of=$SCRATCH_MNT/tmp1 bs=1M count=1 >>$seq.full 2>&1
> +echo "Bytes written until ENOSPC:" >>$seq.full
> +du $SCRATCH_MNT/tmp1 >>$seq.full
>  
> -dd if=/dev/zero of=tmp1 bs=8K count=1 >/dev/null 2>&1
> -_filesize=`du tmp1 | awk '{print $1}'`
> -if [ $_filesize -ne 4 ]
> -then
> -	echo "write file err"
> -	status=1
> -	exit
> -fi
> +# And at least some of it should succeed.
> +_filesize=`ls -l $SCRATCH_MNT/tmp1 | awk '{print $5}'`
> +[ $_filesize -eq 0 ] && _fail "write file err: Partial write until enospc failed; wrote 0 bytes."
>  
>  echo "done"
> +status=0
>  exit
> diff --git a/275.out b/275.out
> index 30af43c..69b9d52 100644
> --- a/275.out
> +++ b/275.out
> @@ -1,5 +1,5 @@
>  QA output created by 275
>  ------------------------------
> -write lack test
> +write until ENOSPC test
>  ------------------------------
>  done
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
