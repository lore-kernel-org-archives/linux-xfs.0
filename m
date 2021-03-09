Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4613FC433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 00:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 082E26528D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 00:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbhCIASA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 19:18:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:47432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230070AbhCIARb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 19:17:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1E97614A7;
        Tue,  9 Mar 2021 00:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615249051;
        bh=yFAk55/8T80HFn81si56v5l/1xOoPmvul7WwpUdkUJU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G5+4WBjXUQDgqfoh0e1AZLYILcTH0YyjrrVhbUx6E2OYbcap+fXPUDHbUl5uRr25U
         7eQtZRBCz9WeTIl/M1JBi9aBx5raOxU6e4kvya/fvdj5POlBDoYdAMEyAnAEIHp2VQ
         JRDqskrmsAfqoDkkxo8VDhjAqSHXWGSDMQtrOpmoZxDjL2JgUhAPj1qI1HT0zYMnA2
         naxhUFVmV2aEro3yernxKG4XwkVIVtXHvbXDr64+g6rDGea6mTZIzmRd7dhfY9jbis
         u0xjEngaao26VFlEXJ5HN46oMeLPKvnAZxRKumf9QX5PbPnxjB6/4GYIlcAEhf1KQ0
         Ot5gp0AlvwUow==
Date:   Mon, 8 Mar 2021 16:17:30 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/45] xfs: embed the xlog_op_header in the commit record
Message-ID: <20210309001730.GI3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-23-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-23-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:20PM +1100, Dave Chinner wrote:
> Remove the final case where xlog_write() has to prepend an opheader
> to a log transaction. Similar to the start record, the commit record
> is just an empty opheader with a XLOG_COMMIT_TRANS type, so we can
> just make this the payload for the region being passed to
> xlog_write() and remove the special handling in xlog_write() for
> the commit record.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks sane enough...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 33 +++++++++++++++------------------
>  1 file changed, 15 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 94711b9ff007..c2e69a1f5cad 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1529,9 +1529,14 @@ xlog_commit_record(
>  	struct xlog_in_core	**iclog,
>  	xfs_lsn_t		*lsn)
>  {
> +	struct xlog_op_header	ophdr = {
> +		.oh_clientid = XFS_TRANSACTION,
> +		.oh_tid = cpu_to_be32(ticket->t_tid),
> +		.oh_flags = XLOG_COMMIT_TRANS,
> +	};
>  	struct xfs_log_iovec reg = {
> -		.i_addr = NULL,
> -		.i_len = 0,
> +		.i_addr = &ophdr,
> +		.i_len = sizeof(struct xlog_op_header),
>  		.i_type = XLOG_REG_TYPE_COMMIT,
>  	};
>  	struct xfs_log_vec vec = {
> @@ -1543,6 +1548,8 @@ xlog_commit_record(
>  	if (XLOG_FORCED_SHUTDOWN(log))
>  		return -EIO;
>  
> +	/* account for space used by record data */
> +	ticket->t_curr_res -= reg.i_len;
>  	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS);
>  	if (error)
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
> @@ -2148,11 +2155,10 @@ xlog_write_calc_vec_length(
>  
>  	/* Don't account for regions with embedded ophdrs */
>  	if (optype && headers > 0) {
> -		if (optype & XLOG_UNMOUNT_TRANS)
> -			headers--;
> +		headers--;
>  		if (optype & XLOG_START_TRANS) {
> -			ASSERT(headers >= 2);
> -			headers -= 2;
> +			ASSERT(headers >= 1);
> +			headers--;
>  		}
>  	}
>  
> @@ -2362,14 +2368,6 @@ xlog_write(
>  	int			data_cnt = 0;
>  	int			error = 0;
>  
> -	/*
> -	 * If this is a commit or unmount transaction, we don't need a start
> -	 * record to be written.  We do, however, have to account for the commit
> -	 * header that gets written. Hence we always have to account for an
> -	 * extra xlog_op_header here for commit records.
> -	 */
> -	if (optype & XLOG_COMMIT_TRANS)
> -		ticket->t_curr_res -= sizeof(struct xlog_op_header);
>  	if (ticket->t_curr_res < 0) {
>  		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
>  		     "ctx ticket reservation ran out. Need to up reservation");
> @@ -2433,14 +2431,13 @@ xlog_write(
>  			/*
>  			 * The XLOG_START_TRANS has embedded ophdrs for the
>  			 * start record and transaction header. They will always
> -			 * be the first two regions in the lv chain.
> +			 * be the first two regions in the lv chain. Commit and
> +			 * unmount records also have embedded ophdrs.
>  			 */
> -			if (optype & XLOG_START_TRANS) {
> +			if (optype) {
>  				ophdr = reg->i_addr;
>  				if (index)
>  					optype &= ~XLOG_START_TRANS;
> -			} else if (optype & XLOG_UNMOUNT_TRANS) {
> -				ophdr = reg->i_addr;
>  			} else {
>  				ophdr = xlog_write_setup_ophdr(log, ptr,
>  							ticket, optype);
> -- 
> 2.28.0
> 
