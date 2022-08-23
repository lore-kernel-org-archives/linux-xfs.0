Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 725F7C28D13
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Aug 2022 00:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbiHWAdY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Aug 2022 20:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiHWAdX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Aug 2022 20:33:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3785591
        for <linux-xfs@vger.kernel.org>; Mon, 22 Aug 2022 17:33:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2775DB8171E
        for <linux-xfs@vger.kernel.org>; Tue, 23 Aug 2022 00:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA256C433C1;
        Tue, 23 Aug 2022 00:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661214799;
        bh=fy4bvDLt/7Q2ggKWBq/diNh6jPKI7V4mxbKkYiz4BbU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jr6GcY/DBrC+WsR31AjSUyQikgZE6XXpJrsyMbvC/a3pheSmIl4H2gfHnjgJi3dOl
         IsMY8RDIyP83nmtEVXN88703OqtD6duTJvfNcWx05bVHeaGyO643c3bmfFDIWC1s+G
         Do7HVIjWP44tdvd98HIg1e+aUY0G9TvD0TtyTrmAcdJhow1jneB/4MEGn+MEtCmJcB
         HxtJIyVwpBr0tbBjBfMFTOTlAbUnx2uzEAfV3t4p/v0QX2GHPAR2XnU6/LgA2+/5Ju
         x9cagbkJsGcv93yPVM121FOe90OBSUeiwdy1G4JRl1jRktlGondkvJQR5fyD1h23gA
         v0DuTiOe3/Ojg==
Date:   Mon, 22 Aug 2022 17:33:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: ensure log tail is always up to date
Message-ID: <YwQgT1i0x2i+wGF8@magnolia>
References: <20220809230353.3353059-1-david@fromorbit.com>
 <20220809230353.3353059-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809230353.3353059-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 10, 2022 at 09:03:48AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Whenever we write an iclog, we call xlog_assign_tail_lsn() to update
> the current tail before we write it into the iclog header. This
> means we have to take the AIL lock on every iclog write just to
> check if the tail of the log has moved.
> 
> This doesn't avoid races with log tail updates - the log tail could
> move immediately after we assign the tail to the iclog header and
> hence by the time the iclog reaches stable storage the tail LSN has
> moved forward in memory. Hence the log tail LSN in the iclog header
> is really just a point in time snapshot of the current state of the
> AIL.
> 
> With this in mind, if we simply update the in memory log->l_tail_lsn
> every time it changes in the AIL, there is no need to update the in
> memory value when we are writing it into an iclog - it will already
> be up-to-date in memory and checking the AIL again will not change
> this.

This is too subtle for me to understand -- does the codebase
already update l_tail_lsn?  Does this patch make it do that?

--D

> Hence xlog_state_release_iclog() does not need to check the
> AIL to update the tail lsn and can just sample it directly without
> needing to take the AIL lock.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c       |  5 ++---
>  fs/xfs/xfs_trans_ail.c | 17 +++++++++++++++--
>  2 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index c609c188bd8a..042744fe37b7 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -530,7 +530,6 @@ xlog_state_release_iclog(
>  	struct xlog_in_core	*iclog,
>  	struct xlog_ticket	*ticket)
>  {
> -	xfs_lsn_t		tail_lsn;
>  	bool			last_ref;
>  
>  	lockdep_assert_held(&log->l_icloglock);
> @@ -545,8 +544,8 @@ xlog_state_release_iclog(
>  	if ((iclog->ic_state == XLOG_STATE_WANT_SYNC ||
>  	     (iclog->ic_flags & XLOG_ICL_NEED_FUA)) &&
>  	    !iclog->ic_header.h_tail_lsn) {
> -		tail_lsn = xlog_assign_tail_lsn(log->l_mp);
> -		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
> +		iclog->ic_header.h_tail_lsn =
> +				cpu_to_be64(atomic64_read(&log->l_tail_lsn));
>  	}
>  
>  	last_ref = atomic_dec_and_test(&iclog->ic_refcnt);
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index d3dcb4942d6a..5f40509877f7 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -715,6 +715,13 @@ xfs_ail_push_all_sync(
>  	finish_wait(&ailp->ail_empty, &wait);
>  }
>  
> +/*
> + * Callers should pass the the original tail lsn so that we can detect if the
> + * tail has moved as a result of the operation that was performed. If the caller
> + * needs to force a tail LSN update, it should pass NULLCOMMITLSN to bypass the
> + * "did the tail LSN change?" checks. If the caller wants to avoid a tail update
> + * (e.g. it knows the tail did not change) it should pass an @old_lsn of 0.
> + */
>  void
>  xfs_ail_update_finish(
>  	struct xfs_ail		*ailp,
> @@ -799,10 +806,16 @@ xfs_trans_ail_update_bulk(
>  
>  	/*
>  	 * If this is the first insert, wake up the push daemon so it can
> -	 * actively scan for items to push.
> +	 * actively scan for items to push. We also need to do a log tail
> +	 * LSN update to ensure that it is correctly tracked by the log, so
> +	 * set the tail_lsn to NULLCOMMITLSN so that xfs_ail_update_finish()
> +	 * will see that the tail lsn has changed and will update the tail
> +	 * appropriately.
>  	 */
> -	if (!mlip)
> +	if (!mlip) {
>  		wake_up_process(ailp->ail_task);
> +		tail_lsn = NULLCOMMITLSN;
> +	}
>  
>  	xfs_ail_update_finish(ailp, tail_lsn);
>  }
> -- 
> 2.36.1
> 
