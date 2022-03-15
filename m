Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0EEFC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Mar 2022 19:36:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351381AbiCOThj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 15:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbiCOThi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 15:37:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53036286F7
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 12:36:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E99CE616F8
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 19:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D14C340E8;
        Tue, 15 Mar 2022 19:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647372985;
        bh=4K9N+bhmZgWVpuaUH28aT4xb7apTOhLbtT1zotwa4Cg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qf10xv0OwbuOHXEfkVM9L/sWWZWw5UCnfTLhiH9CLvWWvQBNofo+/L5zXK2Mkemm2
         6Ssc6VhXdVQVMT1jDJEPbQeKGJu8YKhTc4gfjCFRpl5DJ8SfEphh08U3oac04OULM9
         34z28KpT057cUD3dexWDx57iVvjZPQyOji7AjaHba03AZedcQzl5XuXNIGV26nN6gv
         AMf5TmNsFlqIu+4F67HMnjzQGVOTKMdRcFPV+/LOOi3DCOhPP14hD+KlDCoH/Vfmhk
         FMTSSvJIT/dd1TS+/c0oIWXVrhsl+Dlp74uFBLOp74u7qD10Ye89BuRjwdpEhKoZ9I
         mQS8/M80cV7/Q==
Date:   Tue, 15 Mar 2022 12:36:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: async CIL flushes need pending pushes to be
 made stable
Message-ID: <20220315193624.GH8241@magnolia>
References: <20220315064241.3133751-1-david@fromorbit.com>
 <20220315064241.3133751-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315064241.3133751-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 15, 2022 at 05:42:38PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When the AIL tries to flush the CIL, it relies on the CIL push
> ending up on stable storage without having to wait for and
> manipulate iclog state directly. However, if there is already a
> pending CIL push when the AIL tries to flush the CIL, it won't set
> the cil->xc_push_commit_stable flag and so the CIL push will not
> actively flush the commit record iclog.
> 
> generic/530 when run on a single CPU test VM can trigger this fairly
> reliably. This test exercises unlinked inode recovery, and can
> result in inodes being pinned in memory by ongoing modifications to
> the inode cluster buffer to record unlinked list modifications. As a
> result, the first inode unlinked in a buffer can pin the tail of the
> log whilst the inode cluster buffer is pinned by the current
> checkpoint that has been pushed but isn't on stable storage because
> because the cil->xc_push_commit_stable was not set. This results in
> the log/AIL effectively deadlocking until something triggers the
> commit record iclog to be pushed to stable storage (i.e. the
> periodic log worker calling xfs_log_force()).
> 
> The fix is two-fold - first we should always set the
> cil->xc_push_commit_stable when xlog_cil_flush() is called,
> regardless of whether there is already a pending push or not.
> 
> Second, if the CIL is empty, we should trigger an iclog flush to
> ensure that the iclogs of the last checkpoint have actually been
> submitted to disk as that checkpoint may not have been run under
> stable completion constraints.

Can it ever be the case that the CIL is not empty but the last
checkpoint wasn't committed to disk?  Let's say someone else
commits a transaction after the worker samples xc_push_commit_stable?

IOWs, why does a not-empty CIL mean that the last checkpoint is on disk?

> Reported-and-tested-by: Matthew Wilcox <willy@infradead.org>

MMMM testing. :D

--D

> Fixes: 0020a190cf3e ("xfs: AIL needs asynchronous CIL forcing")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 3d8ebf2a1e55..48b16a5feb27 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1369,18 +1369,27 @@ xlog_cil_push_now(
>  	if (!async)
>  		flush_workqueue(cil->xc_push_wq);
>  
> +	spin_lock(&cil->xc_push_lock);
> +
> +	/*
> +	 * If this is an async flush request, we always need to set the
> +	 * xc_push_commit_stable flag even if something else has already queued
> +	 * a push. The flush caller is asking for the CIL to be on stable
> +	 * storage when the next push completes, so regardless of who has queued
> +	 * the push, the flush requires stable semantics from it.
> +	 */
> +	cil->xc_push_commit_stable = async;
> +
>  	/*
>  	 * If the CIL is empty or we've already pushed the sequence then
> -	 * there's no work we need to do.
> +	 * there's no more work that we need to do.
>  	 */
> -	spin_lock(&cil->xc_push_lock);
>  	if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
>  		spin_unlock(&cil->xc_push_lock);
>  		return;
>  	}
>  
>  	cil->xc_push_seq = push_seq;
> -	cil->xc_push_commit_stable = async;
>  	queue_work(cil->xc_push_wq, &cil->xc_ctx->push_work);
>  	spin_unlock(&cil->xc_push_lock);
>  }
> @@ -1520,6 +1529,13 @@ xlog_cil_flush(
>  
>  	trace_xfs_log_force(log->l_mp, seq, _RET_IP_);
>  	xlog_cil_push_now(log, seq, true);
> +
> +	/*
> +	 * If the CIL is empty, make sure that any previous checkpoint that may
> +	 * still be in an active iclog is pushed to stable storage.
> +	 */
> +	if (list_empty(&log->l_cilp->xc_cil))
> +		xfs_log_force(log->l_mp, 0);
>  }
>  
>  /*
> -- 
> 2.35.1
> 
