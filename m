Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n36MErxk218053 for <xfs@oss.sgi.com>; Mon, 6 Apr 2009 17:15:03 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 09F728F8078
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2009 15:14:33 -0700 (PDT)
Message-Id: <6DD58BEE-122C-4283-A9C8-AA3EEE50D60D@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090318094132.430583000@bombadil.infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 5/5] xfs: remove m_attroffset
Date: Mon, 6 Apr 2009 17:11:57 -0500
References: <20090318094119.561416000@bombadil.infradead.org>
	<20090318094132.430583000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


On Mar 18, 2009, at 4:41 AM, Christoph Hellwig wrote:

> With the upcoming v3 inodes the default attroffset needs to be  
> calculated
> for each specific inode, so we can't cache it in the superblock  
> anymore.
>
> Also replace the assert for wrong inode sizes with a proper error  
> check
> also included in non-debug builds.  Note that the ENOSYS retourn for
> that might seem odd, but that error is returned by  
> xfs_mount_validate_sb
> for all theoretically valid but not supported filesystem geometries.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Felix Blyakher <sgi.com>

>
>
> Index: xfs/fs/xfs/xfs_mount.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_mount.c	2009-03-18 07:37:20.566978952 +0100
> +++ xfs/fs/xfs/xfs_mount.c	2009-03-18 07:47:49.573979000 +0100
> @@ -333,6 +333,22 @@ xfs_mount_validate_sb(
> 		return XFS_ERROR(ENOSYS);
> 	}
>
> +	/*
> +	 * Currently only very few inode sizes are supported.
> +	 */
> +	switch (sbp->sb_inodesize) {
> +	case 256:
> +	case 512:
> +	case 1024:
> +	case 2048:
> +		break;
> +	default:
> +		xfs_fs_mount_cmn_err(flags,
> +			"inode size of %d bytes not supported",
> +			sbp->sb_inodesize);
> +		return XFS_ERROR(ENOSYS);
> +	}
> +
> 	if (xfs_sb_validate_fsb_count(sbp, sbp->sb_dblocks) ||
> 	    xfs_sb_validate_fsb_count(sbp, sbp->sb_rblocks)) {
> 		xfs_fs_mount_cmn_err(flags,
> @@ -655,27 +671,6 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb
> 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
> 	mp->m_blockwmask = mp->m_blockwsize - 1;
>
> -	/*
> -	 * Setup for attributes, in case they get created.
> -	 * This value is for inodes getting attributes for the first time,
> -	 * the per-inode value is for old attribute values.
> -	 */
> -	ASSERT(sbp->sb_inodesize >= 256 && sbp->sb_inodesize <= 2048);
> -	switch (sbp->sb_inodesize) {
> -	case 256:
> -		mp->m_attroffset = XFS_LITINO(mp) -
> -				   XFS_BMDR_SPACE_CALC(MINABTPTRS);
> -		break;
> -	case 512:
> -	case 1024:
> -	case 2048:
> -		mp->m_attroffset = XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
> -		break;
> -	default:
> -		ASSERT(0);
> -	}
> -	ASSERT(mp->m_attroffset < XFS_LITINO(mp));
> -
> 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
> 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
> 	mp->m_alloc_mnr[0] = mp->m_alloc_mxr[0] / 2;
> Index: xfs/fs/xfs/xfs_attr_leaf.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_attr_leaf.c	2009-03-18 07:37:20.570978763  
> +0100
> +++ xfs/fs/xfs/xfs_attr_leaf.c	2009-03-18 07:37:23.768978423 +0100
> @@ -155,7 +155,8 @@ xfs_attr_shortform_bytesfit(xfs_inode_t
> 		 * minimum offset only needs to be the space required for
> 		 * the btree root.
> 		 */
> -		if (!dp->i_d.di_forkoff && dp->i_df.if_bytes > mp->m_attroffset)
> +		if (!dp->i_d.di_forkoff && dp->i_df.if_bytes >
> +		    xfs_default_attroffset(dp))
> 			dsize = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
> 		break;
> 		
> Index: xfs/fs/xfs/xfs_bmap.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap.c	2009-03-18 07:37:20.575978772 +0100
> +++ xfs/fs/xfs/xfs_bmap.c	2009-03-18 07:37:23.770978468 +0100
> @@ -3569,6 +3569,27 @@ xfs_bmap_extents_to_btree(
> }
>
> /*
> + * Calculate the default attribute fork offset for newly created  
> inodes.
> + */
> +uint
> +xfs_default_attroffset(
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	uint			offset;
> +
> +	if (mp->m_sb.sb_inodesize == 256) {
> +		offset = XFS_LITINO(mp) -
> +				XFS_BMDR_SPACE_CALC(MINABTPTRS);
> +	} else {
> +		offset = XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
> +	}
> +
> +	ASSERT(offset < XFS_LITINO(mp));
> +	return offset;
> +}
> +
> +/*
>  * Helper routine to reset inode di_forkoff field when switching
>  * attribute fork from local to extent format - we reset it where
>  * possible to make space available for inline data fork extents.
> @@ -3580,15 +3601,18 @@ xfs_bmap_forkoff_reset(
> 	int		whichfork)
> {
> 	if (whichfork == XFS_ATTR_FORK &&
> -	    (ip->i_d.di_format != XFS_DINODE_FMT_DEV) &&
> -	    (ip->i_d.di_format != XFS_DINODE_FMT_UUID) &&
> -	    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
> -	    ((mp->m_attroffset >> 3) > ip->i_d.di_forkoff)) {
> -		ip->i_d.di_forkoff = mp->m_attroffset >> 3;
> -		ip->i_df.if_ext_max = XFS_IFORK_DSIZE(ip) /
> -					(uint)sizeof(xfs_bmbt_rec_t);
> -		ip->i_afp->if_ext_max = XFS_IFORK_ASIZE(ip) /
> -					(uint)sizeof(xfs_bmbt_rec_t);
> +	    ip->i_d.di_format != XFS_DINODE_FMT_DEV &&
> +	    ip->i_d.di_format != XFS_DINODE_FMT_UUID &&
> +	    ip->i_d.di_format != XFS_DINODE_FMT_BTREE) {
> +		uint	dfl_forkoff = xfs_default_attroffset(ip) >> 3;
> +
> +		if (dfl_forkoff > ip->i_d.di_forkoff) {
> +			ip->i_d.di_forkoff = dfl_forkoff;
> +			ip->i_df.if_ext_max =
> +				XFS_IFORK_DSIZE(ip) / sizeof(xfs_bmbt_rec_t);
> +			ip->i_afp->if_ext_max =
> +				XFS_IFORK_ASIZE(ip) / sizeof(xfs_bmbt_rec_t);
> +		}
> 	}
> }
>
> @@ -4057,7 +4081,7 @@ xfs_bmap_add_attrfork(
> 	case XFS_DINODE_FMT_BTREE:
> 		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
> 		if (!ip->i_d.di_forkoff)
> -			ip->i_d.di_forkoff = mp->m_attroffset >> 3;
> +			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
> 		else if (mp->m_flags & XFS_MOUNT_ATTR2)
> 			version = 2;
> 		break;
> @@ -4204,12 +4228,12 @@ xfs_bmap_compute_maxlevels(
> 	 * (a signed 16-bit number, xfs_aextnum_t).
> 	 *
> 	 * Note that we can no longer assume that if we are in ATTR1 that
> -	 * the fork offset of all the inodes will be (m_attroffset >> 3)
> -	 * because we could have mounted with ATTR2 and then mounted back
> -	 * with ATTR1, keeping the di_forkoff's fixed but probably at
> -	 * various positions. Therefore, for both ATTR1 and ATTR2
> -	 * we have to assume the worst case scenario of a minimum size
> -	 * available.
> +	 * the fork offset of all the inodes will be
> +	 * (xfs_default_attroffset(ip) >> 3) because we could have mounted
> +	 * with ATTR2 and then mounted back with ATTR1, keeping the
> +	 * di_forkoff's fixed but probably at various positions. Therefore,
> +	 * for both ATTR1 and ATTR2 we have to assume the worst case  
> scenario
> +	 * of a minimum size available.
> 	 */
> 	if (whichfork == XFS_DATA_FORK) {
> 		maxleafents = MAXEXTNUM;
> Index: xfs/fs/xfs/xfs_bmap.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap.h	2009-03-18 07:37:20.579979142 +0100
> +++ xfs/fs/xfs/xfs_bmap.h	2009-03-18 07:37:23.772979002 +0100
> @@ -338,6 +338,10 @@ xfs_check_nostate_extents(
> 	xfs_extnum_t		idx,
> 	xfs_extnum_t		num);
>
> +uint
> +xfs_default_attroffset(
> +	struct xfs_inode	*ip);
> +
> #ifdef __KERNEL__
>
> /*
> Index: xfs/fs/xfs/xfs_mount.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_mount.h	2009-03-18 07:37:20.585978718 +0100
> +++ xfs/fs/xfs/xfs_mount.h	2009-03-18 07:37:23.772979002 +0100
> @@ -198,7 +198,6 @@ typedef struct xfs_mount {
> 	int			m_fixedfsid[2];	/* unchanged for life of FS */
> 	uint			m_dmevmask;	/* DMI events for this FS */
> 	__uint64_t		m_flags;	/* global mount flags */
> -	uint			m_attroffset;	/* inode attribute offset */
> 	uint			m_dir_node_ents; /* #entries in a dir danode */
> 	uint			m_attr_node_ents; /* #entries in attr danode */
> 	int			m_ialloc_inos;	/* inodes in inode allocation */
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
