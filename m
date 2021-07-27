Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 587BCC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 23:10:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30F7160F90
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 23:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbhG0XK4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 19:10:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232198AbhG0XK4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 19:10:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD9E560249;
        Tue, 27 Jul 2021 23:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627427455;
        bh=PwznqRpjuvcITV9gYMaHGfEvfIOvuHya6/cxf+DFPtk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HCuFPsBiE3bg7ALjTnygQ+bkk1VvzvMbW6vdk1aLDljrui4cpqHzer8q3JNpPCtZT
         hn3pKJlsYzI5FA+ZKuc9tQuVH94iYElJwBM2Jti/dRXYqC1uC0MD2kkifL0mh3qQgJ
         jjVCvNdd7Lv9IPS5o5rHXRNQt1tGCzVqNWLoFulmD9hcq8S5zncb+nSotfD77Wh21B
         ii611CL7F7mzdsT3e4CTEY9GEBMLLlvx7qNKh8YcYdAhsUCjAMcz/HEqfhfNY213ip
         vGnVhWiaj5hd22r2MFs+JyFgStvlbGcPEgUtcB+dDni9ati3AZn2uZ1MT5hgmTuz89
         1Z7uNOMjpNV6A==
Date:   Tue, 27 Jul 2021 16:10:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 12/12] xfs: Error tag to test if v5 bulkstat skips
 inodes with large extent count
Message-ID: <20210727231055.GV559212@magnolia>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
 <20210726114541.24898-13-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726114541.24898-13-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 05:15:41PM +0530, Chandan Babu R wrote:
> This commit adds a new error tag to allow user space tests to check if V5
> bulkstat ioctl skips reporting inodes with large extent count.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Keep in mind that each of these injection knobs costs us 4 bytes per
mount.  No particular objections, but I don't know how urgently we need
to do that to test a corner case...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_errortag.h | 4 +++-
>  fs/xfs/xfs_error.c           | 3 +++
>  fs/xfs/xfs_itable.c          | 9 ++++++++-
>  3 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index f5fa2151e05d..b2c533153737 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -60,7 +60,8 @@
>  #define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
>  #define XFS_ERRTAG_AG_RESV_FAIL				38
>  #define XFS_ERRTAG_SWAPEXT_FINISH_ONE			39
> -#define XFS_ERRTAG_MAX					40
> +#define XFS_ERRTAG_BULKSTAT_REDUCE_MAX_IEXTENTS		40
> +#define XFS_ERRTAG_MAX					41
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -105,5 +106,6 @@
>  #define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
>  #define XFS_RANDOM_AG_RESV_FAIL				1
>  #define XFS_RANDOM_SWAPEXT_FINISH_ONE			1
> +#define XFS_RANDOM_BULKSTAT_REDUCE_MAX_IEXTENTS		1
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index e25b440cbfd3..e2a9446fb025 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -58,6 +58,7 @@ static unsigned int xfs_errortag_random_default[] = {
>  	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
>  	XFS_RANDOM_AG_RESV_FAIL,
>  	XFS_RANDOM_SWAPEXT_FINISH_ONE,
> +	XFS_RANDOM_BULKSTAT_REDUCE_MAX_IEXTENTS,
>  };
>  
>  struct xfs_errortag_attr {
> @@ -172,6 +173,7 @@ XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
>  XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
>  XFS_ERRORTAG_ATTR_RW(ag_resv_fail, XFS_ERRTAG_AG_RESV_FAIL);
>  XFS_ERRORTAG_ATTR_RW(swapext_finish_one, XFS_RANDOM_SWAPEXT_FINISH_ONE);
> +XFS_ERRORTAG_ATTR_RW(bulkstat_reduce_max_iextents, XFS_ERRTAG_BULKSTAT_REDUCE_MAX_IEXTENTS);
>  
>  static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -214,6 +216,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
>  	XFS_ERRORTAG_ATTR_LIST(ag_resv_fail),
>  	XFS_ERRORTAG_ATTR_LIST(swapext_finish_one),
> +	XFS_ERRORTAG_ATTR_LIST(bulkstat_reduce_max_iextents),
>  	NULL,
>  };
>  
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 8493870a0a87..1b252d1cda9d 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -20,6 +20,7 @@
>  #include "xfs_icache.h"
>  #include "xfs_health.h"
>  #include "xfs_trans.h"
> +#include "xfs_errortag.h"
>  
>  /*
>   * Bulk Stat
> @@ -143,7 +144,13 @@ xfs_bulkstat_one_int(
>  
>  	nextents = xfs_ifork_nextents(&ip->i_df);
>  	if (bc->breq->version != XFS_BULKSTAT_VERSION_V6) {
> -		if (nextents > XFS_IFORK_EXTCNT_MAXS32) {
> +		xfs_extnum_t max_nextents = XFS_IFORK_EXTCNT_MAXS32;
> +
> +		if (unlikely(XFS_TEST_ERROR(false, mp,
> +				XFS_ERRTAG_BULKSTAT_REDUCE_MAX_IEXTENTS)))
> +			max_nextents = 10;
> +
> +		if (nextents > max_nextents) {
>  			xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  			xfs_irele(ip);
>  			error = -EINVAL;
> -- 
> 2.30.2
> 
