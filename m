Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7G6Brx9063768 for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 01:11:53 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jNTrawBus8BjCmrg for
	<xfs@oss.sgi.com>; Wed, 15 Aug 2012 23:11:52 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7G6Bp2A007647
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 02:11:52 -0400
Received: from localhost (dhcp12-245.nay.redhat.com [10.66.12.245] (may be
	forged))
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q7G6Bo1S023288
	for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 02:11:51 -0400
Date: Thu, 16 Aug 2012 14:11:49 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfstests 274: test more code paths
Message-ID: <20120816061149.GF2088@eguan-t400>
References: <1342768841-16821-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1342768841-16821-1-git-send-email-eguan@redhat.com>
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
To: xfs@oss.sgi.com

On Fri, Jul 20, 2012 at 03:20:41PM +0800, Eryu Guan wrote:
> Fill preallocated(update/keep size) space by buffered/direct IO
> 
> Also change the seek uplimit of last round dd from 1023 to 1024
> to completely fill preallocated space.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>

Hi, any comments on this one? I tested it on ext4 and xfs. In the keep
size case, ext4 would fail. Xfs could pass the whole test.

Thanks,
Eryu Guan
> ---
>  274     |   95 ++++++++++++++++++++++++++++++++++++---------------------------
>  274.out |    7 +++--
>  2 files changed, 58 insertions(+), 44 deletions(-)
> 
> diff --git a/274 b/274
> index dcad90e..938232a 100755
> --- a/274
> +++ b/274
> @@ -50,52 +50,65 @@ _supported_os IRIX Linux
>  _require_scratch
>  _require_xfs_io_falloc
>  
> -echo "------------------------------"
> -echo "preallocation test"
> -echo "------------------------------"
> -
>  rm -f $seq.full
>  
> -umount $SCRATCH_DEV 2>/dev/null
> -_scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
> -_scratch_mount
> +do_test()
> +{
> +	local keep_size=""
> +	local dio=""
> +	[ $1 -eq 1 ] && keep_size="-k"
> +	[ $2 -eq 1 ] && dio="oflag=direct"
> +
> +	umount $SCRATCH_DEV 2>/dev/null
> +	_scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
> +	_scratch_mount
>  
> -# Create a 4k file and Allocate 4M past EOF on that file
> -xfs_io -F -f -c "pwrite 0 4k" -c "falloc -k 4k 4m" $SCRATCH_MNT/test \
> -	>>$seq.full 2>&1 || _fail "failed to create test file"
> +	# Create a 4k file and Allocate 4M past EOF on that file
> +	xfs_io -F -f -c "pwrite 0 4k" -c "falloc $keep_size 4k 4m" $SCRATCH_MNT/test \
> +		>>$seq.full 2>&1 || _fail "failed to create test file"
>  
> -# Fill the rest of the fs completely
> -# Note, this will show ENOSPC errors in $seq.full, that's ok.
> -echo "Fill fs with 1M IOs; ENOSPC expected" >> $seq.full
> -dd if=/dev/zero of=$SCRATCH_MNT/tmp1 bs=1M >>$seq.full 2>&1
> -echo "Fill fs with 4K IOs; ENOSPC expected" >> $seq.full
> -dd if=/dev/zero of=$SCRATCH_MNT/tmp2 bs=4K >>$seq.full 2>&1
> -sync
> -# Last effort, use O_SYNC
> -echo "Fill fs with 4K DIOs; ENOSPC expected" >> $seq.full
> -dd if=/dev/zero of=$SCRATCH_MNT/tmp3 bs=4K oflag=sync >>$seq.full 2>&1
> -# Save space usage info
> -echo "Post-fill space:" >> $seq.full
> -df $SCRATCH_MNT >>$seq.full 2>&1
> +	# Fill the rest of the fs completely
> +	# Note, this will show ENOSPC errors in $seq.full, that's ok.
> +	echo "Fill fs with 1M IOs; ENOSPC expected" >> $seq.full
> +	dd if=/dev/zero of=$SCRATCH_MNT/tmp1 bs=1M >>$seq.full 2>&1
> +	echo "Fill fs with 4K IOs; ENOSPC expected" >> $seq.full
> +	dd if=/dev/zero of=$SCRATCH_MNT/tmp2 bs=4K >>$seq.full 2>&1
> +	sync
> +	# Last effort, use O_SYNC
> +	echo "Fill fs with 4K DIOs; ENOSPC expected" >> $seq.full
> +	dd if=/dev/zero of=$SCRATCH_MNT/tmp3 bs=4K oflag=sync >>$seq.full 2>&1
> +	# Save space usage info
> +	echo "Post-fill space:" >> $seq.full
> +	df $SCRATCH_MNT >>$seq.full 2>&1
> +
> +	# Now attempt a write into all of the preallocated space -
> +	# in a very nasty way, badly fragmenting it and then filling it in.
> +	echo "Fill in prealloc space; fragment at offsets:" >> $seq.full
> +	for i in `seq 1 2 1023`; do
> +		echo -n "$i " >> $seq.full
> +		dd if=/dev/zero of=$SCRATCH_MNT/test seek=$i bs=4K count=1 conv=notrunc $dio \
> +			>>$seq.full 2>/dev/null || _fail "failed to write to test file"
> +	done
> +	sync
> +	echo >> $seq.full
> +	echo "Fill in prealloc space; fill holes at offsets:" >> $seq.full
> +	for i in `seq 2 2 1024`; do
> +		echo -n "$i " >> $seq.full
> +		dd if=/dev/zero of=$SCRATCH_MNT/test seek=$i bs=4K count=1 conv=notrunc $dio \
> +			>>$seq.full 2>/dev/null || _fail "failed to fill test file"
> +	done
> +	sync
> +	echo >> $seq.full
> +}
>  
> -# Now attempt a write into all of the preallocated space -
> -# in a very nasty way, badly fragmenting it and then filling it in.
> -echo "Fill in prealloc space; fragment at offsets:" >> $seq.full
> -for i in `seq 1 2 1023`; do
> -	echo -n "$i " >> $seq.full
> -	dd if=/dev/zero of=$SCRATCH_MNT/test seek=$i bs=4K count=1 conv=notrunc \
> -		>>$seq.full 2>/dev/null || _fail "failed to write to test file"
> -done
> -sync
> -echo >> $seq.full
> -echo "Fill in prealloc space; fill holes at offsets:" >> $seq.full
> -for i in `seq 2 2 1023`; do
> -	echo -n "$i " >> $seq.full
> -	dd if=/dev/zero of=$SCRATCH_MNT/test seek=$i bs=4K count=1 conv=notrunc \
> -		>>$seq.full 2>/dev/null || _fail "failed to fill test file"
> -done
> -sync
> -echo >> $seq.full
> +echo "preallocation test, update size/buffer IO"
> +do_test 0 0
> +echo "preallocation test, update size/direct IO"
> +do_test 0 1
> +echo "preallocation test, keep size/buffer IO"
> +do_test 1 0
> +echo "preallocation test, keep size/direct IO"
> +do_test 1 1
>  
>  echo "done"
>  exit
> diff --git a/274.out b/274.out
> index edbf3cc..b1473bc 100644
> --- a/274.out
> +++ b/274.out
> @@ -1,5 +1,6 @@
>  QA output created by 274
> -------------------------------
> -preallocation test
> -------------------------------
> +preallocation test, update size/buffer IO
> +preallocation test, update size/direct IO
> +preallocation test, keep size/buffer IO
> +preallocation test, keep size/direct IO
>  done
> -- 
> 1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
