Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 105FA7F52
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 13:29:34 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B5F75AC004
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 11:29:33 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JVJ87o09ur7RVMXn for
	<xfs@oss.sgi.com>; Wed, 05 Feb 2014 11:29:29 -0800 (PST)
Message-ID: <52F29116.4000201@redhat.com>
Date: Wed, 05 Feb 2014 14:29:26 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs: default log size for small filesystems too large
References: <1391579241-32747-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1391579241-32747-1-git-send-email-david@fromorbit.com>
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

On 02/05/2014 12:47 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Recent changes to the log size scaling have resulted in using the
> default size multiplier for the log size even on small filesystems.
> Commit 88cd79b ("xfs: Add xfs_log_rlimit.c") changed the calculation
> of the maximum transaction size that the kernel would issues and
> that significantly increased the minimum size of the default log.
> As such the size of the log on small filesystems was typically
> larger than the prefious default, even though the previous default
		previous
> was still larger than the minimum needed.
> 

Hey Dave,

Can you elaborate on what you mean by the previous default being larger
than the minimum needed? If that is the case, doesn't that mean the
calculations based on the max transaction size are not valid? Perhaps
I'm not parsing something here.

> Rework the default log size calculation such that it will use the
> original log size default if it is larger than the minimum log size
> required, and only use a larger log if the configuration of the
> filesystem requires it.
> 
> This is especially obvious in xfs/216, where the default log size is
> 10MB all the way up to 16GB filesystems. The current mkfs selects a
> log size of 50MB for the same size filesystems and this is
> unnecessarily large.
> 
> Return the scaling of the log size for small filesystems to
> something similar to what xfs/216 expects.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index d82128c..4a29eea 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2377,17 +2377,18 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  		logblocks = MAX(min_logblocks, logblocks);
>  
>  		/*
> -		 * If the default log size doesn't fit in the AG size, use the
> -		 * minimum log size instead. This ensures small filesystems
> -		 * don't use excessive amounts of space for the log.
> +		 * For small filesystems, we want to use the XFS_MIN_LOG_BYTES
> +		 * for filesystems smaller than 16G if at all possible, ramping
> +		 * up to 128MB at 256GB.
>  		 */
> -		if (min_logblocks * XFS_DFL_LOG_FACTOR >= agsize) {
> -			logblocks = min_logblocks;
> -		} else {
> -			logblocks = MAX(logblocks,
> -				MAX(XFS_DFL_LOG_SIZE,
> -					min_logblocks * XFS_DFL_LOG_FACTOR));
> +		 if (dblocks < GIGABYTES(16, blocklog)) {
> +			logblocks = MIN(XFS_MIN_LOG_BYTES >> blocklog,
> +					min_logblocks * XFS_DFL_LOG_FACTOR);
>  		}

Nit: extra space after tab before the 'if (dblocks < GIGABYTES(...)) {'
line...

More generally... by the time we get here, min_logblocks is at least
XFS_MIN_LOG_BLOCKS and XFS_MIN_LOG_BYTES (if the fs is >=1GB). The only
way we would use the min_logblocks based value is if min_logblocks is
less than 1/5 of XFS_MIN_LOG_BYTES (due to DFL_LOG_FACTOR). After
testing this a bit, creating a 20MB fs with 4k blocks gives me an
initial min_logblocks of 853, which works out to ~16MB after
DFL_LOG_FACTOR. So this effectively looks like an assignment of
XFS_MIN_LOG_BYTES in that case.

In the sub 1GB case, we skip the existing XFS_MIN_LOG_BYTES check, but
this new block of code just adds it back, at least in the internal log case.

Given that, I wonder if this can all be cleaned up to start with some
combination of the calculated min_logblocks and defined min blocks/bytes
values, and then add the 2048:1 scaling conditionally in the >=16GB
case. E.g., I modified the MIN() statement this patch adds to a straight
assignment of min_logblocks and xfs/216 still passes.

Thoughts? Would that be sufficient here, or am I missing some other
scenarios?

Brian

> +
> +		if (logblocks >= agsize)
> +			logblocks = min_logblocks;
> +
>  		logblocks = MIN(logblocks, XFS_MAX_LOG_BLOCKS);
>  		if ((logblocks << blocklog) > XFS_MAX_LOG_BYTES) {
>  			logblocks = XFS_MAX_LOG_BYTES >> blocklog;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
