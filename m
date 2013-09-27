Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CFAC47F52
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 11:34:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4837CAC005
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 09:34:27 -0700 (PDT)
Received: from mail.in8.de (brockman.in8.de [85.214.220.56]) by cuda.sgi.com
	with ESMTP id uqEMWYw3wlsudLgs for <xfs@oss.sgi.com>;
	Fri, 27 Sep 2013 09:34:25 -0700 (PDT)
Message-ID: <5245B38F.20800@jan-o-sch.net>
Date: Fri, 27 Sep 2013 18:34:23 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: btrfs/011 improvement for compressed filesystems
References: <1379068041-4299-1-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1379068041-4299-1-git-send-email-sbehrens@giantdisaster.de>
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
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: jbacik@fusionio.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, September 13, 2013 at 12:27 (+0200), Stefan Behrens wrote:
> Josef noticed that using /dev/zero to generate most of the test
> data doesn't work if someone overides the mount options to
> enable compression. The test that performs a cancelation failed
> because the replace operation was already finished when the
> cancel request was executed.
> 
> Since /dev/urandom is too slow to generate multiple GB, the
> way how the filesystem data is generated is completely changed
> with this patch. Now /dev/urandom is used to generate one 1MB
> file and this file is copied up to 2048 times. /dev/zero is no
> longer used.
> 
> The runtime of the test is about the same as before. Compression
> works now, online deduplication will again cause issues, but
> we don't have online deduplicatin today.
> 
> Reported-by: Josef Bacik <jbacik@fusionio.com>
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> ---
>  tests/btrfs/011 | 46 ++++++++++++++++++++++++++++++----------------
>  1 file changed, 30 insertions(+), 16 deletions(-)
> 
> diff --git a/tests/btrfs/011 b/tests/btrfs/011
> index c8b4aac..71ff3de 100755
> --- a/tests/btrfs/011
> +++ b/tests/btrfs/011
> @@ -78,6 +78,7 @@ workout()
>  	local quick="$4"
>  	local source_dev="`echo ${SCRATCH_DEV_POOL} | awk '{print $1}'`"
>  	local target_dev="`echo ${SCRATCH_DEV_POOL} | awk '{print $NF}'`"
> +	local fssize
>  
>  	if [ "`echo $SCRATCH_DEV_POOL | wc -w`" -lt `expr $num_devs4raid + 1` ]; then
>  		echo "Skip workout $1 $2 $3 $4" >> $seqres.full
> @@ -107,33 +108,46 @@ workout()
>  		_notrun "Different device sizes detected"
>  	fi
>  
> +	if [ `$BTRFS_SHOW_SUPER_PROG $SCRATCH_DEV | grep dev_item.total_bytes | awk '{print $2}'` -lt 2500000000 ]; then
> +		_notrun "device size too small"
> +	fi
> +
>  	_scratch_mount
>  
> -	# Generate 500 times 20K extents in the data chunk and fill up
> -	# metadata with inline extents. Ignore ENOSPC.
> +	# Generate metadata and some minimal user data, generate 500 times
> +	# 20K extents in the data chunk and fill up metadata with inline
> +	# extents.
>  	for i in `seq 1 500`; do
>  		dd if=/dev/urandom of=$SCRATCH_MNT/l$i bs=16385 count=1
>  		dd if=/dev/urandom of=$SCRATCH_MNT/s$i bs=3800 count=1
>  	done > /dev/null 2>&1
>  
> +	# /dev/urandom is slow but has the benefit that the generated
> +	# contents does not shrink during compression.
> +	# Generate a template once and quickly copy it multiple times.
> +	# Obviously with online deduplication this will not work anymore.
> +	dd if=/dev/urandom of=$SCRATCH_MNT/t0 bs=1M count=1 > /dev/null 2>&1
> +
>  	if [ "${quick}Q" = "thoroughQ" ]; then
>  		# The intention of this "thorough" test is to increase
>  		# the probability of random errors, in particular in
>  		# conjunction with the background noise generator and
> -		# a sync call while the replace operation in ongoing.
> -		# Unfortunately it takes quite some time to generate
> -		# the test filesystem, therefore most data consists out
> -		# of zeros although this data is not very useful for
> -		# detecting misplaced read/write requests.
> -		# Ignore ENOSPC, it's not a problem..
> -		dd if=/dev/urandom of=$SCRATCH_MNT/r bs=1M count=200 >> $seqres.full 2>&1 &
> -		dd if=/dev/zero of=$SCRATCH_MNT/0 bs=1M count=2000 >> $seqres.full 2>&1
> -		wait
> +		# a sync call while the replace operation is ongoing.
> +		fssize=2048
>  	elif [ "${with_cancel}Q" = "cancelQ" ]; then
> -		# produce some data to prevent that the replace operation
> -		# finishes before the cancel request is started
> -		dd if=/dev/zero of=$SCRATCH_MNT/0 bs=1M count=1000 >> $seqres.full 2>&1
> +		# The goal is to produce enough data to prevent that the
> +		# replace operation finishes before the cancel request
> +		# is started.
> +		fssize=1024
> +	else
> +		fssize=64
>  	fi
> +
> +	# since the available size was tested before, do not tolerate
> +	# any failures
> +	for i in `seq $fssize`; do
> +		cp $SCRATCH_MNT/t0 $SCRATCH_MNT/t$i || _fail "cp failed"
> +	done > /dev/null 2>> $seqres.full
>  	sync; sync
>  
>  	btrfs_replace_test $source_dev $target_dev "" $with_cancel $quick
> @@ -214,7 +228,7 @@ btrfs_replace_test()
>  		# before the status is printed
>  		$BTRFS_UTIL_PROG replace status $SCRATCH_MNT > $tmp.tmp 2>&1
>  		cat $tmp.tmp >> $seqres.full
> -		grep -q canceled $tmp.tmp || _fail "btrfs replace status failed"
> +		grep -q canceled $tmp.tmp || _fail "btrfs replace status (canceled) failed"
>  	else
>  		if [ "${quick}Q" = "thoroughQ" ]; then
>  			# On current hardware, the thorough test runs
> @@ -226,7 +240,7 @@ btrfs_replace_test()
>  
>  		$BTRFS_UTIL_PROG replace status $SCRATCH_MNT > $tmp.tmp 2>&1
>  		cat $tmp.tmp >> $seqres.full
> -		grep -q finished $tmp.tmp || _fail "btrfs replace status failed"
> +		grep -q finished $tmp.tmp || _fail "btrfs replace status (finished) failed"
>  	fi
>  
>  	if ps -p $noise_pid | grep -q $noise_pid; then
> 

The "Q"-comparisons look a bit strange to me, but they've been there before.

Reviewed-by: Jan Schmidt <list.xfs@jan-o-sch.net>

-Jan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
