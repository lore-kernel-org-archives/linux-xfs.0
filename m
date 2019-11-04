Return-Path: <SRS0=9rhF=Y4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C082CA9EB5
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 19:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2CC52089C
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Nov 2019 19:59:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sQMyhd6g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbfKDT7Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 14:59:24 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59034 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728392AbfKDT7Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 14:59:24 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4JxHvE080172;
        Mon, 4 Nov 2019 19:59:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=8EYZ1lO/3XhObZJrpu8e6SAWWpovHVBCCxs+Xuog7fg=;
 b=sQMyhd6g/gEsP+h/eWX2C0/RercY+uhSQqyLwez5TIQWzoHXbKO3x/axNwXjBuMl6GS2
 NXcJ4/Abm2J4Flf822FVKHfwx++GYJ4Ys2P2bH922kcWSVvhZu4o3cWr3pjkdEJlSqA8
 Ond0xgnA/Bb1mWyk52Thfl28GWaSmgYuoajFLNG3yV2mL3UIPf0sfYqXGIXkys1Mn8hq
 WLy/pgxqY0zbIvJPE5zRyckD1M0RcdAw/f2oxKkns23nqzMgE8wY8M2TURKylldWQHWb
 wqm1zEqNCX8l81mj9Vmg2H5Z+3q5IZG1spIQgfodde82T46o97WmnY2SQiQVzMC3Nuuz fA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w12er1k0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 19:59:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4Jx8oG064040;
        Mon, 4 Nov 2019 19:59:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2w1kxdvgf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 19:59:13 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA4JwjF1021819;
        Mon, 4 Nov 2019 19:58:45 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 11:58:45 -0800
Date:   Mon, 4 Nov 2019 11:58:44 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/34] xfs: move the node header size to struct
 xfs_da_geometry
Message-ID: <20191104195844.GG4153244@magnolia>
References: <20191101220719.29100-1-hch@lst.de>
 <20191101220719.29100-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101220719.29100-7-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040191
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040192
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 01, 2019 at 03:06:51PM -0700, Christoph Hellwig wrote:
> Move the node header size field to struct xfs_da_geometry, and remove
> the now unused non-directory dir ops infrastructure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_da_btree.c  | 14 ++++++++------
>  fs/xfs/libxfs/xfs_da_btree.h  |  1 +
>  fs/xfs/libxfs/xfs_da_format.c | 28 ----------------------------
>  fs/xfs/libxfs/xfs_dir2.c      | 12 +++++++-----
>  fs/xfs/libxfs/xfs_dir2.h      |  4 ----
>  fs/xfs/xfs_iops.c             |  1 -
>  fs/xfs/xfs_mount.h            |  1 -
>  7 files changed, 16 insertions(+), 45 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index d8f062343bab..26ad79d96205 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -414,7 +414,7 @@ xfs_da3_node_create(
>  
>  	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &ichdr);
>  	xfs_trans_log_buf(tp, bp,
> -		XFS_DA_LOGRANGE(node, &node->hdr, dp->d_ops->node_hdr_size));
> +		XFS_DA_LOGRANGE(node, &node->hdr, args->geo->node_hdr_size));
>  
>  	*bpp = bp;
>  	return 0;
> @@ -920,12 +920,13 @@ xfs_da3_node_rebalance(
>  	 */
>  	xfs_da3_node_hdr_to_disk(dp->i_mount, node1, &nodehdr1);
>  	xfs_trans_log_buf(tp, blk1->bp,
> -		XFS_DA_LOGRANGE(node1, &node1->hdr, dp->d_ops->node_hdr_size));
> +		XFS_DA_LOGRANGE(node1, &node1->hdr,
> +				state->args->geo->node_hdr_size));
>  
>  	xfs_da3_node_hdr_to_disk(dp->i_mount, node2, &nodehdr2);
>  	xfs_trans_log_buf(tp, blk2->bp,
>  		XFS_DA_LOGRANGE(node2, &node2->hdr,
> -				dp->d_ops->node_hdr_size +
> +				state->args->geo->node_hdr_size +
>  				(sizeof(btree2[0]) * nodehdr2.count)));
>  
>  	/*
> @@ -996,7 +997,8 @@ xfs_da3_node_add(
>  	nodehdr.count += 1;
>  	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &nodehdr);
>  	xfs_trans_log_buf(state->args->trans, oldblk->bp,
> -		XFS_DA_LOGRANGE(node, &node->hdr, dp->d_ops->node_hdr_size));
> +		XFS_DA_LOGRANGE(node, &node->hdr,
> +				state->args->geo->node_hdr_size));
>  
>  	/*
>  	 * Copy the last hash value from the oldblk to propagate upwards.
> @@ -1426,7 +1428,7 @@ xfs_da3_node_remove(
>  	nodehdr.count -= 1;
>  	xfs_da3_node_hdr_to_disk(dp->i_mount, node, &nodehdr);
>  	xfs_trans_log_buf(state->args->trans, drop_blk->bp,
> -	    XFS_DA_LOGRANGE(node, &node->hdr, dp->d_ops->node_hdr_size));
> +	    XFS_DA_LOGRANGE(node, &node->hdr, state->args->geo->node_hdr_size));
>  
>  	/*
>  	 * Copy the last hash value from the block to propagate upwards.
> @@ -1499,7 +1501,7 @@ xfs_da3_node_unbalance(
>  	xfs_da3_node_hdr_to_disk(dp->i_mount, save_node, &save_hdr);
>  	xfs_trans_log_buf(tp, save_blk->bp,
>  		XFS_DA_LOGRANGE(save_node, &save_node->hdr,
> -				dp->d_ops->node_hdr_size));
> +				state->args->geo->node_hdr_size));
>  
>  	/*
>  	 * Save the last hashval in the remaining block for upward propagation.
> diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
> index 63ed45057fa5..11b2d75f83ad 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.h
> +++ b/fs/xfs/libxfs/xfs_da_btree.h
> @@ -22,6 +22,7 @@ struct xfs_da_geometry {
>  	int		fsbcount;	/* da block size in filesystem blocks */
>  	uint8_t		fsblog;		/* log2 of _filesystem_ block size */
>  	uint8_t		blklog;		/* log2 of da block size */
> +	int		node_hdr_size;	/* danode header size in bytes */
>  	uint		node_ents;	/* # of entries in a danode */
>  	int		magicpct;	/* 37% of block size in bytes */
>  	xfs_dablk_t	datablk;	/* blockno of dir data v2 */
> diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
> index f896d37c845f..68dff1de61e9 100644
> --- a/fs/xfs/libxfs/xfs_da_format.c
> +++ b/fs/xfs/libxfs/xfs_da_format.c
> @@ -652,8 +652,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
>  	.leaf_max_ents = xfs_dir2_max_leaf_ents,
>  	.leaf_ents_p = xfs_dir2_leaf_ents_p,
>  
> -	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
> -
>  	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
>  	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
>  	.free_hdr_from_disk = xfs_dir2_free_hdr_from_disk,
> @@ -699,8 +697,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
>  	.leaf_max_ents = xfs_dir2_max_leaf_ents,
>  	.leaf_ents_p = xfs_dir2_leaf_ents_p,
>  
> -	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
> -
>  	.free_hdr_size = sizeof(struct xfs_dir2_free_hdr),
>  	.free_hdr_to_disk = xfs_dir2_free_hdr_to_disk,
>  	.free_hdr_from_disk = xfs_dir2_free_hdr_from_disk,
> @@ -746,8 +742,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  	.leaf_max_ents = xfs_dir3_max_leaf_ents,
>  	.leaf_ents_p = xfs_dir3_leaf_ents_p,
>  
> -	.node_hdr_size = sizeof(struct xfs_da3_node_hdr),
> -
>  	.free_hdr_size = sizeof(struct xfs_dir3_free_hdr),
>  	.free_hdr_to_disk = xfs_dir3_free_hdr_to_disk,
>  	.free_hdr_from_disk = xfs_dir3_free_hdr_from_disk,
> @@ -757,14 +751,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
>  	.db_to_fdindex = xfs_dir3_db_to_fdindex,
>  };
>  
> -static const struct xfs_dir_ops xfs_dir2_nondir_ops = {
> -	.node_hdr_size = sizeof(struct xfs_da_node_hdr),
> -};
> -
> -static const struct xfs_dir_ops xfs_dir3_nondir_ops = {
> -	.node_hdr_size = sizeof(struct xfs_da3_node_hdr),
> -};
> -
>  /*
>   * Return the ops structure according to the current config.  If we are passed
>   * an inode, then that overrides the default config we use which is based on
> @@ -785,17 +771,3 @@ xfs_dir_get_ops(
>  		return &xfs_dir2_ftype_ops;
>  	return &xfs_dir2_ops;
>  }
> -
> -const struct xfs_dir_ops *
> -xfs_nondir_get_ops(
> -	struct xfs_mount	*mp,
> -	struct xfs_inode	*dp)
> -{
> -	if (dp)
> -		return dp->d_ops;
> -	if (mp->m_nondir_inode_ops)
> -		return mp->m_nondir_inode_ops;
> -	if (xfs_sb_version_hascrc(&mp->m_sb))
> -		return &xfs_dir3_nondir_ops;
> -	return &xfs_dir2_nondir_ops;
> -}
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 867c5dee0751..aef20ec6e140 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -99,16 +99,13 @@ xfs_da_mount(
>  	struct xfs_mount	*mp)
>  {
>  	struct xfs_da_geometry	*dageo;
> -	int			nodehdr_size;
>  
>  
>  	ASSERT(mp->m_sb.sb_versionnum & XFS_SB_VERSION_DIRV2BIT);
>  	ASSERT(xfs_dir2_dirblock_bytes(&mp->m_sb) <= XFS_MAX_BLOCKSIZE);
>  
>  	mp->m_dir_inode_ops = xfs_dir_get_ops(mp, NULL);
> -	mp->m_nondir_inode_ops = xfs_nondir_get_ops(mp, NULL);
>  
> -	nodehdr_size = mp->m_dir_inode_ops->node_hdr_size;
>  	mp->m_dir_geo = kmem_zalloc(sizeof(struct xfs_da_geometry),
>  				    KM_MAYFAIL);
>  	mp->m_attr_geo = kmem_zalloc(sizeof(struct xfs_da_geometry),
> @@ -125,6 +122,10 @@ xfs_da_mount(
>  	dageo->fsblog = mp->m_sb.sb_blocklog;
>  	dageo->blksize = xfs_dir2_dirblock_bytes(&mp->m_sb);
>  	dageo->fsbcount = 1 << mp->m_sb.sb_dirblklog;
> +	if (xfs_sb_version_hascrc(&mp->m_sb))
> +		dageo->node_hdr_size = sizeof(struct xfs_da3_node_hdr);
> +	else
> +		dageo->node_hdr_size = sizeof(struct xfs_da_node_hdr);
>  
>  	/*
>  	 * Now we've set up the block conversion variables, we can calculate the
> @@ -133,7 +134,7 @@ xfs_da_mount(
>  	dageo->datablk = xfs_dir2_byte_to_da(dageo, XFS_DIR2_DATA_OFFSET);
>  	dageo->leafblk = xfs_dir2_byte_to_da(dageo, XFS_DIR2_LEAF_OFFSET);
>  	dageo->freeblk = xfs_dir2_byte_to_da(dageo, XFS_DIR2_FREE_OFFSET);
> -	dageo->node_ents = (dageo->blksize - nodehdr_size) /
> +	dageo->node_ents = (dageo->blksize - dageo->node_hdr_size) /
>  				(uint)sizeof(xfs_da_node_entry_t);
>  	dageo->magicpct = (dageo->blksize * 37) / 100;
>  
> @@ -143,7 +144,8 @@ xfs_da_mount(
>  	dageo->fsblog = mp->m_sb.sb_blocklog;
>  	dageo->blksize = 1 << dageo->blklog;
>  	dageo->fsbcount = 1;
> -	dageo->node_ents = (dageo->blksize - nodehdr_size) /
> +	dageo->node_hdr_size = mp->m_dir_geo->node_hdr_size;
> +	dageo->node_ents = (dageo->blksize - dageo->node_hdr_size) /
>  				(uint)sizeof(xfs_da_node_entry_t);
>  	dageo->magicpct = (dageo->blksize * 37) / 100;
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index 6eee4c1b20da..87fe876e90ed 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -81,8 +81,6 @@ struct xfs_dir_ops {
>  	struct xfs_dir2_leaf_entry *
>  		(*leaf_ents_p)(struct xfs_dir2_leaf *lp);
>  
> -	int	node_hdr_size;
> -
>  	int	free_hdr_size;
>  	void	(*free_hdr_to_disk)(struct xfs_dir2_free *to,
>  				    struct xfs_dir3_icfree_hdr *from);
> @@ -98,8 +96,6 @@ struct xfs_dir_ops {
>  
>  extern const struct xfs_dir_ops *
>  	xfs_dir_get_ops(struct xfs_mount *mp, struct xfs_inode *dp);
> -extern const struct xfs_dir_ops *
> -	xfs_nondir_get_ops(struct xfs_mount *mp, struct xfs_inode *dp);
>  
>  /*
>   * Generic directory interface routines
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 18e45e3a3f9f..40d4495e013c 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1319,7 +1319,6 @@ xfs_setup_inode(
>  		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_dir_ilock_class);
>  		ip->d_ops = ip->i_mount->m_dir_inode_ops;
>  	} else {
> -		ip->d_ops = ip->i_mount->m_nondir_inode_ops;
>  		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_nondir_ilock_class);
>  	}
>  
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index a46cb3fd24b1..3ddc5f4d1053 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -159,7 +159,6 @@ typedef struct xfs_mount {
>  	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
>  	const struct xfs_nameops *m_dirnameops;	/* vector of dir name ops */
>  	const struct xfs_dir_ops *m_dir_inode_ops; /* vector of dir inode ops */
> -	const struct xfs_dir_ops *m_nondir_inode_ops; /* !dir inode ops */
>  	uint			m_chsize;	/* size of next field */
>  	atomic_t		m_active_trans;	/* number trans frozen */
>  	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
> -- 
> 2.20.1
> 
