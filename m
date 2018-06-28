Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:1092 "EHLO
        ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750936AbeF1A4M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Jun 2018 20:56:12 -0400
Date: Thu, 28 Jun 2018 10:55:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/21] xfs: repair inode btrees
Message-ID: <20180628005516.GB2234@dastard>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986825387.3155.16901181422449777127.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152986825387.3155.16901181422449777127.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Jun 24, 2018 at 12:24:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use the rmapbt to find inode chunks, query the chunks to compute
> hole and free masks, and with that information rebuild the inobt
> and finobt.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

[....]

> +/*
> + * For each cluster in this blob of inode, we must calculate the
> + * properly aligned startino of that cluster, then iterate each
> + * cluster to fill in used and filled masks appropriately.  We
> + * then use the (startino, used, filled) information to construct
> + * the appropriate inode records.
> + */
> +STATIC int
> +xfs_repair_ialloc_process_cluster(
> +	struct xfs_repair_ialloc	*ri,
> +	xfs_agblock_t			agbno,
> +	int				blks_per_cluster,
> +	xfs_agino_t			rec_agino)
> +{
> +	struct xfs_imap			imap;
> +	struct xfs_repair_ialloc_extent	*rie;
> +	struct xfs_dinode		*dip;
> +	struct xfs_buf			*bp;
> +	struct xfs_scrub_context	*sc = ri->sc;
> +	struct xfs_mount		*mp = sc->mp;
> +	xfs_ino_t			fsino;
> +	xfs_inofree_t			usedmask;
> +	xfs_agino_t			nr_inodes;
> +	xfs_agino_t			startino;
> +	xfs_agino_t			clusterino;
> +	xfs_agino_t			clusteroff;
> +	xfs_agino_t			agino;
> +	uint16_t			fillmask;
> +	bool				inuse;
> +	int				usedcount;
> +	int				error;
> +
> +	/* The per-AG inum of this inode cluster. */
> +	agino = XFS_OFFBNO_TO_AGINO(mp, agbno, 0);
> +
> +	/* The per-AG inum of the inobt record. */
> +	startino = rec_agino + rounddown(agino - rec_agino,
> +			XFS_INODES_PER_CHUNK);
> +
> +	/* The per-AG inum of the cluster within the inobt record. */
> +	clusteroff = agino - startino;
> +
> +	/* Every inode in this holemask slot is filled. */
> +	nr_inodes = XFS_OFFBNO_TO_AGINO(mp, blks_per_cluster, 0);
> +	fillmask = xfs_inobt_maskn(clusteroff / XFS_INODES_PER_HOLEMASK_BIT,
> +			nr_inodes / XFS_INODES_PER_HOLEMASK_BIT);
> +
> +	/* Grab the inode cluster buffer. */
> +	imap.im_blkno = XFS_AGB_TO_DADDR(mp, sc->sa.agno, agbno);
> +	imap.im_len = XFS_FSB_TO_BB(mp, blks_per_cluster);
> +	imap.im_boffset = 0;
> +
> +	error = xfs_imap_to_bp(mp, sc->tp, &imap, &dip, &bp, 0,
> +			XFS_IGET_UNTRUSTED);

This is going to error out if the cluster we are asking to be mapped
has no record in the inobt. Aren't we trying to rebuild the inobt
here from the rmap's idea of on-disk clusters? So how do we rebuild
the inobt record if we can't already find the chunk record in the
inobt?

At minimum, this needs a comment explaining why it works.

> +/* Initialize new inobt/finobt roots and implant them into the AGI. */
> +STATIC int
> +xfs_repair_iallocbt_reset_btrees(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_owner_info		*oinfo,
> +	int				*log_flags)
> +{
> +	struct xfs_agi			*agi;
> +	struct xfs_buf			*bp;
> +	struct xfs_mount		*mp = sc->mp;
> +	xfs_fsblock_t			inofsb;
> +	xfs_fsblock_t			finofsb;
> +	enum xfs_ag_resv_type		resv;
> +	int				error;
> +
> +	agi = XFS_BUF_TO_AGI(sc->sa.agi_bp);
> +
> +	/* Initialize new inobt root. */
> +	resv = XFS_AG_RESV_NONE;
> +	error = xfs_repair_alloc_ag_block(sc, oinfo, &inofsb, resv);
> +	if (error)
> +		return error;
> +	error = xfs_repair_init_btblock(sc, inofsb, &bp, XFS_BTNUM_INO,
> +			&xfs_inobt_buf_ops);
> +	if (error)
> +		return error;
> +	agi->agi_root = cpu_to_be32(XFS_FSB_TO_AGBNO(mp, inofsb));
> +	agi->agi_level = cpu_to_be32(1);
> +	*log_flags |= XFS_AGI_ROOT | XFS_AGI_LEVEL;
> +
> +	/* Initialize new finobt root. */
> +	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
> +		return 0;
> +
> +	resv = mp->m_inotbt_nores ? XFS_AG_RESV_NONE : XFS_AG_RESV_METADATA;

Comment explaining this?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
