Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1813C83000
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 15:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBAC7205C9
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 15:13:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LLdTFIuD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgD1PN0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 11:13:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44973 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727108AbgD1PN0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 11:13:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588086805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G9otsS7VQhX2yPYILXlwXDsk8PVw/glWW1AHqkgqhaI=;
        b=LLdTFIuDF38JZKCv+L74nEVWVtPRURCLTAH92LcrYRVJ6NC7nECCDoFTVG7pIYXT6B7yE8
        mv96txvt7/Q3lVmjSmfqrKbrpO0CDY7q0Xh+fecsDD0s/kYrALJtZ6xEDDbdGTdpfFDfk6
        uqgmicHiaI8VT6dQg8JvDVcnk38FKaQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-yHHXywX3MzyrAp1ub-mxbQ-1; Tue, 28 Apr 2020 11:13:22 -0400
X-MC-Unique: yHHXywX3MzyrAp1ub-mxbQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD30C835BC2;
        Tue, 28 Apr 2020 15:13:21 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 873645D9E5;
        Tue, 28 Apr 2020 15:13:21 +0000 (UTC)
Date:   Tue, 28 Apr 2020 11:13:19 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/2] xfs: refactor xlog_recover_buffer_pass1
Message-ID: <20200428151319.GE27954@bfoster>
References: <20200428080550.GA20138@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428080550.GA20138@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 28, 2020 at 10:05:50AM +0200, Christoph Hellwig wrote:
> Split out a xlog_add_buffer_cancelled helper which does the low-level
> manipulation of the buffer cancelation table, and in that helper call
> xlog_find_buffer_cancelled instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log_recover.c | 114 +++++++++++++++++++--------------------
>  1 file changed, 55 insertions(+), 59 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index fe4dad5b77a95..3bc61838266f1 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
...
> @@ -2045,6 +2015,32 @@ xlog_buf_readahead(
>  		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
>  }
>  
> +/*
> + * Build up the table of buf cancel records so that we don't replay cancelled
> + * data in the second pass.
> + */
> +static int
> +xlog_recover_buffer_pass1(
> +	struct xlog			*log,
> +	struct xlog_recover_item	*item)
> +{
> +	struct xfs_buf_log_format	*bf = item->ri_buf[0].i_addr;
> +
> +	if (!xfs_buf_log_check_iovec(&item->ri_buf[0])) {
> +		xfs_err(log->l_mp, "bad buffer log item size (%d)",
> +				item->ri_buf[0].i_len);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	if (!(bf->blf_flags & XFS_BLF_CANCEL))
> +		trace_xfs_log_recover_buf_not_cancel(log, bf);
> +	else if (xlog_add_buffer_cancelled(log, bf->blf_blkno, bf->blf_len))
> +		trace_xfs_log_recover_buf_cancel_add(log, bf);
> +	else
> +		trace_xfs_log_recover_buf_cancel_ref_inc(log, bf);

Nit, but the function call looks buried here. Also, the boolean return
seems like overkill if it's only used to control tracepoints (and
true/false for inc/ref isn't terribly intuitive anyways).

This looks cleaner to me if it's just:

	if (!XFS_BLF_CANCEL) {
		trace_xfs_log_recover_buf_not_cancel(log, bf);
		return 0;
	}

	xlog_add_buffer_cancelled(log, bf->blf_blkno, bf->blf_len);
	return 0;

... and let the helper invoke the buf_cancel tracepoints and return
void. Otherwise looks like a good cleanup to me.

Brian

> +	return 0;
> +}
> +
>  /*
>   * Perform recovery for a buffer full of inodes.  In these buffers, the only
>   * data which should be recovered is that which corresponds to the
> -- 
> 2.26.1
> 

