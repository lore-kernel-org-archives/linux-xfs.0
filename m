Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FB8FC83000
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 15:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5F60205C9
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 15:10:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="azj4v/1W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgD1PKu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 11:10:50 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58837 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727865AbgD1PKu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 11:10:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588086645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U5lJW6UxW/uRU7KKO+CqUeSF4JVxTHQ15hB1qm7ICsU=;
        b=azj4v/1WBokAPpMvT9hWAcFa0tOdU4QYzInBrt1JL42Q78bZRotxgWiG0R3toOuSZe6KWB
        mpAVkodJAvWUSbyBcrUJXpzlD/aa3V9tCDl0wjcLnCbIXYxU8S6z1QjiRcRrS+MoowHGzl
        LulYdqFMJ0LcHxPRr9oxLdbcz9BlRSY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-Nbk54w00MS2P6oMSIKs6pw-1; Tue, 28 Apr 2020 11:10:44 -0400
X-MC-Unique: Nbk54w00MS2P6oMSIKs6pw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21D0F835B40;
        Tue, 28 Apr 2020 15:10:43 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A6CE11002395;
        Tue, 28 Apr 2020 15:10:42 +0000 (UTC)
Date:   Tue, 28 Apr 2020 11:10:40 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: refactor the buffer cancellation table helpers
Message-ID: <20200428151040.GA27954@bfoster>
References: <20200427135229.1480993-1-hch@lst.de>
 <20200427135229.1480993-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427135229.1480993-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 27, 2020 at 03:52:28PM +0200, Christoph Hellwig wrote:
> Replace the somewhat convoluted use of xlog_peek_buffer_cancelled and
> xlog_check_buffer_cancelled with two obvious helpers:
> 
>  xlog_is_buffer_cancelled, which returns true if there is a buffer in
>  the cancellation table, and
>  xlog_put_buffer_cancelled, which also decrements the reference count
>  of the buffer cancellation table.
> 
> Both share a little helper to look up the entry.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log_recover.c | 109 ++++++++++++++++++---------------------
>  1 file changed, 50 insertions(+), 59 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 11c3502b07b13..750a81b941ea4 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1972,26 +1972,17 @@ xlog_recover_buffer_pass1(
>  	return 0;
>  }
>  
...
>  /*
> - * If the buffer is being cancelled then return 1 so that it will be cancelled,
> - * otherwise return 0.  If the buffer is actually a buffer cancel item
> - * (XFS_BLF_CANCEL is set), then decrement the refcount on the entry in the
> - * table and remove it from the table if this is the last reference.
> + * Check if there is and entry for blkno, len in the buffer cancel record table.
> + */
> +static bool
> +xlog_is_buffer_cancelled(
> +	struct xlog		*log,
> +	xfs_daddr_t		blkno,
> +	uint			len)
> +{
> +	return xlog_find_buffer_cancelled(log, blkno, len) != NULL;
> +}
> +
> +/*
> + * Check if there is and entry for blkno, len in the buffer cancel record table,

Nit:			an

> + * and decremented the reference count on it if there is one.

Nit:	  decrement

...
> @@ -2733,10 +2722,15 @@ xlog_recover_buffer_pass2(
>  	 * In this pass we only want to recover all the buffers which have
>  	 * not been cancelled and are not cancellation buffers themselves.
>  	 */
> -	if (xlog_check_buffer_cancelled(log, buf_f->blf_blkno,
> -			buf_f->blf_len, buf_f->blf_flags)) {
> -		trace_xfs_log_recover_buf_cancel(log, buf_f);
> -		return 0;
> +	if (buf_f->blf_flags & XFS_BLF_CANCEL) {
> +		if (xlog_put_buffer_cancelled(log, buf_f->blf_blkno,
> +				buf_f->blf_len))
> +			goto cancelled;
> +	} else {
> +

Extra whitespace above. With those nits fixed:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +		if (xlog_is_buffer_cancelled(log, buf_f->blf_blkno,
> +				buf_f->blf_len))
> +			goto cancelled;
>  	}
>  
>  	trace_xfs_log_recover_buf_recover(log, buf_f);
> @@ -2820,6 +2814,9 @@ xlog_recover_buffer_pass2(
>  out_release:
>  	xfs_buf_relse(bp);
>  	return error;
> +cancelled:
> +	trace_xfs_log_recover_buf_cancel(log, buf_f);
> +	return 0;
>  }
>  
>  /*
> @@ -2937,8 +2934,7 @@ xlog_recover_inode_pass2(
>  	 * Inode buffers can be freed, look out for it,
>  	 * and do not replay the inode.
>  	 */
> -	if (xlog_check_buffer_cancelled(log, in_f->ilf_blkno,
> -					in_f->ilf_len, 0)) {
> +	if (xlog_is_buffer_cancelled(log, in_f->ilf_blkno, in_f->ilf_len)) {
>  		error = 0;
>  		trace_xfs_log_recover_inode_cancel(log, in_f);
>  		goto error;
> @@ -3840,7 +3836,7 @@ xlog_recover_do_icreate_pass2(
>  
>  		daddr = XFS_AGB_TO_DADDR(mp, agno,
>  				agbno + i * igeo->blocks_per_cluster);
> -		if (xlog_check_buffer_cancelled(log, daddr, bb_per_cluster, 0))
> +		if (xlog_is_buffer_cancelled(log, daddr, bb_per_cluster))
>  			cancel_count++;
>  	}
>  
> @@ -3876,11 +3872,8 @@ xlog_recover_buffer_ra_pass2(
>  	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
>  	struct xfs_mount		*mp = log->l_mp;
>  
> -	if (xlog_peek_buffer_cancelled(log, buf_f->blf_blkno,
> -			buf_f->blf_len, buf_f->blf_flags)) {
> +	if (xlog_is_buffer_cancelled(log, buf_f->blf_blkno, buf_f->blf_len))
>  		return;
> -	}
> -
>  	xfs_buf_readahead(mp->m_ddev_targp, buf_f->blf_blkno,
>  				buf_f->blf_len, NULL);
>  }
> @@ -3905,9 +3898,8 @@ xlog_recover_inode_ra_pass2(
>  			return;
>  	}
>  
> -	if (xlog_peek_buffer_cancelled(log, ilfp->ilf_blkno, ilfp->ilf_len, 0))
> +	if (xlog_is_buffer_cancelled(log, ilfp->ilf_blkno, ilfp->ilf_len))
>  		return;
> -
>  	xfs_buf_readahead(mp->m_ddev_targp, ilfp->ilf_blkno,
>  				ilfp->ilf_len, &xfs_inode_buf_ra_ops);
>  }
> @@ -3943,9 +3935,8 @@ xlog_recover_dquot_ra_pass2(
>  	ASSERT(dq_f->qlf_len == 1);
>  
>  	len = XFS_FSB_TO_BB(mp, dq_f->qlf_len);
> -	if (xlog_peek_buffer_cancelled(log, dq_f->qlf_blkno, len, 0))
> +	if (xlog_is_buffer_cancelled(log, dq_f->qlf_blkno, len))
>  		return;
> -
>  	xfs_buf_readahead(mp->m_ddev_targp, dq_f->qlf_blkno, len,
>  			  &xfs_dquot_buf_ra_ops);
>  }
> -- 
> 2.26.1
> 

