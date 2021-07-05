Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A280C07E98
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 08:11:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65C1F613BD
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 08:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhGEIOa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jul 2021 04:14:30 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:43605 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230000AbhGEIOa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jul 2021 04:14:30 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0Uek3Y4A_1625472710;
Received: from B-P7TQMD6M-0146.local(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Uek3Y4A_1625472710)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 05 Jul 2021 16:11:52 +0800
Date:   Mon, 5 Jul 2021 16:11:50 +0800
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: check for sparse inode clusters that cross new EOAG
 when shrinking
Message-ID: <YOK+xpu3+82rXci6@B-P7TQMD6M-0146.local>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
References: <20210703030157.GC24788@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210703030157.GC24788@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 08:01:57PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While running xfs/168, I noticed occasional write verifier shutdowns
> involving inodes at the very end of the filesystem.  Existing inode
> btree validation code checks that all inode clusters are fully contained
> within the filesystem.
> 
> However, due to inadequate checking in the fs shrink code, it's possible
> that there could be a sparse inode cluster at the end of the filesystem
> where the upper inodes of the cluster are marked as holes and the
> corresponding blocks are free.  In this case, the last blocks in the AG
> are listed in the bnobt.  This enables the shrink to proceed but results
> in a filesystem that trips the inode verifiers.  Fix this by disallowing
> the shrink.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Ohh, sparse inode chunks with partial free blocks...

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang

> ---
>  fs/xfs/libxfs/xfs_ag.c     |    8 +++++++
>  fs/xfs/libxfs/xfs_ialloc.c |   52 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ialloc.h |    3 +++
>  3 files changed, 63 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index dcd8c8f7cd4a..376e4bb0e4ec 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -815,6 +815,14 @@ xfs_ag_shrink_space(
>  
>  	args.fsbno = XFS_AGB_TO_FSB(mp, agno, aglen - delta);
>  
> +	/*
> +	 * Make sure that the last inode cluster cannot overlap with the new
> +	 * end of the AG, even if it's sparse.
> +	 */
> +	error = xfs_ialloc_check_shrink(*tpp, agno, agibp, aglen - delta);
> +	if (error)
> +		return error;
> +
>  	/*
>  	 * Disable perag reservations so it doesn't cause the allocation request
>  	 * to fail. We'll reestablish reservation before we return.
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 57d9cb632983..90c4afecf7ba 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2928,3 +2928,55 @@ xfs_ialloc_calc_rootino(
>  
>  	return XFS_AGINO_TO_INO(mp, 0, XFS_AGB_TO_AGINO(mp, first_bno));
>  }
> +
> +/*
> + * Ensure there are not sparse inode clusters that cross the new EOAG.
> + *
> + * This is a no-op for non-spinode filesystems since clusters are always fully
> + * allocated and checking the bnobt suffices.  However, a spinode filesystem
> + * could have a record where the upper inodes are free blocks.  If those blocks
> + * were removed from the filesystem, the inode record would extend beyond EOAG,
> + * which will be flagged as corruption.
> + */
> +int
> +xfs_ialloc_check_shrink(
> +	struct xfs_trans	*tp,
> +	xfs_agnumber_t		agno,
> +	struct xfs_buf		*agibp,
> +	xfs_agblock_t		new_length)
> +{
> +	struct xfs_inobt_rec_incore rec;
> +	struct xfs_btree_cur	*cur;
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	xfs_agino_t		agino = XFS_AGB_TO_AGINO(mp, new_length);
> +	int			has;
> +	int			error;
> +
> +	if (!xfs_sb_version_hassparseinodes(&mp->m_sb))
> +		return 0;
> +
> +	cur = xfs_inobt_init_cursor(mp, tp, agibp, agno, XFS_BTNUM_INO);
> +
> +	/* Look up the inobt record that would correspond to the new EOFS. */
> +	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &has);
> +	if (error || !has)
> +		goto out;
> +
> +	error = xfs_inobt_get_rec(cur, &rec, &has);
> +	if (error)
> +		goto out;
> +
> +	if (!has) {
> +		error = -EFSCORRUPTED;
> +		goto out;
> +	}
> +
> +	/* If the record covers inodes that would be beyond EOFS, bail out. */
> +	if (rec.ir_startino + XFS_INODES_PER_CHUNK > agino) {
> +		error = -ENOSPC;
> +		goto out;
> +	}
> +out:
> +	xfs_btree_del_cursor(cur, error);
> +	return error;
> +}
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index 9df7c80408ff..9a2112b4ad5e 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
> @@ -122,4 +122,7 @@ int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
>  void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
>  xfs_ino_t xfs_ialloc_calc_rootino(struct xfs_mount *mp, int sunit);
>  
> +int xfs_ialloc_check_shrink(struct xfs_trans *tp, xfs_agnumber_t agno,
> +		struct xfs_buf *agibp, xfs_agblock_t new_length);
> +
>  #endif	/* __XFS_IALLOC_H__ */
