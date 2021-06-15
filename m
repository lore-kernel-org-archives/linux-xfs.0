Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7775C48BDF
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Jun 2021 16:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF144616E9
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Jun 2021 16:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhFOQVe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Jun 2021 12:21:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230450AbhFOQV0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Jun 2021 12:21:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E32B616EA;
        Tue, 15 Jun 2021 16:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623773962;
        bh=QAMJ2mAwUxvPNsJ5yiyHppBLEhPPp9OczV4LpsCXCgc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=deKOdVhkvkUYq1D3ePsTBDE9YV4w9itsbkI3X2FyGdlsUHsXGsjnhReFxMqTC3gIw
         7Onz3H5CxLWm5NfHBP+yjChHdbLfFWzRKxoN9yfi+YYaRL8VzSWqJIIZI701G/z3aP
         f8bqLjZcgccYNUSgHByd8awj1UnpXiMjlIDZWAnTJbnZOJX4M+3SlIip9PW6s7ZYyt
         qgcq+K9cyOIeewgZWCbzxZJ2cmjOzPPJL2mwQvb3UTpoO/8+2XP7RPL+1Qk0aIuJ/w
         DNdqyhzwUnuHa7mMuJGCpW3spzbi5zUIVw2Bx7OwK2RC++Nv+e9RGysfNy3gKHI61I
         YPqTNlpqMPQsQ==
Date:   Tue, 15 Jun 2021 09:19:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: don't wait on future iclogs when pushing the CIL
Message-ID: <20210615161921.GC158209@locust>
References: <20210615064658.854029-1-david@fromorbit.com>
 <20210615064658.854029-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615064658.854029-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 15, 2021 at 04:46:58PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The iclogbuf ring attached to the struct xlog is circular, hence the
> first and last iclogs in the ring can only be determined by
> comparing them against the log->l_iclog pointer.
> 
> In xfs_cil_push_work(), we want to wait on previous iclogs that were
> issued so that we can flush them to stable storage with the commit
> record write, and it simply waits on the previous iclog in the ring.
> This, however, leads to CIL push hangs in generic/019 like so:
> 
> task:kworker/u33:0   state:D stack:12680 pid:    7 ppid:     2 flags:0x00004000
> Workqueue: xfs-cil/pmem1 xlog_cil_push_work
> Call Trace:
>  __schedule+0x30b/0x9f0
>  schedule+0x68/0xe0
>  xlog_wait_on_iclog+0x121/0x190
>  ? wake_up_q+0xa0/0xa0
>  xlog_cil_push_work+0x994/0xa10
>  ? _raw_spin_lock+0x15/0x20
>  ? xfs_swap_extents+0x920/0x920
>  process_one_work+0x1ab/0x390
>  worker_thread+0x56/0x3d0
>  ? rescuer_thread+0x3c0/0x3c0
>  kthread+0x14d/0x170
>  ? __kthread_bind_mask+0x70/0x70
>  ret_from_fork+0x1f/0x30
> 
> With other threads blocking in either xlog_state_get_iclog_space()
> waiting for iclog space or xlog_grant_head_wait() waiting for log
> reservation space.
> 
> The problem here is that the previous iclog on the ring might
> actually be a future iclog. That is, if log->l_iclog points at
> commit_iclog, commit_iclog is the first (oldest) iclog in the ring
> and there are no previous iclogs pending as they have all completed
> their IO and been activated again. IOWs, commit_iclog->ic_prev
> points to an iclog that will be written in the future, not one that
> has been written in the past.
> 
> Hence, in this case, waiting on the ->ic_prev iclog is incorrect
> behaviour, and depending on the state of the future iclog, we can
> end up with a circular ABA wait cycle and we hang.
> 
> Fix this by only waiting on the previous iclog when the commit_iclog
> is not the oldest iclog in the ring.
> 
> Fixes: 5fd9256ce156 ("xfs: separate CIL commit record IO")
> Reported-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 705619e9dab4..398f00cf9cbf 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1075,15 +1075,21 @@ xlog_cil_push_work(
>  	ticket = ctx->ticket;
>  
>  	/*
> -	 * If the checkpoint spans multiple iclogs, wait for all previous
> -	 * iclogs to complete before we submit the commit_iclog. In this case,
> -	 * the commit_iclog write needs to issue a pre-flush so that the
> -	 * ordering is correctly preserved down to stable storage.
> +	 * If the checkpoint spans multiple iclogs, wait for all previous iclogs
> +	 * to complete before we submit the commit_iclog. If the commit iclog is
> +	 * at the head of the iclog ring, then all other iclogs have completed
> +	 * and are waiting on this one and hence we don't need to wait.
> +	 *
> +	 * Regardless of whether we need to wait or not, the the commit_iclog
> +	 * write needs to issue a pre-flush so that the ordering for this
> +	 * checkpoint is correctly preserved down to stable storage.
>  	 */
>  	spin_lock(&log->l_icloglock);
>  	if (ctx->start_lsn != commit_lsn) {
> -		xlog_wait_on_iclog(commit_iclog->ic_prev);
> -		spin_lock(&log->l_icloglock);
> +		if (commit_iclog != log->l_iclog) {
> +			xlog_wait_on_iclog(commit_iclog->ic_prev);
> +			spin_lock(&log->l_icloglock);
> +		}

I'm confused.  How can you tell that we need to wait for
commit_iclog->ic_prev to be written out by comparing commit_iclog to
log->l_iclog?  Can't you determine this by checking ic_prev for DIRTY
state?

--D


>  		commit_iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
>  	}
>  
> -- 
> 2.31.1
> 
