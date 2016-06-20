Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9744F7CA0
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2016 19:21:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3A5A98F8039
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2016 17:21:53 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	RpubFsgj0hxZVoCp for <xfs@oss.sgi.com>;
	Sun, 19 Jun 2016 17:21:46 -0700 (PDT)
Date: Mon, 20 Jun 2016 10:21:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 006/119] xfs: port differences from xfsprogs libxfs
Message-ID: <20160620002107.GG26977@dastard>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612631079.12839.13685287438216197909.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612631079.12839.13685287438216197909.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Thu, Jun 16, 2016 at 06:18:30PM -0700, Darrick J. Wong wrote:
> Port various differences between xfsprogs and the kernel.  This
> cleans up both so that we can develop rmap and reflink on the
> same libxfs code.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Nak. I'm essentially trying to keep the little hacks needed in 
userspace out of the kernel libxfs tree. We quite regularly get
people scanning the kernel tree and trying to remove things like
exported function prototypes that are not used in kernel space,
so the headers in userspace carry those simply to prevent people
continually sending kernel patches that we have to look at and then
ignore...

> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 99b077c..58bdca7 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2415,7 +2415,9 @@ xfs_alloc_read_agf(
>  			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
>  		spin_lock_init(&pag->pagb_lock);
>  		pag->pagb_count = 0;
> +#ifdef __KERNEL__
>  		pag->pagb_tree = RB_ROOT;
> +#endif
>  		pag->pagf_init = 1;
>  	}
>  #ifdef DEBUG

e.g. this is an indication that reminds us that there is
functionality in the libxfs kernel tree that isn't in userspace...

> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index 4f2aed0..8ef420a 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -51,7 +51,7 @@ int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
>  int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
>  int	xfs_attr_shortform_remove(struct xfs_da_args *args);
>  int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
> -int	xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes);
> +int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
>  void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);

Things like this are fine...

>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 932381c..499e980 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1425,7 +1425,7 @@ xfs_bmap_search_multi_extents(
>   * Else, *lastxp will be set to the index of the found
>   * entry; *gotp will contain the entry.
>   */
> -STATIC xfs_bmbt_rec_host_t *                 /* pointer to found extent entry */
> +xfs_bmbt_rec_host_t *                 /* pointer to found extent entry */
>  xfs_bmap_search_extents(
>  	xfs_inode_t     *ip,            /* incore inode pointer */
>  	xfs_fileoff_t   bno,            /* block number searched for */
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 423a34e..79e3ebe 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -231,4 +231,10 @@ int	xfs_bmap_shift_extents(struct xfs_trans *tp, struct xfs_inode *ip,
>  		int num_exts);
>  int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
>  
> +struct xfs_bmbt_rec_host *
> +	xfs_bmap_search_extents(struct xfs_inode *ip, xfs_fileoff_t bno,
> +				int fork, int *eofp, xfs_extnum_t *lastxp,
> +				struct xfs_bmbt_irec *gotp,
> +				struct xfs_bmbt_irec *prevp);
> +
>  #endif	/* __XFS_BMAP_H__ */

But these are the sort of "clean up the kernel patches" that I was
refering to. If there's a user in kernel space, then fine, otherwise
it doesn't hurt to keep it only in userspace. There are relatively
few of these....

> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 1f88e1c..105979d 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -2532,6 +2532,7 @@ error0:
>  	return error;
>  }
>  
> +#ifdef __KERNEL__
>  struct xfs_btree_split_args {
>  	struct xfs_btree_cur	*cur;
>  	int			level;
> @@ -2609,6 +2610,9 @@ xfs_btree_split(
>  	destroy_work_on_stack(&args.work);
>  	return args.result;
>  }
> +#else /* !KERNEL */
> +#define xfs_btree_split	__xfs_btree_split
> +#endif

Same again -this is 4 lines of code that is userspace only. It's a
tiny amount compared to the original difference that these
kernel-only stack splits required, and so not a huge issue.

> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -31,10 +31,16 @@
>  #include "xfs_cksum.h"
>  #include "xfs_trace.h"
>  
> +/*
> + * XXX: kernel implementation causes ndquots calc to go real
> + * bad. Just leaving the existing userspace calc here right now.
> + */
>  int
>  xfs_calc_dquots_per_chunk(
>  	unsigned int		nbblks)	/* basic block units */
>  {
> +#ifdef __KERNEL__
> +	/* kernel code that goes wrong in userspace! */
>  	unsigned int	ndquots;
>  
>  	ASSERT(nbblks > 0);
> @@ -42,6 +48,10 @@ xfs_calc_dquots_per_chunk(
>  	do_div(ndquots, sizeof(xfs_dqblk_t));
>  
>  	return ndquots;
> +#else
> +	ASSERT(nbblks > 0);
> +	return BBTOB(nbblks) / sizeof(xfs_dqblk_t);
> +#endif
>  }

This is a clear case that we need to fix the code to be
correct for both kernel and userspace without modification, not
propagate the userspace hack back into the kernel code.

> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 9d9559e..794fa66 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -56,6 +56,17 @@ xfs_inobp_check(
>  }
>  #endif
>  
> +bool
> +xfs_dinode_good_version(
> +	struct xfs_mount *mp,
> +	__u8		version)
> +{
> +	if (xfs_sb_version_hascrc(&mp->m_sb))
> +		return version == 3;
> +
> +	return version == 1 || version == 2;
> +}

This xfs_dinode_good_version() change needs to be a separate patch

>  void	xfs_inobp_check(struct xfs_mount *, struct xfs_buf *);
>  #else
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index e8f49c0..e5baba3 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -462,8 +462,8 @@ static inline uint xfs_log_dinode_size(int version)
>  typedef struct xfs_buf_log_format {
>  	unsigned short	blf_type;	/* buf log item type indicator */
>  	unsigned short	blf_size;	/* size of this item */
> -	ushort		blf_flags;	/* misc state */
> -	ushort		blf_len;	/* number of blocks in this buf */
> +	unsigned short	blf_flags;	/* misc state */
> +	unsigned short	blf_len;	/* number of blocks in this buf */
>  	__int64_t	blf_blkno;	/* starting blkno of this buf */
>  	unsigned int	blf_map_size;	/* used size of data bitmap in words */
>  	unsigned int	blf_data_map[XFS_BLF_DATAMAP_SIZE]; /* dirty bitmap */

The removal of ushort/uint from the kernel code needs to be a
separate patch that addresses all the users, not just the couple in
shared headers....

> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 12ca867..09d6fd0 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -261,6 +261,7 @@ xfs_mount_validate_sb(
>  	/*
>  	 * Until this is fixed only page-sized or smaller data blocks work.
>  	 */
> +#ifdef __KERNEL__
>  	if (unlikely(sbp->sb_blocksize > PAGE_SIZE)) {
>  		xfs_warn(mp,
>  		"File system with blocksize %d bytes. "
> @@ -268,6 +269,7 @@ xfs_mount_validate_sb(
>  				sbp->sb_blocksize, PAGE_SIZE);
>  		return -ENOSYS;
>  	}
> +#endif
>  
>  	/*
>  	 * Currently only very few inode sizes are supported.
> @@ -291,10 +293,12 @@ xfs_mount_validate_sb(
>  		return -EFBIG;
>  	}
>  
> +#ifdef __KERNEL__
>  	if (check_inprogress && sbp->sb_inprogress) {
>  		xfs_warn(mp, "Offline file system operation in progress!");
>  		return -EFSCORRUPTED;
>  	}
> +#endif
>  	return 0;
>  }

Again, I don't think this needs to be propagated back into the
kernel code...

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
