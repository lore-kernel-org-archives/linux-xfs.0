Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7BE137CBF
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 20:15:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5C2268F8049
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 18:15:07 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	KoM2UXMZzWugBUVB for <xfs@oss.sgi.com>;
	Mon, 13 May 2013 18:15:02 -0700 (PDT)
Date: Tue, 14 May 2013 11:15:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC] xfstests: fail test if it causes a kernel taint
Message-ID: <20130514011501.GR32675@dastard>
References: <51916146.80308@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51916146.80308@redhat.com>
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

On Mon, May 13, 2013 at 04:55:18PM -0500, Eric Sandeen wrote:
> This should, in theory, fail a test if it introduces one of
> a handful of "serious" kernel taints.  I mask on a few taint
> values because using an out of tree module or a non-GPL module
> should never fail a test, for example.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

I like the idea - it should catch lockdep failures and other such
problems.

> ---
> 
> diff --git a/check b/check
> index a79747e..a9cac4e 100755
> --- a/check
> +++ b/check
> @@ -446,6 +445,11 @@ do
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
> @@ -507,6 +511,19 @@ do
>  			 "entire diff)"
>  		    err=true
>  		fi
> +
> +		# See if this run tainted the kernel due to oops, etc
> +		if [ "$HOSTOS" == "Linux" ]
> +		then
> +			tainted2=`sysctl -n kernel.tainted`
> +			let "tainted2 &= $TAINT_FAIL"
> +			if [ "$tainted" != "$tainted2" ]
> +			then
> +				echo " Kernel taint changed from $tainted to $tainted2."
> +				echo " See dmesg for details."
> +				err=true
> +			fi

Should we dump the last 100 lines of dmesg into the output file
here? And then rely on the golden image match failing to fail the
test?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
