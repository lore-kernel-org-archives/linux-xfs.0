Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B63C63797
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 18:20:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 100A360454
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Jul 2021 18:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhGVReM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Jul 2021 13:34:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhGVReL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jul 2021 13:34:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71E0D603E6;
        Thu, 22 Jul 2021 18:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626977686;
        bh=Ti1Yxc7T7Eude48D1dPxA51l+W30zssDh7FHzQOsS54=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ksSM+Aw0/dQfYbb/ZtWmkRnW4ALLellX5Cir91Ib0HamtHfSmhDLwC7I1Y7+l763Z
         Z9R8zgiBcfrofAzPW2WQRagKD1sfI8Jx4nxExHRymlOqpJ6dPNnM7E+0dqchgUi9+q
         p+GOGCzRRxpLZrL6uj2D5UHE2gDu7EULuR+Eux8qMFpJPmqd94i/ok+SD89yTJDfrW
         68SDXoe9D7FpAUIkfpm9MLO+VWufZju29f6XjqY3WfN0WFK5AvykXTRhVUJm97QOPW
         RmtNJk//bUegS87Qu5lPYpKPD98Akb6vTb0YldEosVtpHgNrcG/x+uumZobBU31SzT
         uaTkgHWkzetPQ==
Date:   Thu, 22 Jul 2021 11:14:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: external logs need to flush data device
Message-ID: <20210722181445.GA559212@magnolia>
References: <20210722015335.3063274-1-david@fromorbit.com>
 <20210722015335.3063274-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722015335.3063274-3-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 11:53:32AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The recent journal flush/FUA changes replaced the flushing of the
> data device on every iclog write with an up-front async data device
> cache flush. Unfortunately, the assumption of which this was based
> on has been proven incorrect by the flush vs log tail update
> ordering issue. As the fix for that issue uses the
> XLOG_ICL_NEED_FLUSH flag to indicate that data device needs a cache
> flush, we now need to (once again) ensure that an iclog write to
> external logs that need a cache flush to be issued actually issue a
> cache flush to the data device as well as the log device.
> 
> Fixes: eef983ffeae7 ("xfs: journal IO cache flush reductions")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 96434cc4df6e..a3c4d48195d9 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -827,13 +827,6 @@ xlog_write_unmount_record(
>  	/* account for space used by record data */
>  	ticket->t_curr_res -= sizeof(ulf);
>  
> -	/*
> -	 * For external log devices, we need to flush the data device cache
> -	 * first to ensure all metadata writeback is on stable storage before we
> -	 * stamp the tail LSN into the unmount record.
> -	 */
> -	if (log->l_targ != log->l_mp->m_ddev_targp)
> -		blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev);
>  	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS);
>  }
>  
> @@ -1796,10 +1789,20 @@ xlog_write_iclog(
>  	 * metadata writeback and causing priority inversions.
>  	 */
>  	iclog->ic_bio.bi_opf = REQ_OP_WRITE | REQ_META | REQ_SYNC | REQ_IDLE;
> -	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH)
> +	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH) {
>  		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
> +		/*
> +		 * For external log devices, we also need to flush the data
> +		 * device cache first to ensure all metadata writeback covered
> +		 * by the LSN in this iclog is on stable storage. This is slow,
> +		 * but it *must* complete before we issue the external log IO.

I'm a little confused about what's going on here.  We're about to write
a log record to disk, with h_tail_lsn reflecting the tail of the log and
h_lsn reflecting the current head of the log (i.e. this record).

If the log tail has moved forward since the last log record was written
and this fs has an external log, we need to flush the data device
because the AIL could have written logged items back into the filesystem
and we need to ensure those items have been persisted before we write to
the log the fact that the tail moved forward.  The AIL itself doesn't
issue cache flushes (nor does it need to), so that's why we do that
here.

Why don't we need a flush like this if only FUA is set?  Is it not
possible to write a checkpoint that fits within a single iclog after the
log tail has moved forward?

--D

> +		 */
> +		if (log->l_targ != log->l_mp->m_ddev_targp)
> +			blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev);
> +	}
>  	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
>  		iclog->ic_bio.bi_opf |= REQ_FUA;
> +
>  	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
>  
>  	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count)) {
> -- 
> 2.31.1
> 
