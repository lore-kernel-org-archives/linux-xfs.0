Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8660BC4707F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 19:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 694CB6135F
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 19:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhE0TTv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 15:19:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229791AbhE0TTu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 15:19:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D8316135F;
        Thu, 27 May 2021 19:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622143097;
        bh=ltPk0EIauO1fhgGTRhZc2UOqBK8oat99PAjIZkqjbYM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vLWoQGg5KgKlvzIioBSm9tD8ideYHuVHLjJp6gMF3CYzIak90+ZLvbKP0f2tSUCsu
         oV/wi+oHMAuOIKIUAIlfT5DHhdMn0RinjMMVMu3iU41fJuYl7Z1ukhhpwF+gBwMI3x
         4ne9vYzOsWCWJi26VFlRdg40Qh9hfS/++fqMm/nMF4175pgdZoxK654bVHw8AhVP4n
         y7GW6dI2zIkFjMXJl4e5KgedemS9a/hBS7emN8CFbKRNuY+2Tk5Htdyotj377ENS2b
         HZrwU390/nGAeTpjo2p2KYFl9ztge3IJRxqP3V5Pkx+Bsm4NL/VvN7nVuqvUdHCR8i
         clrndOZM0/uRA==
Date:   Thu, 27 May 2021 12:18:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 37/39] xfs: avoid cil push lock if possible
Message-ID: <20210527191816.GO2402049@locust>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-38-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519121317.585244-38-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 10:13:15PM +1000, Dave Chinner wrote:
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

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_cil.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index cfd3128399f6..672cbaa4606c 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1125,10 +1125,18 @@ xlog_cil_push_background(
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
> 2.31.1
> 
