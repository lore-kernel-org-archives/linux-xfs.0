Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2KC2lcU226863 for <xfs@oss.sgi.com>; Tue, 20 Mar 2012 07:02:48 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TznBPkN0r1bdkcwz for
	<xfs@oss.sgi.com>; Tue, 20 Mar 2012 05:02:46 -0700 (PDT)
Date: Tue, 20 Mar 2012 13:02:41 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2] 251: Make fstrim call a bit more random
In-Reply-To: <1330589716-32362-1-git-send-email-lczerner@redhat.com>
Message-ID: <alpine.LFD.2.00.1203201302250.5067@dhcp-27-109.brq.redhat.com>
References: <1330439400-26390-1-git-send-email-lczerner@redhat.com>
	<1330589716-32362-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: elder@dreamhost.com, xfs@oss.sgi.com

On Thu, 1 Mar 2012, Lukas Czerner wrote:

> To cover cases when fstrim arguments are not block/block group/file
> system size aligned, we can be a bit more random. This commit changes
> fstrim argument computing to use $RANDOM bash variable in order to have
> different minlen, start, len argument settings and change the full fs
> fstrim to be called randomly as well.
> 
> Also make kill and wait not complain about non existent process, since
> it may have already finished before we attempt to kill it and wait for
> it. No reason to fail the test.

ping

> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
> v2: guess maximum minlen so we do not fail if milnen limitation
>     of the fs is too small.
> 
>  251 |   36 +++++++++++++++++++++++++-----------
>  1 files changed, 25 insertions(+), 11 deletions(-)
> 
> diff --git a/251 b/251
> index fa3d74a..6d87bf4 100755
> --- a/251
> +++ b/251
> @@ -54,21 +54,21 @@ _cleanup()
>  
>  _destroy()
>  {
> -	kill $pids $fstrim_pid
> -	wait $pids $fstrim_pid
> +	kill $pids $fstrim_pid 2> /dev/null
> +	wait $pids $fstrim_pid 2> /dev/null
>  	rm -rf $tmp
>  }
>  
>  _destroy_fstrim()
>  {
> -	kill $fpid
> -	wait $fpid
> +	kill $fpid 2> /dev/null
> +	wait $fpid 2> /dev/null
>  }
>  
>  _fail()
>  {
>  	echo "$1"
> -	kill $mypid
> +	kill $mypid 2> /dev/null
>  }
>  
>  _check_fstrim_support()
> @@ -76,6 +76,16 @@ _check_fstrim_support()
>  	$here/src/fstrim -l 10M $SCRATCH_MNT &> /dev/null
>  }
>  
> +_guess_max_minlen()
> +{
> +	mmlen=100000
> +	while [ $mmlen -gt 1 ]; do
> +		$here/src/fstrim -l $(($mmlen*2))k -m ${mmlen}k $SCRATCH_MNT &> /dev/null && break
> +		mmlen=$(($mmlen/2))
> +	done
> +	echo $mmlen
> +}
> +
>  ##
>  # Background FSTRIM loop. We are trimming the device in the loop and for
>  # test coverage, we are doing whole device trim followed by several smaller
> @@ -85,15 +95,19 @@ fstrim_loop()
>  {
>  	trap "_destroy_fstrim; exit \$status" 2 15
>  	fsize=$(df | grep $SCRATCH_MNT | grep $SCRATCH_DEV  | awk '{print $2}')
> +	mmlen=$(_guess_max_minlen)
>  
>  	while true ; do
> -		step=1048576
> -		start=0
> -		$here/src/fstrim $SCRATCH_MNT &
> -		fpid=$!
> -		wait $fpid
> +		step=$((RANDOM*$RANDOM))
> +		minlen=$(((RANDOM*($RANDOM%2+1))%$mmlen))
> +		start=$RANDOM
> +		if [ $((RANDOM%10)) -gt 7 ]; then
> +			$here/src/fstrim $SCRATCH_MNT &
> +			fpid=$!
> +			wait $fpid
> +		fi
>  		while [ $start -lt $fsize ] ; do
> -			$here/src/fstrim -s ${start}k -l ${step}k $SCRATCH_MNT &
> +			$here/src/fstrim -m ${minlen}k -s ${start}k -l ${step}k $SCRATCH_MNT &
>  			fpid=$!
>  			wait $fpid
>  			start=$(( $start + $step ))
> 

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
