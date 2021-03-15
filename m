Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6C27C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 14:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B042664F23
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 14:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbhCOOlp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 10:41:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51499 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237391AbhCOOkk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Mar 2021 10:40:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615819238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9B98kVkx9t/dhCv9I5LuzLeK2X8U+C+jdibWE4+oZzA=;
        b=IQy+9FZ4Cc3PUqnFYOVHxThkqCaaM+zVGCNC4JWLrHz3yNN4ck4LA7DVPpvKC3gg2wOLKQ
        /JJ+8IJl9wyKfksAXaUmXc1UMIf9kvL7oaKNaQJ/K/HQcKb4vGCBolboKnO0IYQVRGhxWl
        KKKKDaEpnxhZAT9fX9M2RNziG9ihNV4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-F6u_p96kOMuAS_60Xw9ssg-1; Mon, 15 Mar 2021 10:40:36 -0400
X-MC-Unique: F6u_p96kOMuAS_60Xw9ssg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF2E3800C78;
        Mon, 15 Mar 2021 14:40:34 +0000 (UTC)
Received: from bfoster (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C16539A73;
        Mon, 15 Mar 2021 14:40:34 +0000 (UTC)
Date:   Mon, 15 Mar 2021 10:40:32 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/45] xfs: separate CIL commit record IO
Message-ID: <YE9x4IxVUK1Xy8DD@bfoster>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-4-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:01PM +1100, Dave Chinner wrote:
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
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---

I still think the patch could be titled much more descriptively. For
example:

xfs: checkpoint completion to commit record submission ordering

Otherwise (and despite my slight unease over now blocking async log
forces on iclog callback completion) looks Ok:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c      | 8 +++++---
>  fs/xfs/xfs_log_cil.c  | 9 +++++++++
>  fs/xfs/xfs_log_priv.h | 2 ++
>  3 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index fa284f26d10e..317c466232d4 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -784,10 +784,12 @@ xfs_log_mount_cancel(
>  }
>  
>  /*
> - * Wait for the iclog to be written disk, or return an error if the log has been
> - * shut down.
> + * Wait for the iclog and all prior iclogs to be written disk as required by the
> + * log force state machine. Waiting on ic_force_wait ensures iclog completions
> + * have been ordered and callbacks run before we are woken here, hence
> + * guaranteeing that all the iclogs up to this one are on stable storage.
>   */
> -static int
> +int
>  xlog_wait_on_iclog(
>  	struct xlog_in_core	*iclog)
>  		__releases(iclog->ic_log->l_icloglock)
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index b0ef071b3cb5..1e5fd6f268c2 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -870,6 +870,15 @@ xlog_cil_push_work(
>  	wake_up_all(&cil->xc_commit_wait);
>  	spin_unlock(&cil->xc_push_lock);
>  
> +	/*
> +	 * If the checkpoint spans multiple iclogs, wait for all previous
> +	 * iclogs to complete before we submit the commit_iclog.
> +	 */
> +	if (ctx->start_lsn != commit_lsn) {
> +		spin_lock(&log->l_icloglock);
> +		xlog_wait_on_iclog(commit_iclog->ic_prev);
> +	}
> +
>  	/* release the hounds! */
>  	xfs_log_release_iclog(commit_iclog);
>  	return;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 037950cf1061..ee7786b33da9 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -584,6 +584,8 @@ xlog_wait(
>  	remove_wait_queue(wq, &wait);
>  }
>  
> +int xlog_wait_on_iclog(struct xlog_in_core *iclog);
> +
>  /*
>   * The LSN is valid so long as it is behind the current LSN. If it isn't, this
>   * means that the next log record that includes this metadata could have a
> -- 
> 2.28.0
> 

