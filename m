Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 993F3C25B45
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Oct 2023 21:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjJWVWZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Oct 2023 17:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjJWVWZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2023 17:22:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EE0E8
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2023 14:22:23 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62B9C433C8;
        Mon, 23 Oct 2023 21:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698096142;
        bh=y1x3f8tGj2UDU36mWoZStKca7djWg6nQBrndkVEcA5A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZqyC2cenKOO47u/mSIcdz1HIXyveLcDVhJY4HtS+iFjC/CXzATaQHH4sAWEG2k3F6
         B4449R+6+v/3K8ugzH6srAeEKVryAeFAetXUxvRWySuHGjbs+Cr4QeUB1Zq0eK/wR4
         YVSk5HYDKGZpEpyMdTgtizzhudAgfJCrijotUAdj8/7URsDVW/jkVSZfabK+G3fREm
         hKL0EThlkkQPeJ6AyFyCTv+zFfNDJ+T+w8dzwvNgpVZYElRU+2MuMkBGPO/aOZoySZ
         XcoXXNY2zrxSWo2pyz7Ce7vJmFr5vsNB0gD7U0ZklH+qmrkGDAem66TI45KRTqu0KO
         PmEAlc54/Dj+w==
Date:   Mon, 23 Oct 2023 14:22:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: up(ic_sema) if flushing data device fails
Message-ID: <20231023212221.GV3195650@frogsfrogsfrogs>
References: <20231023181410.844000-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023181410.844000-1-leah.rumancik@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 23, 2023 at 11:14:10AM -0700, Leah Rumancik wrote:
> We flush the data device cache before we issue external log IO. Since
> 7d839e325af2, we check the return value of the flush, and if the flush
> failed, we shut down the log immediately and return. However, the
> iclog->ic_sema is left in a decremented state so let's add an up().
> Prior to this patch, xfs/438 would fail consistently when running with
> an external log device:
> 
> sync
>   -> xfs_log_force
>   -> xlog_write_iclog
>       -> down(&iclog->ic_sema)
>       -> blkdev_issue_flush (fail causes us to intiate shutdown)
>           -> xlog_force_shutdown
>           -> return
> 
> unmount
>   -> xfs_log_umount
>       -> xlog_wait_iclog_completion
>           -> down(&iclog->ic_sema) --------> HANG
> 
> There is a second early return / shutdown. Add an up() there as well.

Ow.  Yes, I think it's correct that both of those error returns need to
drop ic_sema since we don't submit_bio, so there is no xlog_ioend_work
to do it for us.

> Fixes: 7d839e325af2 ("xfs: check return codes when flushing block devices")

Hmm.  This bug was introduced in b5d721eaae47e ("xfs: external logs need
to flush data device"), not 7d839.  That said, this patch only applies
cleanly to 7d839e325af2.

b5d721 was introduced in 5.14 and 7d839 came in via 6.0, so ... this is
where I would have spat out:

Fixes: 7d839e325af2 ("xfs: check return codes when flushing block devices")
Actually-Fixes: b5d721eaae47e ("xfs: external logs need to flush data device")

> Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
> ---
> 
> Notes:
>     Tested auto group for xfs/4k and xfs/logdev configs with no regressions
>     seen.
> 
>  fs/xfs/xfs_log.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 51c100c86177..b4a8105299c2 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1926,6 +1926,7 @@ xlog_write_iclog(
>  		 */
>  		if (log->l_targ != log->l_mp->m_ddev_targp &&
>  		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev)) {
> +			up(&iclog->ic_sema);
>  			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
>  			return;
>  		}
> @@ -1936,6 +1937,7 @@ xlog_write_iclog(
>  	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
>  
>  	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count)) {
> +		up(&iclog->ic_sema);
>  		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);

I wonder if these two should both become a cleanup clause at the end?

		if (log->l_targ != log->l_mp->m_ddev_targp &&
		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev))
			goto shutdown;

...

	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count))
		goto shutdown;

...

	submit_bio(&iclog->ic_bio);
	return;

shutdown:
	up(&iclog->ic_sema);
	xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
}

Seeing as we've screwed this up twice now and not a whole lot of people
actually use external logs, and somehow I've never seen this on my test
fleet.

Anyway the code change looks correct so modulo the stylistic thing,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  		return;
>  	}
> -- 
> 2.42.0.758.gaed0368e0e-goog
> 
