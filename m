Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1194C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 15:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 637B864DF8
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 15:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbhA1PJu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 10:09:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54428 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232348AbhA1PJQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 10:09:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611846469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8UOWFzAeNzswPIS6ydLCwaxDBhveYvXgC0UR1CDJK1I=;
        b=RdWyihhYH3VG2T92yj9dJ9Jocv3QQVt4M+yWE1eP83e0vPugnjNpP0UmGTOPw5jIjdCCmi
        2nkq3pawyX73WrOYuRRgj/nUHmwBsHGv/Y+GbjOEiNtrtPfu9NsK96nE12bVEqR9Hr0Aet
        qAtWT9Y/6LonvRPQVJe1QKCwP4w7vUg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-WW7XYxJPO6ine-w3DDLSSg-1; Thu, 28 Jan 2021 10:07:45 -0500
X-MC-Unique: WW7XYxJPO6ine-w3DDLSSg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EB528030A2;
        Thu, 28 Jan 2021 15:07:44 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 971995C582;
        Thu, 28 Jan 2021 15:07:43 +0000 (UTC)
Date:   Thu, 28 Jan 2021 10:07:41 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: separate CIL commit record IO
Message-ID: <20210128150741.GB2599027@bfoster>
References: <20210128044154.806715-1-david@fromorbit.com>
 <20210128044154.806715-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128044154.806715-3-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

FYI, I finally got to reading your prior log cache flushing thread
yesterday afternoon. I was planning to revisit that and probably reply
this morning after having some time to digest, but saw this and so will
reply here..

On Thu, Jan 28, 2021 at 03:41:51PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To allow for iclog IO device cache flush behaviour to be optimised,
> we first need to separate out the commit record iclog IO from the
> rest of the checkpoint so we can wait for the checkpoint IO to
> complete before we issue the commit record.
> 
> This separate is only necessary if the commit record is being
> written into a different iclog to the start of the checkpoint. If
> the entire checkpoint and commit is in the one iclog, then they are
> both covered by the one set of cache flush primitives on the iclog
> and hence there is no need to separate them.
> 

I find the description here a bit vague.. we have to separate out the
commit record I/O, but only if it's already separate..? Glancing at the
code, I don't see any new "separation" happening, so it's not clear to
me what that really refers to. This looks more like we're introducing
serialization to provide checkpoint -> commit record ordering (when the
commit record happens to be in a separate iclog).

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
>  fs/xfs/xfs_log.c      | 47 +++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_log_cil.c  |  7 +++++++
>  fs/xfs/xfs_log_priv.h |  2 ++
>  3 files changed, 56 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index c5f507c24577..c5e3da23961c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -808,6 +808,53 @@ xlog_wait_on_iclog(
>  	return 0;
>  }
>  
> +/*
> + * Wait on any iclogs that are still flushing in the range of start_lsn to
> + * the current iclog's lsn. The caller holds a reference to the iclog, but
> + * otherwise holds no log locks.
> + *
> + * We walk backwards through the iclogs to find the iclog with the highest lsn
> + * in the range that we need to wait for and then wait for it to complete.
> + * Completion ordering of iclog IOs ensures that all prior iclogs to this IO are
> + * complete by the time our candidate has completed.
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

Hmm.. that logic looks a bit dodgy when you consider that the iclog
header lsn is reset to zero on activation. I think it actually works as
intended because iclog completion reactivates iclogs in LSN order and
this loop walks in reverse order, but that is a very subtle connection
that might be useful to document.

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

This is an interesting serialization point because we don't necessarily
submit the iclog that holds the commit record. I actually think in most
cases the separate commit record won't land on disk until the next CIL
push causes a sync of the current head iclog (assuming it fills it up).
Granted, this is the last point we have context of the commit record
being written, so it makes sense from an opportunistic standpoint to
serialize here (just as we already block to ensure commit record
ordering across checkpoints). That said, with the aggressive batching
ability of the CIL I think blocking on prior pushes is potentially less
heavy handed than unconditionally blocking on all prior iclog I/O. I
wonder if this might be something to address if we're going to compound
this path with more serialization.

From a performance perspective, it seems like this makes the CIL push
_nearly_ synchronous by default. I.e., if we have a several hundred MB
CIL context, we're going to wait for all but the final iclog to complete
before we return. Of course we'll be waiting for much of that anyways to
reuse limited iclog space, but I have to think more about what that
means in general (maybe not much) and get through the subsequent
patches. In the meantime, have you put thought into any potential
negative performance impact from this that might or might not be offset
by subsequent flush optimizations?

Brian

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

