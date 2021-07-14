Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 164C6C12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1FBA613CA
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhGNXVE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:21:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhGNXVE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 19:21:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 248D76136E;
        Wed, 14 Jul 2021 23:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626304692;
        bh=cxtrzu1KRoBKZ81L3dmO3ObtnUfjC1ScS0o+7N9VgvU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G2bIP+xB7ebW6qc4P1G3X9pktKgpk+9qWaFuuQ27+n3gVdhctqfSxJSpbt4oKYphC
         W3VNf3iRIvFA7gulU5K1QiN2ft6Spi3G4Kke7aXRadcDVLKRayOakhSWlqr+zOUzYn
         50ATlvuZqeCSVMZLavb6u2eyH85OWCfpQ/uX0+ImTNQugQbJZdSCTTZmhAucQMB3WS
         vXutp5CePIUQIr221a0bfrGF4j/jtIZj9RJCzPWFHpholHl70AzIqVwG5KKSWV3UVa
         N9EpKig4AqEiNGvRFZSx1ps/aScYGJcEBWhxLj0AlDEntub1EM7VU9wVh149DQXCdQ
         QAfd1iPqNxJkg==
Date:   Wed, 14 Jul 2021 16:18:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/16] xfs: convert scrub to use mount-based feature
 checks
Message-ID: <20210714231811.GF22402@magnolia>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-13-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714041912.2625692-13-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:19:08PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> THe scrub feature checks are the last place that the superblock
> feature checks are used. Convert them to mount based feature checks.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/scrub/scrub.c | 12 ++++++------
>  fs/xfs/scrub/scrub.h |  2 +-
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index a5b1ea9361b3..57ecbc48bbd5 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -239,21 +239,21 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
>  		.type	= ST_PERAG,
>  		.setup	= xchk_setup_ag_iallocbt,
>  		.scrub	= xchk_finobt,
> -		.has	= xfs_sb_version_hasfinobt,
> +		.has	= xfs_has_finobt,
>  		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_RMAPBT] = {	/* rmapbt */
>  		.type	= ST_PERAG,
>  		.setup	= xchk_setup_ag_rmapbt,
>  		.scrub	= xchk_rmapbt,
> -		.has	= xfs_sb_version_hasrmapbt,
> +		.has	= xfs_has_rmapbt,
>  		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_REFCNTBT] = {	/* refcountbt */
>  		.type	= ST_PERAG,
>  		.setup	= xchk_setup_ag_refcountbt,
>  		.scrub	= xchk_refcountbt,
> -		.has	= xfs_sb_version_hasreflink,
> +		.has	= xfs_has_reflink,
>  		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_INODE] = {	/* inode record */
> @@ -308,14 +308,14 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
>  		.type	= ST_FS,
>  		.setup	= xchk_setup_rt,
>  		.scrub	= xchk_rtbitmap,
> -		.has	= xfs_sb_version_hasrealtime,
> +		.has	= xfs_has_realtime,
>  		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_RTSUM] = {	/* realtime summary */
>  		.type	= ST_FS,
>  		.setup	= xchk_setup_rt,
>  		.scrub	= xchk_rtsummary,
> -		.has	= xfs_sb_version_hasrealtime,
> +		.has	= xfs_has_realtime,
>  		.repair	= xrep_notsupported,
>  	},
>  	[XFS_SCRUB_TYPE_UQUOTA] = {	/* user quota */
> @@ -383,7 +383,7 @@ xchk_validate_inputs(
>  	if (ops->setup == NULL || ops->scrub == NULL)
>  		goto out;
>  	/* Does this fs even support this type of metadata? */
> -	if (ops->has && !ops->has(&mp->m_sb))
> +	if (ops->has && !ops->has(mp))
>  		goto out;
>  
>  	error = -EINVAL;
> diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
> index 08a483cb46e2..b8e7ccc5e6c3 100644
> --- a/fs/xfs/scrub/scrub.h
> +++ b/fs/xfs/scrub/scrub.h
> @@ -27,7 +27,7 @@ struct xchk_meta_ops {
>  	int		(*repair)(struct xfs_scrub *);
>  
>  	/* Decide if we even have this piece of metadata. */
> -	bool		(*has)(struct xfs_sb *);
> +	bool		(*has)(struct xfs_mount *);
>  
>  	/* type describing required/allowed inputs */
>  	enum xchk_type	type;
> -- 
> 2.31.1
> 
