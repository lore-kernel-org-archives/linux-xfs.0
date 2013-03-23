Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id 22DEF7F3F
	for <xfs@oss.sgi.com>; Sat, 23 Mar 2013 05:19:30 -0500 (CDT)
Date: Sat, 23 Mar 2013 03:19:28 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 07/25] xfstests: kill hangcheck stuff from check
Message-ID: <20130323101928.GK25253@caliban.engr.sgi.com>
References: <1363350489-22257-1-git-send-email-david@fromorbit.com>
	<1363350489-22257-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363350489-22257-8-git-send-email-david@fromorbit.com>
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

On Fri, Mar 15, 2013 at 11:27:51PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This is an old script from the auto-qa days back at SGI. It no
> longer is in use or, AFAIK, ever been used for xfstests. If anyone
> needs it, they can pull it back out of git, so lets remove it to
> simplify check.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  check |   25 -------------------------
>  1 file changed, 25 deletions(-)
> 
> diff --git a/check b/check
> index 7d563e9..d69f948 100755
> --- a/check
> +++ b/check
> @@ -275,12 +275,6 @@ fi
>  
>  _wrapup()
>  {
> -    # for hangcheck ...
> -    # remove files that were used by hangcheck
> -    #
> -    [ -f /tmp/check.pid ] && rm -rf /tmp/check.pid
> -    [ -f /tmp/check.sts ] && rm -rf /tmp/check.sts
> -
>      if $showme
>      then
>  	:
> @@ -336,27 +330,11 @@ END	{ if (NR > 0) {
>      fi
>  
>      rm -f /tmp/*.rawout /tmp/*.out /tmp/*.err /tmp/*.time
> -    rm -f /tmp/check.pid /tmp/check.sts
>      rm -f $tmp.*
>  }
>  
>  trap "_wrapup; exit \$status" 0 1 2 3 15
>  
> -# for hangcheck ...
> -# Save pid of check in a well known place, so that hangcheck can be sure it
> -# has the right pid (getting the pid from ps output is not reliable enough).
> -#
> -rm -rf /tmp/check.pid
> -echo $$ >/tmp/check.pid
> -
> -# for hangcheck ...
> -# Save the status of check in a well known place, so that hangcheck can be
> -# sure to know where check is up to (getting test number from ps output is
> -# not reliable enough since the trace stuff has been introduced).
> -#
> -rm -rf /tmp/check.sts
> -echo "preamble" >/tmp/check.sts
> -
>  # don't leave old full output behind on a clean run
>  rm -f check.full
>  
> @@ -436,9 +414,6 @@ do
>  	fi
>  	rm -f core $seq.notrun
>  
> -	# for hangcheck ...
> -	echo "$seq" >/tmp/check.sts
> -
>  	start=`_wallclock`
>  	$timestamp && echo -n "	["`date "+%T"`"]"
>  	[ ! -x $seq ] && chmod u+x $seq # ensure we can run it
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
