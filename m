Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:12503 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751171AbdJDBny (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 21:43:54 -0400
Date: Wed, 4 Oct 2017 12:43:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/25] xfs: scrub the AGI
Message-ID: <20171004014347.GX3666@dastard>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706331918.19351.1010060377239825093.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150706331918.19351.1010060377239825093.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 03, 2017 at 01:41:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a forgotten check to the AGI verifier, then wire up the scrub
> infrastructure to check the AGI contents.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h  |    3 +-
>  fs/xfs/scrub/agheader.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/common.c   |    6 ++-
>  fs/xfs/scrub/scrub.c    |    4 ++
>  fs/xfs/scrub/scrub.h    |    1 +
>  5 files changed, 99 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index aeb2a66..1e326dd 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -487,9 +487,10 @@ struct xfs_scrub_metadata {
>  #define XFS_SCRUB_TYPE_SB	1	/* superblock */
>  #define XFS_SCRUB_TYPE_AGF	2	/* AG free header */
>  #define XFS_SCRUB_TYPE_AGFL	3	/* AG free list */
> +#define XFS_SCRUB_TYPE_AGI	4	/* AG inode header */
>  
>  /* Number of scrub subcommands. */
> -#define XFS_SCRUB_TYPE_NR	4
> +#define XFS_SCRUB_TYPE_NR	5
>  
>  /* i: Repair this metadata. */
>  #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index 7fe6630..3d269c2 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -535,3 +535,91 @@ xfs_scrub_agfl(
>  out:
>  	return error;
>  }
> +
> +/* AGI */
> +
> +/* Scrub the AGI. */
> +int
> +xfs_scrub_agi(
> +	struct xfs_scrub_context	*sc)
> +{
> +	struct xfs_mount		*mp = sc->mp;
> +	struct xfs_agi			*agi;
> +	xfs_daddr_t			daddr;
> +	xfs_daddr_t			eofs;
> +	xfs_agnumber_t			agno;
> +	xfs_agblock_t			agbno;
> +	xfs_agblock_t			eoag;
> +	xfs_agino_t			agino;
> +	xfs_agino_t			first_agino;
> +	xfs_agino_t			last_agino;
> +	int				i;
> +	int				level;
> +	int				error = 0;
> +
> +	agno = sc->sm->sm_agno;
> +	error = xfs_scrub_load_ag_headers(sc, agno, XFS_SCRUB_TYPE_AGI);
> +	if (!xfs_scrub_op_ok(sc, agno, XFS_AGI_BLOCK(sc->mp), &error))
> +		goto out;
> +
> +	agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
> +	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
> +
> +	/* Check the AG length */
> +	eoag = be32_to_cpu(agi->agi_length);
> +	if (eoag != xfs_scrub_ag_blocks(mp, agno))
> +		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);

Should we be cross checking that the AGI and AGF both have
the same length here?

> +
> +	/* Check btree roots and levels */
> +	agbno = be32_to_cpu(agi->agi_root);
> +	daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
> +	if (agbno <= XFS_AGI_BLOCK(mp) || agbno >= mp->m_sb.sb_agblocks ||
> +	    agbno >= eoag || daddr >= eofs)
> +		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);

xfs_verify_agbno(), again :P

> +
> +	level = be32_to_cpu(agi->agi_level);
> +	if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
> +		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
> +
> +	if (xfs_sb_version_hasfinobt(&mp->m_sb)) {
> +		agbno = be32_to_cpu(agi->agi_free_root);
> +		daddr = XFS_AGB_TO_DADDR(mp, agno, agbno);
> +		if (agbno <= XFS_AGI_BLOCK(mp) ||
> +		    agbno >= mp->m_sb.sb_agblocks ||
> +		    agbno >= eoag ||
> +		    daddr >= eofs)

Broken records are us....

> +			xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
> +
> +		level = be32_to_cpu(agi->agi_free_level);
> +		if (level <= 0 || level > XFS_BTREE_MAXLEVELS)
> +			xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
> +	}
> +
> +	/* Check inode counters */
> +	first_agino = XFS_OFFBNO_TO_AGINO(mp, XFS_AGI_BLOCK(mp) + 1, 0);

Don't think this is right. AGFL, not AGI....

> +	last_agino = XFS_OFFBNO_TO_AGINO(mp, eoag + 1, 0) - 1;

Not sure this is right, either, because inode chunks won't be
allocated over the end of the AG. hence if the eoag is not chunk
aligned, there will be up to (chunk size - 1) blocks inodes won't be
allocated in...

> +	agino = be32_to_cpu(agi->agi_count);
> +	if (agino > last_agino - first_agino + 1 ||
> +	    agino < be32_to_cpu(agi->agi_freecount))
> +		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);

Please don't use agino as a count of inodes - this confused me
very much because I was wondering how these checks were in any way
realted to valid AG inode numbers....

> +
> +	/* Check inode pointers */
> +	agino = be32_to_cpu(agi->agi_newino);
> +	if (agino != NULLAGINO && (agino < first_agino || agino > last_agino))
> +		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);
> +	agino = be32_to_cpu(agi->agi_dirino);
> +	if (agino != NULLAGINO && (agino < first_agino || agino > last_agino))
> +		xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);

Perhaps we also need a xfs_verify_agino() helper here.

> +	/* Check unlinked inode buckets */
> +	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
> +		agino = be32_to_cpu(agi->agi_unlinked[i]);
> +		if (agino == NULLAGINO)
> +			continue;
> +		if (agino < first_agino || agino > last_agino)
> +			xfs_scrub_block_set_corrupt(sc, sc->sa.agi_bp);

This is effectively the same check as above:

	if (agino != NULLAGINO && (agino < first_agino || agino > last_agino))

so all these checks could use the same helper to make it easier
to read.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
