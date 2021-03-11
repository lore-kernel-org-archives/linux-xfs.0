Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E209C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 01:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4935364FC5
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 01:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbhCKBhN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 20:37:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229790AbhCKBgs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 20:36:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3C0264FC8;
        Thu, 11 Mar 2021 01:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615426608;
        bh=WVTw9bEeckO3hSvluKIjHktjEUHGD3sZ5jVSmjypTWA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N7CmdwBUIZWpakuktgcSNupCRDmPNpHA3TXnVPwnkjiw3azMwQ3490tSlPN9vU4Po
         DRVRLlMQprA73B4VpRe2Wc6vwvzoJ39Njc2b9qI4MizuKS1mhuSOQgLccsxTRKNG9d
         R4yC7D8Q1hosP+co8KMe2Li4XJmiJ+hUiPq2zvhl8InA3uBEOlCz6roW542a2ldU6j
         EIQeq1e1w1rbUZ/Gm3iWmX4VY3bdcBswMsaZv91dinLO+lepXAg+O8dcmXazVxJaVF
         2R9aq9ozD9p6fgqL3d0yzhiGhg6cm4H2ox0B0JDMYxxR0y3nE0TnKTOS5wNpof0GSJ
         UonhDsGmuoqMQ==
Date:   Wed, 10 Mar 2021 17:36:46 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 42/45] xfs: __percpu_counter_compare() inode count debug
 too expensive
Message-ID: <20210311013646.GP3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-43-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-43-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:40PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
>  - 21.92% __xfs_trans_commit
>      - 21.62% xfs_log_commit_cil
> 	- 11.69% xfs_trans_unreserve_and_mod_sb
> 	   - 11.58% __percpu_counter_compare
> 	      - 11.45% __percpu_counter_sum
> 		 - 10.29% _raw_spin_lock_irqsave
> 		    - 10.28% do_raw_spin_lock
> 			 __pv_queued_spin_lock_slowpath
> 
> We debated just getting rid of it last time this came up and
> there was no real objection to removing it. Now it's the biggest
> scalability limitation for debug kernels even on smallish machines,
> so let's just get rid of it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

...unless you want a CONFIG_XFS_DEBUG_SLOW to hide these things behind?

--D

> ---
>  fs/xfs/xfs_trans.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index b20e68279808..637d084c8aa8 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -616,19 +616,12 @@ xfs_trans_unreserve_and_mod_sb(
>  		ASSERT(!error);
>  	}
>  
> -	if (idelta) {
> +	if (idelta)
>  		percpu_counter_add_batch(&mp->m_icount, idelta,
>  					 XFS_ICOUNT_BATCH);
> -		if (idelta < 0)
> -			ASSERT(__percpu_counter_compare(&mp->m_icount, 0,
> -							XFS_ICOUNT_BATCH) >= 0);
> -	}
>  
> -	if (ifreedelta) {
> +	if (ifreedelta)
>  		percpu_counter_add(&mp->m_ifree, ifreedelta);
> -		if (ifreedelta < 0)
> -			ASSERT(percpu_counter_compare(&mp->m_ifree, 0) >= 0);
> -	}
>  
>  	if (rtxdelta == 0 && !(tp->t_flags & XFS_TRANS_SB_DIRTY))
>  		return;
> -- 
> 2.28.0
> 
