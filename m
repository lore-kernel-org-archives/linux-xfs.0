Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC91C4707F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 22:06:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE617613E5
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 22:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbhE0WHx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 18:07:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233563AbhE0WHw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 18:07:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5663C613DA;
        Thu, 27 May 2021 22:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622153178;
        bh=0Xayw0T6I8H1hcfXmIM/AaZnw57roTI2e7SQ6q1Zu7Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pv7zX21Hm16erOnTI7Z6QFeiyzskNOD3cMtKTDCwrFPjp7G0kYXdXVMNn6kdtz5+h
         M01158RRIs+1O+0jJ/QGyFHYtrqe5AuYxVUlh7jdRCPnkTNsx2DopTLqRe1E4mwqej
         UIPtmZ6Z2l5/dgDgbGVbQuYQVxkjGQJM8d9rCc2RN8pnWdYBv/A5X4xUk7xMl/HcNi
         BVpS5WOM2HY28QGRkGoy7NRPSFhHLo/sEp0ClMiyU0c2NbSWlbE7mhaCZZbA8GksXI
         Y42TX6jVsFrEoaUgcptJlhq12PwdFQpfaULkeEtcfP8GzHCOcM8KBa/nemdTp6WLxX
         dmtgX+9mW2Wuw==
Date:   Thu, 27 May 2021 15:06:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/23] xfs: remove xfs_perag_t
Message-ID: <20210527220618.GR2402049@locust>
References: <20210519012102.450926-1-david@fromorbit.com>
 <20210519012102.450926-24-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519012102.450926-24-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 11:21:02AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Almost unused, gets rid of another typedef.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ag.c    | 24 +++++++++++-----------
>  fs/xfs/libxfs/xfs_ag.h    |  4 ++--
>  fs/xfs/libxfs/xfs_alloc.c | 42 +++++++++++++++++++--------------------
>  3 files changed, 35 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 0e0819f6fb89..29c42698aa90 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -104,19 +104,19 @@ xfs_perag_put(
>   */
>  int
>  xfs_initialize_perag_data(
> -	struct xfs_mount *mp,
> -	xfs_agnumber_t	agcount)
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agcount)
>  {
> -	xfs_agnumber_t	index;
> -	xfs_perag_t	*pag;
> -	xfs_sb_t	*sbp = &mp->m_sb;
> -	uint64_t	ifree = 0;
> -	uint64_t	ialloc = 0;
> -	uint64_t	bfree = 0;
> -	uint64_t	bfreelst = 0;
> -	uint64_t	btree = 0;
> -	uint64_t	fdblocks;
> -	int		error = 0;
> +	xfs_agnumber_t		index;
> +	struct xfs_perag	*pag;
> +	struct xfs_sb		*sbp = &mp->m_sb;
> +	uint64_t		ifree = 0;
> +	uint64_t		ialloc = 0;
> +	uint64_t		bfree = 0;
> +	uint64_t		bfreelst = 0;
> +	uint64_t		btree = 0;
> +	uint64_t		fdblocks;
> +	int			error = 0;
>  
>  	for (index = 0; index < agcount; index++) {
>  		/*
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index bebbe1bfce27..39f6a0dc984a 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -29,7 +29,7 @@ struct xfs_ag_resv {
>   * Per-ag incore structure, copies of information in agf and agi, to improve the
>   * performance of allocation group selection.
>   */
> -typedef struct xfs_perag {
> +struct xfs_perag {
>  	struct xfs_mount *pag_mount;	/* owner filesystem */
>  	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
>  	atomic_t	pag_ref;	/* perag reference count */
> @@ -102,7 +102,7 @@ typedef struct xfs_perag {
>  	 * or have some other means to control concurrency.
>  	 */
>  	struct rhashtable	pagi_unlinked_hash;
> -} xfs_perag_t;
> +};
>  
>  int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
>  			xfs_agnumber_t *maxagi);
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index f7864f33c1f0..00bb34251829 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2694,21 +2694,21 @@ xfs_alloc_fix_freelist(
>   * Get a block from the freelist.
>   * Returns with the buffer for the block gotten.
>   */
> -int				/* error */
> +int
>  xfs_alloc_get_freelist(
> -	xfs_trans_t	*tp,	/* transaction pointer */
> -	struct xfs_buf	*agbp,	/* buffer containing the agf structure */
> -	xfs_agblock_t	*bnop,	/* block address retrieved from freelist */
> -	int		btreeblk) /* destination is a AGF btree */
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agbp,
> +	xfs_agblock_t		*bnop,
> +	int			btreeblk)
>  {
> -	struct xfs_agf	*agf = agbp->b_addr;
> -	struct xfs_buf	*agflbp;/* buffer for a.g. freelist structure */
> -	xfs_agblock_t	bno;	/* block number returned */
> -	__be32		*agfl_bno;
> -	int		error;
> -	int		logflags;
> -	xfs_mount_t	*mp = tp->t_mountp;
> -	xfs_perag_t	*pag;	/* per allocation group data */
> +	struct xfs_agf		*agf = agbp->b_addr;
> +	struct xfs_buf		*agflbp;
> +	xfs_agblock_t		bno;
> +	__be32			*agfl_bno;
> +	int			error;
> +	int			logflags;
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_perag	*pag;
>  
>  	/*
>  	 * Freelist is empty, give up.
> @@ -2818,20 +2818,20 @@ xfs_alloc_pagf_init(
>  /*
>   * Put the block on the freelist for the allocation group.
>   */
> -int					/* error */
> +int
>  xfs_alloc_put_freelist(
> -	xfs_trans_t		*tp,	/* transaction pointer */
> -	struct xfs_buf		*agbp,	/* buffer for a.g. freelist header */
> -	struct xfs_buf		*agflbp,/* buffer for a.g. free block array */
> -	xfs_agblock_t		bno,	/* block being freed */
> -	int			btreeblk) /* block came from a AGF btree */
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agbp,
> +	struct xfs_buf		*agflbp,
> +	xfs_agblock_t		bno,
> +	int			btreeblk)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_agf		*agf = agbp->b_addr;
> -	__be32			*blockp;/* pointer to array entry */
> +	struct xfs_perag	*pag;
> +	__be32			*blockp;
>  	int			error;
>  	int			logflags;
> -	xfs_perag_t		*pag;	/* per allocation group data */
>  	__be32			*agfl_bno;
>  	int			startoff;
>  
> -- 
> 2.31.1
> 
