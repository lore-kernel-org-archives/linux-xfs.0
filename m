Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2A6E67CA1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 16:47:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EFEE7304048
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 14:47:22 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id IgQAboynz5ksEkdp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 14:47:20 -0700 (PDT)
Date: Wed, 3 Aug 2016 14:47:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: store rmapbt block count in the AGF
Message-ID: <20160803214710.GG8593@birch.djwong.org>
References: <20160803023711.GE8593@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160803023711.GE8593@birch.djwong.org>
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

<grumble> Ok, let's try this again, but this time with the chunk we
need for growfs actually included in the commit.  Someone forgot to
run 'stg ref'.  v2 patch (and xfsprogs stuff) will be out shortly.

--D

On Tue, Aug 02, 2016 at 07:37:11PM -0700, Darrick J. Wong wrote:
> Track the number of blocks used for the rmapbt in the AGF.  When we
> get to the AG reservation code we need this counter to quickly
> make our reservation during mount.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c      |    1 +
>  fs/xfs/libxfs/xfs_format.h     |   11 ++++++++---
>  fs/xfs/libxfs/xfs_rmap_btree.c |    6 ++++++
>  3 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 776ae2f..af1a72e 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2264,6 +2264,7 @@ xfs_alloc_log_agf(
>  		offsetof(xfs_agf_t, agf_longest),
>  		offsetof(xfs_agf_t, agf_btreeblks),
>  		offsetof(xfs_agf_t, agf_uuid),
> +		offsetof(xfs_agf_t, agf_rmap_blocks),
>  		sizeof(xfs_agf_t)
>  	};
>  
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index f814d42..e6a8bea 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -640,12 +640,15 @@ typedef struct xfs_agf {
>  	__be32		agf_btreeblks;	/* # of blocks held in AGF btrees */
>  	uuid_t		agf_uuid;	/* uuid of filesystem */
>  
> +	__be32		agf_rmap_blocks;	/* rmapbt blocks used */
> +	__be32		agf_padding;		/* padding */
> +
>  	/*
>  	 * reserve some contiguous space for future logged fields before we add
>  	 * the unlogged fields. This makes the range logging via flags and
>  	 * structure offsets much simpler.
>  	 */
> -	__be64		agf_spare64[16];
> +	__be64		agf_spare64[15];
>  
>  	/* unlogged fields, written during buffer writeback. */
>  	__be64		agf_lsn;	/* last write sequence */
> @@ -670,7 +673,8 @@ typedef struct xfs_agf {
>  #define	XFS_AGF_LONGEST		0x00000400
>  #define	XFS_AGF_BTREEBLKS	0x00000800
>  #define	XFS_AGF_UUID		0x00001000
> -#define	XFS_AGF_NUM_BITS	13
> +#define	XFS_AGF_RMAP_BLOCKS	0x00002000
> +#define	XFS_AGF_NUM_BITS	14
>  #define	XFS_AGF_ALL_BITS	((1 << XFS_AGF_NUM_BITS) - 1)
>  
>  #define XFS_AGF_FLAGS \
> @@ -686,7 +690,8 @@ typedef struct xfs_agf {
>  	{ XFS_AGF_FREEBLKS,	"FREEBLKS" }, \
>  	{ XFS_AGF_LONGEST,	"LONGEST" }, \
>  	{ XFS_AGF_BTREEBLKS,	"BTREEBLKS" }, \
> -	{ XFS_AGF_UUID,		"UUID" }
> +	{ XFS_AGF_UUID,		"UUID" }, \
> +	{ XFS_AGF_RMAP_BLOCKS,	"RMAP_BLOCKS" }
>  
>  /* disk block (xfs_daddr_t) in the AG */
>  #define XFS_AGF_DADDR(mp)	((xfs_daddr_t)(1 << (mp)->m_sectbb_log))
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index bc1faeb..17b8eeb 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -98,6 +98,8 @@ xfs_rmapbt_alloc_block(
>  	union xfs_btree_ptr	*new,
>  	int			*stat)
>  {
> +	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
> +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
>  	int			error;
>  	xfs_agblock_t		bno;
>  
> @@ -124,6 +126,8 @@ xfs_rmapbt_alloc_block(
>  
>  	xfs_trans_agbtree_delta(cur->bc_tp, 1);
>  	new->s = cpu_to_be32(bno);
> +	be32_add_cpu(&agf->agf_rmap_blocks, 1);
> +	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
>  
>  	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
>  	*stat = 1;
> @@ -143,6 +147,8 @@ xfs_rmapbt_free_block(
>  	bno = xfs_daddr_to_agbno(cur->bc_mp, XFS_BUF_ADDR(bp));
>  	trace_xfs_rmapbt_free_block(cur->bc_mp, cur->bc_private.a.agno,
>  			bno, 1);
> +	be32_add_cpu(&agf->agf_rmap_blocks, -1);
> +	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
>  	error = xfs_alloc_put_freelist(cur->bc_tp, agbp, NULL, bno, 1);
>  	if (error)
>  		return error;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
