Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2VG0bXe171594 for <xfs@oss.sgi.com>; Sat, 31 Mar 2012 11:00:37 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	VMt7eMBDWeC5xqE6 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 31 Mar 2012 09:00:36 -0700 (PDT)
Date: Sat, 31 Mar 2012 12:00:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: several 274 fixups
Message-ID: <20120331160034.GA13581@infradead.org>
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

Do you plan to resend this one with the fixups pointed out by Dave?

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
> * Don't cd into $SCRATCH_MNT
> * Try harder to completely fill the fs
> * Use a larger preallocated space, and write into all of it (hopefully
>   avoid just accidentally succeeding by writing into fs reserved
>   space that may be there)
> * Save more output in $seq.full instead of /dev/null
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/274 b/274
> index b658004..acf4543 100755
> --- a/274
> +++ b/274
> @@ -1,7 +1,9 @@
>  #! /bin/bash
>  # FS QA Test No. 274
>  #
> -# preallocation test
> +# preallocation test:
> +# Preallocate space to a file, and fill the rest of the fs to 100%.
> +# Then test a write into that preallocated space, which should succeed.
>  #
>  #-----------------------------------------------------------------------
>  # Copyright (c) 2011-2012 Fujitsu, Inc.  All Rights Reserved.
> @@ -35,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
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
>  
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
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
