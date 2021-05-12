Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B10C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 22:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0869D610A7
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 22:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344036AbhELWnn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 18:43:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348801AbhELWKW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 May 2021 18:10:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE12061406;
        Wed, 12 May 2021 22:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620857347;
        bh=ZYu4BF8/+3SxAus/6PjuZT00260fpH82dM8HoD70x8c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KrydeH4Qpsr6hr8bgWgmqyN0MMPsQfOqHgr/LvGBsktyRel8L11n7xPoZLcU5XxgK
         rPUjWZAUrLdaR4T5P+CFDeYD+rraaI148AhUC4u/fuua0M18k1swgA30WmF6eTF6qc
         g7opjRpJ29YVPpEARVYykYp2BM5z7yN4mBZ9g02TXaO8BY82UbzfnfpovaZtLeM2CK
         3EsmCS08bFmR4UaoVlxZeiHUZR5pfVPWQ20yXMx9nNcRf0u/4Y/zkC3EdrQLyjCmxv
         M+k2jO13H8Ez6jyvoPE08vS81yubnk3aT1PyHLsSvTvhcXdh6Auvt0VFJFcGBHktRv
         pREe1SMCvcLEw==
Date:   Wed, 12 May 2021 15:09:05 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/22] xfs: convert secondary superblock walk to use
 perags
Message-ID: <20210512220905.GC8582@magnolia>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506072054.271157-8-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 05:20:39PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Clean up the last external manual AG walk.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Simple enough conversion I don't mind RVBing before we settle the exact
iterator idioms...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_sb.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index cbcfce8cebf1..7d4c238540d4 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -25,6 +25,7 @@
>  #include "xfs_refcount_btree.h"
>  #include "xfs_da_format.h"
>  #include "xfs_health.h"
> +#include "xfs_ag.h"
>  
>  /*
>   * Physical superblock buffer manipulations. Shared with libxfs in userspace.
> @@ -856,17 +857,18 @@ int
>  xfs_update_secondary_sbs(
>  	struct xfs_mount	*mp)
>  {
> -	xfs_agnumber_t		agno;
> +	struct xfs_perag	*pag;
> +	xfs_agnumber_t		agno = 1;
>  	int			saved_error = 0;
>  	int			error = 0;
>  	LIST_HEAD		(buffer_list);
>  
>  	/* update secondary superblocks. */
> -	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
> +	for_each_perag_from(mp, agno, pag) {
>  		struct xfs_buf		*bp;
>  
>  		error = xfs_buf_get(mp->m_ddev_targp,
> -				 XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
> +				 XFS_AG_DADDR(mp, pag->pag_agno, XFS_SB_DADDR),
>  				 XFS_FSS_TO_BB(mp, 1), &bp);
>  		/*
>  		 * If we get an error reading or writing alternate superblocks,
> @@ -878,7 +880,7 @@ xfs_update_secondary_sbs(
>  		if (error) {
>  			xfs_warn(mp,
>  		"error allocating secondary superblock for ag %d",
> -				agno);
> +				pag->pag_agno);
>  			if (!saved_error)
>  				saved_error = error;
>  			continue;
> @@ -899,7 +901,7 @@ xfs_update_secondary_sbs(
>  		if (error) {
>  			xfs_warn(mp,
>  		"write error %d updating a secondary superblock near ag %d",
> -				error, agno);
> +				error, pag->pag_agno);
>  			if (!saved_error)
>  				saved_error = error;
>  			continue;
> -- 
> 2.31.1
> 
