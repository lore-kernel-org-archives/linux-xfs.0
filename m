Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:58874 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbeJJWHT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 18:07:19 -0400
Date: Wed, 10 Oct 2018 07:44:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfsprogs: remove unused functions
Message-ID: <20181010144441.GM28243@magnolia>
References: <20181010071023.6765-1-david@fromorbit.com>
 <20181010071023.6765-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181010071023.6765-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 10, 2018 at 06:10:23PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Clean up build warnings about defined by not used functions by
> removing them.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Fine with me; if anyone wants them in the future they can put them back.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  libxfs/rdwr.c  |  8 -------
>  libxfs/util.c  | 63 --------------------------------------------------
>  repair/btree.c | 23 ------------------
>  3 files changed, 94 deletions(-)
> 
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 753b9396fbe5..e580aba1d7ee 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -544,14 +544,6 @@ libxfs_bcompare(struct cache_node *node, cache_key_t key)
>  	return CACHE_MISS;
>  }
>  
> -static void
> -libxfs_bprint(xfs_buf_t *bp)
> -{
> -	fprintf(stderr, "Buffer %p blkno=%llu bytes=%u flags=0x%x count=%u\n",
> -		bp, (unsigned long long)bp->b_bn, (unsigned)bp->b_bcount,
> -		bp->b_flags, bp->b_node.cn_count);
> -}
> -
>  static void
>  __initbuf(xfs_buf_t *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
>  		unsigned int bytes)
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 993218615d00..ffd265094b4c 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -380,69 +380,6 @@ libxfs_ialloc(
>  	return 0;
>  }
>  
> -static void
> -libxfs_iprint(
> -	xfs_inode_t		*ip)
> -{
> -	struct xfs_icdinode	*dip;
> -	xfs_extnum_t		i = 0;
> -	struct xfs_ifork	*ifp;		/* inode fork pointer */
> -	struct xfs_iext_cursor	icur;
> -	xfs_bmbt_irec_t		rec;
> -
> -	printf("Inode %lx\n", (unsigned long)ip);
> -	printf("    i_ino %llx\n", (unsigned long long)ip->i_ino);
> -
> -	if (ip->i_df.if_flags & XFS_IFEXTENTS)
> -		printf("EXTENTS ");
> -	printf("\n");
> -	printf("    i_df.if_bytes %d\n", ip->i_df.if_bytes);
> -	printf("    i_df.if_u1.if_root/if_data %lx\n",
> -		(unsigned long)ip->i_df.if_u1.if_root);
> -	if (ip->i_df.if_flags & XFS_IFEXTENTS) {
> -		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> -		for_each_xfs_iext(ifp, &icur, &rec) {
> -			printf("\t%d: startoff %llu, startblock 0x%llx,"
> -				" blockcount %llu, state %d\n",
> -				i, (unsigned long long)rec.br_startoff,
> -				(unsigned long long)rec.br_startblock,
> -				(unsigned long long)rec.br_blockcount,
> -				(int)rec.br_state);
> -			i++;
> -		}
> -	}
> -	printf("    i_df.if_broot %lx\n", (unsigned long)ip->i_df.if_broot);
> -	printf("    i_df.if_broot_bytes %x\n", ip->i_df.if_broot_bytes);
> -
> -	dip = &ip->i_d;
> -	printf("\nOn disk portion\n");
> -	printf("    di_mode %o\n", VFS_I(ip)->i_mode);
> -	printf("    di_version %x\n", (uint)dip->di_version);
> -	switch (ip->i_d.di_format) {
> -	case XFS_DINODE_FMT_LOCAL:
> -		printf("    Inline inode\n");
> -		break;
> -	case XFS_DINODE_FMT_EXTENTS:
> -		printf("    Extents inode\n");
> -		break;
> -	case XFS_DINODE_FMT_BTREE:
> -		printf("    B-tree inode\n");
> -		break;
> -	default:
> -		printf("    Other inode\n");
> -		break;
> -	}
> -	printf("   di_nlink %x\n", VFS_I(ip)->i_nlink);
> -	printf("   di_uid %d\n", dip->di_uid);
> -	printf("   di_gid %d\n", dip->di_gid);
> -	printf("   di_nextents %d\n", dip->di_nextents);
> -	printf("   di_size %llu\n", (unsigned long long)dip->di_size);
> -	printf("   di_gen %x\n", VFS_I(ip)->i_generation);
> -	printf("   di_extsize %d\n", dip->di_extsize);
> -	printf("   di_flags %x\n", dip->di_flags);
> -	printf("   di_nblocks %llu\n", (unsigned long long)dip->di_nblocks);
> -}
> -
>  /*
>   * Writes a modified inode's changes out to the inode's on disk home.
>   * Originally based on xfs_iflush_int() from xfs_inode.c in the kernel.
> diff --git a/repair/btree.c b/repair/btree.c
> index a402d0a67349..292fa518d019 100644
> --- a/repair/btree.c
> +++ b/repair/btree.c
> @@ -444,29 +444,6 @@ btree_lookup_prev(
>  	return value;
>  }
>  
> -static void *
> -btree_uncached_lookup(
> -	struct btree_root	*root,
> -	unsigned long		key)
> -{
> -	/* cursor-less (ie. uncached) lookup */
> -	int			height = root->height - 1;
> -	struct btree_node	*node = root->root_node;
> -	int			i;
> -	int			key_found = 0;
> -
> -	while (height >= 0) {
> -		for (i = 0; i < node->num_keys; i++)
> -			if (node->keys[i] >= key) {
> -				key_found = node->keys[i] == key;
> -				break;
> -			}
> -		node = node->ptrs[i];
> -		height--;
> -	}
> -	return key_found ? node : NULL;
> -}
> -
>  /* Update functions */
>  
>  static inline void
> -- 
> 2.17.0
> 
