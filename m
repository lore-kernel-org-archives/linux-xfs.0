Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8745C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 00:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B34765287
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 00:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhCIAPt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 19:15:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230512AbhCIAPY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 19:15:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2913614A7;
        Tue,  9 Mar 2021 00:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615248923;
        bh=vlHkCQiPW0XS+3LK4wBEjwMnN0wW8RHZFA6U8mG+kCM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HJRKt9disq14PJXiLvTHL+PGLmbFIRbwpqNp3OGKnPGrjLKLM1jG4MfYeKpuFMeTB
         6FzWyk3r4/nt3h8Ob0adrBmamR0ReW1diJo1D9nf867MFsUJE138I70JZywjIAdy6e
         iNc52jSknGlOL8qVcNUmw4NYStakgE5PBuArHGErSznxJQOWaIr1KgmXNy3FWyYA6C
         uJNObRXCSECCWvm5/RAqgWXPLVgmyalGcryxp5+mMXwoi+xsxaWecDEIB5+zuBW9w5
         yrpfqxMgnnSYnYetj2Xhtv2B+VB0LDupP3L+iqkzuP1d5tpbwSJASTUqlv1xMkqdUV
         Q/gZJSdVzdYZw==
Date:   Mon, 8 Mar 2021 16:15:23 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/45] xfs: embed the xlog_op_header in the unmount record
Message-ID: <20210309001523.GH3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-22-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-22-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:19PM +1100, Dave Chinner wrote:
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
> ---
>  fs/xfs/xfs_log.c | 35 ++++++++++++++++++++++++-----------
>  1 file changed, 24 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index b2f9fb1b4fed..94711b9ff007 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -798,12 +798,22 @@ xlog_write_unmount_record(
>  	struct xlog		*log,
>  	struct xlog_ticket	*ticket)
>  {
> -	struct xfs_unmount_log_format ulf = {
> -		.magic = XLOG_UNMOUNT_TYPE,
> +	struct  {
> +		struct xlog_op_header ophdr;
> +		struct xfs_unmount_log_format ulf;
> +	} unmount_rec = {

I wonder, should we have a BUILD_BUG_ON to confirm sizeof(umount_rec)
just in case some weird architecture injects padding between these two?
Prior to this code we formatted the op header and unmount record in
separate incore buffers and wrote them to disk with no gap, right?

--D

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
> @@ -812,7 +822,7 @@ xlog_write_unmount_record(
>  	};
>  
>  	/* account for space used by record data */
> -	ticket->t_curr_res -= sizeof(ulf);
> +	ticket->t_curr_res -= sizeof(unmount_rec);
>  
>  	/*
>  	 * For external log devices, we need to flush the data device cache
> @@ -2138,6 +2148,8 @@ xlog_write_calc_vec_length(
>  
>  	/* Don't account for regions with embedded ophdrs */
>  	if (optype && headers > 0) {
> +		if (optype & XLOG_UNMOUNT_TRANS)
> +			headers--;
>  		if (optype & XLOG_START_TRANS) {
>  			ASSERT(headers >= 2);
>  			headers -= 2;
> @@ -2352,12 +2364,11 @@ xlog_write(
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
> @@ -2428,6 +2439,8 @@ xlog_write(
>  				ophdr = reg->i_addr;
>  				if (index)
>  					optype &= ~XLOG_START_TRANS;
> +			} else if (optype & XLOG_UNMOUNT_TRANS) {
> +				ophdr = reg->i_addr;
>  			} else {
>  				ophdr = xlog_write_setup_ophdr(log, ptr,
>  							ticket, optype);
> @@ -2458,7 +2471,7 @@ xlog_write(
>  			/*
>  			 * Copy region.
>  			 *
> -			 * Commit and unmount records just log an opheader, so
> +			 * Commit records just log an opheader, so
>  			 * we can have empty payloads with no data region to
>  			 * copy.  Hence we only copy the payload if the vector
>  			 * says it has data to copy.
> -- 
> 2.28.0
> 
