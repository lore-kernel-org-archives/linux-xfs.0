Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82D7C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 14:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B24D664E99
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 14:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbhCOOn4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 10:43:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43905 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238173AbhCOOnt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Mar 2021 10:43:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615819428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6groDghF0uhGnrWiq/+P/eE/eVrXS8GF+H0d+BqIK/I=;
        b=Pqta7CZV0pnL5hMvYzfrBPet3sBtycxYSKPQGuhIPBZC/SgZ3WNUXsz12s6it9xh46VaqI
        ul0BmaRJ2+xAsH+1J9sCpaiehiBZ3CCEJ3so/M+n6fT8EoivOI9WXZ+hmjznCdY6Fn8tZG
        Z3E4rOtX4qPTXLmSebd19thQAXepmyo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-c8vYNuGsM8a4MgM81hvu1A-1; Mon, 15 Mar 2021 10:43:46 -0400
X-MC-Unique: c8vYNuGsM8a4MgM81hvu1A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33D27802B45;
        Mon, 15 Mar 2021 14:43:45 +0000 (UTC)
Received: from bfoster (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D3E7819D7C;
        Mon, 15 Mar 2021 14:43:44 +0000 (UTC)
Date:   Mon, 15 Mar 2021 10:43:43 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/45] xfs: CIL checkpoint flushes caches unconditionally
Message-ID: <YE9yn3TVpiHeMRph@bfoster>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-7-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:04PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_log_cil.c | 31 +++++++++++++++++++++++++++----
>  1 file changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 1e5fd6f268c2..b4cdb8b6c4c3 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
...
> @@ -719,10 +721,25 @@ xlog_cil_push_work(
>  	spin_unlock(&cil->xc_push_lock);
>  
>  	/*
> -	 * pull all the log vectors off the items in the CIL, and
> -	 * remove the items from the CIL. We don't need the CIL lock
> -	 * here because it's only needed on the transaction commit
> -	 * side which is currently locked out by the flush lock.
> +	 * The CIL is stable at this point - nothing new will be added to it
> +	 * because we hold the flush lock exclusively. Hence we can now issue
> +	 * a cache flush to ensure all the completed metadata in the journal we
> +	 * are about to overwrite is on stable storage.
> +	 *
> +	 * This avoids the need to have the iclogs issue REQ_PREFLUSH based
> +	 * cache flushes to provide this ordering guarantee, and hence for CIL
> +	 * checkpoints that require hundreds or thousands of log writes no
> +	 * longer need to issue device cache flushes to provide metadata
> +	 * writeback ordering.
> +	 */

I don't think we need to have code comments to explain why some other
code doesn't do something or doesn't exist. This seems like something
that should stick to the commit log description (between this patch and
the future patch that removes the historical behavior). IOW, I'd just
drop that second paragraph.

Otherwise (and modulo my previous thoughts on the bio) LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	xfs_flush_bdev_async(&bio, log->l_mp->m_ddev_targp->bt_bdev,
> +				&bdev_flush);
> +
> +	/*
> +	 * Pull all the log vectors off the items in the CIL, and remove the
> +	 * items from the CIL. We don't need the CIL lock here because it's only
> +	 * needed on the transaction commit side which is currently locked out
> +	 * by the flush lock.
>  	 */
>  	lv = NULL;
>  	num_iovecs = 0;
> @@ -806,6 +823,12 @@ xlog_cil_push_work(
>  	lvhdr.lv_iovecp = &lhdr;
>  	lvhdr.lv_next = ctx->lv_chain;
>  
> +	/*
> +	 * Before we format and submit the first iclog, we have to ensure that
> +	 * the metadata writeback ordering cache flush is complete.
> +	 */
> +	wait_for_completion(&bdev_flush);
> +
>  	error = xlog_write(log, &lvhdr, tic, &ctx->start_lsn, NULL, 0, true);
>  	if (error)
>  		goto out_abort_free_ticket;
> -- 
> 2.28.0
> 

