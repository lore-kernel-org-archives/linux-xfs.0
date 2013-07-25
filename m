Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1AEFF7CBF
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 23:11:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 07C64304039
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 21:11:21 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	9yx9q2IXl0xCf15X for <xfs@oss.sgi.com>;
	Wed, 24 Jul 2013 21:11:16 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1V2CtW-0003Mv-6Z
	for xfs@oss.sgi.com; Thu, 25 Jul 2013 14:11:14 +1000
Date: Thu, 25 Jul 2013 14:11:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 42/49] xfs: Validate log space at mount time
Message-ID: <20130725041114.GG13468@dastard>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-43-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1374215120-7271-43-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

On Fri, Jul 19, 2013 at 04:25:13PM +1000, Dave Chinner wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Validate log space during log mount stage, the underlying function
> will drop a warning message via syslog in critical level if the log
> space is too small or too large.
> 
> [ dchinner: For CRC enable filesystems, abort the mounting of the
> filesystem as mkfs should never make a log too small for the given
> filesystem configuration. ]
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 48 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index b02415b..64b1f01 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -614,7 +614,9 @@ xfs_log_mount(
>  	xfs_daddr_t	blk_offset,
>  	int		num_bblks)
>  {
> -	int		error;
> +	int		error = 0;
> +	int		min_logfsbs;
> +	int		max_logfsbs;
>  
>  	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY))
>  		xfs_notice(mp, "Mounting Filesystem");
> @@ -631,6 +633,51 @@ xfs_log_mount(
>  	}
>  
>  	/*
> +	 * Validate the given log space and drop a critical message via syslog
> +	 * if the log size is too small that would lead to some unexpected
> +	 * situations in transaction log space reservation stage.
> +	 *
> +	 * Note: we can't just reject the mount if the validation fails.  This
> +	 * would mean that people would have to downgrade their kernel just to
> +	 * remedy the situation as there is no way to grow the log (short of
> +	 * black magic surgery with xfs_db).
> +	 *
> +	 * We can, however, reject mounts for CRC format filesystems, as the
> +	 * mkfs binary being used to make the filesystem should never create a
> +	 * filesystem with a log that is too small.
> +	 */
> +	min_logfsbs = xfs_log_calc_minimum_size(mp);
> +	max_logfsbs = XFS_BB_TO_FSB(mp, XFS_MAX_LOG_BLOCKS);

Actually, that's busted:

XFS (vdc): Log size 521728 blocks too large, maximum size is 131072 blocks
XFS (vdc): Log size out of supported range.  Continuing onwards, but if log hangs are
experienced then please report this message in the bug report.

I'll need to revisit this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
