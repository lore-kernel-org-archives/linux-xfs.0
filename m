Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D3DC433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 17:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4BB261A17
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 17:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237091AbhCXRSQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 13:18:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237143AbhCXRRp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 13:17:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21AED61A15;
        Wed, 24 Mar 2021 17:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616606265;
        bh=I2rB0wZcooOuQPNoLBEGDtV+iS04jtAYWGCHIJMzu98=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jod0nzwmNxYaakWPFnsyNvrekbUOP8QPxBkX9YqbURClZIAZkfLYDIlZYq8fPw8z4
         3t68Ol655mKLyclFtTN0NBFfFpLuNA+8UI06GaN5JllxGVYQBSbnJLUAiq2hnKA7WN
         V+RLFqROaHBxTGZG0A2MyMWfKkrb3oLtCLiEhpu01gtQDVUAqFc1zWNJu4BLC80JNQ
         XgoDPJNcdabNj/t4qxaG8PWgc2twAcjInieoUrfHin6RF/CMaNEACf6afdylPCm9mV
         cL+Rot1Pn7E8UWSj9Q0XjPo0A8EavOvGFZhTi/UtufH4UcaltQvdopW1H//qLge32m
         le0Zj2+nGGkMg==
Date:   Wed, 24 Mar 2021 10:17:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v9 5/5] xfs: add error injection for per-AG resv failure
Message-ID: <20210324171744.GT22100@magnolia>
References: <20210324010621.2244671-1-hsiangkao@redhat.com>
 <20210324010621.2244671-6-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324010621.2244671-6-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 09:06:21AM +0800, Gao Xiang wrote:
> per-AG resv failure after fixing up freespace is hard to test in an
> effective way, so directly add an error injection path to observe
> such error handling path works as expected.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Looks good to me; can you send the latest version of the xfs_growfs
patches to the list to get the review started for 5.13?

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ag_resv.c  | 6 +++++-
>  fs/xfs/libxfs/xfs_errortag.h | 4 +++-
>  fs/xfs/xfs_error.c           | 3 +++
>  3 files changed, 11 insertions(+), 2 deletions(-)
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
> index 6ca9084b6934..a23a52e643ad 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -58,7 +58,8 @@
>  #define XFS_ERRTAG_BUF_IOERROR				35
>  #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
>  #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
> -#define XFS_ERRTAG_MAX					38
> +#define XFS_ERRTAG_AG_RESV_FAIL				38
> +#define XFS_ERRTAG_MAX					39
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -101,5 +102,6 @@
>  #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
>  #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
>  #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
> +#define XFS_RANDOM_AG_RESV_FAIL				1
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 185b4915b7bf..f70984f3174d 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -56,6 +56,7 @@ static unsigned int xfs_errortag_random_default[] = {
>  	XFS_RANDOM_BUF_IOERROR,
>  	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
>  	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
> +	XFS_RANDOM_AG_RESV_FAIL,
>  };
>  
>  struct xfs_errortag_attr {
> @@ -168,6 +169,7 @@ XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
>  XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
>  XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
>  XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
> +XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
>  
>  static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -208,6 +210,7 @@ static struct attribute *xfs_errortag_attrs[] = {
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
