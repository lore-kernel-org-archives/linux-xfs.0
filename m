Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67464C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 18:39:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3846B650EF
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 18:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhCPSjS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Mar 2021 14:39:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21407 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237198AbhCPSjE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Mar 2021 14:39:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615919940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xdH2k6wmnQliAu/42GfHzsdSa48NLht8gi6n+qAWzxk=;
        b=YRX6SlVoV+rLfkx6PXoxdM+Gx2EZDdaIbG6zLjs8p0gyk/uTmYt9hKQ5zivqh7waE31njI
        9ipCwZwLV5NXLwaqgUvrm6v32f9ACHmnrN5+GH05NkIFiroOCLOPRVdrHyqC6agqjfg3Qg
        V5FKYXQfinvvxQwUB1xuS1XgGF1ELH0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-5MIBw0SgPpe_603qDNvtgA-1; Tue, 16 Mar 2021 14:38:58 -0400
X-MC-Unique: 5MIBw0SgPpe_603qDNvtgA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2611E100C61B;
        Tue, 16 Mar 2021 18:38:57 +0000 (UTC)
Received: from bfoster (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C426019D61;
        Tue, 16 Mar 2021 18:38:56 +0000 (UTC)
Date:   Tue, 16 Mar 2021 14:38:55 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/45] xfs: pass lv chain length into xlog_write()
Message-ID: <YFD7P+fVkPrwLIb+@bfoster>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-28-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-28-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:25PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The caller of xlog_write() usually has a close accounting of the
> aggregated vector length contained in the log vector chain passed to
> xlog_write(). There is no need to iterate the chain to calculate he
> length of the data in xlog_write_calculate_len() if the caller is
> already iterating that chain to build it.
> 
> Passing in the vector length avoids doing an extra chain iteration,
> which can be a significant amount of work given that large CIL
> commits can have hundreds of thousands of vectors attached to the
> chain.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c      | 37 ++++++-------------------------------
>  fs/xfs/xfs_log_cil.c  | 18 +++++++++++++-----
>  fs/xfs/xfs_log_priv.h |  2 +-
>  3 files changed, 20 insertions(+), 37 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 7a5e6bdb7876..34abc3bae587 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
...
> @@ -893,6 +898,9 @@ xlog_cil_push_work(
>  	 * transaction header here as it is not accounted for in xlog_write().
>  	 */
>  	xlog_cil_build_trans_hdr(ctx, &thdr, &lvhdr, num_iovecs);
> +	num_iovecs += lvhdr.lv_niovecs;

What's the point of this if num_iovecs is only used by
xlog_cil_build_trans_hdr()?

Brian

> +	num_bytes += lvhdr.lv_bytes;
> +
>  
>  	/*
>  	 * Before we format and submit the first iclog, we have to ensure that
> @@ -907,7 +915,7 @@ xlog_cil_push_work(
>  	 * write head.
>  	 */
>  	error = xlog_write(log, &lvhdr, ctx->ticket, &ctx->start_lsn, NULL,
> -				XLOG_START_TRANS);
> +				XLOG_START_TRANS, num_bytes);
>  	if (error)
>  		goto out_abort_free_ticket;
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 8ee6a5f74396..003c11653955 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -462,7 +462,7 @@ void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
>  void	xlog_print_trans(struct xfs_trans *);
>  int	xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
>  		struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
> -		struct xlog_in_core **commit_iclog, uint optype);
> +		struct xlog_in_core **commit_iclog, uint optype, uint32_t len);
>  int	xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
>  		struct xlog_in_core **iclog, xfs_lsn_t *lsn);
>  void	xlog_state_switch_iclogs(struct xlog *log, struct xlog_in_core *iclog,
> -- 
> 2.28.0
> 

