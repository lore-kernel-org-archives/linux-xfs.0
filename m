Return-Path: <SRS0=ZMk+=CA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91BA3C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 07:15:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B33E208E4
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Aug 2020 07:15:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pLzTwovo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgHVHPQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Aug 2020 03:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgHVHPO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Aug 2020 03:15:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A171C061573
        for <linux-xfs@vger.kernel.org>; Sat, 22 Aug 2020 00:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=855WXK35ugdOsCr/UScxewaiyoxS9P7QWNhKZ0916jA=; b=pLzTwovo4MHcjAwUf0iIUIdvgb
        EjdlHRddifntf2rUg2PWvO9ahB2QjwR0bfA1D8t+iW0WVVWDeRNDy6zAR7kiBYNVZwH3A4Lcu0AOl
        PxKK8+JubYXGeWuSj5HJKsw9rFJgN+v2OpH/0cmhvO6Ps7tEG0KUvqKYx/DAizdmHkYFbYUOLz4vv
        C6Wu88i9OkmAfkNy3I03HiavyC7LWfxHuDw68IeyD1mgg2mx37O3GbQ8ZZrmityVcvfE87u71fyZ5
        8VH4UlyltKErB9Y9xCdzkNOr5k00marvahkx7Q14mfdzP1yAGVYjPI388pw905a+KdNb9zraHKHL8
        kJz7mslQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9Nk7-0000gy-Vw; Sat, 22 Aug 2020 07:15:12 +0000
Date:   Sat, 22 Aug 2020 08:15:11 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 03/11] xfs: refactor default quota grace period setting
 code
Message-ID: <20200822071511.GC1629@infradead.org>
References: <159797588727.965217.7260803484540460144.stgit@magnolia>
 <159797590685.965217.9321446937142682044.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159797590685.965217.9321446937142682044.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 20, 2020 at 07:11:47PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the code that sets the default quota grace period into a helper
> function so that we can override the ondisk behavior later.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_format.h |   13 +++++++++++++
>  fs/xfs/xfs_dquot.c         |    9 +++++++++
>  fs/xfs/xfs_dquot.h         |    1 +
>  fs/xfs/xfs_ondisk.h        |    2 ++
>  fs/xfs/xfs_qm_syscalls.c   |    4 ++--
>  5 files changed, 27 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index ef36978239ac..e9e6248b35be 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1205,6 +1205,11 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>   * time zero is the Unix epoch, Jan  1 00:00:01 UTC 1970.  An expiration value
>   * of zero means that the quota limit has not been reached, and therefore no
>   * expiration has been set.
> + *
> + * The grace period for each quota type is stored in the root dquot (id = 0)
> + * and is applied to a non-root dquot when it exceeds the soft or hard limits.
> + * The length of quota grace periods are unsigned 32-bit quantities measured in
> + * units of seconds.  A value of zero means to use the default period.
>   */
>  
>  /*
> @@ -1219,6 +1224,14 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>   */
>  #define XFS_DQ_TIMEOUT_MAX	((int64_t)U32_MAX)
>  
> +/*
> + * Default quota grace periods, ranging from zero (use the compiled defaults)
> + * to ~136 years.  These are applied to a non-root dquot that has exceeded
> + * either limit.
> + */
> +#define XFS_DQ_GRACE_MIN	((int64_t)0)
> +#define XFS_DQ_GRACE_MAX	((int64_t)U32_MAX)
> +
>  /*
>   * This is the main portion of the on-disk representation of quota information
>   * for a user.  We pad this with some more expansion room to construct the on
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 2425b1c30d11..ed3fa6ada0d3 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -98,6 +98,15 @@ xfs_qm_adjust_dqlimits(
>  		xfs_dquot_set_prealloc_limits(dq);
>  }
>  
> +/* Set the length of the default grace period. */
> +void
> +xfs_dquot_set_grace_period(
> +	time64_t		*timer,
> +	time64_t		value)
> +{
> +	*timer = clamp_t(time64_t, value, XFS_DQ_GRACE_MIN, XFS_DQ_GRACE_MAX);
> +}

Why not return the value?
