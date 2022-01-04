Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9A29C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jan 2022 23:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235413AbiADX2h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 18:28:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50030 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbiADX2g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 18:28:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C570F615E4
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 23:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D59C36AEB;
        Tue,  4 Jan 2022 23:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641338914;
        bh=3OnpXPxVh3Gups+B/fwWX0ajLiqflUMzZC+tyfBlnNE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QO9xMfqs3I58w1MVZKj2VkpsQnyUpqN0E7I+llGpT2c2sjAxOQ8hOK9bslP5Hro4j
         DHGwN9woW+kprKtnlBpYWNjHugYUReTllfVaWby6ifVdvNiSqwbTRHcfvOKWekavfV
         nfCbH6JBb49KS8+DLsmA4EsT3Hgn6p6Hld+mWT5tiF2U7EG/vcBEQSl+V9uObAxPl9
         cKXnuNMRLPcnqZl5Dzt/RGMPd5FNw5IEbkqgpyb9bBEaV0u463Ibwz2XgEmL9LHxOi
         wR1gJcKOmFVgbcVrTnBBrb+QCI93VEUU2gfCniFxeYlRPMn7bi43NsQob3tfJZTIDb
         eWzLD3bErz+nA==
Date:   Tue, 4 Jan 2022 15:28:33 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 01/16] xfs: Move extent count limits to xfs_format.h
Message-ID: <20220104232833.GG31583@magnolia>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
 <20211214084519.759272-2-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214084519.759272-2-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 14, 2021 at 02:15:04PM +0530, Chandan Babu R wrote:
> Maximum values associated with extent counters i.e. Maximum extent length,
> Maximum data extents and Maximum xattr extents are dictated by the on-disk
> format. Hence move these definitions over to xfs_format.h.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_format.h | 7 +++++++
>  fs/xfs/libxfs/xfs_types.h  | 7 -------
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index d665c04e69dd..d75e5b16da7e 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -869,6 +869,13 @@ enum xfs_dinode_fmt {
>  	{ XFS_DINODE_FMT_BTREE,		"btree" }, \
>  	{ XFS_DINODE_FMT_UUID,		"uuid" }
>  
> +/*
> + * Max values for extlen, extnum, aextnum.
> + */
> +#define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
> +#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
> +#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
> +
>  /*
>   * Inode minimum and maximum sizes.
>   */
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index b6da06b40989..794a54cbd0de 100644
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
