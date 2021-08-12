Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0550C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 17:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B05A60724
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 17:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbhHLRQ7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 13:16:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:42174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235044AbhHLRQ6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Aug 2021 13:16:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BD7160724;
        Thu, 12 Aug 2021 17:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628788593;
        bh=sjUQV9xtVqqh1HINKoYu4kxCkmUs65SxUnMpDMTjXPo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KOCBHAdss1DoW92/2Zqyw36wxkPEytGChy3U/5jyzZKpH/A/7vfqmHgtFbjNOBUI1
         QdYoqzHzaGy/03JB8GgpWYXAt9lwvU/VyqyjskETNih5+042IbddRecjU3Vm9f6HKv
         F83PX/ythbf2gaC8/KjbvMx8EoMGrUw6XUbrvY31hPQOSDqPJqF36sJB5Nf+/bHnQF
         WAnzDAFrBfEw+tIdRCw7uLf63YvEEo+j0U7Rt10o0IAsCJtD5XMT4nKuTce+Ae0OrP
         a6hJIhyyrBW1YO84RLh2b6vfXk62oQK8F0Ur00JOr8vs0G2nGSzf1FoWch1xH2oo52
         /M341aQt48Xdw==
Date:   Thu, 12 Aug 2021 10:16:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: remove the xfs_dqblk_t typedef
Message-ID: <20210812171633.GU3601443@magnolia>
References: <20210812084343.27934-1-hch@lst.de>
 <20210812084343.27934-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812084343.27934-4-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 12, 2021 at 10:43:43AM +0200, Christoph Hellwig wrote:
> Remove the few leftover instances of the xfs_dinode_t typedef.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

With the commit message fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c | 4 ++--
>  fs/xfs/libxfs/xfs_format.h    | 4 ++--
>  fs/xfs/xfs_dquot.c            | 2 +-
>  fs/xfs/xfs_qm.c               | 2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index 6766417d5ba448..7691e44d38b9ac 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -22,7 +22,7 @@ xfs_calc_dquots_per_chunk(
>  	unsigned int		nbblks)	/* basic block units */
>  {
>  	ASSERT(nbblks > 0);
> -	return BBTOB(nbblks) / sizeof(xfs_dqblk_t);
> +	return BBTOB(nbblks) / sizeof(struct xfs_dqblk);
>  }
>  
>  /*
> @@ -127,7 +127,7 @@ xfs_dqblk_repair(
>  	 * Typically, a repair is only requested by quotacheck.
>  	 */
>  	ASSERT(id != -1);
> -	memset(dqb, 0, sizeof(xfs_dqblk_t));
> +	memset(dqb, 0, sizeof(struct xfs_dqblk));
>  
>  	dqb->dd_diskdq.d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
>  	dqb->dd_diskdq.d_version = XFS_DQUOT_VERSION;
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 5819c25c1478d0..61e454e4381e42 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1411,7 +1411,7 @@ struct xfs_disk_dquot {
>   * This is what goes on disk. This is separated from the xfs_disk_dquot because
>   * carrying the unnecessary padding would be a waste of memory.
>   */
> -typedef struct xfs_dqblk {
> +struct xfs_dqblk {
>  	struct xfs_disk_dquot	dd_diskdq; /* portion living incore as well */
>  	char			dd_fill[4];/* filling for posterity */
>  
> @@ -1421,7 +1421,7 @@ typedef struct xfs_dqblk {
>  	__be32		  dd_crc;	/* checksum */
>  	__be64		  dd_lsn;	/* last modification in log */
>  	uuid_t		  dd_uuid;	/* location information */
> -} xfs_dqblk_t;
> +};
>  
>  #define XFS_DQUOT_CRC_OFF	offsetof(struct xfs_dqblk, dd_crc)
>  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index c301b18b7685b1..a86665bdd4afb5 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -471,7 +471,7 @@ xfs_dquot_alloc(
>  	 * Offset of dquot in the (fixed sized) dquot chunk.
>  	 */
>  	dqp->q_bufoffset = (id % mp->m_quotainfo->qi_dqperchunk) *
> -			sizeof(xfs_dqblk_t);
> +			sizeof(struct xfs_dqblk);
>  
>  	/*
>  	 * Because we want to use a counting completion, complete
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 2bef4735d03031..95fdbe1b7016da 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -850,7 +850,7 @@ xfs_qm_reset_dqcounts(
>  	 */
>  #ifdef DEBUG
>  	j = (int)XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) /
> -		sizeof(xfs_dqblk_t);
> +		sizeof(struct xfs_dqblk);
>  	ASSERT(mp->m_quotainfo->qi_dqperchunk == j);
>  #endif
>  	dqb = bp->b_addr;
> -- 
> 2.30.2
> 
