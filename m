Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9E6317F83
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 19:42:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7B763304032
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 17:42:19 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	3DHzDfnEN75lRRXE for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2015 17:42:17 -0700 (PDT)
Date: Thu, 30 Jul 2015 10:42:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/24] xfs: define the on-disk refcount btree format
Message-ID: <20150730004215.GI16638@dastard>
References: <20150729223258.17414.91354.stgit@birch.djwong.org>
	<20150729223330.17414.82692.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150729223330.17414.82692.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

On Wed, Jul 29, 2015 at 03:33:30PM -0700, Darrick J. Wong wrote:
> Start constructing the refcount btree implementation by establishing
> the on-disk format and everything needed to read, write, and
> manipulate the refcount btree blocks.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
....
> +STATIC bool
> +xfs_refcountbt_verify(
> +	struct xfs_buf		*bp)

feel free to shorten that prefix to xfs_refcbt_.....

> +{
> +	struct xfs_mount	*mp = bp->b_target->bt_mount;
> +	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
> +	struct xfs_perag	*pag = bp->b_pag;
> +	unsigned int		level;
> +
> +	if (block->bb_magic != cpu_to_be32(XFS_REFC_CRC_MAGIC))
> +		return false;
> +
> +	if (!xfs_sb_version_hasreflink(&mp->m_sb))
> +		return false;
> +	if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
> +		return false;
> +	if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
> +		return false;
> +	if (pag &&
> +	    be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
> +		return false;
> +
> +	level = be16_to_cpu(block->bb_level);
> +	if (pag && pag->pagf_init) {
> +		if (level >= pag->pagf_refcount_level)
> +			return false;
> +	} else if (level >= mp->m_ag_maxlevels)
> +		return false;
> +
> +	/* numrecs verification */
> +	if (be16_to_cpu(block->bb_numrecs) > mp->m_refc_mxr[level != 0])
> +		return false;
> +
> +	/* sibling pointer verification */
> +	if (!block->bb_u.s.bb_leftsib ||
> +	    (be32_to_cpu(block->bb_u.s.bb_leftsib) >= mp->m_sb.sb_agblocks &&
> +	     block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK)))
> +		return false;
> +	if (!block->bb_u.s.bb_rightsib ||
> +	    (be32_to_cpu(block->bb_u.s.bb_rightsib) >= mp->m_sb.sb_agblocks &&
> +	     block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK)))
> +		return false;

I'm starting to think there's a xfs_btree_sblock_verify() function
we need to factor out of all these btree verification functions...

> +#ifndef __XFS_REFCOUNT_BTREE_H__
> +#define	__XFS_REFCOUNT_BTREE_H__
> +
> +/*
> + * Freespace on-disk structures
> + */
> +
> +struct xfs_buf;
> +struct xfs_btree_cur;
> +struct xfs_mount;
> +
> +/*
> + * Btree block header size depends on a superblock flag.
> + */
> +#define XFS_REFCOUNT_BLOCK_LEN	XFS_BTREE_SBLOCK_CRC_LEN

Comment is stale.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
