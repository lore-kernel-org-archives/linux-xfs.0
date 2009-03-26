Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2QMfgmM194189 for <xfs@oss.sgi.com>; Thu, 26 Mar 2009 17:41:52 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5AC20AC00E
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2009 15:41:17 -0700 (PDT)
Message-Id: <3D659CF1-738E-4580-B390-9E7B65C4BE2F@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090318094132.224487000@bombadil.infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 4/5] xfs: remove m_litino
Date: Thu, 26 Mar 2009 17:41:16 -0500
References: <20090318094119.561416000@bombadil.infradead.org>
	<20090318094132.224487000@bombadil.infradead.org>
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

> With the upcoming v3 inodes the inode data/attr area size needs to be
> calculated for each specific inode, so we can't cache it in the  
> superblock
> anymore.

The change looks fine. But what is "v3 inodes"? I'm sure it's been
mentioned on the list, I'm just missing the history.

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: xfs/fs/xfs/xfs_dinode.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dinode.h	2009-02-19 20:44:20.755069389 +0100
> +++ xfs/fs/xfs/xfs_dinode.h	2009-03-18 07:37:16.652977839 +0100
> @@ -103,7 +103,9 @@ typedef enum xfs_dinode_fmt {
> /*
>  * Inode size for given fs.
>  */
> -#define	XFS_LITINO(mp)	((mp)->m_litino)
> +#define XFS_LITINO(mp) \
> +	((int)(((mp)->m_sb.sb_inodesize) - sizeof(struct xfs_dinode)))
> +
> #define	XFS_BROOT_SIZE_ADJ	\
> 	(XFS_BTREE_LBLOCK_LEN - sizeof(xfs_bmdr_block_t))
>
> Index: xfs/fs/xfs/xfs_mount.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_mount.c	2009-03-18 07:37:15.633978066 +0100
> +++ xfs/fs/xfs/xfs_mount.c	2009-03-18 07:37:20.566978952 +0100
> @@ -651,7 +651,6 @@ xfs_mount_common(xfs_mount_t *mp, xfs_sb
> 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
> 	mp->m_agno_log = xfs_highbit32(sbp->sb_agcount - 1) + 1;
> 	mp->m_agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
> -	mp->m_litino = sbp->sb_inodesize - sizeof(struct xfs_dinode);
> 	mp->m_blockmask = sbp->sb_blocksize - 1;
> 	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
> 	mp->m_blockwmask = mp->m_blockwsize - 1;
> Index: xfs/fs/xfs/xfs_mount.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_mount.h	2009-03-18 07:37:16.077856262 +0100
> +++ xfs/fs/xfs/xfs_mount.h	2009-03-18 07:37:20.585978718 +0100
> @@ -203,7 +203,6 @@ typedef struct xfs_mount {
> 	uint			m_attr_node_ents; /* #entries in attr danode */
> 	int			m_ialloc_inos;	/* inodes in inode allocation */
> 	int			m_ialloc_blks;	/* blocks in inode allocation */
> -	int			m_litino;	/* size of inode union area */
> 	int			m_inoalign_mask;/* mask sb_inoalignmt if used */
> 	uint			m_qflags;	/* quota status flags */
> 	xfs_trans_reservations_t m_reservations;/* precomputed res values */
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
