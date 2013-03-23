Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id 862F57F88
	for <xfs@oss.sgi.com>; Sat, 23 Mar 2013 05:24:51 -0500 (CDT)
Date: Sat, 23 Mar 2013 03:24:50 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 25/25] xfstests: use _notrun for tape checks
Message-ID: <20130323102450.GC25253@caliban.engr.sgi.com>
References: <1363350489-22257-1-git-send-email-david@fromorbit.com>
	<1363350489-22257-26-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363350489-22257-26-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Looks OK.

Reviewed-by: Phil White <pwhite@sgi.com>

On Fri, Mar 15, 2013 at 11:28:09PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> _require_tape is failing tests when no TAPE_DEV is specified. It
> should be using _notrun for these cases rather than trying to open
> code the $seqres.notrun magic file manipulations.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  common/dump |   13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/common/dump b/common/dump
> index 3df6191..5d4d2ae 100644
> --- a/common/dump
> +++ b/common/dump
> @@ -139,9 +139,7 @@ _check_onl()
>  	echo "ERROR: mt -f $dumptape failed"
>  	cat $tmp.status
>  
> -	echo "mt -f $dumptape failed" >$seq.notrun
> -	status=$NOTRUNSTS
> -	exit
> +	_notrun "mt -f $dumptape failed"
>      fi
>  
>  
> @@ -151,9 +149,7 @@ _check_onl()
>  	echo "ERROR: $dumptape is not online"
>  	cat $tmp.status
>  
> -	echo "dumptape, $dumptape, is not online" >$seq.notrun
> -	status=$NOTRUNSTS
> -	exit
> +	_notrun "dumptape, $dumptape, is not online"
>      fi
>  }
>  
> @@ -229,10 +225,7 @@ _require_tape()
>      dumptape=$1
>  
>      if [ -z "$dumptape" -o "@" == "$dumptape" ]; then
> -        echo "This test requires a dump tape - none was specified"
> -	echo "No dump tape specified" >$seqres.notrun
> -	status=$NOTRUNSTS
> -	exit
> +	_notrun "No dump tape specified"
>      fi
>  
>      _check_onl
> -- 
> 1.7.10.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
