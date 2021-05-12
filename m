Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16367C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 01:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBD3A61186
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 01:55:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhELB4a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 21:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229848AbhELB43 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 May 2021 21:56:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4558B6192A;
        Wed, 12 May 2021 01:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620784522;
        bh=Z1SmLoRFtPnXqjDr2G36gMtesUQL+/Vqc/MXCPXRYeM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oFAkatqrK4nRXtC+FfoL60iftCFz2iyMpr67BMPQmZIr+nfwYVZk4a1NvJaVsLBO+
         w6urN1Hk8El052/uofGHsXDaiDvIUF6++lgb62R5p9uEPnw52sO/ytcUfYCVSx+Ox4
         kpg8GzUHzTbCKvO0/Am6BXEm+8xWRCYs0oNFYWFdcRLL/9h0R2Isq0v+AxzzDWsMv7
         ni0xmkGQtDFP+BTmiP82tm4dOlZyvUUAGzkBdhb/FwrMmWPfuUpFN2/oAA2bcq73fs
         z1XHrnEwP7ZRqre4gK4M2Dz91d9Uq8ntPcN85YCOiRd4sz7nXOAWdow3lSFTMZliey
         lMNhU5dBmk2oQ==
Date:   Tue, 11 May 2021 18:55:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: remove dead stale buf unpin handling code
Message-ID: <20210512015519.GX8582@magnolia>
References: <20210511135257.878743-1-bfoster@redhat.com>
 <20210511135257.878743-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511135257.878743-3-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 11, 2021 at 09:52:57AM -0400, Brian Foster wrote:
> This code goes back to a time when transaction commits wrote
> directly to iclogs. The associated log items were pinned, written to
> the log, and then "uncommitted" if some part of the log write had
> failed. This uncommit sequence called an ->iop_unpin_remove()
> handler that was eventually folded into ->iop_unpin() via the remove
> parameter. The log subsystem has since changed significantly in that
> transactions commit to the CIL instead of direct to iclogs, though
> log items must still be aborted in the event of an eventual log I/O
> error. However, the context for a log item abort is now asynchronous
> from transaction commit, which means the committing transaction has
> been freed by this point in time and the transaction uncommit
> sequence of events is no longer relevant.
> 
> Further, since stale buffers remain locked at transaction commit
> through unpin, we can be certain that the buffer is not associated
> with any transaction when the unpin callback executes. Remove this
> unused hunk of code and replace it with an assertion that the buffer
> is disassociated from transaction context.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

<nod> my brain kinda hurts now, but I have a vague recollection of
wondering how you could get a stale buffer that was also being
removed and not being able to figure out how one might stumble into this
chunk of code. :)

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf_item.c | 20 +-------------------
>  1 file changed, 1 insertion(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 7ff31788512b..634abf30b5bc 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -517,28 +517,10 @@ xfs_buf_item_unpin(
>  		ASSERT(xfs_buf_islocked(bp));
>  		ASSERT(bp->b_flags & XBF_STALE);
>  		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
> +		ASSERT(list_empty(&lip->li_trans) && !bp->b_transp);
>  
>  		trace_xfs_buf_item_unpin_stale(bip);
>  
> -		if (remove) {
> -			/*
> -			 * If we are in a transaction context, we have to
> -			 * remove the log item from the transaction as we are
> -			 * about to release our reference to the buffer.  If we
> -			 * don't, the unlock that occurs later in
> -			 * xfs_trans_uncommit() will try to reference the
> -			 * buffer which we no longer have a hold on.
> -			 */
> -			if (!list_empty(&lip->li_trans))
> -				xfs_trans_del_item(lip);
> -
> -			/*
> -			 * Since the transaction no longer refers to the buffer,
> -			 * the buffer should no longer refer to the transaction.
> -			 */
> -			bp->b_transp = NULL;
> -		}
> -
>  		/*
>  		 * If we get called here because of an IO error, we may or may
>  		 * not have the item on the AIL. xfs_trans_ail_delete() will
> -- 
> 2.26.3
> 
