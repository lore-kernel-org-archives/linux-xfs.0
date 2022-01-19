Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6712DC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jan 2022 04:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351110AbiASEtO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jan 2022 23:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346654AbiASEtN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jan 2022 23:49:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E3CC061574
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jan 2022 20:49:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F27FBB80E09
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 04:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC17CC004E1;
        Wed, 19 Jan 2022 04:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642567738;
        bh=bpOG/hvGtsK40bXvXPp/OwsopaiZslR5ObbJR69yCSQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FQl6cu9KVMM6TAOvnB5q1pWtCoPlqHw68EwqTQcYary9kjFdzy/Ouhi8/slFt+HJ7
         SSc3gh7Kl9wHzN8uW7YV4bx3n5IzRaucQqD8/3VVzcGXbYGqhpfn2tcPQv9wABqL46
         v9ZiSJfmVC8tblPRoP4R2dV49cdx/AT5EM4j6SUpT1xWIDcubFljMQPpwkgAv2xf9o
         4maswN4dM+bmicUrxujbShUH7kvn3fdsgb9JjItAcr4qVrZAonczbYRoFap7MJdor2
         oPOcog4yPEyApcje62oDE4mx8grleFP91ZMA7A1qt8eumGb4wyDfSQpK+cnlnanKAL
         ubvdMpFGkzrJw==
Date:   Tue, 18 Jan 2022 20:48:58 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/2] xfs: add leaf to node error tag
Message-ID: <20220119044858.GG13540@magnolia>
References: <20220110212454.359752-1-catherine.hoang@oracle.com>
 <20220110212454.359752-3-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110212454.359752-3-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 10, 2022 at 09:24:54PM +0000, Catherine Hoang wrote:
> Add an error tag on xfs_attr3_leaf_to_node to test log attribute
> recovery and replay.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

This one actually /is/ an error injection knob for specific xattr
activities, so the naming is appropriate.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 6 ++++++
>  fs/xfs/libxfs/xfs_errortag.h  | 4 +++-
>  fs/xfs/xfs_error.c            | 3 +++
>  3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 74b76b09509f..0fe028d95c77 100644
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
> +	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_LARP_LEAF_TO_NODE)) {
> +		error = -EIO;
> +		goto out;
> +	}
> +
>  	error = xfs_da_grow_inode(args, &blkno);
>  	if (error)
>  		goto out;
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 970f3a3f3750..6d90f06442e8 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -61,7 +61,8 @@
>  #define XFS_ERRTAG_AG_RESV_FAIL				38
>  #define XFS_ERRTAG_LARP					39
>  #define XFS_ERRTAG_LARP_LEAF_SPLIT			40
> -#define XFS_ERRTAG_MAX					41
> +#define XFS_ERRTAG_LARP_LEAF_TO_NODE			41
> +#define XFS_ERRTAG_MAX					42
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -107,5 +108,6 @@
>  #define XFS_RANDOM_AG_RESV_FAIL				1
>  #define XFS_RANDOM_LARP					1
>  #define XFS_RANDOM_LARP_LEAF_SPLIT			1
> +#define XFS_RANDOM_LARP_LEAF_TO_NODE			1
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 9cb6743a5ae3..ae2003a95324 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -59,6 +59,7 @@ static unsigned int xfs_errortag_random_default[] = {
>  	XFS_RANDOM_AG_RESV_FAIL,
>  	XFS_RANDOM_LARP,
>  	XFS_RANDOM_LARP_LEAF_SPLIT,
> +	XFS_RANDOM_LARP_LEAF_TO_NODE,
>  };
>  
>  struct xfs_errortag_attr {
> @@ -174,6 +175,7 @@ XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTE
>  XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
>  XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
>  XFS_ERRORTAG_ATTR_RW(larp_leaf_split,	XFS_ERRTAG_LARP_LEAF_SPLIT);
> +XFS_ERRORTAG_ATTR_RW(larp_leaf_to_node,	XFS_ERRTAG_LARP_LEAF_TO_NODE);
>  
>  static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -217,6 +219,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
>  	XFS_ERRORTAG_ATTR_LIST(larp),
>  	XFS_ERRORTAG_ATTR_LIST(larp_leaf_split),
> +	XFS_ERRORTAG_ATTR_LIST(larp_leaf_to_node),
>  	NULL,
>  };
>  
> -- 
> 2.25.1
> 
