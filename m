Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60510 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbfDIVLd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Apr 2019 17:11:33 -0400
Subject: Re: [PATCH 26/36] xfs_repair: refactor buffer ops assignments during
 phase 5
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259758961.31886.4826767055567611572.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b53bae1a-3791-3cba-da33-279744b299c5@sandeen.net>
Date: Tue, 9 Apr 2019 16:11:32 -0500
MIME-Version: 1.0
In-Reply-To: <155259758961.31886.4826767055567611572.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/14/19 4:06 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the buffer ops assignments in phase 5 to use a helper function
> to determine the correct buf_ops instead of open-coding them.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/phase5.c |   34 ++++++++++++++++++++++++++++------
>  1 file changed, 28 insertions(+), 6 deletions(-)

This is bugging me a bit from a symmetry POV in terms of when your
helper is used and when it's not... a generic helper that only
helps a subset of the btnums seems weird to me.

(I get it that in this case it's because 2 types use the same
ops, but still)

C symbol: b_ops

  File                 Function                 Line
0 repair/dino_chunks.c check_aginode_block        57 bp->b_ops = &xfs_inode_buf_ops;
1 repair/dino_chunks.c process_inode_chunk	 682 bplist[bp_index]->b_ops = &xfs_inode_buf_ops;
2 repair/phase5.c      prop_freespace_cursor     697 lptr->buf_p->b_ops = ops;
3 repair/phase5.c      build_freespace_tree	 777 lptr->buf_p->b_ops = ops;
4 repair/phase5.c      build_freespace_tree	 804 lptr->buf_p->b_ops = ops;
5 repair/phase5.c      prop_ino_cursor          1062 lptr->buf_p->b_ops = ops;
6 repair/phase5.c      build_agi                1104 agi_buf->b_ops = &xfs_agi_buf_ops;
7 repair/phase5.c      build_ino_tree           1185 lptr->buf_p->b_ops = ops;
8 repair/phase5.c      build_ino_tree           1213 lptr->buf_p->b_ops = ops;
9 repair/phase5.c      prop_rmap_cursor         1466 lptr->buf_p->b_ops = &xfs_rmapbt_buf_ops;
a repair/phase5.c      build_rmap_tree          1578 lptr->buf_p->b_ops = &xfs_rmapbt_buf_ops;
b repair/phase5.c      build_rmap_tree          1605 lptr->buf_p->b_ops = &xfs_rmapbt_buf_ops;
c repair/phase5.c      prop_refc_cursor         1814 lptr->buf_p->b_ops = &xfs_refcountbt_buf_ops;
d repair/phase5.c      build_refcount_tree	1881 lptr->buf_p->b_ops = &xfs_refcountbt_buf_ops;
e repair/phase5.c      build_refcount_tree	1908 lptr->buf_p->b_ops = &xfs_refcountbt_buf_ops;
f repair/phase5.c      build_agf_agfl           1992 agf_buf->b_ops = &xfs_agf_buf_ops;
g repair/phase5.c      build_agf_agfl           2064 agfl_buf->b_ops = &xfs_agfl_buf_ops;
h repair/phase6.c      dir_read_buf              205 (*bpp)->b_ops = ops;
i repair/phase6.c      longform_dir2_check_node 2181 bp->b_ops = &xfs_dir3_leafn_buf_ops;


> 
> diff --git a/repair/phase5.c b/repair/phase5.c
> index 367c3ab9..0c53096f 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -615,6 +615,24 @@ calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
>  	return(extra_blocks);
>  }
>  
> +/* Map btnum to buffer ops for the types that need it. */
> +static const struct xfs_buf_ops *
> +btnum_to_ops(
> +	xfs_btnum_t	btnum)
> +{
> +	switch (btnum) {
> +	case XFS_BTNUM_BNO:
> +	case XFS_BTNUM_CNT:
> +		return &xfs_allocbt_buf_ops;
> +	case XFS_BTNUM_INO:
> +	case XFS_BTNUM_FINO:
> +		return &xfs_inobt_buf_ops;
> +	default:
> +		ASSERT(0);
> +		return NULL;
> +	}
> +}
> +
>  static void
>  prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
>  		bt_status_t *btree_curs, xfs_agblock_t startblock,
> @@ -625,6 +643,7 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
>  	xfs_alloc_ptr_t		*bt_ptr;
>  	xfs_agblock_t		agbno;
>  	bt_stat_level_t		*lptr;
> +	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
>  
>  	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
>  
> @@ -675,7 +694,7 @@ prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
>  		/*
>  		 * initialize block header
>  		 */
> -		lptr->buf_p->b_ops = &xfs_allocbt_buf_ops;
> +		lptr->buf_p->b_ops = ops;
>  		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
>  		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
>  		libxfs_btree_init_block(mp, lptr->buf_p, btnum, level,
> @@ -723,6 +742,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
>  	extent_tree_node_t	*ext_ptr;
>  	bt_stat_level_t		*lptr;
>  	xfs_extlen_t		freeblks;
> +	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
>  
>  	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
>  
> @@ -754,7 +774,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
>  		/*
>  		 * initialize block header
>  		 */
> -		lptr->buf_p->b_ops = &xfs_allocbt_buf_ops;
> +		lptr->buf_p->b_ops = ops;
>  		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
>  		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
>  		libxfs_btree_init_block(mp, lptr->buf_p, btnum, i, 0, agno, 0);
> @@ -781,7 +801,7 @@ build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
>  		/*
>  		 * block initialization, lay in block header
>  		 */
> -		lptr->buf_p->b_ops = &xfs_allocbt_buf_ops;
> +		lptr->buf_p->b_ops = ops;
>  		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
>  		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
>  		libxfs_btree_init_block(mp, lptr->buf_p, btnum, 0, 0, agno, 0);
> @@ -990,6 +1010,7 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
>  	xfs_inobt_ptr_t		*bt_ptr;
>  	xfs_agblock_t		agbno;
>  	bt_stat_level_t		*lptr;
> +	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
>  
>  	level++;
>  
> @@ -1038,7 +1059,7 @@ prop_ino_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *btree_curs,
>  		/*
>  		 * initialize block header
>  		 */
> -		lptr->buf_p->b_ops = &xfs_inobt_buf_ops;
> +		lptr->buf_p->b_ops = ops;
>  		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
>  		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
>  		libxfs_btree_init_block(mp, lptr->buf_p, btnum,
> @@ -1130,6 +1151,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
>  	xfs_inobt_rec_t		*bt_rec;
>  	ino_tree_node_t		*ino_rec;
>  	bt_stat_level_t		*lptr;
> +	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
>  	xfs_agino_t		count = 0;
>  	xfs_agino_t		freecount = 0;
>  	int			inocnt;
> @@ -1160,7 +1182,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
>  		 * initialize block header
>  		 */
>  
> -		lptr->buf_p->b_ops = &xfs_inobt_buf_ops;
> +		lptr->buf_p->b_ops = ops;
>  		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
>  		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
>  		libxfs_btree_init_block(mp, lptr->buf_p, btnum, i, 0, agno, 0);
> @@ -1188,7 +1210,7 @@ build_ino_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
>  		/*
>  		 * block initialization, lay in block header
>  		 */
> -		lptr->buf_p->b_ops = &xfs_inobt_buf_ops;
> +		lptr->buf_p->b_ops = ops;
>  		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
>  		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
>  		libxfs_btree_init_block(mp, lptr->buf_p, btnum, 0, 0, agno, 0);
> 
