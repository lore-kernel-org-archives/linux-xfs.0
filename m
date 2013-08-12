Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 40DB27F3F
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 13:46:18 -0500 (CDT)
Message-ID: <52092D79.30905@sgi.com>
Date: Mon, 12 Aug 2013 13:46:17 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: ***** SUSPECTED SPAM ***** [PATCH 42/50] xfs: Validate log space
	at mount time
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
	<1376304611-22994-43-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-43-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/12/13 05:50, Dave Chinner wrote:
> From: Jie Liu<jeff.liu@oracle.com>
>
> Validate log space during log mount stage, the underlying function
> will drop a warning message via syslog in critical level if the log
> space is too small or too large.
>
> [ dchinner: For CRC enable filesystems, abort the mounting of the
> filesystem as mkfs should never make a log too small for the given
> filesystem configuration. ]
>
> [ dchinner: make a note of the fact that the log size limits in
> block counts are in units of filesystem blocks, not basic blocks. ]
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/xfs/xfs_fs.h  |  4 +++-
>   fs/xfs/xfs_log.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
>   2 files changed, 49 insertions(+), 2 deletions(-)
>
> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> index 74b24b2..53e33c2 100644
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -240,7 +240,9 @@ typedef struct xfs_fsop_resblks {
>
>
>   /*
> - * Minimum and maximum sizes need for growth checks
> + * Minimum and maximum sizes need for growth checks.
> + *
> + * Block counts are in units of filesystem blocks, not basic blocks.
>    */
>   #define XFS_MIN_AG_BLOCKS	64
>   #define XFS_MIN_LOG_BLOCKS	512ULL
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 704f095..b5703cc 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c

> @@ -631,6 +632,50 @@ xfs_log_mount(

...

> +	} else if (mp->m_sb.sb_logblocks>  XFS_MAX_LOG_BLOCKS) {

oops - missed that.

> +		xfs_warn(mp,
> +		"Log size %d blocks too large, maximum size is %lld blocks",
> +			 mp->m_sb.sb_logblocks, XFS_MAX_LOG_BLOCKS);
> +		error = EINVAL;

Also, the code to this point in the series has been compared (patches 
and individual files). The items that I mentioned in the previous review 
have been dealt this.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
