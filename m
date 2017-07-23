Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:54866 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750735AbdGWWZq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jul 2017 18:25:46 -0400
Date: Mon, 24 Jul 2017 08:25:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/22] xfs: query the per-AG reservation counters
Message-ID: <20170723222516.GZ17762@dastard>
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
 <150061191503.14732.3422428110288650460.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150061191503.14732.3422428110288650460.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 20, 2017 at 09:38:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Establish an ioctl for userspace to query the original and current
> per-AG reservation counts.  This will be used by xfs_scrub to
> check that the vfs counters are at least somewhat sane.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h |   10 ++++++++++
>  fs/xfs/xfs_fsops.c     |   29 +++++++++++++++++++++++++++++
>  fs/xfs/xfs_fsops.h     |    2 ++
>  fs/xfs/xfs_ioctl.c     |   16 ++++++++++++++++
>  fs/xfs/xfs_ioctl32.c   |    1 +
>  5 files changed, 58 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 8c61f21..5dedab9 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -469,6 +469,15 @@ typedef struct xfs_swapext
>  #define XFS_FSOP_GOING_FLAGS_NOLOGFLUSH		0x2	/* don't flush log nor data */
>  
>  /*
> + * AG reserved block counters
> + */
> +struct xfs_fsop_ag_resblks {
> +	__u64 resblks;		/* blocks reserved now */

		current_reservation

> +	__u64 resblks_orig;	/* blocks reserved at mount time */

		mount_reservation;

> +	__u64 reserved[2];
> +};

Also, any new structure we pass to userspace should be versioned
from the start. At minimum, a flags field so we can, in future, tell
userspace what the reserved space means in future.

> +
> +/* Query the per-AG reservations to see how many blocks we have reserved. */
> +int
> +xfs_fs_get_ag_reserve_blocks(
> +	struct xfs_mount		*mp,
> +	struct xfs_fsop_ag_resblks	*out)
> +{
> +	struct xfs_ag_resv		*r;
> +	struct xfs_perag		*pag;
> +	xfs_agnumber_t			agno;
> +
> +	out->resblks = 0;
> +	out->resblks_orig = 0;
> +	out->reserved[0] = out->reserved[1] = 0;

memset() the structure so we don't forget in future to zero it
properly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
