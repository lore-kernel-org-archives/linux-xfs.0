Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49398 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751150AbeEPV3b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 17:29:31 -0400
Subject: Re: [PATCH 06/22] xfs: add a repair helper to reset superblock
 counters
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642365674.1556.6776151224606075985.stgit@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <9d776d47-48ff-59ef-f46f-f1c40750cf5d@oracle.com>
Date: Wed, 16 May 2018 14:29:27 -0700
MIME-Version: 1.0
In-Reply-To: <152642365674.1556.6776151224606075985.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com

On 05/15/2018 03:34 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a helper function to reset the superblock inode and block counters.
> The AG rebuilding functions will need these to adjust the counts if they
> need to change as a part of recovering from corruption.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/scrub/repair.c |   79 +++++++++++++++++++++++++++++++++++++++++++++++++
>   fs/xfs/scrub/repair.h |    7 ++++
>   fs/xfs/scrub/scrub.c  |    2 +
>   fs/xfs/scrub/scrub.h  |    1 +
>   4 files changed, 89 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 06c84f76d7ff..1ca7e124e1a7 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -944,3 +944,82 @@ xfs_repair_find_ag_btree_roots(
>   
>   	return error;
>   }
> +
> +/* Reset the superblock counters from the AGF/AGI. */
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
> +
> +	/* ...and then update the per-cpu counters. */
> +	if (delta_icount) {
> +		error = xfs_mod_icount(mp, delta_icount);
> +		if (error)
> +			return error;
> +	}
> +	if (delta_ifree) {
> +		error = xfs_mod_ifree(mp, delta_ifree);
> +		if (error)
> +			return error;
> +	}
> +	if (delta_fdblocks) {
> +		error = xfs_mod_fdblocks(mp, delta_fdblocks, false);
> +		if (error)
> +			return error;
> +	}
> +
> +	return 0;
> +}
> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index 55441774e8e5..eea32a26f947 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -96,6 +96,7 @@ int xfs_repair_find_ag_btree_roots(struct xfs_scrub_context *sc,
>   		struct xfs_buf *agf_bp,
>   		struct xfs_repair_find_ag_btree *btree_info,
>   		struct xfs_buf *agfl_bp);
> +int xfs_repair_reset_counters(struct xfs_mount *mp);
>   
>   /* Metadata repairers */
>   
> @@ -121,6 +122,12 @@ xfs_repair_calc_ag_resblks(
>   	return 0;
>   }
>   
> +static inline int xfs_repair_reset_counters(struct xfs_mount *mp)
> +{
> +	ASSERT(0);
> +	return -EIO;
> +}
> +
>   #define xfs_repair_probe		xfs_repair_notsupported
>   
>   #endif /* CONFIG_XFS_ONLINE_REPAIR */
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index c5999c28c20c..bf5e8dd66133 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -200,6 +200,8 @@ xfs_scrub_teardown(
>   		kmem_free(sc->buf);
>   		sc->buf = NULL;
>   	}
> +	if (sc->reset_counters && !error)
> +		error = xfs_repair_reset_counters(sc->mp);
>   	return error;
>   }
>   
> diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
> index 2f89a84a0e10..1aaea393c2d1 100644
> --- a/fs/xfs/scrub/scrub.h
> +++ b/fs/xfs/scrub/scrub.h
> @@ -77,6 +77,7 @@ struct xfs_scrub_context {
>   	uint				ilock_flags;
>   	bool				try_harder;
>   	bool				has_quotaofflock;
> +	bool				reset_counters;
I noticed this bool is added here, and used in the conditional above,
but I don't see where it gets set to anything?  Maybe it gets used later 
in the set?

Other than that looks good.  Thx!

Reviewed by: Allison Henderson <allison.henderson@oracle.com>

>   
>   	/* State tracking for single-AG operations. */
>   	struct xfs_scrub_ag		sa;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=QJevHm77WCVmLISD9kjEPpN22CjDaymobWOYR-vTC2c&s=LEL8S70qR88zGjqrODTcuvE_OA75SuB5hdZ86g6FD70&e=
> 
