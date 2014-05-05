Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 88F5B29DFD
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 16:10:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 58D95304032
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 14:10:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id L2koRWhZsA6jsec7 for
	<xfs@oss.sgi.com>; Mon, 05 May 2014 14:10:01 -0700 (PDT)
Date: Mon, 5 May 2014 17:09:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/6] xfsprogs: get rid of XFS_INODE_CLUSTER_SIZE macros
Message-ID: <20140505210958.GC13973@laptop.bfoster>
References: <536784C6.8000009@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <536784C6.8000009@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, May 05, 2014 at 08:32:06PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Get rid of XFS_INODE_CLUSTER_SIZE() macros, use mp->m_inode_cluster_size
> directly.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  include/xfs_ialloc.h    |  1 -
>  libxfs/xfs_ialloc.c     | 10 +++++-----
>  libxfs/xfs_trans_resv.c |  2 +-
>  repair/dino_chunks.c    |  2 +-
>  repair/prefetch.c       |  6 +++---
>  repair/xfs_repair.c     |  2 +-
>  6 files changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/include/xfs_ialloc.h b/include/xfs_ialloc.h
> index 4689b02..4026933 100644
> --- a/include/xfs_ialloc.h
> +++ b/include/xfs_ialloc.h
> @@ -34,7 +34,6 @@ struct xfs_btree_cur;
>   * Move inodes in clusters of this size.
>   */
>  #define	XFS_INODE_BIG_CLUSTER_SIZE	8192
> -#define	XFS_INODE_CLUSTER_SIZE(mp)	(mp)->m_inode_cluster_size
>  
>  /*
>   * Make an inode pointer out of the buffer/offset.
> diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
> index 108f6f2..bd47971 100644
> --- a/libxfs/xfs_ialloc.c
> +++ b/libxfs/xfs_ialloc.c
> @@ -28,7 +28,7 @@ xfs_ialloc_cluster_alignment(
>  {
>  	if (xfs_sb_version_hasalign(&args->mp->m_sb) &&
>  	    args->mp->m_sb.sb_inoalignmt >=
> -	     XFS_B_TO_FSBT(args->mp, XFS_INODE_CLUSTER_SIZE(args->mp)))
> +	     XFS_B_TO_FSBT(args->mp, args->mp->m_inode_cluster_size))
>  		return args->mp->m_sb.sb_inoalignmt;
>  	return 1;
>  }
> @@ -157,12 +157,12 @@ xfs_ialloc_inode_init(
>  	 * For small block sizes, manipulate the inodes in buffers
>  	 * which are multiples of the blocks size.
>  	 */
> -	if (mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp)) {
> +	if (mp->m_sb.sb_blocksize >= mp->m_inode_cluster_size) {
>  		blks_per_cluster = 1;
>  		nbufs = length;
>  		ninodes = mp->m_sb.sb_inopblock;
>  	} else {
> -		blks_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) /
> +		blks_per_cluster = mp->m_inode_cluster_size /
>  				   mp->m_sb.sb_blocksize;
>  		nbufs = length / blks_per_cluster;
>  		ninodes = blks_per_cluster * mp->m_sb.sb_inopblock;
> @@ -1360,7 +1360,7 @@ xfs_imap(
>  		return XFS_ERROR(EINVAL);
>  	}
>  
> -	blks_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_blocklog;
> +	blks_per_cluster = mp->m_inode_cluster_size >> mp->m_sb.sb_blocklog;
>  
>  	/*
>  	 * For bulkstat and handle lookups, we have an untrusted inode number
> @@ -1381,7 +1381,7 @@ xfs_imap(
>  	 * If the inode cluster size is the same as the blocksize or
>  	 * smaller we get to the buffer by simple arithmetics.
>  	 */
> -	if (XFS_INODE_CLUSTER_SIZE(mp) <= mp->m_sb.sb_blocksize) {
> +	if (mp->m_inode_cluster_size <= mp->m_sb.sb_blocksize) {
>  		offset = XFS_INO_TO_OFFSET(mp, ino);
>  		ASSERT(offset < mp->m_sb.sb_inopblock);
>  
> diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
> index 1e59fad..ba9c7b0 100644
> --- a/libxfs/xfs_trans_resv.c
> +++ b/libxfs/xfs_trans_resv.c
> @@ -369,7 +369,7 @@ xfs_calc_ifree_reservation(
>  		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
>  		xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, 1)) +
>  		MAX((__uint16_t)XFS_FSB_TO_B(mp, 1),
> -		    XFS_INODE_CLUSTER_SIZE(mp)) +
> +		    mp->m_inode_cluster_size) +
>  		xfs_calc_buf_res(1, 0) +
>  		xfs_calc_buf_res(2 + XFS_IALLOC_BLOCKS(mp) +
>  				 mp->m_in_maxlevels, 0) +
> diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
> index 15aa4f8..2c2fd79 100644
> --- a/repair/dino_chunks.c
> +++ b/repair/dino_chunks.c
> @@ -598,7 +598,7 @@ process_inode_chunk(
>  	*bogus = 0;
>  	ASSERT(XFS_IALLOC_BLOCKS(mp) > 0);
>  
> -	blks_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_blocklog;
> +	blks_per_cluster = mp->m_inode_cluster_size >> mp->m_sb.sb_blocklog;
>  	if (blks_per_cluster == 0)
>  		blks_per_cluster = 1;
>  	cluster_count = XFS_INODES_PER_CHUNK / inodes_per_cluster;
> diff --git a/repair/prefetch.c b/repair/prefetch.c
> index 2cd3d5a..25ceb34 100644
> --- a/repair/prefetch.c
> +++ b/repair/prefetch.c
> @@ -682,7 +682,7 @@ pf_queuing_worker(
>  	int			i;
>  	int			err;
>  
> -	blks_per_cluster =  XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_blocklog;
> +	blks_per_cluster = mp->m_inode_cluster_size >> mp->m_sb.sb_blocklog;
>  	if (blks_per_cluster == 0)
>  		blks_per_cluster = 1;
>  
> @@ -844,8 +844,8 @@ start_inode_prefetch(
>  	 */
>  
>  	max_queue = libxfs_bcache->c_maxcount / thread_count / 8;
> -	if (XFS_INODE_CLUSTER_SIZE(mp) > mp->m_sb.sb_blocksize)
> -		max_queue = max_queue * (XFS_INODE_CLUSTER_SIZE(mp) >>
> +	if (mp->m_inode_cluster_size > mp->m_sb.sb_blocksize)
> +		max_queue = max_queue * (mp->m_inode_cluster_size >>
>  				mp->m_sb.sb_blocklog) / XFS_IALLOC_BLOCKS(mp);
>  
>  	sem_init(&args->ra_count, 0, max_queue);
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index 08b25f0..b6d070b 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -618,7 +618,7 @@ main(int argc, char **argv)
>  	chunks_pblock = mp->m_sb.sb_inopblock / XFS_INODES_PER_CHUNK;
>  	max_symlink_blocks = libxfs_symlink_blocks(mp, MAXPATHLEN);
>  	inodes_per_cluster = MAX(mp->m_sb.sb_inopblock,
> -			XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog);
> +			mp->m_inode_cluster_size >> mp->m_sb.sb_inodelog);
>  
>  	/*
>  	 * Automatic striding for high agcount filesystems.
> -- 
> 1.8.3.2
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
