Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:53187 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751769AbeE2DfA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 May 2018 23:35:00 -0400
Date: Tue, 29 May 2018 13:28:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 06/22] xfs: add a repair helper to reset superblock
 counters
Message-ID: <20180529032810.GM10363@dastard>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642365674.1556.6776151224606075985.stgit@magnolia>
 <20180518035623.GD23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180518035623.GD23858@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 17, 2018 at 08:56:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a helper function to reset the superblock inode and block counters.
> The AG rebuilding functions will need these to adjust the counts if they
> need to change as a part of recovering from corruption.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
> v2: improve documentation
> ---
>  fs/xfs/scrub/repair.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/repair.h |    7 ++++
>  fs/xfs/scrub/scrub.c  |    2 +
>  fs/xfs/scrub/scrub.h  |    1 +
>  4 files changed, 99 insertions(+)
> 
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 877488ce4bc8..4b95a15c0bd0 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -1026,3 +1026,92 @@ xfs_repair_find_ag_btree_roots(
>  
>  	return error;
>  }
> +
> +/*
> + * Reset the superblock counters.
> + *
> + * If a repair function changes the inode or free block counters, it must set
> + * reset_counters to push this function to reset the global counters.  Repair
> + * functions are responsible for resetting all other in-core state.  This
> + * function runs outside of transaction context after the repair context has
> + * been torn down, so if there's further filesystem corruption we'll error out
> + * to userspace and give userspace a chance to call back to fix the further
> + * errors.
> + */
> +int
> +xfs_repair_reset_counters(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_buf		*agi_bp;
> +	struct xfs_buf		*agf_bp;
> +	struct xfs_agi		*agi;
> +	struct xfs_agf		*agf;
> +	xfs_agnumber_t		agno;
> +	xfs_ino_t		icount = 0;
> +	xfs_ino_t		ifree = 0;
> +	xfs_filblks_t		fdblocks = 0;
> +	int64_t			delta_icount;
> +	int64_t			delta_ifree;
> +	int64_t			delta_fdblocks;
> +	int			error;
> +
> +	trace_xfs_repair_reset_counters(mp);
> +
> +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> +		/* Count all the inodes... */
> +		error = xfs_ialloc_read_agi(mp, NULL, agno, &agi_bp);
> +		if (error)
> +			return error;
> +		agi = XFS_BUF_TO_AGI(agi_bp);
> +		icount += be32_to_cpu(agi->agi_count);
> +		ifree += be32_to_cpu(agi->agi_freecount);
> +		xfs_buf_relse(agi_bp);
> +
> +		/* Add up the free/freelist/bnobt/cntbt blocks... */
> +		error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agf_bp);
> +		if (error)
> +			return error;
> +		if (!agf_bp)
> +			return -ENOMEM;
> +		agf = XFS_BUF_TO_AGF(agf_bp);
> +		fdblocks += be32_to_cpu(agf->agf_freeblks);
> +		fdblocks += be32_to_cpu(agf->agf_flcount);
> +		fdblocks += be32_to_cpu(agf->agf_btreeblks);
> +		xfs_buf_relse(agf_bp);
> +	}
> +
> +	/*
> +	 * Reinitialize the counters.  The on-disk and in-core counters differ
> +	 * by the number of inodes/blocks reserved by the admin, the per-AG
> +	 * reservation, and any transactions in progress, so we have to
> +	 * account for that.  First we take the sb lock and update its
> +	 * counters...
> +	 */
> +	spin_lock(&mp->m_sb_lock);
> +	delta_icount = (int64_t)mp->m_sb.sb_icount - icount;
> +	delta_ifree = (int64_t)mp->m_sb.sb_ifree - ifree;
> +	delta_fdblocks = (int64_t)mp->m_sb.sb_fdblocks - fdblocks;
> +	mp->m_sb.sb_icount = icount;
> +	mp->m_sb.sb_ifree = ifree;
> +	mp->m_sb.sb_fdblocks = fdblocks;
> +	spin_unlock(&mp->m_sb_lock);

This seems racy to me ? i.e. the per-ag counters can change while
we are summing them, and once we've summed them then sb counters
can change while we are waiting for the m_sb_lock. It's looks to me
like the summed per-ag counters are not in any way coherent
wit the superblock or the in-core per-CPU counters, so I'm
struggling to understand why this is safe?

We can do this sort of summation at mount time (in
xfs_initialize_perag_data()) because the filesystem is running
single threaded while the summation is taking place and so nothing
is changing during th summation. The filesystem is active in this
case, so I don't think we can do the same thing here.

Also, it brought a question to mind because I haven't clearly noted
it happening yet: when do the xfs_perag counters get corrected? And
if they are already correct, why not just iterate the perag
counters?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
