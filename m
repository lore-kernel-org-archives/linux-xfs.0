Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46976 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbfGBOYL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Jul 2019 10:24:11 -0400
Date: Tue, 2 Jul 2019 10:24:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 07/15] xfs: calculate inode walk prefetch more carefully
Message-ID: <20190702142403.GD2866@bfoster>
References: <156158183697.495087.5371839759804528321.stgit@magnolia>
 <156158188075.495087.14228436478786857410.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156158188075.495087.14228436478786857410.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jun 26, 2019 at 01:44:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The existing inode walk prefetch is based on the old bulkstat code,
> which simply allocated 4 pages worth of memory and prefetched that many
> inobt records, regardless of however many inodes the caller requested.
> 65536 inodes is a lot to prefetch (~32M on x64, ~512M on arm64) so let's
> scale things down a little more intelligently based on the number of
> inodes requested, etc.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

A few nits..

>  fs/xfs/xfs_iwalk.c |   46 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 44 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> index 304c41e6ed1d..3e67d7702e16 100644
> --- a/fs/xfs/xfs_iwalk.c
> +++ b/fs/xfs/xfs_iwalk.c
> @@ -333,16 +333,58 @@ xfs_iwalk_ag(
>  	return error;
>  }
>  
> +/*
> + * We experimentally determined that the reduction in ioctl call overhead
> + * diminishes when userspace asks for more than 2048 inodes, so we'll cap
> + * prefetch at this point.
> + */
> +#define MAX_IWALK_PREFETCH	(2048U)
> +

Something like IWALK_MAX_INODE_PREFETCH is a bit more clear IMO.

>  /*
>   * Given the number of inodes to prefetch, set the number of inobt records that
>   * we cache in memory, which controls the number of inodes we try to read
> - * ahead.
> + * ahead.  Set the maximum if @inode_records == 0.
>   */
>  static inline unsigned int
>  xfs_iwalk_prefetch(
>  	unsigned int		inode_records)

Perhaps this should be called 'inodes' since the function converts this
value to inode records?

>  {
> -	return PAGE_SIZE * 4 / sizeof(struct xfs_inobt_rec_incore);
> +	unsigned int		inobt_records;
> +
> +	/*
> +	 * If the caller didn't tell us the number of inodes they wanted,
> +	 * assume the maximum prefetch possible for best performance.
> +	 * Otherwise, cap prefetch at that maximum so that we don't start an
> +	 * absurd amount of prefetch.
> +	 */
> +	if (inode_records == 0)
> +		inode_records = MAX_IWALK_PREFETCH;
> +	inode_records = min(inode_records, MAX_IWALK_PREFETCH);
> +
> +	/* Round the inode count up to a full chunk. */
> +	inode_records = round_up(inode_records, XFS_INODES_PER_CHUNK);
> +
> +	/*
> +	 * In order to convert the number of inodes to prefetch into an
> +	 * estimate of the number of inobt records to cache, we require a
> +	 * conversion factor that reflects our expectations of the average
> +	 * loading factor of an inode chunk.  Based on data gathered, most
> +	 * (but not all) filesystems manage to keep the inode chunks totally
> +	 * full, so we'll underestimate slightly so that our readahead will
> +	 * still deliver the performance we want on aging filesystems:
> +	 *
> +	 * inobt = inodes / (INODES_PER_CHUNK * (4 / 5));
> +	 *
> +	 * The funny math is to avoid division.
> +	 */

The last bit of this comment is unclear. What do you mean by "avoid
division?"

With those nits fixed up:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	inobt_records = (inode_records * 5) / (4 * XFS_INODES_PER_CHUNK);
> +
> +	/*
> +	 * Allocate enough space to prefetch at least two inobt records so that
> +	 * we can cache both the record where the iwalk started and the next
> +	 * record.  This simplifies the AG inode walk loop setup code.
> +	 */
> +	return max(inobt_records, 2U);
>  }
>  
>  /*
> 
