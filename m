Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5BDBA29DF5
	for <xfs@oss.sgi.com>; Wed, 21 Oct 2015 16:08:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 08713AC001
	for <xfs@oss.sgi.com>; Wed, 21 Oct 2015 14:08:43 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id vvJ5covx4uNythiu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 21 Oct 2015 14:08:42 -0700 (PDT)
Date: Wed, 21 Oct 2015 14:08:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 32/51] xfs_repair: add fixed-location per-AG rmaps
Message-ID: <20151021210834.GL10397@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
	<20151007050838.1504.57156.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151007050838.1504.57156.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com
Cc: xfs@oss.sgi.com

On Tue, Oct 06, 2015 at 10:08:38PM -0700, Darrick J. Wong wrote:
> Add reverse-mappings for fixed-location per-AG metadata such as inode
> chunks, superblocks, and the log to the raw rmap list, then merge the
> raw rmap data (which also has the BMBT data) into the main rmap list.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/phase4.c |   41 +++++++++++++++++++++++++++++++++++++++++
>  repair/rmap.c   |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  repair/rmap.h   |    2 ++
>  3 files changed, 94 insertions(+)
> 
> 
> diff --git a/repair/phase4.c b/repair/phase4.c
> index bc43cd8..cbdb92e 100644
> --- a/repair/phase4.c
> +++ b/repair/phase4.c
> @@ -157,6 +157,40 @@ process_ags(
>  	do_inode_prefetch(mp, ag_stride, process_ag_func, true, false);
>  }
>  
> +static void
> +check_rmap_btrees(
> +	work_queue_t	*wq,
> +	xfs_agnumber_t	agno,
> +	void		*arg)
> +{
> +	int		error;
> +
> +	error = add_fixed_ag_rmap_data(wq->mp, agno);
> +	if (error)
> +		do_error(
> +_("unable to add AG %u metadata reverse-mapping data.\n"), agno);
> +
> +	error = fold_raw_rmaps(wq->mp, agno);
> +	if (error)
> +		do_error(
> +_("unable to merge AG %u metadata reverse-mapping data.\n"), agno);
> +}
> +
> +static void
> +process_rmap_data(
> +	struct xfs_mount	*mp)
> +{
> +	struct work_queue	wq;
> +	xfs_agnumber_t		i;
> +
> +	if (!needs_rmap_work(mp))
> +		return;
> +
> +	create_work_queue(&wq, mp, libxfs_nproc());
> +	for (i = 0; i < mp->m_sb.sb_agcount; i++)
> +		queue_work(&wq, check_rmap_btrees, i, NULL);
> +	destroy_work_queue(&wq);
> +}
>  
>  void
>  phase4(xfs_mount_t *mp)
> @@ -306,6 +340,13 @@ phase4(xfs_mount_t *mp)
>  	 * already in phase 3.
>  	 */
>  	process_ags(mp);
> +
> +	/*
> +	 * Process all the reverse-mapping data that we collected.  This
> +	 * involves checking the rmap data against the btree.
> +	 */
> +	process_rmap_data(mp);
> +
>  	print_final_rpt();
>  
>  	/*
> diff --git a/repair/rmap.c b/repair/rmap.c
> index 40bdae3..a5ea685 100644
> --- a/repair/rmap.c
> +++ b/repair/rmap.c
> @@ -344,6 +344,57 @@ err:
>  	return error;
>  }
>  
> +/**
> + * add_fixed_ag_rmap_data() - Add fixed per-AG metadata to the rmap list.
> + *			      This includes sb/agi/agf/agfl headers, inode
> + *			      chunks, and the log.
> + *
> + * @mp: XFS mountpoint.
> + * @agno: AG number.
> + */
> +int
> +add_fixed_ag_rmap_data(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno)
> +{
> +	xfs_fsblock_t		fsbno;
> +	xfs_agblock_t		agbno;
> +	ino_tree_node_t		*ino_rec;
> +	int			error;
> +
> +	if (!needs_rmap_work(mp))
> +		return 0;
> +
> +	/* sb/agi/agf/agfl headers */
> +	error = add_ag_rmap(mp, agno, 0, XFS_BNO_BLOCK(mp),
> +			XFS_RMAP_OWN_FS);
> +	if (error)
> +		goto out;
> +
> +	/* inodes */
> +	ino_rec = findfirst_inode_rec(agno);
> +	for (; ino_rec != NULL; ino_rec = next_ino_rec(ino_rec)) {
> +		agbno = XFS_AGINO_TO_AGBNO(mp, ino_rec->ino_startnum);
> +		error = add_ag_rmap(mp, agno, agbno,
> +				64 / mp->m_sb.sb_inopblock, /* XXX */

This won't work with sparse inode support turned on, because inode chunks
can be shorter than 64 inodes.  Assuming ir_holemask is accurate, it
shouldn't be difficult to make this emit the correct records.

Fixed now.

--D

> +				XFS_RMAP_OWN_INODES);
> +		if (error)
> +			goto out;
> +	}
> +
> +	/* log */
> +	fsbno = mp->m_sb.sb_logstart;
> +	if (fsbno && XFS_FSB_TO_AGNO(mp, fsbno) == agno) {
> +		agbno = XFS_FSB_TO_AGBNO(mp, mp->m_sb.sb_logstart);
> +		error = add_ag_rmap(mp, agno, agbno, mp->m_sb.sb_logblocks,
> +				XFS_RMAP_OWN_LOG);
> +		if (error)
> +			goto out;
> +	}
> +out:
> +	return error;
> +}
> +
>  #ifdef RMAP_DEBUG
>  static void
>  dump_rmap(
> diff --git a/repair/rmap.h b/repair/rmap.h
> index 57d56a0..7bab450 100644
> --- a/repair/rmap.h
> +++ b/repair/rmap.h
> @@ -31,4 +31,6 @@ extern int add_ag_rmap(struct xfs_mount *, xfs_agnumber_t agno,
>  extern int add_bmbt_rmap(struct xfs_mount *, xfs_ino_t, int, xfs_fsblock_t);
>  extern int fold_raw_rmaps(struct xfs_mount *mp, xfs_agnumber_t agno);
>  
> +extern int add_fixed_ag_rmap_data(struct xfs_mount *, xfs_agnumber_t);
> +
>  #endif /* RMAP_H_ */
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
