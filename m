Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 04B417F54
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 22:16:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E8DED8F8039
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 20:16:48 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 1LTNiATdcpm1qGhx for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 20:16:47 -0700 (PDT)
Message-ID: <52561C1E.6040601@sandeen.net>
Date: Wed, 09 Oct 2013 22:16:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, V2] xfstests: fail test if it causes a kernel taint
References: <51916146.80308@redhat.com> <519E3A20.7060102@sandeen.net>
In-Reply-To: <519E3A20.7060102@sandeen.net>
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

On 5/23/13 10:47 AM, Eric Sandeen wrote:
> This modification will fail a test if it introduces one of
> a handful of "serious" kernel taints.  I mask on a few taint
> values because using an out of tree module or a non-GPL module
> should never fail a test, for example.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Tested by modifying tests/generic/001 to modprobe a "staging"
> driver, and adding the staging taint bit (1024) to the mask.
> 
> V2: fail test by modifying the test output so the golden
> output check will fail, per dchinner's suggestion.

Ping, needs re-review for V2 I guess.

Thanks,
-Eric

> diff --git a/check b/check
> index a79747e..7ba6696 100755
> --- a/check
> +++ b/check
> @@ -446,6 +446,11 @@ do
>  	fi
>  	rm -f core $seqres.notrun
>  
> +	if [ "$HOSTOS" == "Linux" ]; then
> +		tainted=`sysctl -n kernel.tainted`
> +		let "tainted &= $TAINT_FAIL"
> +	fi
> +
>  	start=`_wallclock`
>  	$timestamp && echo -n "	["`date "+%T"`"]"
>  	[ ! -x $seq ] && chmod u+x $seq # ensure we can run it
> @@ -458,6 +463,19 @@ do
>  	_fix_malloc <$tmp.rawout >$tmp.out
>  	rm -f $tmp.rawout
>  
> +	# See if this run tainted the kernel due to oops, etc
> +	# If so, break the test via the golden output file
> +	if [ "$HOSTOS" == "Linux" ]
> +	then
> +		tainted2=`sysctl -n kernel.tainted`
> +		let "tainted2 &= $TAINT_FAIL"
> +		if [ "$tainted" != "$tainted2" ]
> +		then
> +			echo " Kernel taint changed from $tainted to $tainted2." >> $tmp.out
> +			echo " See dmesg for details." >> $tmp.out
> +		fi
> +	fi
> +
>  	if [ -f core ]
>  	then
>  	    echo -n " [dumped core]"
> diff --git a/common/config b/common/config
> index 67c1498..6483ded 100644
> --- a/common/config
> +++ b/common/config
> @@ -82,6 +82,15 @@ export PWD=`pwd`
>  export MALLOCLIB=${MALLOCLIB:=/usr/lib/libefence.a}
>  export LOCAL_CONFIGURE_OPTIONS=${LOCAL_CONFIGURE_OPTIONS:=--enable-readline=yes}
>  
> +# kernel taint values on Linux (from kernel.taint sysctl)
> +TAINT_MACHINE_CHECK=16
> +TAINT_BAD_PAGE=32
> +TAINT_DIED=128
> +TAINT_WARNING=512
> +# If a test introduces one of these taints we consider it to have failed
> +let "TAINT_FAIL=( $TAINT_MACHINE_CHECK | $TAINT_BAD_PAGE | $TAINT_DIED | $TAINT_WARNING )"
> +export TAINT_FAIL
> +
>  # $1 = prog to look for, $2* = default pathnames if not found in $PATH
>  set_prog_path()
>  {
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
