Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE43C4363D
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 07:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CAB520719
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 07:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725968AbgJBHYU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 03:24:20 -0400
Received: from verein.lst.de ([213.95.11.211]:51342 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbgJBHYT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Oct 2020 03:24:19 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CD04F67357; Fri,  2 Oct 2020 09:24:16 +0200 (CEST)
Date:   Fri, 2 Oct 2020 09:24:16 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de,
        bfoster@redhat.com
Subject: Re: [PATCH v4.2 5/5] xfs: xfs_defer_capture should absorb
 remaining transaction reservation
Message-ID: <20201002072416.GD9900@lst.de>
References: <160140139198.830233.3093053332257853111.stgit@magnolia> <160140142459.830233.7194402837807253154.stgit@magnolia> <20201002042103.GU49547@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002042103.GU49547@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 01, 2020 at 09:21:03PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When xfs_defer_capture extracts the deferred ops and transaction state
> from a transaction, it should record the transaction reservation type
> from the old transaction so that when we continue the dfops chain, we
> still use the same reservation parameters.
> 
> Doing this means that the log item recovery functions get to determine
> the transaction reservation instead of abusing tr_itruncate in yet
> another part of xfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v4.2: save only the log reservation, and hardcode logcount and flags.
> ---
>  fs/xfs/libxfs/xfs_defer.c |    3 +++
>  fs/xfs/libxfs/xfs_defer.h |    3 +++
>  fs/xfs/xfs_log_recover.c  |   17 ++++++++++++++---
>  3 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 10aeae7353ab..e19dc1ced7e6 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -579,6 +579,9 @@ xfs_defer_ops_capture(
>  	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
>  	dfc->dfc_rtxres = tp->t_rtx_res - tp->t_rtx_res_used;
>  
> +	/* Preserve the log reservation size. */
> +	dfc->dfc_logres = tp->t_log_res;
> +
>  	return dfc;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 5c0e59b69ffa..6cde6f0713f7 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -79,6 +79,9 @@ struct xfs_defer_capture {
>  	/* Block reservations for the data and rt devices. */
>  	unsigned int		dfc_blkres;
>  	unsigned int		dfc_rtxres;
> +
> +	/* Log reservation saved from the transaction. */
> +	unsigned int		dfc_logres;

> +		struct xfs_trans_res	resv;
> +
> +		/*
> +		 * Create a new transaction reservation from the captured
> +		 * information.  Set logcount to 1 to force the new transaction
> +		 * to regrant every roll so that we can make forward progress
> +		 * in recovery no matter how full the log might be.
> +		 */
> +		resv.tr_logres = dfc->dfc_logres;
> +		resv.tr_logcount = 1;
> +		resv.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> +
> +		error = xfs_trans_alloc(mp, &resv, dfc->dfc_blkres,
> +				dfc->dfc_rtxres, XFS_TRANS_RESERVE, &tp);

What about just embedding the struct xfs_trans_res into
struct xfs_defer_capture directly?  That probably also means merging
this and the previous patch.
