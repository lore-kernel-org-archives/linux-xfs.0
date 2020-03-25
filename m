Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B924C43331
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 12:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 390ED2076A
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 12:34:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C/QfLc+D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgCYMeK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 08:34:10 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:20332 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727177AbgCYMeK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 08:34:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585139649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7UiJNGKyxeqDdByKXaqze6D7vuHuiOzvcxsDFlkNXmo=;
        b=C/QfLc+D91ZfJto7vzMieb4nyWK2JiMrcr80MnoAW1iwGqSjWOWsym0wKO7NLOnfYpQyYU
        io9Yjq9oiHHHKvmE4gBS72CJR9BwJKtijI2llsxMFTKnqMhIhZ5bL4+NE8J7baM7w4lgTF
        8lunrlKlnh3+rBjudnbDCSJmxV5DLK4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-nnqGj29tN2G19cDyP4qdVQ-1; Wed, 25 Mar 2020 08:34:07 -0400
X-MC-Unique: nnqGj29tN2G19cDyP4qdVQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD4A51005509;
        Wed, 25 Mar 2020 12:34:06 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 61CD560BF7;
        Wed, 25 Mar 2020 12:34:06 +0000 (UTC)
Date:   Wed, 25 Mar 2020 08:34:04 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 5/8] xfs: split xlog_ticket_done
Message-ID: <20200325123404.GE10922@bfoster>
References: <20200324174459.770999-1-hch@lst.de>
 <20200324174459.770999-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324174459.770999-6-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 24, 2020 at 06:44:56PM +0100, Christoph Hellwig wrote:
> Split the regrant case out of xlog_ticket_done and into a new
> xlog_ticket_regrant helper.  Merge both functions with the low-level
> functions implementing the actual functionality and adjust the
> tracepoints.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c      | 84 ++++++++++++++-----------------------------
>  fs/xfs/xfs_log_cil.c  |  9 +++--
>  fs/xfs/xfs_log_priv.h |  4 +--
>  fs/xfs/xfs_trace.h    | 14 ++++----
>  fs/xfs/xfs_trans.c    |  9 +++--
>  5 files changed, 47 insertions(+), 73 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index efc7751550d9..fbfdd9cf160d 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
...
> @@ -1011,12 +1009,12 @@ DEFINE_LOGGRANT_EVENT(xfs_log_reserve);
>  DEFINE_LOGGRANT_EVENT(xfs_log_reserve_exit);
>  DEFINE_LOGGRANT_EVENT(xfs_log_regrant);
>  DEFINE_LOGGRANT_EVENT(xfs_log_regrant_exit);
> -DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_enter);
> -DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_exit);
> -DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_sub);
> -DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_enter);
> -DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_exit);
> -DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_sub);
> +DEFINE_LOGGRANT_EVENT(xfs_log_ticket_regrant);
> +DEFINE_LOGGRANT_EVENT(xfs_log_ticket_regrant_exit);
> +DEFINE_LOGGRANT_EVENT(xfs_log_ticket_regrant_sub);
> +DEFINE_LOGGRANT_EVENT(xfs_log_ticket_done);
> +DEFINE_LOGGRANT_EVENT(xfs_log_ticket_done_sub);
> +DEFINE_LOGGRANT_EVENT(xfs_log_ticket_done_exit);
>  

Any reason we carry over the vague 'done' naming to the lower level
functions? xlog_ticket_[re|un]grant() seems more consistent and explicit
to me, but either way:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  DECLARE_EVENT_CLASS(xfs_log_item_class,
>  	TP_PROTO(struct xfs_log_item *lip),
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 123ecc8435f6..d7c66c3331ec 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -231,7 +231,7 @@ xfs_trans_reserve(
>  	 */
>  undo_log:
>  	if (resp->tr_logres > 0) {
> -		xlog_ticket_done(mp->m_log, tp->t_ticket, false);
> +		xlog_ticket_done(mp->m_log, tp->t_ticket);
>  		tp->t_ticket = NULL;
>  		tp->t_log_res = 0;
>  		tp->t_flags &= ~XFS_TRANS_PERM_LOG_RES;
> @@ -1001,7 +1001,10 @@ __xfs_trans_commit(
>  	 */
>  	xfs_trans_unreserve_and_mod_dquots(tp);
>  	if (tp->t_ticket) {
> -		xlog_ticket_done(mp->m_log, tp->t_ticket, regrant);
> +		if (regrant && !XLOG_FORCED_SHUTDOWN(mp->m_log))
> +			xlog_ticket_regrant(mp->m_log, tp->t_ticket);
> +		else
> +			xlog_ticket_done(mp->m_log, tp->t_ticket);
>  		tp->t_ticket = NULL;
>  	}
>  	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
> @@ -1060,7 +1063,7 @@ xfs_trans_cancel(
>  	xfs_trans_unreserve_and_mod_dquots(tp);
>  
>  	if (tp->t_ticket) {
> -		xlog_ticket_done(mp->m_log, tp->t_ticket, false);
> +		xlog_ticket_done(mp->m_log, tp->t_ticket);
>  		tp->t_ticket = NULL;
>  	}
>  
> -- 
> 2.25.1
> 

