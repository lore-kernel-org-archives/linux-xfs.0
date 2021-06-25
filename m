Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E459C2B9F4
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 20:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F1C76195F
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 20:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhFYVAA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Jun 2021 17:00:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229573AbhFYU76 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Jun 2021 16:59:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1CE46195F;
        Fri, 25 Jun 2021 20:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624654656;
        bh=cIIz1MNurWDPyUeZuOLQmVw+q1ML8Y+r9U3KxoKvL98=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dgZbSHw9hOtz5rb6wTIWIe7yD8qXuOIZNeBQBCD6Vl1RzFYc5De2kqTLbYL6IW7Y7
         ST8n3NxGd/nXNKamojR58GMyPH22DBDFggYA74XRA4+OtwU0oUj9H6dWxRZaKgEFRK
         TqAvSJKhJ28Fxe61sD2pq2HjIQucH0zmVZzM9I+vF5WL2Mpe0kjSYjH7iecH+7dnay
         MENKEDgGmdsO07nx4qtQNfmW7gMcWrgf/g4I0drgxr1WAHYFQ6cuMqWZSVvUDzhlWa
         Z/ffvQg3rOvC3ZHno5he+jKOeImVOfPMSWsHaVPRq1F9DuAJ9JXIvJUSlukxrObKzn
         CUMu6BxeCdUpw==
Date:   Fri, 25 Jun 2021 13:57:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: remove callback dequeue loop from
 xlog_state_do_iclog_callbacks
Message-ID: <20210625205736.GC13784@locust>
References: <20210622040604.1290539-1-david@fromorbit.com>
 <20210622040604.1290539-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622040604.1290539-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 22, 2021 at 02:06:02PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If we are processing callbacks on an iclog, nothing can be
> concurrently adding callbacks to the loop. We only add callbacks to
> the iclog when they are in ACTIVE or WANT_SYNC state, and we
> explicitly do not add callbacks if the iclog is already in IOERROR
> state.
> 
> The only way to have a dequeue racing with an enqueue is to be
> processing a shutdown without a direct reference to an iclog in
> ACTIVE or WANT_SYNC state. As the enqueue avoids this race
> condition, we only ever need a single dequeue operation in
> xlog_state_do_iclog_callbacks(). Hence we can remove the loop.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Makes sense...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index bb4390942275..05b00fa4d661 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2774,19 +2774,15 @@ xlog_state_do_iclog_callbacks(
>  	struct xlog		*log,
>  	struct xlog_in_core	*iclog)
>  {
> -	trace_xlog_iclog_callbacks_start(iclog, _RET_IP_);
> -	spin_lock(&iclog->ic_callback_lock);
> -	while (!list_empty(&iclog->ic_callbacks)) {
> -		LIST_HEAD(tmp);
> +	LIST_HEAD(tmp);
>  
> -		list_splice_init(&iclog->ic_callbacks, &tmp);
> -
> -		spin_unlock(&iclog->ic_callback_lock);
> -		xlog_cil_process_committed(&tmp);
> -		spin_lock(&iclog->ic_callback_lock);
> -	}
> +	trace_xlog_iclog_callbacks_start(iclog, _RET_IP_);
>  
> +	spin_lock(&iclog->ic_callback_lock);
> +	list_splice_init(&iclog->ic_callbacks, &tmp);
>  	spin_unlock(&iclog->ic_callback_lock);
> +
> +	xlog_cil_process_committed(&tmp);
>  	trace_xlog_iclog_callbacks_done(iclog, _RET_IP_);
>  }
>  
> -- 
> 2.31.1
> 
