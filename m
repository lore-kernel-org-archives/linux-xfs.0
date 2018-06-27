Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:34522 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751706AbeF0CW2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jun 2018 22:22:28 -0400
Date: Wed, 27 Jun 2018 12:22:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/21] xfs: repair the AGI
Message-ID: <20180627022209.GE19934@dastard>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986824119.3155.17444896035154098752.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152986824119.3155.17444896035154098752.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jun 24, 2018 at 12:24:01PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Rebuild the AGI header items with some help from the rmapbt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/agheader_repair.c |  211 ++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/repair.h          |    2 
>  fs/xfs/scrub/scrub.c           |    2 
>  3 files changed, 214 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 90e5e6cbc911..61e0134f6f9f 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -698,3 +698,214 @@ xfs_repair_agfl(
>  	xfs_repair_cancel_btree_extents(sc, &agfl_extents);
>  	return error;
>  }
> +
> +/* AGI */
> +
> +enum {
> +	REPAIR_AGI_INOBT = 0,
> +	REPAIR_AGI_FINOBT,
> +	REPAIR_AGI_END,
> +	REPAIR_AGI_MAX
> +};

XFS_BTNUM_INOBT?

Basically same infrastructure questions as last patch.

.....
> +/*
> + * Reinitialize the AGI header, making an in-core copy of the old contents so
> + * that we know which in-core state needs to be reinitialized.
> + */
> +STATIC void
> +xfs_repair_agi_init_header(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_buf			*agi_bp,
> +	struct xfs_agi			*old_agi)
> +{
> +	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agi_bp);
> +	struct xfs_mount		*mp = sc->mp;
> +
> +	memcpy(old_agi, agi, sizeof(*old_agi));
> +	memset(agi, 0, BBTOB(agi_bp->b_length));
> +	agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
> +	agi->agi_versionnum = cpu_to_be32(XFS_AGI_VERSION);
> +	agi->agi_seqno = cpu_to_be32(sc->sa.agno);
> +	agi->agi_length = cpu_to_be32(xfs_ag_block_count(mp, sc->sa.agno));
> +	agi->agi_newino = cpu_to_be32(NULLAGINO);
> +	agi->agi_dirino = cpu_to_be32(NULLAGINO);
> +	if (xfs_sb_version_hascrc(&mp->m_sb))
> +		uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid);
> +
> +	/* We don't know how to fix the unlinked list yet. */
> +	memcpy(&agi->agi_unlinked, &old_agi->agi_unlinked,
> +			sizeof(agi->agi_unlinked));
> +}

and clear pagi_init?

> +/* Update the AGI counters. */
> +STATIC int
> +xfs_repair_agi_update_btree_counters(

_update_counts

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
