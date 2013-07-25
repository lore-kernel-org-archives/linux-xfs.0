Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 75C417F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 07:58:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 013D4AC003
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 05:58:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Y7arFFVny9m4tesF for
	<xfs@oss.sgi.com>; Thu, 25 Jul 2013 05:58:36 -0700 (PDT)
Message-ID: <51F12037.6020406@redhat.com>
Date: Thu, 25 Jul 2013 08:55:19 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 11/49] xfs: split out transaction reservation code
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-12-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-12-git-send-email-david@fromorbit.com>
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

On 07/19/2013 02:24 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The transaction reservation size calculations is used by both kernel
> and userspace, but most of the transaction code in xfs_trans.c is
> kernel specific. Split all the transaction reservation code out into
> it's own files to make sharing with userspace simpler. This just
> leaves kernel-only definitions in xfs_trans.h, so it doesn't need to
> be shared with userspace anymore, either.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/Makefile         |   3 +-
>  fs/xfs/xfs_acl.c        |   1 +
>  fs/xfs/xfs_buf.c        |   1 +
>  fs/xfs/xfs_discard.c    |   4 +-
>  fs/xfs/xfs_mount.h      |  42 +--
>  fs/xfs/xfs_quotaops.c   |   3 +-
>  fs/xfs/xfs_trans.c      | 654 +-------------------------------------------
>  fs/xfs/xfs_trans.h      |  77 +-----
>  fs/xfs/xfs_trans_resv.c | 701 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_trans_resv.h | 137 ++++++++++
>  10 files changed, 851 insertions(+), 772 deletions(-)
>  create mode 100644 fs/xfs/xfs_trans_resv.c
>  create mode 100644 fs/xfs/xfs_trans_resv.h
> 
...
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 9b70df3..cc824eff 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -49,629 +49,6 @@ kmem_zone_t	*xfs_trans_zone;
>  kmem_zone_t	*xfs_log_item_desc_zone;
>  
...
> -/*
>   * Initialize the precomputed transaction reservation values
>   * in the mount structure.
>   */
> @@ -679,36 +56,7 @@ void
>  xfs_trans_init(
>  	struct xfs_mount	*mp)
>  {
> -	struct xfs_trans_reservations *resp = &mp->m_reservations;
> -
> -	resp->tr_write = xfs_calc_write_reservation(mp);
> -	resp->tr_itruncate = xfs_calc_itruncate_reservation(mp);
> -	resp->tr_rename = xfs_calc_rename_reservation(mp);
> -	resp->tr_link = xfs_calc_link_reservation(mp);
> -	resp->tr_remove = xfs_calc_remove_reservation(mp);
> -	resp->tr_symlink = xfs_calc_symlink_reservation(mp);
> -	resp->tr_create = xfs_calc_create_reservation(mp);
> -	resp->tr_mkdir = xfs_calc_mkdir_reservation(mp);
> -	resp->tr_ifree = xfs_calc_ifree_reservation(mp);
> -	resp->tr_ichange = xfs_calc_ichange_reservation(mp);
> -	resp->tr_growdata = xfs_calc_growdata_reservation(mp);
> -	resp->tr_swrite = xfs_calc_swrite_reservation(mp);
> -	resp->tr_writeid = xfs_calc_writeid_reservation(mp);
> -	resp->tr_addafork = xfs_calc_addafork_reservation(mp);
> -	resp->tr_attrinval = xfs_calc_attrinval_reservation(mp);
> -	resp->tr_attrsetm = xfs_calc_attrsetm_reservation(mp);
> -	resp->tr_attrsetrt = xfs_calc_attrsetrt_reservation(mp);
> -	resp->tr_attrrm = xfs_calc_attrrm_reservation(mp);
> -	resp->tr_clearagi = xfs_calc_clear_agi_bucket_reservation(mp);
> -	resp->tr_growrtalloc = xfs_calc_growrtalloc_reservation(mp);
> -	resp->tr_growrtzero = xfs_calc_growrtzero_reservation(mp);
> -	resp->tr_growrtfree = xfs_calc_growrtfree_reservation(mp);
> -	resp->tr_qm_sbchange = xfs_calc_qm_sbchange_reservation(mp);
> -	resp->tr_qm_setqlim = xfs_calc_qm_setqlim_reservation(mp);
> -	resp->tr_qm_dqalloc = xfs_calc_qm_dqalloc_reservation(mp);
> -	resp->tr_qm_quotaoff = xfs_calc_qm_quotaoff_reservation(mp);
> -	resp->tr_qm_equotaoff = xfs_calc_qm_quotaoff_end_reservation(mp);
> -	resp->tr_sb = xfs_calc_sb_reservation(mp);
> +	xfs_trans_resv_calc(mp, &mp->m_reservations);
>  }
>  

Reservation calculations pushed off into a helper, otherwise a clean move.

>  /*
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
...
> diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
...
> diff --git a/fs/xfs/xfs_trans_resv.h b/fs/xfs/xfs_trans_resv.h
> new file mode 100644
> index 0000000..cc8260e
> --- /dev/null
> +++ b/fs/xfs/xfs_trans_resv.h
> @@ -0,0 +1,137 @@
> +/*
> + * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
> + * All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +#ifndef	__XFS_TRANS_RESV_H__
> +#define	__XFS_TRANS_RESV_H__
> +
> +struct xfs_mount;
> +
> +/*
> + * structure for maintaining pre-calculated transaction reservations.
> + */
> +struct xfs_trans_resv {
> +	uint	tr_write;	/* extent alloc trans */
> +	uint	tr_itruncate;	/* truncate trans */
> +	uint	tr_rename;	/* rename trans */
> +	uint	tr_link;	/* link trans */
> +	uint	tr_remove;	/* unlink trans */
> +	uint	tr_symlink;	/* symlink trans */
> +	uint	tr_create;	/* create trans */
> +	uint	tr_mkdir;	/* mkdir trans */
> +	uint	tr_ifree;	/* inode free trans */
> +	uint	tr_ichange;	/* inode update trans */
> +	uint	tr_growdata;	/* fs data section grow trans */
> +	uint	tr_swrite;	/* sync write inode trans */
> +	uint	tr_addafork;	/* cvt inode to attributed trans */
> +	uint	tr_writeid;	/* write setuid/setgid file */
> +	uint	tr_attrinval;	/* attr fork buffer invalidation */
> +	uint	tr_attrsetm;	/* set/create an attribute at mount time */
> +	uint	tr_attrsetrt;	/* set/create an attribute at runtime */
> +	uint	tr_attrrm;	/* remove an attribute */
> +	uint	tr_clearagi;	/* clear bad agi unlinked ino bucket */
> +	uint	tr_growrtalloc;	/* grow realtime allocations */
> +	uint	tr_growrtzero;	/* grow realtime zeroing */
> +	uint	tr_growrtfree;	/* grow realtime freeing */
> +	uint	tr_qm_sbchange;	/* change quota flags */
> +	uint	tr_qm_setqlim;	/* adjust quota limits */
> +	uint	tr_qm_dqalloc;	/* allocate quota on disk */
> +	uint	tr_qm_quotaoff;	/* turn quota off */
> +	uint	tr_qm_equotaoff;/* end of turn quota off */
> +	uint	tr_sb;		/* modify superblock */
> +};
> +

Structure name change, matches otherwise.

> +/*
> + * Per-extent log reservation for the allocation btree changes
> + * involved in freeing or allocating an extent.
> + * 2 trees * (2 blocks/level * max depth - 1) * block size
> + */
> +#define	XFS_ALLOCFREE_LOG_RES(mp,nx) \
> +	((nx) * (2 * XFS_FSB_TO_B((mp), 2 * XFS_AG_MAXLEVELS(mp) - 1)))
> +#define	XFS_ALLOCFREE_LOG_COUNT(mp,nx) \
> +	((nx) * (2 * (2 * XFS_AG_MAXLEVELS(mp) - 1)))
> +
> +/*
> + * Per-directory log reservation for any directory change.
> + * dir blocks: (1 btree block per level + data block + free block) * dblock size
> + * bmap btree: (levels + 2) * max depth * block size
> + * v2 directory blocks can be fragmented below the dirblksize down to the fsb
> + * size, so account for that in the DAENTER macros.
> + */
> +#define	XFS_DIROP_LOG_RES(mp)	\
> +	(XFS_FSB_TO_B(mp, XFS_DAENTER_BLOCKS(mp, XFS_DATA_FORK)) + \
> +	 (XFS_FSB_TO_B(mp, XFS_DAENTER_BMAPS(mp, XFS_DATA_FORK) + 1)))
> +#define	XFS_DIROP_LOG_COUNT(mp)	\
> +	(XFS_DAENTER_BLOCKS(mp, XFS_DATA_FORK) + \
> +	 XFS_DAENTER_BMAPS(mp, XFS_DATA_FORK) + 1)
> +
> +

The XFS_*_LOG_RES() macros don't appear to be used anywhere..?

And other than some whitespace fixups, everything else seems to match:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +#define	XFS_WRITE_LOG_RES(mp)	((mp)->m_reservations.tr_write)
> +#define	XFS_ITRUNCATE_LOG_RES(mp)   ((mp)->m_reservations.tr_itruncate)
> +#define	XFS_RENAME_LOG_RES(mp)	((mp)->m_reservations.tr_rename)
> +#define	XFS_LINK_LOG_RES(mp)	((mp)->m_reservations.tr_link)
> +#define	XFS_REMOVE_LOG_RES(mp)	((mp)->m_reservations.tr_remove)
> +#define	XFS_SYMLINK_LOG_RES(mp)	((mp)->m_reservations.tr_symlink)
> +#define	XFS_CREATE_LOG_RES(mp)	((mp)->m_reservations.tr_create)
> +#define	XFS_MKDIR_LOG_RES(mp)	((mp)->m_reservations.tr_mkdir)
> +#define	XFS_IFREE_LOG_RES(mp)	((mp)->m_reservations.tr_ifree)
> +#define	XFS_ICHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_ichange)
> +#define	XFS_GROWDATA_LOG_RES(mp)    ((mp)->m_reservations.tr_growdata)
> +#define	XFS_GROWRTALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_growrtalloc)
> +#define	XFS_GROWRTZERO_LOG_RES(mp)	((mp)->m_reservations.tr_growrtzero)
> +#define	XFS_GROWRTFREE_LOG_RES(mp)	((mp)->m_reservations.tr_growrtfree)
> +#define	XFS_SWRITE_LOG_RES(mp)	((mp)->m_reservations.tr_swrite)
> +/*
> + * Logging the inode timestamps on an fsync -- same as SWRITE
> + * as long as SWRITE logs the entire inode core
> + */
> +#define XFS_FSYNC_TS_LOG_RES(mp)        ((mp)->m_reservations.tr_swrite)
> +#define	XFS_WRITEID_LOG_RES(mp)		((mp)->m_reservations.tr_swrite)
> +#define	XFS_ADDAFORK_LOG_RES(mp)	((mp)->m_reservations.tr_addafork)
> +#define	XFS_ATTRINVAL_LOG_RES(mp)	((mp)->m_reservations.tr_attrinval)
> +#define	XFS_ATTRSETM_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetm)
> +#define	XFS_ATTRSETRT_LOG_RES(mp)	((mp)->m_reservations.tr_attrsetrt)
> +#define	XFS_ATTRRM_LOG_RES(mp)		((mp)->m_reservations.tr_attrrm)
> +#define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)  ((mp)->m_reservations.tr_clearagi)
> +#define XFS_QM_SBCHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_qm_sbchange)
> +#define XFS_QM_SETQLIM_LOG_RES(mp)	((mp)->m_reservations.tr_qm_setqlim)
> +#define XFS_QM_DQALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_qm_dqalloc)
> +#define XFS_QM_QUOTAOFF_LOG_RES(mp)	((mp)->m_reservations.tr_qm_quotaoff)
> +#define XFS_QM_QUOTAOFF_END_LOG_RES(mp)	((mp)->m_reservations.tr_qm_equotaoff)
> +#define XFS_SB_LOG_RES(mp)		((mp)->m_reservations.tr_sb)
> +
> +/*
> + * Various log count values.
> + */
> +#define	XFS_DEFAULT_LOG_COUNT		1
> +#define	XFS_DEFAULT_PERM_LOG_COUNT	2
> +#define	XFS_ITRUNCATE_LOG_COUNT		2
> +#define XFS_INACTIVE_LOG_COUNT		2
> +#define	XFS_CREATE_LOG_COUNT		2
> +#define	XFS_MKDIR_LOG_COUNT		3
> +#define	XFS_SYMLINK_LOG_COUNT		3
> +#define	XFS_REMOVE_LOG_COUNT		2
> +#define	XFS_LINK_LOG_COUNT		2
> +#define	XFS_RENAME_LOG_COUNT		2
> +#define	XFS_WRITE_LOG_COUNT		2
> +#define	XFS_ADDAFORK_LOG_COUNT		2
> +#define	XFS_ATTRINVAL_LOG_COUNT		1
> +#define	XFS_ATTRSET_LOG_COUNT		3
> +#define	XFS_ATTRRM_LOG_COUNT		3
> +
> +void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
> +
> +#endif	/* __XFS_TRANS_RESV_H__ */
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
