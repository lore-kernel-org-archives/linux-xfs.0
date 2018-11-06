Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:57298 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726282AbeKGHCE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 02:02:04 -0500
Date: Wed, 7 Nov 2018 08:34:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/8] xfs: check the ir_startino alignment directly
Message-ID: <20181106213447.GQ19305@dastard>
References: <154147728649.32496.4515247239602322709.stgit@magnolia>
 <154147730502.32496.4086322277755351139.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154147730502.32496.4086322277755351139.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 05, 2018 at 08:08:25PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In xchk_iallocbt_rec, check the alignment of ir_startino by converting
> the inode cluster block alignment into units of inodes instead of the
> other way around (converting ir_startino to blocks).  This prevents us
> from tripping over off-by-one errors in ir_startino which are obscured
> by the inode -> block conversion.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/ialloc.c |   32 ++++++++++++++++++++++++++------
>  1 file changed, 26 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 3c12a0fe3b38..f498dfca3312 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -278,6 +278,29 @@ xchk_iallocbt_check_freemask(
>  	return error;
>  }
>  
> +/* Make sure this record is aligned to cluster and inoalignmnt size. */
> +STATIC void
> +xchk_iallocbt_rec_alignment(
> +	struct xchk_btree		*bs,
> +	struct xfs_inobt_rec_incore	*irec)
> +{
> +	struct xfs_mount		*mp = bs->cur->bc_mp;
> +	struct xchk_iallocbt		*iabt = bs->private;
> +	xfs_agino_t			imask;
> +
> +	imask = XFS_OFFBNO_TO_AGINO(mp, iabt->cluster_align, 0) - 1;

Again, this seems obtuse.

	imask = (iabt->cluster_align << mp->m_sb.sb_inopblog) - 1;

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
