Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC19C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 16:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 631A461247
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 16:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbhKKQHw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Nov 2021 11:07:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233128AbhKKQHw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Nov 2021 11:07:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C177B60EE4;
        Thu, 11 Nov 2021 16:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636646702;
        bh=3YV2Gy2KvB/zga8kpNX1A+766zYjU5jFIW4/pTnZ5nU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eeWFEBjG/DDQ26xb6dHgzPFt+6s0HPMzjspNfMMg9LmoJ0y8n/665ptwsSNc6IjPc
         LBo/UdYmiHMzvehE2WStutxDmKGKEw5kqofkLdiyzILZ13emDGNm/PRs8D7nfwrBWO
         hX97nk2X/LXGHYtZCC7Q/jNFiheCH9FMGdL7LpLR87emhdR2LPNa8HDh1mbyf+t3fb
         F3SxZ4XI1Rh3FexuTDhl3rdeYr+XIIzDW95j/4lboE7KUt4y2PF7iw6eUUyUK7Ivy2
         gNearOjlTU5YfPrMP+fvjRzpJphvVI6LqjqA0Y0yrIwUJxGDTcJJ6hSWpVyC1QAu/4
         Llz0sjgLhAzDw==
Date:   Thu, 11 Nov 2021 08:05:02 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] xfs: add leaf split error tag
Message-ID: <20211111160502.GB24307@magnolia>
References: <20211111001716.77336-1-catherine.hoang@oracle.com>
 <20211111001716.77336-2-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111001716.77336-2-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 11, 2021 at 12:17:15AM +0000, Catherine Hoang wrote:
> Add an error tag on xfs_da3_split to test log attribute recovery
> and replay.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 6 ++++++
>  fs/xfs/libxfs/xfs_errortag.h | 4 +++-
>  fs/xfs/xfs_error.c           | 3 +++
>  3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index dd7a2dbce1d1..000101783648 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -22,6 +22,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_log.h"
> +#include "xfs_errortag.h"
>  
>  /*
>   * xfs_da_btree.c
> @@ -482,6 +483,11 @@ xfs_da3_split(
>  
>  	trace_xfs_da_split(state->args);
>  
> +	if (XFS_TEST_ERROR(false, state->mp, XFS_ERRTAG_LEAF_SPLIT)) {
> +		error = -EIO;
> +		return error;

Nit:

if (XFS_TEST_ERROR(...))
	return -EIO;

--D

> +	}
> +
>  	/*
>  	 * Walk back up the tree splitting/inserting/adjusting as necessary.
>  	 * If we need to insert and there isn't room, split the node, then
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index c15d2340220c..31aeeb94dd5b 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -60,7 +60,8 @@
>  #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
>  #define XFS_ERRTAG_AG_RESV_FAIL				38
>  #define XFS_ERRTAG_LARP					39
> -#define XFS_ERRTAG_MAX					40
> +#define XFS_ERRTAG_LEAF_SPLIT				40
> +#define XFS_ERRTAG_MAX					41
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -105,5 +106,6 @@
>  #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
>  #define XFS_RANDOM_AG_RESV_FAIL				1
>  #define XFS_RANDOM_LARP					1
> +#define XFS_RANDOM_LEAF_SPLIT				1
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index d4b2256ba00b..732cb66236c1 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -58,6 +58,7 @@ static unsigned int xfs_errortag_random_default[] = {
>  	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
>  	XFS_RANDOM_AG_RESV_FAIL,
>  	XFS_RANDOM_LARP,
> +	XFS_RANDOM_LEAF_SPLIT,
>  };
>  
>  struct xfs_errortag_attr {
> @@ -172,6 +173,7 @@ XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
>  XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
>  XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
>  XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
> +XFS_ERRORTAG_ATTR_RW(leaf_split,	XFS_ERRTAG_LEAF_SPLIT);
>  
>  static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -214,6 +216,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
>  	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
>  	XFS_ERRORTAG_ATTR_LIST(larp),
> +	XFS_ERRORTAG_ATTR_LIST(leaf_split),
>  	NULL,
>  };
>  
> -- 
> 2.25.1
> 
