Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0807529DFB
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 11:21:26 -0500 (CDT)
Date: Thu, 1 Aug 2013 11:21:22 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 24/48] xfsprogs: add crc format support to repair
Message-ID: <20130801162122.GX3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-25-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-25-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 07, 2013 at 10:25:47AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

...

> diff --git a/include/xfs_alloc_btree.h b/include/xfs_alloc_btree.h
> index 70c3ea0..e160339 100644
> --- a/include/xfs_alloc_btree.h
> +++ b/include/xfs_alloc_btree.h
> @@ -64,7 +64,7 @@ typedef __be32 xfs_alloc_ptr_t;
>   */
>  #define XFS_ALLOC_BLOCK_LEN(mp) \
>  	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
> -	 XFS_BTREE_SBLOCK_LEN + XFS_BTREE_CRCBLOCK_ADD : \
> +	 XFS_BTREE_SBLOCK_CRC_LEN : \
>  	 XFS_BTREE_SBLOCK_LEN)

Good.  This addresses my observation that this was done differently in
userspace than in the kernel.

>  
>  /*
> diff --git a/include/xfs_bmap_btree.h b/include/xfs_bmap_btree.h
> index 8a28b89..20d66b0 100644
> --- a/include/xfs_bmap_btree.h
> +++ b/include/xfs_bmap_btree.h
> @@ -140,7 +140,7 @@ typedef __be64 xfs_bmbt_ptr_t, xfs_bmdr_ptr_t;
>   */
>  #define XFS_BMBT_BLOCK_LEN(mp) \
>  	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
> -	 XFS_BTREE_LBLOCK_LEN + XFS_BTREE_CRCBLOCK_ADD : \
> +	 XFS_BTREE_LBLOCK_CRC_LEN : \
>  	 XFS_BTREE_LBLOCK_LEN)

Here too.

>  
>  #define XFS_BMBT_REC_ADDR(mp, block, index) \
> diff --git a/include/xfs_btree.h b/include/xfs_btree.h
> index 02f89d8..c0acbbf 100644
> --- a/include/xfs_btree.h
> +++ b/include/xfs_btree.h
> @@ -83,7 +83,10 @@ struct xfs_btree_block {
>  
>  #define XFS_BTREE_SBLOCK_LEN	16	/* size of a short form block */
>  #define XFS_BTREE_LBLOCK_LEN	24	/* size of a long form block */
> -#define XFS_BTREE_CRCBLOCK_ADD	32	/* size of blkno + crc + uuid */
> +
> +/* sizes of CRC enabled btree blocks */
> +#define XFS_BTREE_SBLOCK_CRC_LEN	(XFS_BTREE_SBLOCK_LEN + 40)
> +#define XFS_BTREE_LBLOCK_CRC_LEN	(XFS_BTREE_LBLOCK_LEN + 48)
>  
>  #define XFS_BTREE_SBLOCK_CRC_OFF \
>  	offsetof(struct xfs_btree_block, bb_u.s.bb_crc)
> diff --git a/include/xfs_ialloc_btree.h b/include/xfs_ialloc_btree.h
> index a1bfa7a..7f5ae6b 100644
> --- a/include/xfs_ialloc_btree.h
> +++ b/include/xfs_ialloc_btree.h
> @@ -80,7 +80,7 @@ typedef __be32 xfs_inobt_ptr_t;
>   */
>  #define XFS_INOBT_BLOCK_LEN(mp) \
>  	(xfs_sb_version_hascrc(&((mp)->m_sb)) ? \
> -	 XFS_BTREE_SBLOCK_LEN + XFS_BTREE_CRCBLOCK_ADD : \
> +	 XFS_BTREE_SBLOCK_CRC_LEN : \
>  	 XFS_BTREE_SBLOCK_LEN)

And here.

>  
>  /*
> diff --git a/include/xfs_symlink.h b/include/xfs_symlink.h
> index bb21e6a..55f3f2d 100644
> --- a/include/xfs_symlink.h
> +++ b/include/xfs_symlink.h
> @@ -29,6 +29,8 @@ struct xfs_dsymlink_hdr {
>  			sizeof(struct xfs_dsymlink_hdr) : 0))
>  
>  int xfs_symlink_blocks(struct xfs_mount *mp, int pathlen);
> +bool xfs_symlink_hdr_ok(struct xfs_mount *mp, xfs_ino_t ino, uint32_t offset,
> +			uint32_t size, struct xfs_buf *bp);
>  
>  extern const struct xfs_buf_ops xfs_symlink_buf_ops;
>  
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index f91a5d0..c679f81 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -445,6 +445,7 @@ __libxfs_getbufr(int blen)
>  	} else
>  		bp = kmem_zone_zalloc(xfs_buf_zone, 0);
>  	pthread_mutex_unlock(&xfs_buf_freelist.cm_mutex);
> +	bp->b_ops = NULL;
>  
>  	return bp;
>  }
> @@ -833,10 +834,20 @@ libxfs_writebufr(xfs_buf_t *bp)
>  		}
>  	}
>  
> +	/*
> +	 * clear any pre-existing error status on the buffer. This can occur if
> +	 * the buffer is corrupt on disk and the repair process doesn't clear
> +	 * the error before fixing and writing it back.
> +	 */
> +	bp->b_error = 0;

And here we're clearing b_error, which I think addresses my concern from the
last patch.

> diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
> index 1041f8f..1d7ea8f 100644
> --- a/libxfs/xfs_alloc.c
> +++ b/libxfs/xfs_alloc.c
> @@ -2173,8 +2173,13 @@ xfs_agf_verify(
>  	struct xfs_agf	*agf = XFS_BUF_TO_AGF(bp);
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> -	    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_uuid))
> +	    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_uuid)) {
> +		char uu[64], uu2[64];
> +		platform_uuid_unparse(&agf->agf_uuid, uu);
> +		platform_uuid_unparse(&mp->m_sb.sb_uuid, uu2);
> +

Here it looks like we unparse the uuids into strings, and then do nothing with them?

> diff --git a/repair/agheader.c b/repair/agheader.c
> index 769022d..bc8b1bf 100644
> --- a/repair/agheader.c
> +++ b/repair/agheader.c
> @@ -22,6 +22,11 @@
>  #include "protos.h"
>  #include "err_protos.h"
>  
> +/*
> + * XXX (dgc): WTF is the point of all the check and repair here when phase 5

Don't cuss into the codebase.  People work here.

> diff --git a/repair/dinode.c b/repair/dinode.c
> index 66eedc2..2df9a91 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c

...

> +	if (platform_uuid_compare(&dinoc->di_uuid, &mp->m_sb.sb_uuid)) {
> +		__dirty_no_modify_ret(dirty);
> +		platform_uuid_copy(&dinoc->di_uuid, &mp->m_sb.sb_uuid);
> +	}
> +
> +	for (i = 0; i < 16; i++) {
> +		if (dinoc->di_pad[i] != 0) {
> +			__dirty_no_modify_ret(dirty);
> +			memset(dinoc->di_pad, 0, 16);
> +			break;
> +		}

This looks incorrect.  di_pad is 6 bytes long.  Maybe you are after di_pad2,
but even then there is no need to zero it up to 16 times, afaict.

> @@ -1137,6 +1126,9 @@ process_btinode(
>  	else
>  		forkname = _("attr");
>  
> +	magic = xfs_sb_version_hascrc(&mp->m_sb) ? XFS_BMAP_CRC_MAGIC
> +						 : XFS_BMAP_MAGIC;
> +
>  	level = be16_to_cpu(dib->bb_level);
>  	numrecs = be16_to_cpu(dib->bb_numrecs);
>  
> @@ -1190,9 +1182,9 @@ _("bad numrecs 0 in inode %" PRIu64 " bmap btree root block\n"),
>  			return(1);
>  		}
>  
> -		if (scan_lbtree(be64_to_cpu(pp[i]), level, scanfunc_bmap, type, 
> +		if (scan_lbtree(be64_to_cpu(pp[i]), level, scan_bmapbt, type, 
>  				whichfork, lino, tot, nex, blkmapp, &cursor,
> -				1, check_dups))
> +				1, check_dups, magic, &xfs_bmbt_buf_ops))
>  			return(1);
>  		/*
>  		 * fix key (offset) mismatches between the keys in root
> @@ -1520,9 +1512,21 @@ _("cannot read inode %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
>  				return(1);
>  			}
>  
> +

Extra line.

> diff --git a/repair/phase2.c b/repair/phase2.c
> index 2817fed..a62854e 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -64,6 +64,7 @@ zero_log(xfs_mount_t *mp)
>  		ASSERT(mp->m_sb.sb_logsectlog >= BBSHIFT);
>  	}
>  	log.l_sectbb_mask = (1 << log.l_sectbb_log) - 1;
> +	log.l_sectBBsize = 1 << mp->m_sb.sb_logsectlog;

I'm not seeing how this change is connected with the patch.  Is it something we
didn't use and needs to be initialized now?

> diff --git a/repair/phase5.c b/repair/phase5.c
> index c7cef4f..2eae42a 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -1342,6 +1398,26 @@ build_agf_agfl(xfs_mount_t	*mp,
>  
>  	libxfs_writebuf(agf_buf, 0);
>  
> +	/*
> +	 * now fix up the free list appropriately
> +	 * XXX: code lifted from mkfs, shoul dbe shared.
				       should be

> diff --git a/repair/scan.c b/repair/scan.c
> index 0b5ab1b..d58d55a 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -709,10 +702,20 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
>  		 * as possible.
>  		 */
>  		if (bno != 0 && verify_agbno(mp, agno, bno)) {
> -			scan_sbtree(bno, level, agno, suspect,
> -				    (magic == XFS_ABTB_MAGIC) ?
> -				     scanfunc_bno : scanfunc_cnt, 0,
> -				     (void *)agcnts);
> +			switch (magic) {
> +			case XFS_ABTB_CRC_MAGIC:
> +			case XFS_ABTB_MAGIC:
> +				scan_sbtree(bno, level, agno, suspect,
> +					    scan_allocbt, 0, magic, priv,
> +					    &xfs_allocbt_buf_ops);
> +				break;
> +			case XFS_ABTC_CRC_MAGIC:
> +			case XFS_ABTC_MAGIC:
> +				scan_sbtree(bno, level, agno, suspect,
> +					    scan_allocbt, 0, magic, priv,
> +					    &xfs_allocbt_buf_ops);
> +				break;
> +			}

This looks ok but appears that it could be collapsed.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
