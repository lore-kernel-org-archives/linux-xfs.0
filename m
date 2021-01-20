Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C99E4C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 19:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82F4F2342C
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jan 2021 19:28:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392060AbhATT1I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 14:27:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:60612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392384AbhATT03 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Jan 2021 14:26:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2661233FE;
        Wed, 20 Jan 2021 19:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611170747;
        bh=gzBfFSlYPny3Wwewe9fvw5T7+lztEPlz37lBH996JHY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nS9MMrqlder4GgzCh3cKTDQYLLGalfxVPgIABdsQxyIvy3aqaiGE+BbHXP+EltzN1
         bwKIof4ZQOyPryDWKjRNvPqWAESci1pEipF/+731AMGta+wdetp4S2eqyWutXn7Hgk
         N7pcKJRBZhoK8yDrT1CqggtyGKe6TL5Rh3+XB4px4XWxpHYWB9ZxSkpZOzKOs/mT8L
         EH13yi7i6YpzrrsaT/RPxzjQGgnb+kEHtrPlxGFs9AtGLjCTWPdO+c13alu410k2xc
         VvD2OZU/9/lNcF9YzK9MLBCwBBXnhe4xT/Pru6A2XgVnn3Za2BNl3WO+RIYUP2PbgL
         mJi7RiWTh48jw==
Date:   Wed, 20 Jan 2021 11:25:47 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 5/5] xfs: add error injection for per-AG resv failure
 when shrinkfs
Message-ID: <20210120192547.GM3134581@magnolia>
References: <20210118083700.2384277-1-hsiangkao@redhat.com>
 <20210118083700.2384277-6-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118083700.2384277-6-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 04:37:00PM +0800, Gao Xiang wrote:
> per-AG resv failure after fixing up freespace is hard to test in an
> effective way, so directly add an error injection path to observe
> such error handling path works as expected.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Generally seems fine to me...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ag.c       | 5 +++++
>  fs/xfs/libxfs/xfs_errortag.h | 2 ++
>  fs/xfs/xfs_error.c           | 2 ++
>  3 files changed, 9 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 04a7c9b20470..65e8e07f179b 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -23,6 +23,7 @@
>  #include "xfs_ag_resv.h"
>  #include "xfs_health.h"
>  #include "xfs_error.h"
> +#include "xfs_errortag.h"
>  #include "xfs_bmap.h"
>  
>  static int
> @@ -552,6 +553,10 @@ xfs_ag_shrink_space(
>  	be32_add_cpu(&agf->agf_length, -len);
>  
>  	err2 = xfs_ag_resv_init(agibp->b_pag, tp);
> +
> +	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_SHRINKFS_AG_RESV_FAIL))
> +		err2 = -ENOSPC;
> +
>  	if (err2) {
>  		be32_add_cpu(&agi->agi_length, len);
>  		be32_add_cpu(&agf->agf_length, len);
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 53b305dea381..89da08a451cf 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -40,6 +40,8 @@
>  #define XFS_ERRTAG_REFCOUNT_FINISH_ONE			25
>  #define XFS_ERRTAG_BMAP_FINISH_ONE			26
>  #define XFS_ERRTAG_AG_RESV_CRITICAL			27
> +#define XFS_ERRTAG_SHRINKFS_AG_RESV_FAIL		28
> +
>  /*
>   * DEBUG mode instrumentation to test and/or trigger delayed allocation
>   * block killing in the event of failed writes. When enabled, all
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 7f6e20899473..c864451ba7d0 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -164,6 +164,7 @@ XFS_ERRORTAG_ATTR_RW(force_repair,	XFS_ERRTAG_FORCE_SCRUB_REPAIR);
>  XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
>  XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
>  XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
> +XFS_ERRORTAG_ATTR_RW(shrinkfs_ag_resv_fail, XFS_ERRTAG_SHRINKFS_AG_RESV_FAIL);
>  
>  static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(noerror),
> @@ -202,6 +203,7 @@ static struct attribute *xfs_errortag_attrs[] = {
>  	XFS_ERRORTAG_ATTR_LIST(bad_summary),
>  	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
>  	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
> +	XFS_ERRORTAG_ATTR_LIST(shrinkfs_ag_resv_fail),
>  	NULL,
>  };
>  
> -- 
> 2.27.0
> 
