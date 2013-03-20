Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3AE3A7CBF
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 17:03:38 -0500 (CDT)
Date: Wed, 20 Mar 2013 17:03:34 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 10/21] xfs: add CRC checks to remote symlinks
Message-ID: <20130320220334.GN22182@sgi.com>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
	<1363091454-8852-11-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363091454-8852-11-git-send-email-david@fromorbit.com>
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

On Tue, Mar 12, 2013 at 11:30:43PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add a header to the remote symlink block, containing location and
> owner information, as well as CRCs and LSN fields. This requires
> verifiers to be added to the remote symlink buffers for CRC enabled
> filesystems.
> 
> This also fixes a bug reading multiple block symlinks, where the second block
> overwrites the first block when copying out the link name.

More comments below.

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/Makefile          |    5 +-
>  fs/xfs/xfs_bmap.c        |   21 +-
>  fs/xfs/xfs_buf_item.h    |    4 +-
>  fs/xfs/xfs_log_recover.c |    9 +
>  fs/xfs/xfs_symlink.c     |  719 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_symlink.h     |   53 ++++
>  fs/xfs/xfs_vnodeops.c    |  480 +------------------------------
>  7 files changed, 797 insertions(+), 494 deletions(-)
>  create mode 100644 fs/xfs/xfs_symlink.c
>  create mode 100644 fs/xfs/xfs_symlink.h
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index d02201d..062f25c 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -45,11 +45,11 @@ xfs-y				+= xfs_aops.o \
>  				   xfs_itable.o \
>  				   xfs_message.o \
>  				   xfs_mru_cache.o \
> -				   xfs_super.o \
> -				   xfs_xattr.o \
>  				   xfs_rename.o \
> +				   xfs_super.o \
>  				   xfs_utils.o \
>  				   xfs_vnodeops.o \
> +				   xfs_xattr.o \
>  				   kmem.o \
>  				   uuid.o
>  
> @@ -73,6 +73,7 @@ xfs-y				+= xfs_alloc.o \
>  				   xfs_inode.o \
>  				   xfs_log_recover.o \
>  				   xfs_mount.o \
> +				   xfs_symlink.o \
>  				   xfs_trans.o
>  
>  # low-level transaction/log code
> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> index 0531cd3..0fcb7f4 100644
> --- a/fs/xfs/xfs_bmap.c
> +++ b/fs/xfs/xfs_bmap.c
> @@ -47,6 +47,7 @@
>  #include "xfs_filestream.h"
>  #include "xfs_vnodeops.h"
>  #include "xfs_trace.h"
> +#include "xfs_symlink.h"
>  
>  
>  kmem_zone_t		*xfs_bmap_free_item_zone;
> @@ -1321,9 +1322,10 @@ xfs_bmap_add_attrfork_extents(
>  }
>  
>  /*
> - * Block initialisation functions for local to extent format conversion.
> - * As these get more complex, they will be moved to the relevant files,
> - * but for now they are too simple to worry about.
> + * Block initialisation function for local to extent format conversion.
> + *
> + * This shouldn't actually be called by anyone, so make sure debug kernels cause
> + * a noticable failure.

That's greater than 80 columns.

>   */
>  STATIC void
>  xfs_bmap_local_to_extents_init_fn(
> @@ -1332,23 +1334,12 @@ xfs_bmap_local_to_extents_init_fn(
>  	struct xfs_inode	*ip,
>  	struct xfs_ifork	*ifp)
>  {
> +	ASSERT(0);

That has nothing to do with crcs.

>  	bp->b_ops = &xfs_bmbt_buf_ops;
>  	memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLF_BTREE_BUF);
>  }
>  
> -STATIC void
> -xfs_symlink_local_to_remote(
> -	struct xfs_trans	*tp,
> -	struct xfs_buf		*bp,
> -	struct xfs_inode	*ip,
> -	struct xfs_ifork	*ifp)
> -{
> -	/* remote symlink blocks are not verifiable until CRCs come along */
> -	bp->b_ops = NULL;
> -	memcpy(bp->b_addr, ifp->if_u1.if_data, ifp->if_bytes);
> -}
> -
>  /*
>   * Called from xfs_bmap_add_attrfork to handle local format files. Each
>   * different data fork content type needs a different callout to do the
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index abae8c8..09cab4e 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -49,6 +49,7 @@ extern kmem_zone_t	*xfs_buf_item_zone;
>  #define XFS_BLF_AGFL_BUF	(1<<7)
>  #define XFS_BLF_AGI_BUF		(1<<8)
>  #define XFS_BLF_DINO_BUF	(1<<9)
> +#define XFS_BLF_SYMLINK_BUF	(1<<10)
>  
>  #define XFS_BLF_TYPE_MASK	\
>  		(XFS_BLF_UDQUOT_BUF | \
> @@ -58,7 +59,8 @@ extern kmem_zone_t	*xfs_buf_item_zone;
>  		 XFS_BLF_AGF_BUF | \
>  		 XFS_BLF_AGFL_BUF | \
>  		 XFS_BLF_AGI_BUF | \
> -		 XFS_BLF_DINO_BUF)
> +		 XFS_BLF_DINO_BUF | \
> +		 XFS_BLF_SYMLINK_BUF)
>  
>  #define	XFS_BLF_CHUNK		128
>  #define	XFS_BLF_SHIFT		7
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 6d08eaa..352d794 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -45,6 +45,7 @@
>  #include "xfs_cksum.h"
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
> +#include "xfs_symlink.h"
>  
>  STATIC int
>  xlog_find_zeroed(
> @@ -2005,6 +2006,14 @@ xlog_recover_do_reg_buffer(
>  		}
>  		bp->b_ops = &xfs_inode_buf_ops;
>  		break;
> +	case XFS_BLF_SYMLINK_BUF:
> +		if (*(__be32 *)bp->b_addr != cpu_to_be32(XFS_SYMLINK_MAGIC)) {
> +			xfs_warn(mp, "Bad symlink block magic!");
> +			ASSERT(0);
> +			break;
> +		}
> +		bp->b_ops = &xfs_symlink_buf_ops;
> +		break;
>  	default:
>  		break;
>  	}
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> new file mode 100644
> index 0000000..33e8f13
> --- /dev/null
> +++ b/fs/xfs/xfs_symlink.c
> @@ -0,0 +1,719 @@
> +/*
> + * Copyright (c) 2000-2006 Silicon Graphics, Inc.
> + * Copyright (c) 2012-2013 Red Hat, Inc.
> + * All rights reserved.
> + */
> +
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_types.h"
> +#include "xfs_bit.h"
> +#include "xfs_log.h"
> +#include "xfs_trans.h"
> +#include "xfs_sb.h"
> +#include "xfs_ag.h"
> +#include "xfs_dir2.h"
> +#include "xfs_mount.h"
> +#include "xfs_da_btree.h"
> +#include "xfs_bmap_btree.h"
> +#include "xfs_ialloc_btree.h"
> +#include "xfs_dinode.h"
> +#include "xfs_inode.h"
> +#include "xfs_inode_item.h"
> +#include "xfs_itable.h"
> +#include "xfs_ialloc.h"
> +#include "xfs_alloc.h"
> +#include "xfs_bmap.h"
> +#include "xfs_error.h"
> +#include "xfs_quota.h"
> +#include "xfs_utils.h"
> +#include "xfs_trans_space.h"
> +#include "xfs_log_priv.h"
> +#include "xfs_trace.h"
> +#include "xfs_symlink.h"
> +#include "xfs_cksum.h"
> +#include "xfs_buf_item.h"
> +
> +
> +/*
> + * Each contiguous block has a header, so it is not just a simple pathlen
> + * to FSB conversion.
> + */
> +int
> +xfs_symlink_blocks(
> +	struct xfs_mount *mp,
> +	int		pathlen)
> +{
> +	int		fsblocks = 0;
> +	int		len = pathlen;
> +
> +	do {
> +		fsblocks++;
> +		len -= XFS_SYMLINK_BUF_SPACE(mp, mp->m_sb.sb_blocksize);
> +	} while (len > 0);
> +
> +	ASSERT(fsblocks <= XFS_SYMLINK_MAPS);
> +	return fsblocks;
> +}
> +
> +static int
> +xfs_symlink_hdr_set(
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		ino,
> +	uint32_t		offset,
> +	uint32_t		size,
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_dsymlink_hdr	*dsl = bp->b_addr;
> +
> +	if (!xfs_sb_version_hascrc(&mp->m_sb))
> +		return 0;
> +
> +	dsl->sl_magic = cpu_to_be32(XFS_SYMLINK_MAGIC);
> +	dsl->sl_offset = cpu_to_be32(offset);
> +	dsl->sl_bytes = cpu_to_be32(size);
> +	uuid_copy(&dsl->sl_uuid, &mp->m_sb.sb_uuid);
> +	dsl->sl_owner = cpu_to_be64(ino);
> +	dsl->sl_blkno = cpu_to_be64(bp->b_bn);
> +	bp->b_ops = &xfs_symlink_buf_ops;
> +
> +	return sizeof(struct xfs_dsymlink_hdr);
> +}
> +
> +/*
> + * Checking of the symlink header is split into two parts. the verifier does
> + * CRC, location and bounds checking, the unpacking function checks the path
> + * parameters and owner.
> + */
> +bool
> +xfs_symlink_hdr_ok(
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		ino,
> +	uint32_t		offset,
> +	uint32_t		size,
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_dsymlink_hdr *dsl = bp->b_addr;
> +
> +	if (offset != be32_to_cpu(dsl->sl_offset))
> +		return false;
> +	if (size != be32_to_cpu(dsl->sl_bytes))
> +		return false;
> +	if (ino != be64_to_cpu(dsl->sl_owner))
> +		return false;
> +
> +	/* ok */
> +	return true;
> +

Looks like an extra line here.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
