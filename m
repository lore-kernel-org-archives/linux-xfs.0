Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2D9C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 18:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DA4060F6C
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 18:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbhGZRUW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 13:20:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231844AbhGZRUV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Jul 2021 13:20:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0260760F6C;
        Mon, 26 Jul 2021 18:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627322450;
        bh=KZISyuJgykNUbMzjlg9D7WK6Q4MYv5wM6RNtbamcjf8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hF+gqO892sYAurFCpjetELnc2LIl0uX3ZTWRjVHGRYcILLXwtZjjyxO0vZWFkpjtD
         CoDoMKyOL8Po+83sgWHftu8Gcv2PxhzzXbRwrcR91EgQCxkxlQGf2X9DKKzabcqNWY
         iSJiJmx0BjQjpIkiiCwCkGn6ASpZ3IfCANHiv3Gw38vGsBmKyah8Gdq8cg3Hn8+Nhp
         vrnmd+SBIldgCuAP95cS0GXn+8pMssH2RR6PjL2jMszWbZPxdtY1OuZbE1K3dtrPfQ
         2AfnAo1NDksBsvjHtCiDkQVl9LnUsVayv7XxceFCDrYUVHslepin6NgNlcmkOZitMy
         4DBrF+FZnBcLA==
Date:   Mon, 26 Jul 2021 11:00:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 01/12] xfs: Move extent count limits to xfs_format.h
Message-ID: <20210726180049.GB559212@magnolia>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
 <20210726114541.24898-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726114541.24898-2-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 05:15:30PM +0530, Chandan Babu R wrote:
> Maximum values associated with extent counters i.e. Maximum extent length,
> Maximum data extents and Maximum xattr extents are dictated by the on-disk
> format. Hence move these definitions over to xfs_format.h.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_format.h | 7 +++++++
>  fs/xfs/libxfs/xfs_types.h  | 7 -------
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 8cd48a651b96..37cca918d2ba 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1109,6 +1109,13 @@ enum xfs_dinode_fmt {
>  	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
>  	{ XFS_DINODE_FMT_UUID,		"uuid" }
>  
> +/*
> + * Max values for extlen, extnum, aextnum.
> + */
> +#define	MAXEXTLEN	((uint32_t)0x001fffff)	/* 21 bits */
> +#define	MAXEXTNUM	((int32_t)0x7fffffff)	/* signed int */
> +#define	MAXAEXTNUM	((int16_t)0x7fff)	/* signed short */

Why do the cast types change here?  This is a simple hoist, right?

--D

> +
>  /*
>   * Inode minimum and maximum sizes.
>   */
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 5c0cc806068b..8908346b1deb 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -56,13 +56,6 @@ typedef void *		xfs_failaddr_t;
>  #define	NULLFSINO	((xfs_ino_t)-1)
>  #define	NULLAGINO	((xfs_agino_t)-1)
>  
> -/*
> - * Max values for extlen, extnum, aextnum.
> - */
> -#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
> -#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
> -#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
> -
>  /*
>   * Minimum and maximum blocksize and sectorsize.
>   * The blocksize upper limit is pretty much arbitrary.
> -- 
> 2.30.2
> 
