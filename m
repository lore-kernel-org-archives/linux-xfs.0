Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F103B7F47
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 21:48:19 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DD8E3304043
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 19:48:19 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id sAxutiCzei4FbhyF for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 19:48:18 -0800 (PST)
Message-ID: <54EBF481.8000309@sandeen.net>
Date: Mon, 23 Feb 2015 21:48:17 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs: log stripe unit fails to influence default log size
References: <1424745588-16361-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1424745588-16361-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 2/23/15 8:39 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This fails:
> 
> # mkfs.xfs -f -l version=2,su=256k /dev/ram1
> log size 2560 blocks too small, minimum size is 3264 blocks
> ....
> 
> We should be automatically calculating an appropriate, valid log
> size when the user does not specify it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 66711cb..5e10c4e 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2441,9 +2441,11 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  			 */
>  			logblocks = (dblocks << blocklog) / 2048;
>  			logblocks = logblocks >> blocklog;
> -			logblocks = MAX(min_logblocks, logblocks);
>  		}
>  
> +		/* Log size must exceed the minimum the geometry requires. */

ok, so 4G device with 4k sectors; 4k sectors + log sunit is what made
the calculated min_logblocks large enough that it is failing without
this change.  Those details should probably be in the commit log.

Also, nitpick, it doesn't have to exceed, and MAX() doesn't make it exceed....
maybe:

		/* Log size can't be less than the minimum the geometry requires. */

Code wise it's fine, I'd prefer to see commit log & comment tidied up, but:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> +		logblocks = MAX(min_logblocks, logblocks);
> +
>  		/* make sure the log fits wholly within an AG */
>  		if (logblocks >= agsize)
>  			logblocks = min_logblocks;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
