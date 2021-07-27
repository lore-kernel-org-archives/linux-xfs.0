Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E50C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 21:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2C9D60F6E
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 21:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhG0V6X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 17:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231814AbhG0V6X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 17:58:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A357760F57;
        Tue, 27 Jul 2021 21:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627423102;
        bh=H8QwCJbLteDDYoKWJgShX1T4ejsYTI3j+mLWdDubge0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KXDMiHUWB+JO0uKfh8uAti+IUC/3myO18SSiY92ZGB7znsUvgFsk8jpU3KOLM+4Jg
         QXid871sJ0NjSCuTJgAuZdLUZj1/xYaTPrIUf4UKz0yvifDoS9Kg+lvFhRJGqYiXzY
         brk9Jn4M6/Oy9uMj/BdUB1vzq+whp2xa15RvIyIfUaBtcE5DMML/HeDeX1rH0t752G
         QjVV3RZ3bjBGfUkye07ZtPuf5TYXVafz/tBZ5pspFjkU9AEY65yV91uOiKS2ZwRuOy
         i4Awh9uGg/vWC4IlJU4I352WZHpy0JfHUVxzavt2pWfC6cW4rAfMtpLvUbrorx7qVH
         yvyG/sw0eFTbg==
Date:   Tue, 27 Jul 2021 14:58:22 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 03/12] xfs: Introduce xfs_iext_max() helper
Message-ID: <20210727215822.GL559212@magnolia>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
 <20210726114541.24898-4-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726114541.24898-4-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 05:15:32PM +0530, Chandan Babu R wrote:
> xfs_iext_max() returns the maximum number of extents possible for one of
> data, cow or attribute fork. This helper will be extended further in a
> future commit when maximum extent counts associated with data/attribute
> forks are increased.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 9 ++++-----
>  fs/xfs/libxfs/xfs_inode_buf.c  | 8 +++-----
>  fs/xfs/libxfs/xfs_inode_fork.c | 6 +++---
>  fs/xfs/libxfs/xfs_inode_fork.h | 8 ++++++++
>  fs/xfs/scrub/inode_repair.c    | 2 +-
>  5 files changed, 19 insertions(+), 14 deletions(-)
> 

<snip>

> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index cf82be263b48..1eda2163603e 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -133,6 +133,14 @@ static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
>  	return ifp->if_format;
>  }
>  
> +static inline xfs_extnum_t xfs_iext_max(struct xfs_mount *mp, int whichfork)

xfs_iext_max_nextents() to go with the constants?  "max" on its own is a
little vague.  I /really/ like this getting cleaned up finally though.

> +{
> +	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
> +		return XFS_IFORK_EXTCNT_MAXS32;
> +	else
> +		return XFS_IFORK_EXTCNT_MAXS16;

No need for the 'else'.

--D

> +}
> +
>  struct xfs_ifork *xfs_ifork_alloc(enum xfs_dinode_fmt format,
>  				xfs_extnum_t nextents);
>  struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
> diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
> index c44f8d06939b..a44d7b48c374 100644
> --- a/fs/xfs/scrub/inode_repair.c
> +++ b/fs/xfs/scrub/inode_repair.c
> @@ -1198,7 +1198,7 @@ xrep_inode_blockcounts(
>  			return error;
>  		if (count >= sc->mp->m_sb.sb_dblocks)
>  			return -EFSCORRUPTED;
> -		if (nextents >= XFS_IFORK_EXTCNT_MAXS16)
> +		if (nextents >= xfs_iext_max(sc->mp, XFS_ATTR_FORK))
>  			return -EFSCORRUPTED;
>  		ifp->if_nextents = nextents;
>  	} else {
> -- 
> 2.30.2
> 
