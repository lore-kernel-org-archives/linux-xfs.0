Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B39A929DF8
	for <xfs@oss.sgi.com>; Mon, 30 Dec 2013 10:57:27 -0600 (CST)
Message-ID: <52C1A5F7.2040604@sgi.com>
Date: Mon, 30 Dec 2013 10:57:27 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 6/10] xfs: introduce xfs_bulkstat_ichunk_ra
References: <52BEB459.7020202@oracle.com>
In-Reply-To: <52BEB459.7020202@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 12/28/13 05:22, Jeff Liu wrote:
> From: Jie Liu<jeff.liu@oracle.com>
>
> Introduce xfs_bulkstat_ichunk_ra() to loop over all clusters in
> the next inode chunk, then performs readahead if there are any
> allocated inodes in that cluster.
>
> Refactor xfs_bulkstat() with it.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
> ---

Had some problems applying this patch.
...

> +STATIC void
> +xfs_bulkstat_ichunk_ra(
> +	struct xfs_mount		*mp,
> +	xfs_agnumber_t			agno,
> +	struct xfs_inobt_rec_incore	*irec)
> +{
> +	xfs_agblock_t			agbno;
> +	struct blk_plug			plug;
> +	int				blks_per_cluster;
> +	int				inodes_per_cluster;
> +	int				i;	/* inode chunk index */
> +
> +	agbno = XFS_AGINO_TO_AGBNO(mp, irec->ir_startino);
> +	blks_per_cluster = xfs_icluster_size_fsb(mp);
                            ^^^^^
does not exist.


> @@ -187,7 +218,6 @@ xfs_bulkstat(
>   	char			__user *ubuffer, /* buffer with inode stats */
>   	int			*done)	/* 1 if there are more stats to get */
>   {
> -	xfs_agblock_t		agbno=0;/* allocation group block number */
>   	xfs_buf_t		*agbp;	/* agi header buffer */
>   	xfs_agi_t		*agi;	/* agi header data */
>   	xfs_agino_t		agino;	/* inode # in allocation group */
> @@ -206,8 +236,6 @@ xfs_bulkstat(
>   	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
>   	xfs_inobt_rec_incore_t	*irbufend; /* end of good irec buffer entries */
>   	xfs_ino_t		lastino; /* last inode number returned */
> -	int			blks_per_cluster; /* # of blocks per cluster */
> -	int			inodes_per_cluster;/* # of inodes per cluster */
>   	int			nirbuf;	/* size of irbuf */
>   	int			rval;	/* return value error code */
>   	int			tmp;	/* result value from btree calls */
> @@ -236,8 +264,6 @@ xfs_bulkstat(
>   	*done = 0;
>   	fmterror = 0;
>   	ubufp = ubuffer;
> -	blks_per_cluster = xfs_icluster_size_fsb(mp);
> -	inodes_per_cluster = blks_per_cluster<<  mp->m_sb.sb_inopblog;
>   	irbuf = kmem_zalloc_greedy(&irbsize, PAGE_SIZE, PAGE_SIZE * 4);
>   	if (!irbuf)
>   		return ENOMEM;
> @@ -345,25 +371,7 @@ xfs_bulkstat(
>   			 * Also start read-ahead now for this chunk.
>   			 */
>   			if (r.ir_freecount<  XFS_INODES_PER_CHUNK) {
> -				struct blk_plug	plug;
> -				/*
> -				 * Loop over all clusters in the next chunk.
> -				 * Do a readahead if there are any allocated
> -				 * inodes in that cluster.
> -				 */
> -				blk_start_plug(&plug);
> -				agbno = XFS_AGINO_TO_AGBNO(mp, r.ir_startino);
> -				for (chunkidx = 0;
> -				     chunkidx<  XFS_INODES_PER_CHUNK;
> -				     chunkidx += inodes_per_cluster,
> -				     agbno += blks_per_cluster) {
> -					if (xfs_inobt_maskn(chunkidx,
> -					    inodes_per_cluster)&  ~r.ir_free)
> -						xfs_btree_reada_bufs(mp, agno,
> -							agbno, blks_per_cluster,
> -							&xfs_inode_buf_ops);
> -				}
> -				blk_finish_plug(&plug);
> +				xfs_bulkstat_ichunk_ra(mp, agno,&r);
>   				irbp->ir_startino = r.ir_startino;
>   				irbp->ir_freecount = r.ir_freecount;
>   				irbp->ir_free = r.ir_free;

last 3 chunks failed to apply because the sources have 
nbcluster/nicluster (and nimask) instead of 
blks_per_cluster/inodes_per_cluster.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
