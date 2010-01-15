Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0F78U7L076803 for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 01:08:31 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C81111F2DE0
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 23:09:25 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	R7a6P3a9sd7dcKat for <xfs@oss.sgi.com>;
	Thu, 14 Jan 2010 23:09:25 -0800 (PST)
Received: from discord (unverified [121.44.236.168])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11551597-1927428
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 17:39:24 +1030 (CDT)
Received: from dave by discord with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>) id 1NVgJ9-0000js-Di
	for xfs@oss.sgi.com; Fri, 15 Jan 2010 18:09:23 +1100
Date: Fri, 15 Jan 2010 18:09:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 9/9] xfsprogs: fix build warnings in repair
Message-ID: <20100115070923.GE28498@discord.disaster>
References: <1263463752-5052-1-git-send-email-david@fromorbit.com>
	<1263463752-5052-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263463752-5052-10-git-send-email-david@fromorbit.com>
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

On Thu, Jan 14, 2010 at 09:09:12PM +1100, Dave Chinner wrote:
> Rewrite the loop in btree_get_prev() so that the compiler
> can see that it returns if the cur->index is zero so it
> doesn't complain about possible array bound underflows
> when getting the key out of the buffer.
> 
> Fix the directory name sign warnings by casting to (uchar_t *)
> appropriately.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  repair/btree.c  |    9 +++++----
>  repair/phase6.c |   10 +++++-----
>  2 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/repair/btree.c b/repair/btree.c
> index 3141388..b53b4e4 100644
> --- a/repair/btree.c
> +++ b/repair/btree.c
> @@ -194,12 +194,13 @@ btree_get_prev(
>  	}
>  
>  	/* else need to go up and back down the tree to find the previous */
> -
> -	while (cur->index == 0) {
> -		if (++level == root->height)
> -			return NULL;
> +	while (++level < root->height) {
> +		if (cur->index)
> +			break;
>  		cur++;
>  	}
> +	if (cur->index == 0)
> +		return NULL;

This is broken - causes a segv. i have a fixed patch, which I'll
send out once I've got xfstests running again on my test box (using
dash as /bin/sh breaks *lots* of stuff in xfstests).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
