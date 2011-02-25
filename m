Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1PJOkwG218478 for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 13:24:46 -0600
Subject: Re: [PATCH] xfsdump: prune inventory sessions by session id
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1298564720-11447-1-git-send-email-wkendall@sgi.com>
References: <1298564720-11447-1-git-send-email-wkendall@sgi.com>
Date: Fri, 25 Feb 2011 13:27:29 -0600
Message-ID: <1298662049.1990.7053.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, 2011-02-24 at 10:25 -0600, Bill Kendall wrote:
> Allow xfsinvutil to prune inventory sessions by their ID
> instead of only by filesystem and cutoff date.

This would have been a bit nicer with a little more
explanation.  I.e.:
- You specify the session id using the new "-s <sessid>"
  command line option.
- The "-s" option is mutually exclusive with "-u <UUID>"
  and "-M <mount_point> <mm/dd/yy>".  It also cannot be
  used together with the "-i" (interactive) or "-C"
  (consistency check) options.
- The change is implemented by adding a session id argument
  to CheckAndPruneFstab(), CheckAndPruneInvIndexFile(), and
  CheckAndPruneStObjFile().  That session becomes a third
  way of identifying entries to be pruned (in addition
  to mount point and UUID).

Anyway, this looks good to me.  I have one question
below, but regardless of your answer...

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Bill Kendall <wkendall@sgi.com>
> 
> ---
. . .

> diff --git a/invutil/invutil.c b/invutil/invutil.c
> index af6836b..37489c0 100644
> --- a/invutil/invutil.c
> +++ b/invutil/invutil.c

. . .

> @@ -594,14 +648,8 @@ CheckAndPruneInvIndexFile( bool_t checkonly,
>  	    removeflag = BOOL_TRUE;
>  	}    
>  
> -	if (( !removeflag ) && (checkonly == BOOL_FALSE) && 
> -		( invIndexEntry[i].ie_timeperiod.tp_start < prunetime))
> -	{
> -	    IdxCheckOnly = BOOL_FALSE;
> -	    printf("          Mount point match\n");
> -	}

Why do you no longer print this in this case?

> -	if (CheckAndPruneStObjFile(IdxCheckOnly, invIndexEntry[i].ie_filename,
> -		    prunetime, r_mf_label) == -1) {
> +	if (CheckAndPruneStObjFile(checkonly, invIndexEntry[i].ie_filename,
> +		    sessionp, prunetime, r_mf_label) == -1) {
>  	    removeflag = BOOL_TRUE; /* The StObj is gone */
>  	}
>  

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
