Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F78C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jan 2022 04:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351512AbiASEsI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jan 2022 23:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346654AbiASEsI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jan 2022 23:48:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDFDC061574
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jan 2022 20:48:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF673615B3
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 04:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30679C004E1;
        Wed, 19 Jan 2022 04:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642567680;
        bh=Z21ClwqDAJqGabVc2db7UQjXtCiY/r1ttPsYMS/eYZU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JVWuSxDUnMx6uvJaPOv9MU2GfbFazEvT+W5uvkexYnTnZnYS/mfmfuSP+Xp14OxJg
         ntBU/g5jL1tpbS9HuK6/QC0YnBtgIf71Gim8Lq3NRoIftEDuvyV1i6I8u5dr/bYuXI
         2HzdWzQuQzeUndsm6oLBkFICAP1rk81wsxaKJW3gJSaVz5JtQmIRvzVoBnuAAQaQTh
         vAEjS41BD1yfZ+qZHIoRlCuD+ZjBePMB0K5bQcHcZ5/VInkiQ8kGPEbo15tW1++lpm
         PvMP1UOlZ2g1umtv0nOL7iqNhPN6n3u1chdBCdvyhCXcuEqV3RgboEvAShJ1RQJTT6
         PzozhWtLlRBjw==
Date:   Tue, 18 Jan 2022 20:47:59 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/2] xfs: add leaf split error tag
Message-ID: <20220119044759.GF13540@magnolia>
References: <20220110212454.359752-1-catherine.hoang@oracle.com>
 <20220110212454.359752-2-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110212454.359752-2-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 10, 2022 at 09:24:53PM +0000, Catherine Hoang wrote:
> Add an error tag on xfs_da3_split to test log attribute recovery
> and replay.
> 
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_da_btree.c | 5 +++++
>  fs/xfs/libxfs/xfs_errortag.h | 4 +++-
>  fs/xfs/xfs_error.c           | 3 +++
>  3 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index dd7a2dbce1d1..258a5fef64b2 100644
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
> @@ -482,6 +483,10 @@ xfs_da3_split(
>  
>  	trace_xfs_da_split(state->args);
>  
> +	if (XFS_TEST_ERROR(false, state->mp, XFS_ERRTAG_LARP_LEAF_SPLIT)) {

This error injection knob is in the middle of the dabtree code, so it
really ought to be namespaced _DA_ and not _LARP_:

XFS_ERRTAG_DA_LEAF_SPLIT

A bit of background: in XFS, directories and extended file attributes
both start their lives as arrays of variable length records that map a
name to some sort of binary data.  Directory entries map a human-
readable bytestring to an inode number, and xattrs map a namespaced
human-readable bytestring to a blob of binary data.

To speed up lookups by name, both structures support adding a btree
index that maps the human-readable name to a hash value, then maps the
hash value(s) to positions within the array.  Within the xfs codebase,
that btree is called the "dabtree" to distinguish it from xfs_btree,
which is a totally different animal.

Hence, any error injection knobs touching xfs_da* functions really
should be namespaced _DA_ to match.

(And for everyone else following along at home, "LARP" refers to Logging
extended Attributes that are Replayable on Purpose or something like
that.)

> +		return -EIO;
> +	}

Nit: don't need braces for a single-line if body.

Other than those two things, this looks good to me.

--D

> +
>  	/*
>  	 * Walk back up the tree splitting/inserting/adjusting as necessary.
>  	 * If we need to insert and there isn't room, split the node, then
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index c15d2340220c..970f3a3f3750 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -60,7 +60,8 @@
>  #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
>  #define XFS_ERRTAG_AG_RESV_FAIL				38
>  #define XFS_ERRTAG_LARP					39
> -#define XFS_ERRTAG_MAX					40
> +#define XFS_ERRTAG_LARP_LEAF_SPLIT			40
> +#define XFS_ERRTAG_MAX					41
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -105,5 +106,6 @@
>  #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
>  #define XFS_RANDOM_AG_RESV_FAIL				1
>  #define XFS_RANDOM_LARP					1
> +#define XFS_RANDOM_LARP_LEAF_SPLIT			1
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index d4b2256ba00b..9cb6743a5ae3 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -58,6 +58,7 @@ static unsigned int xfs_errortag_random_default[] = {
>  	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
>  	XFS_RANDOM_AG_RESV_FAIL,
>  	XFS_RANDOM_LARP,
> +	XFS_RANDOM_LARP_LEAF_SPLIT,
>  };
>  
>  struct xfs_errortag_attr {
> @@ -172,6 +173,7 @@ XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
>  XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
>  XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
>  XFS_ERRORTAG_ATTR_RW(larp,		XFS_ERRTAG_LARP);
> +XFS_ERRORTAG_ATTR_RW(larp_leaf_split,	XFS_ERRTAG_LARP_LEAF_SPLIT);
>  
>  static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -214,6 +216,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
>  	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
>  	XFS_ERRORTAG_ATTR_LIST(larp),
> +	XFS_ERRORTAG_ATTR_LIST(larp_leaf_split),
>  	NULL,
>  };
>  
> -- 
> 2.25.1
> 
