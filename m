Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0A9C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 17:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEF9760FC0
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 17:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbhHLRPM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 13:15:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235003AbhHLRPL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Aug 2021 13:15:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A7F460FD7;
        Thu, 12 Aug 2021 17:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628788485;
        bh=wx3KhKRb8GPkLHXHevRcWtfQZ4zOEGHK+XV9Dqlp7Ik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hgSV0BWRgZsq8WM6KPMaiMO28Lg0sl6NOC4rzNmM6ux809fSa6q/RnR3tdocS+O81
         YE2vOGKjRKRbjHrvcD9AFPakwMwUD6VecaE5mV3eKDPxa2zUjkZdij/D/a/jtBoAYO
         QNjIDGVdbJsGnfr/whG3AXYGBJK5paXuGKyi+ClSQ0G/ZJQxyAO6PYjpQ1eZsA1TUp
         EMtqWi+BEz2LgdnHQNWyDFC+tMR1VtKiNQxsC37m3COWDREPhQAvZfvqHuDUlqd0kg
         dzLISuFdzIPwnFNoPkyFRtoV6ZM8YEQB1wfFXyPLxRIu57NqU5Cjji5BJ0sP4PTqyn
         yY/LjWDitmouw==
Date:   Thu, 12 Aug 2021 10:14:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: remove the xfs_dsb_t typedef
Message-ID: <20210812171445.GS3601443@magnolia>
References: <20210812084343.27934-1-hch@lst.de>
 <20210812084343.27934-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812084343.27934-3-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 12, 2021 at 10:43:42AM +0200, Christoph Hellwig wrote:
> Remove the few leftover instances of the xfs_dinode_t typedef.

With the commit message fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_format.h | 5 ++---
>  fs/xfs/libxfs/xfs_sb.c     | 4 ++--
>  fs/xfs/xfs_trans.c         | 8 ++++----
>  3 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index f601049b65f465..5819c25c1478d0 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -184,7 +184,7 @@ typedef struct xfs_sb {
>   * Superblock - on disk version.  Must match the in core version above.
>   * Must be padded to 64 bit alignment.
>   */
> -typedef struct xfs_dsb {
> +struct xfs_dsb {
>  	__be32		sb_magicnum;	/* magic number == XFS_SB_MAGIC */
>  	__be32		sb_blocksize;	/* logical block size, bytes */
>  	__be64		sb_dblocks;	/* number of data blocks */
> @@ -263,8 +263,7 @@ typedef struct xfs_dsb {
>  	uuid_t		sb_meta_uuid;	/* metadata file system unique id */
>  
>  	/* must be padded to 64 bit alignment */
> -} xfs_dsb_t;
> -
> +};
>  
>  /*
>   * Misc. Flags - warning - these will be cleared by xfs_repair unless
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 04f5386446dbb0..56d241cb17ee1b 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -391,7 +391,7 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
>  static void
>  __xfs_sb_from_disk(
>  	struct xfs_sb	*to,
> -	xfs_dsb_t	*from,
> +	struct xfs_dsb	*from,
>  	bool		convert_xquota)
>  {
>  	to->sb_magicnum = be32_to_cpu(from->sb_magicnum);
> @@ -466,7 +466,7 @@ __xfs_sb_from_disk(
>  void
>  xfs_sb_from_disk(
>  	struct xfs_sb	*to,
> -	xfs_dsb_t	*from)
> +	struct xfs_dsb	*from)
>  {
>  	__xfs_sb_from_disk(to, from, true);
>  }
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 83abaa21961605..7f4f431bc256ce 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -477,7 +477,7 @@ STATIC void
>  xfs_trans_apply_sb_deltas(
>  	xfs_trans_t	*tp)
>  {
> -	xfs_dsb_t	*sbp;
> +	struct xfs_dsb	*sbp;
>  	struct xfs_buf	*bp;
>  	int		whole = 0;
>  
> @@ -541,14 +541,14 @@ xfs_trans_apply_sb_deltas(
>  		/*
>  		 * Log the whole thing, the fields are noncontiguous.
>  		 */
> -		xfs_trans_log_buf(tp, bp, 0, sizeof(xfs_dsb_t) - 1);
> +		xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb) - 1);
>  	else
>  		/*
>  		 * Since all the modifiable fields are contiguous, we
>  		 * can get away with this.
>  		 */
> -		xfs_trans_log_buf(tp, bp, offsetof(xfs_dsb_t, sb_icount),
> -				  offsetof(xfs_dsb_t, sb_frextents) +
> +		xfs_trans_log_buf(tp, bp, offsetof(struct xfs_dsb, sb_icount),
> +				  offsetof(struct xfs_dsb, sb_frextents) +
>  				  sizeof(sbp->sb_frextents) - 1);
>  }
>  
> -- 
> 2.30.2
> 
