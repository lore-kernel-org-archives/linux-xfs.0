Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2336C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 16:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 921CA61252
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 16:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbhKKQKS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Nov 2021 11:10:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:40764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232366AbhKKQKS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Nov 2021 11:10:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C3AB6124D;
        Thu, 11 Nov 2021 16:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636646849;
        bh=1z5DguXtaSDEwWuq56VwfBwkMawplKMIY8/cFNfz7v4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VT65O4vUKMPUEhJej4JT5EKMgHBs5VGReKiWxWwrVnSIea675j6iYzH8ByzyJkxTY
         wcNmfEiD3Xvebfo7dtpLhm14VRDOorXcXKxkVWyAPCJn4Bo0o8uhy7pgFvaTVNLdmy
         7ZHR0A6j6Tmws4qnfu7SAmxxjK/Zqs6pvkONiGX2HA2hLLyexWKwvQ9SdYkUyxutsh
         nUfDxLPLxV4OvCS4SOZZuo5x9qAsalFI2UG+O99tu17Yvb83rnzLsvDZ0BeeRLT97A
         KMdNHvU9/qA5zzm8HoTkJ/GjD0mZA/vu0yyLyNyXY8U2ofP4w1aGCDwBoEwj8hqjrK
         5j/B5XIJE0l6Q==
Date:   Thu, 11 Nov 2021 08:07:28 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] xfs: add leaf to node error tag
Message-ID: <20211111160728.GC24307@magnolia>
References: <20211111001716.77336-1-catherine.hoang@oracle.com>
 <20211111001716.77336-3-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111001716.77336-3-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 11, 2021 at 12:17:16AM +0000, Catherine Hoang wrote:
> Add an error tag on xfs_attr3_leaf_to_node to test log attribute
> recovery and replay.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 6 ++++++
>  fs/xfs/libxfs/xfs_errortag.h  | 4 +++-
>  fs/xfs/xfs_error.c            | 3 +++
>  3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 74b76b09509f..fdeb09de74ca 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -28,6 +28,7 @@
>  #include "xfs_dir2.h"
>  #include "xfs_log.h"
>  #include "xfs_ag.h"
> +#include "xfs_errortag.h"
>  
>  
>  /*
> @@ -1189,6 +1190,11 @@ xfs_attr3_leaf_to_node(
>  
>  	trace_xfs_attr_leaf_to_node(args);
>  
> +	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_LEAF_TO_NODE)) {

Hmmm... any plans to do a similar thing for directories too?

(FWIW the rest of the errortag injecting stuff looks ok...)

--D

> +		error = -EIO;
> +		goto out;
> +	}
> +
>  	error = xfs_da_grow_inode(args, &blkno);
>  	if (error)
>  		goto out;
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 31aeeb94dd5b..cc1650b58723 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -61,7 +61,8 @@
>  #define XFS_ERRTAG_AG_RESV_FAIL				38
>  #define XFS_ERRTAG_LARP					39
>  #define XFS_ERRTAG_LEAF_SPLIT				40
> -#define XFS_ERRTAG_MAX					41
> +#define XFS_ERRTAG_LEAF_TO_NODE				41
> +#define XFS_ERRTAG_MAX					42
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -107,5 +108,6 @@
>  #define XFS_RANDOM_AG_RESV_FAIL				1
>  #define XFS_RANDOM_LARP					1
>  #define XFS_RANDOM_LEAF_SPLIT				1
> +#define XFS_RANDOM_LEAF_TO_NODE				1
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 732cb66236c1..7f2a71218a82 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -59,6 +59,7 @@ static unsigned int xfs_errortag_random_default[] = {
>  	XFS_RANDOM_AG_RESV_FAIL,
>  	XFS_RANDOM_LARP,
>  	XFS_RANDOM_LEAF_SPLIT,
> +	XFS_RANDOM_LEAF_TO_NODE,
>  };
>  
>  struct xfs_errortag_attr {
> @@ -174,6 +175,7 @@ XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTE
>  XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
>  XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
>  XFS_ERRORTAG_ATTR_RW(leaf_split,	XFS_ERRTAG_LEAF_SPLIT);
> +XFS_ERRORTAG_ATTR_RW(leaf_to_node,	XFS_ERRTAG_LEAF_TO_NODE);
>  
>  static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -217,6 +219,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
>  	XFS_ERRORTAG_ATTR_LIST(larp),
>  	XFS_ERRORTAG_ATTR_LIST(leaf_split),
> +	XFS_ERRORTAG_ATTR_LIST(leaf_to_node),
>  	NULL,
>  };
>  
> -- 
> 2.25.1
> 
