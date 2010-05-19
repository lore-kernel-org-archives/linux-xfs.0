Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JJ72jR148613 for <xfs@oss.sgi.com>; Wed, 19 May 2010 14:07:03 -0500
Subject: Re: [PATCH 04/12] xfs: Clean up XFS_BLI_* flag namespace
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1274138668-1662-5-git-send-email-david@fromorbit.com>
References: <1274138668-1662-1-git-send-email-david@fromorbit.com>
	<1274138668-1662-5-git-send-email-david@fromorbit.com>
Date: Wed, 19 May 2010 14:09:16 -0500
Message-ID: <1274296156.2140.51.camel@doink>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 2010-05-18 at 09:24 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Clean up the buffer log format (XFS_BLI_*) flags because they have a
> polluted namespace. They XFS_BLI_ prefix is used for both in-memory
> and on-disk flag feilds, but have overlapping values for different
> flags. Rename the buffer log format flags to use the XFS_BLF_*
> prefix to avoid confusing them with the in-memory XFS_BLI_* prefixed
> flags.

This is a good change.  That XFS_BLI_INODE_BUF thing was nasty.

One little comment below, but otherwise looks good.

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/linux-2.6/xfs_super.c |    2 +-
>  fs/xfs/quota/xfs_dquot.c     |    6 ++--

. . .

> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index df44545..8cbb82b 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -41,22 +41,22 @@ typedef struct xfs_buf_log_format {
>   * This flag indicates that the buffer contains on disk inodes
>   * and requires special recovery handling.
>   */
> -#define	XFS_BLI_INODE_BUF	0x1
> +#define	XFS_BLF_INODE_BUF	0x1
>  /*
>   * This flag indicates that the buffer should not be replayed
>   * during recovery because its blocks are being freed.
>   */
> -#define	XFS_BLI_CANCEL		0x2
> +#define	XFS_BLF_CANCEL		0x2
>  /*
>   * This flag indicates that the buffer contains on disk
>   * user or group dquots and may require special recovery handling.
>   */
> -#define	XFS_BLI_UDQUOT_BUF	0x4
> -#define XFS_BLI_PDQUOT_BUF	0x8
> -#define	XFS_BLI_GDQUOT_BUF	0x10
> +#define	XFS_BLF_UDQUOT_BUF	0x4
> +#define XFS_BLF_PDQUOT_BUF	0x8
> +#define	XFS_BLF_GDQUOT_BUF	0x10

I know this isn't part of your change, but I think
a small comment here would make it more obvious
that the following are numeric values, distinct
from the bits defined just above (and therefore
not part of the same name space for flags).

Not a big deal--I'll make a note of it and may
do it myself someday.

> -#define	XFS_BLI_CHUNK		128
> -#define	XFS_BLI_SHIFT		7
> +#define	XFS_BLF_CHUNK		128
> +#define	XFS_BLF_SHIFT		7


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
