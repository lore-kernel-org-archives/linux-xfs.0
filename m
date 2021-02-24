Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5262DC433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 20:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2306464E7A
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 20:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbhBXUfM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:35:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:41020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229598AbhBXUfM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Feb 2021 15:35:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BEB164E09;
        Wed, 24 Feb 2021 20:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614198870;
        bh=KZSJrlYdeLt670eKrZWq/34MOFY51vCG5O3X3NNWPHE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ajti0mURRk+TIeyWx9DZtw086SvbQuCVwS4jU3hodm1ovsvc03D6iIqNYtbaVT0hz
         oc3Ngv6NjdekWNwH58Omwtxvklw06uFXehTU2T70GEeM60JDTYOxKkAYHxUSJc64FZ
         UaDh/JhxADVAMhwWt1QKcMu9u4Bk9GktfBxmgzlHfi64qZ8MhicF748o2Gtrqsx3xW
         ELP4MswktzQnvkIV3Vk9GwEfDJonUko4XywkuJatee81TAQOcZDDAhdvRE5QD/RGMM
         TTy6Duz+cnNpxe7XhA0coF/mIhj+rnbLluZjWq7QbYMpYG+D7Fpy4hk7Vi/Tm5RcxV
         WdEICtvdbgAvw==
Date:   Wed, 24 Feb 2021 12:34:29 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: separate CIL commit record IO
Message-ID: <20210224203429.GR7272@magnolia>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223033442.3267258-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 02:34:36PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To allow for iclog IO device cache flush behaviour to be optimised,
> we first need to separate out the commit record iclog IO from the
> rest of the checkpoint so we can wait for the checkpoint IO to
> complete before we issue the commit record.
> 
> This separation is only necessary if the commit record is being
> written into a different iclog to the start of the checkpoint as the
> upcoming cache flushing changes requires completion ordering against
> the other iclogs submitted by the checkpoint.
> 
> If the entire checkpoint and commit is in the one iclog, then they
> are both covered by the one set of cache flush primitives on the
> iclog and hence there is no need to separate them for ordering.
> 
> Otherwise, we need to wait for all the previous iclogs to complete
> so they are ordered correctly and made stable by the REQ_PREFLUSH
> that the commit record iclog IO issues. This guarantees that if a
> reader sees the commit record in the journal, they will also see the
> entire checkpoint that commit record closes off.
> 
> This also provides the guarantee that when the commit record IO
> completes, we can safely unpin all the log items in the checkpoint
> so they can be written back because the entire checkpoint is stable
> in the journal.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c      | 55 +++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_log_cil.c  |  7 ++++++
>  fs/xfs/xfs_log_priv.h |  2 ++
>  3 files changed, 64 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index fa284f26d10e..ff26fb46d70f 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -808,6 +808,61 @@ xlog_wait_on_iclog(
>  	return 0;
>  }
>  
> +/*
> + * Wait on any iclogs that are still flushing in the range of start_lsn to the
> + * current iclog's lsn. The caller holds a reference to the iclog, but otherwise
> + * holds no log locks.
> + *
> + * We walk backwards through the iclogs to find the iclog with the highest lsn
> + * in the range that we need to wait for and then wait for it to complete.
> + * Completion ordering of iclog IOs ensures that all prior iclogs to the
> + * candidate iclog we need to sleep on have been complete by the time our
> + * candidate has completed it's IO.

Hmm, I guess this means that iclog header lsns are supposed to increase
as one walks forwards through the list?

> + *
> + * Therefore we only need to find the first iclog that isn't clean within the
> + * span of our flush range. If we come across a clean, newly activated iclog
> + * with a lsn of 0, it means IO has completed on this iclog and all previous
> + * iclogs will be have been completed prior to this one. Hence finding a newly
> + * activated iclog indicates that there are no iclogs in the range we need to
> + * wait on and we are done searching.

I don't see an explicit check for an iclog with a zero lsn?  Is that
implied by XLOG_STATE_ACTIVE?

Also, do you have any idea what was Christoph talking about wrt devices
with no-op flushes the last time this patch was posted?  This change
seems straightforward to me (assuming the answers to my two question are
'yes') but I didn't grok what subtlety he was alluding to...?

--D

> + */
> +int
> +xlog_wait_on_iclog_lsn(
> +	struct xlog_in_core	*iclog,
> +	xfs_lsn_t		start_lsn)
> +{
> +	struct xlog		*log = iclog->ic_log;
> +	struct xlog_in_core	*prev;
> +	int			error = -EIO;
> +
> +	spin_lock(&log->l_icloglock);
> +	if (XLOG_FORCED_SHUTDOWN(log))
> +		goto out_unlock;
> +
> +	error = 0;
> +	for (prev = iclog->ic_prev; prev != iclog; prev = prev->ic_prev) {
> +
> +		/* Done if the lsn is before our start lsn */
> +		if (XFS_LSN_CMP(be64_to_cpu(prev->ic_header.h_lsn),
> +				start_lsn) < 0)
> +			break;
> +
> +		/* Don't need to wait on completed, clean iclogs */
> +		if (prev->ic_state == XLOG_STATE_DIRTY ||
> +		    prev->ic_state == XLOG_STATE_ACTIVE) {
> +			continue;
> +		}
> +
> +		/* wait for completion on this iclog */
> +		xlog_wait(&prev->ic_force_wait, &log->l_icloglock);
> +		return 0;
> +	}
> +
> +out_unlock:
> +	spin_unlock(&log->l_icloglock);
> +	return error;
> +}
> +
>  /*
>   * Write out an unmount record using the ticket provided. We have to account for
>   * the data space used in the unmount ticket as this write is not done from a
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index b0ef071b3cb5..c5cc1b7ad25e 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -870,6 +870,13 @@ xlog_cil_push_work(
>  	wake_up_all(&cil->xc_commit_wait);
>  	spin_unlock(&cil->xc_push_lock);
>  
> +	/*
> +	 * If the checkpoint spans multiple iclogs, wait for all previous
> +	 * iclogs to complete before we submit the commit_iclog.
> +	 */
> +	if (ctx->start_lsn != commit_lsn)
> +		xlog_wait_on_iclog_lsn(commit_iclog, ctx->start_lsn);
> +
>  	/* release the hounds! */
>  	xfs_log_release_iclog(commit_iclog);
>  	return;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 037950cf1061..a7ac85aaff4e 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -584,6 +584,8 @@ xlog_wait(
>  	remove_wait_queue(wq, &wait);
>  }
>  
> +int xlog_wait_on_iclog_lsn(struct xlog_in_core *iclog, xfs_lsn_t start_lsn);
> +
>  /*
>   * The LSN is valid so long as it is behind the current LSN. If it isn't, this
>   * means that the next log record that includes this metadata could have a
> -- 
> 2.28.0
> 
