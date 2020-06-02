Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A10EFC433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 16:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 793982081A
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 16:46:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BsejVM8y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgFBQqG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 12:46:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31684 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727769AbgFBQpy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 12:45:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591116352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N0bKjO/dKPtzqP+CsHR9NJD+sqQ+xHtPD4jF6g30548=;
        b=BsejVM8yaszT34v2QUXU9bEGgwIoAGxhYaAKDDXCf8BH+oKwLXi1ohZKkwX9go8c/ZM/4Y
        rHsyJTTFJsOY4SSSnclVMSptxgNkWwmzT/92sc6cTGnPQk4T3mIie1PUgE9ypfNLYxtKs3
        DY/GVp8VCwIdt2DIIeeeiYLsb6lb1Cs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-Df2-Yun3PwKWMZjmbptjew-1; Tue, 02 Jun 2020 12:45:50 -0400
X-MC-Unique: Df2-Yun3PwKWMZjmbptjew-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 838F1100CCC0;
        Tue,  2 Jun 2020 16:45:49 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 165CB7E7C0;
        Tue,  2 Jun 2020 16:45:48 +0000 (UTC)
Date:   Tue, 2 Jun 2020 12:45:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/30] xfs: mark dquot buffers in cache
Message-ID: <20200602164547.GE7967@bfoster>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-6-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:26AM +1000, Dave Chinner wrote:
> dquot buffers always have write IO callbacks, so by marking them
> directly we can avoid needing to attach ->b_iodone functions to
> them. This avoids an indirect call, and makes future modifications
> much simpler.
> 
> This is largely a rearrangement of the code at this point - no IO
> completion functionality changes at this point, just how the
> code is run is modified.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Similar question as on the previous patch wrt to xfs_trans_dquot_buf(),
but otherwise looks reasonable:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_buf.c       |  5 +++++
>  fs/xfs/xfs_buf.h       |  2 ++
>  fs/xfs/xfs_buf_item.c  | 10 ++++++++++
>  fs/xfs/xfs_buf_item.h  |  1 +
>  fs/xfs/xfs_dquot.c     |  1 +
>  fs/xfs/xfs_trans_buf.c |  1 +
>  6 files changed, 20 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index fcf650575be61..3bffde8640a52 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1212,6 +1212,11 @@ xfs_buf_ioend(
>  		return;
>  	}
>  
> +	if (bp->b_flags & _XBF_DQUOTS) {
> +		xfs_buf_dquot_iodone(bp);
> +		return;
> +	}
> +
>  	if (bp->b_iodone) {
>  		(*(bp->b_iodone))(bp);
>  		return;
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 2400cb90a04c6..c1d0843206dd6 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -32,6 +32,7 @@
>  
>  /* buffer type flags for write callbacks */
>  #define _XBF_INODES	 (1 << 16)/* inode buffer */
> +#define _XBF_DQUOTS	 (1 << 17)/* dquot buffer */
>  
>  /* flags used only internally */
>  #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
> @@ -54,6 +55,7 @@ typedef unsigned int xfs_buf_flags_t;
>  	{ XBF_STALE,		"STALE" }, \
>  	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
>  	{ _XBF_INODES,		"INODES" }, \
> +	{ _XBF_DQUOTS,		"DQUOTS" }, \
>  	{ _XBF_PAGES,		"PAGES" }, \
>  	{ _XBF_KMEM,		"KMEM" }, \
>  	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 8659cf4282a64..a42cdf9ccc47d 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1210,6 +1210,16 @@ xfs_buf_inode_iodone(
>  	xfs_buf_ioend_finish(bp);
>  }
>  
> +/*
> + * Dquot buffer iodone callback function.
> + */
> +void
> +xfs_buf_dquot_iodone(
> +	struct xfs_buf		*bp)
> +{
> +	xfs_buf_run_callbacks(bp);
> +	xfs_buf_ioend_finish(bp);
> +}
>  
>  /*
>   * This is the iodone() function for buffers which have been
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index a342933ad9b8d..27d13d29b5bbb 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -60,6 +60,7 @@ void	xfs_buf_attach_iodone(struct xfs_buf *,
>  void	xfs_buf_iodone_callbacks(struct xfs_buf *);
>  void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
>  void	xfs_buf_inode_iodone(struct xfs_buf *);
> +void	xfs_buf_dquot_iodone(struct xfs_buf *);
>  bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
>  
>  extern kmem_zone_t	*xfs_buf_item_zone;
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index d5b7f03e93c8d..2e2146fa0914c 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1179,6 +1179,7 @@ xfs_qm_dqflush(
>  	 * Attach an iodone routine so that we can remove this dquot from the
>  	 * AIL and release the flush lock once the dquot is synced to disk.
>  	 */
> +	bp->b_flags |= _XBF_DQUOTS;
>  	xfs_buf_attach_iodone(bp, xfs_qm_dqflush_done,
>  				  &dqp->q_logitem.qli_item);
>  
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 552d0869aa0fe..93d62cb864c15 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -788,5 +788,6 @@ xfs_trans_dquot_buf(
>  		break;
>  	}
>  
> +	bp->b_flags |= _XBF_DQUOTS;
>  	xfs_trans_buf_set_type(tp, bp, type);
>  }
> -- 
> 2.26.2.761.g0e0b3e54be
> 

