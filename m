Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E20BC433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 00:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56C0E60C3E
	for <linux-xfs@archiver.kernel.org>; Fri, 21 May 2021 00:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235134AbhEUAgX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 May 2021 20:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235124AbhEUAgX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 May 2021 20:36:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCE936138C;
        Fri, 21 May 2021 00:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621557300;
        bh=GLncOGGwb3gF7djb+Xy6GdHGh0Mw4oLFEwu9yRqp/MY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uTzWAxXgCCv0fu+YzRi21NNudq0LnPll4jqI4VnpoOasK6nZ5iyKohZiGQJBooaIS
         wJBnwkfcbyqgXmwVU1+CXFe9Huk1Qe3sE1VARNtprQaIIG68If6EIZwp3eS0Mb06bg
         8xMFIPI8kwNEpRahx3l/HZtn1gl8viNd5WQFR+CdZDhqzcJcrJUCSXx39a4w6ZjzuK
         +hvmh0GjOeUoyJU6aL6L62MJIbJFLvw0cDqWr+OHpm8Vwdk2bYGLmLXbS5QvVdP7dt
         GbDhxlIukLO7o0ZoNL6nFliBkgUZWh/2ucfhnKSxphsWrMj12lF4HnIGFxm3CWjKO7
         odFD8iQwnqr8Q==
Date:   Thu, 20 May 2021 17:35:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/39] xfs: embed the xlog_op_header in the unmount record
Message-ID: <20210521003500.GI9675@magnolia>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-15-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519121317.585244-15-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 10:12:52PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Remove another case where xlog_write() has to prepend an opheader to
> a log transaction. The unmount record + ophdr is smaller than the
> minimum amount of space guaranteed to be free in an iclog (2 *
> sizeof(ophdr)) and so we don't have to care about an unmount record
> being split across 2 iclogs.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

I love me some BUILD_BUG_ON, so

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 39 ++++++++++++++++++++++++++++-----------
>  1 file changed, 28 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 981cd6f8f0ff..e7a135ffa66f 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -800,12 +800,22 @@ xlog_write_unmount_record(
>  	struct xlog		*log,
>  	struct xlog_ticket	*ticket)
>  {
> -	struct xfs_unmount_log_format ulf = {
> -		.magic = XLOG_UNMOUNT_TYPE,
> +	struct  {
> +		struct xlog_op_header ophdr;
> +		struct xfs_unmount_log_format ulf;
> +	} unmount_rec = {
> +		.ophdr = {
> +			.oh_clientid = XFS_LOG,
> +			.oh_tid = cpu_to_be32(ticket->t_tid),
> +			.oh_flags = XLOG_UNMOUNT_TRANS,
> +		},
> +		.ulf = {
> +			.magic = XLOG_UNMOUNT_TYPE,
> +		},
>  	};
>  	struct xfs_log_iovec reg = {
> -		.i_addr = &ulf,
> -		.i_len = sizeof(ulf),
> +		.i_addr = &unmount_rec,
> +		.i_len = sizeof(unmount_rec),
>  		.i_type = XLOG_REG_TYPE_UNMOUNT,
>  	};
>  	struct xfs_log_vec vec = {
> @@ -813,8 +823,12 @@ xlog_write_unmount_record(
>  		.lv_iovecp = &reg,
>  	};
>  
> +	BUILD_BUG_ON((sizeof(struct xlog_op_header) +
> +		      sizeof(struct xfs_unmount_log_format)) !=
> +							sizeof(unmount_rec));
> +
>  	/* account for space used by record data */
> -	ticket->t_curr_res -= sizeof(ulf);
> +	ticket->t_curr_res -= sizeof(unmount_rec);
>  
>  	/*
>  	 * For external log devices, we need to flush the data device cache
> @@ -2145,6 +2159,8 @@ xlog_write_calc_vec_length(
>  
>  	/* Don't account for regions with embedded ophdrs */
>  	if (optype && headers > 0) {
> +		if (optype & XLOG_UNMOUNT_TRANS)
> +			headers--;
>  		if (optype & XLOG_START_TRANS) {
>  			ASSERT(headers >= 2);
>  			headers -= 2;
> @@ -2359,12 +2375,11 @@ xlog_write(
>  
>  	/*
>  	 * If this is a commit or unmount transaction, we don't need a start
> -	 * record to be written.  We do, however, have to account for the
> -	 * commit or unmount header that gets written. Hence we always have
> -	 * to account for an extra xlog_op_header here for commit and unmount
> -	 * records.
> +	 * record to be written.  We do, however, have to account for the commit
> +	 * header that gets written. Hence we always have to account for an
> +	 * extra xlog_op_header here for commit records.
>  	 */
> -	if (optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS))
> +	if (optype & XLOG_COMMIT_TRANS)
>  		ticket->t_curr_res -= sizeof(struct xlog_op_header);
>  	if (ticket->t_curr_res < 0) {
>  		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
> @@ -2424,6 +2439,8 @@ xlog_write(
>  				ophdr = reg->i_addr;
>  				if (index)
>  					optype &= ~XLOG_START_TRANS;
> +			} else if (optype & XLOG_UNMOUNT_TRANS) {
> +				ophdr = reg->i_addr;
>  			} else {
>  				ophdr = xlog_write_setup_ophdr(log, ptr,
>  							ticket, optype);
> @@ -2454,7 +2471,7 @@ xlog_write(
>  			/*
>  			 * Copy region.
>  			 *
> -			 * Commit and unmount records just log an opheader, so
> +			 * Commit records just log an opheader, so
>  			 * we can have empty payloads with no data region to
>  			 * copy.  Hence we only copy the payload if the vector
>  			 * says it has data to copy.
> -- 
> 2.31.1
> 
