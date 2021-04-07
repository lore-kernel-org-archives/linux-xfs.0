Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B9CC433ED
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 15:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8CB461382
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Apr 2021 15:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbhDGPkP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 11:40:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231366AbhDGPkO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Apr 2021 11:40:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEDF361262;
        Wed,  7 Apr 2021 15:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617810005;
        bh=JwsekB0pLkS7UCzPV3lOky7rbFuA03SE5wUwtPLs/rY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L55Sbs3gQaW1XdQtRXZfDxw3Ckco0xn/tjzjGaOSTSZE8cnzWK9XZyl/Pk1XFNAqI
         S/QwxXlNnSxLzeMFzzE37ggfmVW9MJ+ECfYAxpvK+U4Kn5d4NZ47MiOJToDlwL+CFI
         4R1L2UL8ui/Ym9wlitEdo4gdNRWupQUBkzmDgKIlEkrP3dnOL7BzI6433BjcMgXChn
         nstXse4mhpM+wNBmfF8lMFZT0wO5S/TQFr06l4FkQ3xR/hEIylB5qtEPFTHiISwl1o
         bUAebWUKf3FT8ja+Se+k1krFuSUFBA/hlKl0ncxLMh52Kn80pVvS2A8p8YWl3nfkaN
         skUvzhBnzIJMQ==
Date:   Wed, 7 Apr 2021 08:40:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: drop unnecessary setfilesize helper
Message-ID: <20210407154004.GK3957620@magnolia>
References: <20210405145903.629152-1-bfoster@redhat.com>
 <20210405145903.629152-5-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405145903.629152-5-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 05, 2021 at 10:59:03AM -0400, Brian Foster wrote:
> xfs_setfilesize() is the only remaining caller of the internal
> __xfs_setfilesize() helper. Fold them into a single function.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

LGTM
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_aops.c | 29 +++++++++--------------------
>  1 file changed, 9 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index a7f91f4186bc..87c2912f147d 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -42,14 +42,20 @@ static inline bool xfs_ioend_is_append(struct iomap_ioend *ioend)
>  /*
>   * Update on-disk file size now that data has been written to disk.
>   */
> -STATIC int
> -__xfs_setfilesize(
> +int
> +xfs_setfilesize(
>  	struct xfs_inode	*ip,
> -	struct xfs_trans	*tp,
>  	xfs_off_t		offset,
>  	size_t			size)
>  {
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_trans	*tp;
>  	xfs_fsize_t		isize;
> +	int			error;
> +
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
> +	if (error)
> +		return error;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	isize = xfs_new_eof(ip, offset + size);
> @@ -68,23 +74,6 @@ __xfs_setfilesize(
>  	return xfs_trans_commit(tp);
>  }
>  
> -int
> -xfs_setfilesize(
> -	struct xfs_inode	*ip,
> -	xfs_off_t		offset,
> -	size_t			size)
> -{
> -	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_trans	*tp;
> -	int			error;
> -
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_fsyncts, 0, 0, 0, &tp);
> -	if (error)
> -		return error;
> -
> -	return __xfs_setfilesize(ip, tp, offset, size);
> -}
> -
>  /*
>   * IO write completion.
>   */
> -- 
> 2.26.3
> 
