Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15712 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727627AbfAINcj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 Jan 2019 08:32:39 -0500
Date: Wed, 9 Jan 2019 08:32:36 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/7] xfs: scrub big block inode btrees correctly
Message-ID: <20190109133236.GB13613@bfoster>
References: <154697955494.2494.5221420762912855354.stgit@magnolia>
 <154697959265.2494.12997637561160260241.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154697959265.2494.12997637561160260241.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 08, 2019 at 12:33:12PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach scrub how to handle the case that there are one or more inobt
> records covering a given inode cluster.  This fixes the operation on big
> block filesystems (e.g. 64k blocks, 512 byte inodes).
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/ialloc.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 708f6607db71..1929d79ea6b3 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -162,6 +162,7 @@ xchk_iallocbt_check_cluster_ifree(
>  	xfs_ino_t			fsino;
>  	xfs_agino_t			agino;
>  	unsigned int			offset;
> +	unsigned int			cluster_buf_base;
>  	bool				irec_free;
>  	bool				ino_inuse;
>  	bool				freemask_ok;
> @@ -174,10 +175,17 @@ xchk_iallocbt_check_cluster_ifree(
>  	 * Given an inobt record, an offset of a cluster within the record, and
>  	 * an offset of an inode within a cluster, compute which fs inode we're
>  	 * talking about and the offset of that inode within the buffer.
> +	 *
> +	 * Be careful about inobt records that don't align with the start of
> +	 * the inode buffer when block sizes are large enough to hold multiple
> +	 * inode chunks.  When this happens, cluster_base will be zero but
> +	 * ir_startino can be large enough to make cluster_buf_base nonzero.
>  	 */
>  	agino = irec->ir_startino + cluster_base + cluster_index;
>  	fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_private.a.agno, agino);
> -	offset = cluster_index * mp->m_sb.sb_inodesize;
> +	cluster_buf_base = XFS_INO_TO_OFFSET(mp, irec->ir_startino);
> +	ASSERT(cluster_buf_base == 0 || cluster_base == 0);
> +	offset = (cluster_buf_base + cluster_index) * mp->m_sb.sb_inodesize;
>  	if (offset >= BBTOB(cluster_bp->b_length)) {
>  		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
>  		goto out;
> 
