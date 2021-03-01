Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5AEDC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 15:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77F6664DFB
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Mar 2021 15:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237125AbhCAPVZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Mar 2021 10:21:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22521 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237117AbhCAPVJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Mar 2021 10:21:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614611982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eA2o4+SvTek7RiYEEyaNDWYGNjF1nGVFK8IcZPwca+I=;
        b=Dxl74Xy0L6WXYUt3tzl+R8K3Z4ck5vVPkmNb8r0S6FvY5jZWJz6gL32vl4UpXK9+fm8zJ7
        VvcJbdfge3410wWTxySXaA3P82hkWtm3Xruh0FAb4Uh1u5AYNAzEM+OAgRa7BWgzBI+zC9
        Wzp1E72mGkSm9JV4QEzrunOhFtsS8RM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-TqQqd8OSM0eRXpEmkYDqAw-1; Mon, 01 Mar 2021 10:19:40 -0500
X-MC-Unique: TqQqd8OSM0eRXpEmkYDqAw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E03A19611A3;
        Mon,  1 Mar 2021 15:19:39 +0000 (UTC)
Received: from bfoster (ovpn-113-120.rdu2.redhat.com [10.10.113.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C8152100239A;
        Mon,  1 Mar 2021 15:19:38 +0000 (UTC)
Date:   Mon, 1 Mar 2021 10:19:36 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: separate CIL commit record IO
Message-ID: <YD0GCCPmCkoYBVK0@bfoster>
References: <20210223033442.3267258-1-david@fromorbit.com>
 <20210223033442.3267258-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223033442.3267258-3-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
> + *
> + * Therefore we only need to find the first iclog that isn't clean within the
> + * span of our flush range. If we come across a clean, newly activated iclog
> + * with a lsn of 0, it means IO has completed on this iclog and all previous
> + * iclogs will be have been completed prior to this one. Hence finding a newly
> + * activated iclog indicates that there are no iclogs in the range we need to
> + * wait on and we are done searching.
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

You haven't addressed my feedback from the previous version. In
particular the bit about whether it is safe to block on ->ic_force_wait
from here considering some of our more quirky buffer locking behavior.

That aside, this iteration logic all seems a bit overengineered to me.
We have the commit record iclog of the current checkpoint and thus the
immediately previous iclog in the ring. We know that previous record
isn't earlier than start_lsn because the caller confirmed that start_lsn
!= commit_lsn. We also know that iclog can't become dirty -> active
until it and all previous iclog writes have completed because the
callback ordering implemented by xlog_state_do_callback() won't clean
the iclog until that point. Given that, can't this whole thing be
replaced with a check of iclog->prev to either see if it's been cleaned
or to otherwise xlog_wait() for that condition and return?

Brian

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

