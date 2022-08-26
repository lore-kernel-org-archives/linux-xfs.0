Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE9EECAAD4
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Aug 2022 22:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242698AbiHZWjT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Aug 2022 18:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241947AbiHZWjS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Aug 2022 18:39:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A165CE86AB
        for <linux-xfs@vger.kernel.org>; Fri, 26 Aug 2022 15:39:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39F1A6188A
        for <linux-xfs@vger.kernel.org>; Fri, 26 Aug 2022 22:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E52C433D6;
        Fri, 26 Aug 2022 22:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661553556;
        bh=7Ycta9adVyLAQIAXeoqFkrsy2A4BO+dNrs5UAT48JHw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K7oijdiBEb5Zite4TlG+Kt24jPV4s8jaz3TwpXrYvdHVQRRuzm37TWnIO8ZgxQLJv
         hGeadzscCbblP0ecpDK1dNpaQ/AieyEcSHEEGdkNH7K0X2yc26Lzs7lXaszBkdgzXH
         zySupfMEnhplE4UisMLD2aVKvWt6Q1I/Smc1VYmE2uNI2KTQniqUSJsm2PtCLicWMU
         E27t9A/5GyXHZPbHrIfqhGV3FsOu81xYDZYKv3NM0OUEH/nT32Qj3gkOY5lFCObEi5
         EKf+GOGdgw1Vu+ZSWHbkRB1vk98qC3g7uguHFGYkITUCXg/0GzrtSITEq6Id0oQdYN
         /cnS7QLokbm2A==
Date:   Fri, 26 Aug 2022 15:39:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: track log space pinned by the AIL
Message-ID: <YwlLlLRGf0ShqK3o@magnolia>
References: <20220809230353.3353059-1-david@fromorbit.com>
 <20220809230353.3353059-8-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809230353.3353059-8-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 10, 2022 at 09:03:51AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently we track space used in the log by grant heads.
> These store the reserved space as a physical log location and
> combine both space reserved for future use with space already used in
> the log in a single variable. The amount of space consumed in the
> log is then calculated as the  distance between the log tail and
> the grant head.
> 
> The problem with tracking the grant head as a physical location
> comes from the fact that it tracks both log cycle count and offset
> into the log in bytes in a single 64 bit variable. because the cycle
> count on disk is a 32 bit number, this also limits the offset into
> the log to 32 bits. ANd because that is in bytes, we are limited to
> being able to track only 2GB of log space in the grant head.
> 
> Hence to support larger physical logs, we need to track used space
> differently in the grant head. We no longer use the grant head for
> guiding AIL pushing, so the only thing it is now used for is
> determining if we've run out of reservation space via the
> calculation in xlog_space_left().
> 
> What we really need to do is move the grant heads away from tracking
> physical space in the log. The issue here is that space consumed in
> the log is not directly tracked by the current mechanism - the
> space consumed in the log by grant head reservations gets returned
> to the free pool by the tail of the log moving forward. i.e. the
> space isn't directly tracked or calculated, but the used grant space
> gets "freed" as the physical limits of the log are updated without
> actually needing to update the grant heads.
> 
> Hence to move away from implicit, zero-update log space tracking we
> need to explicitly track the amount of physical space the log
> actually consumes separately to the in-memory reservations for
> operations that will be committed to the journal. Luckily, we
> already track the information we need to calculate this in the AIL
> itself.
> 
> That is, the space currently consumed by the journal is the maximum
> LSN that the AIL has seen minus the current log tail. As we update
> both of these items dynamically as the head and tail of the log
> moves, we always know exactly how much space the journal consumes.
> 
> This means that we also know exactly how much space the currently
> active reservations require, and exactly how much free space we have
> remaining for new reservations to be made. Most importantly, we know
> what these spaces are indepedently of the physical locations of
> the head and tail of the log.
> 
> Hence by separating out the physical space consumed by the journal,
> we can now track reservations in the grant heads purely as a byte
> count, and the log can be considered full when the tail space +
> reservation space exceeds the size of the log. This means we can use
> the full 64 bits of grant head space for reservation space,
> completely removing the 32 bit byte count limitation on log size
> that they impose.
> 
> Hence the first step in this conversion is to track and update the
> "log tail space" every time the AIL tail or maximum seen LSN
> changes.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c   | 9 ++++++---
>  fs/xfs/xfs_log_priv.h  | 1 +
>  fs/xfs/xfs_trans_ail.c | 9 ++++++---
>  3 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 843764d40232..e482ae9fc01c 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -761,14 +761,17 @@ xlog_cil_ail_insert(
>  	 * always be the same (as iclogs can contain multiple commit records) or
>  	 * higher LSN than the current head. We do this before insertion of the
>  	 * items so that log space checks during insertion will reflect the
> -	 * space that this checkpoint has already consumed.
> +	 * space that this checkpoint has already consumed.  We call
> +	 * xfs_ail_update_finish() so that tail space and space-based wakeups
> +	 * will be recalculated appropriately.
>  	 */
>  	ASSERT(XFS_LSN_CMP(ctx->commit_lsn, ailp->ail_head_lsn) >= 0 ||
>  			aborted);
>  	spin_lock(&ailp->ail_lock);
> -	ailp->ail_head_lsn = ctx->commit_lsn;
>  	xfs_trans_ail_cursor_last(ailp, &cur, ctx->start_lsn);
> -	spin_unlock(&ailp->ail_lock);
> +	ailp->ail_head_lsn = ctx->commit_lsn;
> +	/* xfs_ail_update_finish() drops the ail_lock */
> +	xfs_ail_update_finish(ailp, NULLCOMMITLSN);

Hmm.  I think this change makes it so that any time we add items to the
AIL, we update the head lsn, recalculate the amount of space being used
by the ondisk(?) journal, and possibly start waking threads up if we've
pushed the tail ahead enough space to somebody have some grant space?

If I grokked that, then:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  
>  	/* unpin all the log items */
>  	list_for_each_entry(lv, &ctx->lv_chain, lv_list) {
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 5f4358f18224..8a005cb08a02 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -435,6 +435,7 @@ struct xlog {
>  
>  	struct xlog_grant_head	l_reserve_head;
>  	struct xlog_grant_head	l_write_head;
> +	uint64_t		l_tail_space;
>  
>  	struct xfs_kobj		l_kobj;
>  
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index fe3f8b80e687..5d0ddd6d68e9 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -731,6 +731,8 @@ __xfs_ail_assign_tail_lsn(
>  	if (!tail_lsn)
>  		tail_lsn = ailp->ail_head_lsn;
>  
> +	WRITE_ONCE(log->l_tail_space,
> +			xlog_lsn_sub(log, ailp->ail_head_lsn, tail_lsn));
>  	trace_xfs_log_assign_tail_lsn(log, tail_lsn);
>  	atomic64_set(&log->l_tail_lsn, tail_lsn);
>  }
> @@ -738,9 +740,10 @@ __xfs_ail_assign_tail_lsn(
>  /*
>   * Callers should pass the the original tail lsn so that we can detect if the
>   * tail has moved as a result of the operation that was performed. If the caller
> - * needs to force a tail LSN update, it should pass NULLCOMMITLSN to bypass the
> - * "did the tail LSN change?" checks. If the caller wants to avoid a tail update
> - * (e.g. it knows the tail did not change) it should pass an @old_lsn of 0.
> + * needs to force a tail space update, it should pass NULLCOMMITLSN to bypass
> + * the "did the tail LSN change?" checks. If the caller wants to avoid a tail
> + * update (e.g. it knows the tail did not change) it should pass an @old_lsn of
> + * 0.
>   */
>  void
>  xfs_ail_update_finish(
> -- 
> 2.36.1
> 
