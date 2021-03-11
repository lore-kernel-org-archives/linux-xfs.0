Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B5DC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 01:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71B0D64FC5
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 01:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbhCKBrf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 20:47:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:34770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhCKBrK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 20:47:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98B7C64FB5;
        Thu, 11 Mar 2021 01:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615427230;
        bh=gapGbGa0U8g50TT4IyFIjFRBuZwMK6bPuSImyLpFZvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OgrKd6BxnKeN1woqHDYGgf4YALLcF+PNPP8EgKtSkr0sHkMScqKwP56M9q04qunyq
         Dg01JNQZiu7wsVU2z9JQX2BwRQBtA0HH2oRa1/XJMvRwtQ6kSRlxwshnnh4orJ6c+H
         +8vuY4VvgAw6b9XzGDL9w0zLcYc1is2yPwNgAggVaYssOw0sA9HKgJ7bFwfwqutzgL
         3vr42F5GIKPhPWvkCvlNeuU/EWialzz121oqBAfFp9YHWJ0y/PpYxwWC3KFcpozNl3
         vjJFko4c/c2xjL7QqNr3AOlJIXvcAEQBddghVVUTqFIXPb6r3qBgpI9zRBzxqGS9Ha
         JQoRSE8fjM3Kg==
Date:   Wed, 10 Mar 2021 17:47:09 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 43/45] xfs: avoid cil push lock if possible
Message-ID: <20210311014709.GQ3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-44-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-44-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:41PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because now it hurts when the CIL fills up.
> 
>   - 37.20% __xfs_trans_commit
>       - 35.84% xfs_log_commit_cil
>          - 19.34% _raw_spin_lock
>             - do_raw_spin_lock
>                  19.01% __pv_queued_spin_lock_slowpath
>          - 4.20% xfs_log_ticket_ungrant
>               0.90% xfs_log_space_wake
> 
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 6dcc23829bef..d60c72ad391a 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1115,10 +1115,18 @@ xlog_cil_push_background(
>  	ASSERT(!test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
>  
>  	/*
> -	 * Don't do a background push if we haven't used up all the
> -	 * space available yet.
> +	 * We are done if:
> +	 * - we haven't used up all the space available yet; or
> +	 * - we've already queued up a push; and
> +	 * - we're not over the hard limit; and
> +	 * - nothing has been over the hard limit.

Er... do these last three bullet points correspond to the last three
lines of the if test?  I'm not sure how !waitqueue_active() determines
that nothing has been over the hard limit?  Or for that matter how
comparing push_seq against current_seq tells us if we've queued a
push?

--D

> +	 *
> +	 * If so, we don't need to take the push lock as there's nothing to do.
>  	 */
> -	if (space_used < XLOG_CIL_SPACE_LIMIT(log)) {
> +	if (space_used < XLOG_CIL_SPACE_LIMIT(log) ||
> +	    (cil->xc_push_seq == cil->xc_current_sequence &&
> +	     space_used < XLOG_CIL_BLOCKING_SPACE_LIMIT(log) &&
> +	     !waitqueue_active(&cil->xc_push_wait))) {
>  		up_read(&cil->xc_ctx_lock);
>  		return;
>  	}
> -- 
> 2.28.0
> 
