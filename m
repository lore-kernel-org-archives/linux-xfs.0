Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C34B4C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 17:45:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BFA865238
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 17:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhCIRo1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 12:44:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:47228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230425AbhCIRo0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Mar 2021 12:44:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E70365215;
        Tue,  9 Mar 2021 17:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615311866;
        bh=EMWO2R9ts7MIc+KTaLrxy6B4I4EUNSJzT7alnDoailg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qT/dM5UYpSB+4h+K4rTGgf4+fu3rXDHx+yiojY+YyqQTB1LYFIcjuD21x+u/dA7WU
         4hGcwd61HJrbSpwxtwFWfSM3ATWNM6/8sv+ZLQ8dRG3Luqc0taXNYlVdA3t/PgUUCB
         LIbx5x7wvgdTxou2jHwyCXs0SdPe8sZKLr2Rcqx2rLZpJqdnggZSoQn2G7+PTOafd6
         /Z50EITrX1vkBDIxE2cs9zh6Mh4a0lSdgnhJqiRuaUF2Jf+yOjNklcGxNtp4TTZTYK
         EONcOCLh28F2hequu/F3gtdNSuYpcQrW9hx9WCc6X4OnhfqFm+WJLKlysbADB6Torb
         qJnWRN2lKfvLw==
Date:   Tue, 9 Mar 2021 09:44:25 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: mark xfs_bmap_set_attrforkoff static
Message-ID: <20210309174425.GW3419940@magnolia>
References: <20210225081355.139766-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225081355.139766-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 09:13:55AM +0100, Christoph Hellwig wrote:
> xfs_bmap_set_attrforkoff is only used inside of xfs_bmap.c, so mark it
> static.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine, assuming you're all fine with Dave's other patch to
initialize attr forks when ACLs are turned on?

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 2 +-
>  fs/xfs/libxfs/xfs_bmap.h | 1 -
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index e0905ad171f0a5..d53afd82e109e5 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1028,7 +1028,7 @@ xfs_bmap_add_attrfork_local(
>  }
>  
>  /* Set an inode attr fork off based on the format */
> -int
> +static int
>  xfs_bmap_set_attrforkoff(
>  	struct xfs_inode	*ip,
>  	int			size,
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 6747e97a794901..66a7b5b755a493 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -186,7 +186,6 @@ static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
>  void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
>  		xfs_filblks_t len);
>  int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
> -int	xfs_bmap_set_attrforkoff(struct xfs_inode *ip, int size, int *version);
>  void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
>  		struct xfs_inode *ip, int whichfork);
>  void	__xfs_bmap_add_free(struct xfs_trans *tp, xfs_fsblock_t bno,
> -- 
> 2.29.2
> 
