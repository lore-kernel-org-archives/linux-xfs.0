Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C88C43619
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0A2564F56
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353109AbhCDASI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:18:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:34486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1579511AbhCCSbZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 13:31:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ED0B64EBD;
        Wed,  3 Mar 2021 18:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614796243;
        bh=F0e3L2Wm3uQfA6XE/nNAtnKnAk5UnNpxLpwHgvmK4gs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qz1R6/NU/g6RF/rEGIgBv9g5bx10v6GQIRRUzvGcA9hJXYGRNYz1mN118r6ErDwf3
         Ppeenpz6TByfv2otCTHUOAyVRlvu+/RtvpK6zbiQ1FXyOmqIV02HdEp5JEgsza3h06
         XOSTsRfHhsV+X2C4mqTl5sRNco8nTS5bhOG9GjZKbyXphzt+DKxwbzk1CR/iYU76tU
         QPACdYouqFiuFPt8QSX6JS/L/ejAqKnh2oXrL5IhxrSYFrdocBd5OXcv/PVMHVezMk
         4i64JCDjV//dsozlOZ/yeVYgdwVdwXoO3QceVE+Cz1DQ+QRtYzSkOVhXj2baOjdlOR
         Nq9+2X6WbadFQ==
Date:   Wed, 3 Mar 2021 10:30:42 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v7 5/5] xfs: add error injection for per-AG resv failure
Message-ID: <20210303183042.GD3419940@magnolia>
References: <20210302024816.2525095-1-hsiangkao@redhat.com>
 <20210302024816.2525095-6-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302024816.2525095-6-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 10:48:16AM +0800, Gao Xiang wrote:
> per-AG resv failure after fixing up freespace is hard to test in an
> effective way, so directly add an error injection path to observe
> such error handling path works as expected.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag_resv.c  | 6 +++++-
>  fs/xfs/libxfs/xfs_errortag.h | 4 +++-
>  fs/xfs/xfs_error.c           | 2 ++
>  3 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index fdfe6dc0d307..6c5f8d10589c 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -211,7 +211,11 @@ __xfs_ag_resv_init(
>  		ASSERT(0);
>  		return -EINVAL;
>  	}
> -	error = xfs_mod_fdblocks(mp, -(int64_t)hidden_space, true);
> +
> +	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_AG_RESV_FAIL))
> +		error = -ENOSPC;
> +	else
> +		error = xfs_mod_fdblocks(mp, -(int64_t)hidden_space, true);
>  	if (error) {
>  		trace_xfs_ag_resv_init_error(pag->pag_mount, pag->pag_agno,
>  				error, _RET_IP_);
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 6ca9084b6934..b433ef735217 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -40,6 +40,7 @@
>  #define XFS_ERRTAG_REFCOUNT_FINISH_ONE			25
>  #define XFS_ERRTAG_BMAP_FINISH_ONE			26
>  #define XFS_ERRTAG_AG_RESV_CRITICAL			27
> +

Extra space?

>  /*
>   * DEBUG mode instrumentation to test and/or trigger delayed allocation
>   * block killing in the event of failed writes. When enabled, all
> @@ -58,7 +59,8 @@
>  #define XFS_ERRTAG_BUF_IOERROR				35
>  #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
>  #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
> -#define XFS_ERRTAG_MAX					38
> +#define XFS_ERRTAG_AG_RESV_FAIL				38
> +#define XFS_ERRTAG_MAX					39
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.

This needs to define XFS_RANDOM_AG_RESV_FAIL and put it in
xfs_errortag_random_default in xfs_error.c to avoid running off the end
of the array.

Also... that _default array /really/ needs to have a BUILD_BUG_ON
somewhere to scream loudly if it isn't XFS_ERRTAG_MAX elements long.

--D

> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 185b4915b7bf..5192a7063d95 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -168,6 +168,7 @@ XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
>  XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
>  XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
>  XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
> +XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
>  
>  static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -208,6 +209,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
>  	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
>  	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
> +	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
>  	NULL,
>  };
>  
> -- 
> 2.27.0
> 
