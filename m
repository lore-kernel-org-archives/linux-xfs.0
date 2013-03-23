Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id 98FBC7F53
	for <xfs@oss.sgi.com>; Sat, 23 Mar 2013 05:20:18 -0500 (CDT)
Date: Sat, 23 Mar 2013 03:20:17 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 09/25] xfstests: remove undocumented TESTS_REMAINING_LOG
Message-ID: <20130323102016.GM25253@caliban.engr.sgi.com>
References: <1363350489-22257-1-git-send-email-david@fromorbit.com>
	<1363350489-22257-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363350489-22257-10-git-send-email-david@fromorbit.com>
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

On Fri, Mar 15, 2013 at 11:27:53PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Undocumented and unused, AFAICT. Kill it.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> ---
>  check |    7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/check b/check
> index 8a998c4..b93316a 100755
> --- a/check
> +++ b/check
> @@ -365,17 +365,10 @@ fi
>  seq="check"
>  _check_test_fs
>  
> -[ -n "$TESTS_REMAINING_LOG" ] && echo $list > $TESTS_REMAINING_LOG
> -
>  for seq in $list
>  do
>      err=false
>      echo -n "$seq"
> -    if [ -n "$TESTS_REMAINING_LOG" ] ; then
> -        sed -e "s/$seq//" -e 's/  / /' -e 's/^ *//' $TESTS_REMAINING_LOG > $TESTS_REMAINING_LOG.tmp
> -        mv $TESTS_REMAINING_LOG.tmp $TESTS_REMAINING_LOG
> -        sync
> -    fi
>  
>      if $showme
>      then
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
