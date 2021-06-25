Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9ECC2B9F4
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 20:52:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7513F61973
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 20:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhFYUyd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Jun 2021 16:54:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:50028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229573AbhFYUyc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Jun 2021 16:54:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 659056195F;
        Fri, 25 Jun 2021 20:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624654331;
        bh=1ogUzjtMMcg6K+7kZiiqjl6bbFUfMJcsiseQ3pZU2iY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D2g120dvF/zUkg5kC5TvkswVx4NhAafnob5LjkLCSV15+99jFKSICuwnpPhu5Xfo7
         TFi+WUqewX2owrpNyYB9S671v77KfwT5ADc0RpRfcIH9wqbbK+Z3iHmxYZK56417Kh
         QyjSoNFnJX6a5hof07AZZdmZHCrBFhN5EMBVzHDI2nKrln0KJYcpvwu7QOrELYeBRa
         S5CwToKV9vnFz4QJsnY2Dtf/4TgcZ2biWwa1gUowMMGESxqDQ0s7AcHEXrJlLm/c43
         2euRn/1THfI3N3dWJpk4Krl/mBX1VGa79pu7rdJsTLUJJr5Tn0pg4BBxEZCmPr93XW
         fTnSb25a2+QvA==
Date:   Fri, 25 Jun 2021 13:52:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: don't nest icloglock inside ic_callback_lock
Message-ID: <20210625205210.GB13784@locust>
References: <20210622040604.1290539-1-david@fromorbit.com>
 <20210622040604.1290539-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622040604.1290539-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 22, 2021 at 02:06:01PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It's completely unnecessary because callbacks are added to iclogs
> without holding the icloglock, hence no amount of ordering between
> the icloglock and ic_callback_lock will order the removal of
> callbacks from the iclog.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Seems reasonable so far -- we don't tangle the icloglock with the
callback lock anywhere like this.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 18 ++++--------------
>  1 file changed, 4 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index e93cac6b5378..bb4390942275 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2773,11 +2773,8 @@ static void
>  xlog_state_do_iclog_callbacks(
>  	struct xlog		*log,
>  	struct xlog_in_core	*iclog)
> -		__releases(&log->l_icloglock)
> -		__acquires(&log->l_icloglock)
>  {
>  	trace_xlog_iclog_callbacks_start(iclog, _RET_IP_);
> -	spin_unlock(&log->l_icloglock);
>  	spin_lock(&iclog->ic_callback_lock);
>  	while (!list_empty(&iclog->ic_callbacks)) {
>  		LIST_HEAD(tmp);
> @@ -2789,12 +2786,6 @@ xlog_state_do_iclog_callbacks(
>  		spin_lock(&iclog->ic_callback_lock);
>  	}
>  
> -	/*
> -	 * Pick up the icloglock while still holding the callback lock so we
> -	 * serialise against anyone trying to add more callbacks to this iclog
> -	 * now we've finished processing.
> -	 */
> -	spin_lock(&log->l_icloglock);
>  	spin_unlock(&iclog->ic_callback_lock);
>  	trace_xlog_iclog_callbacks_done(iclog, _RET_IP_);
>  }
> @@ -2836,13 +2827,12 @@ xlog_state_do_callback(
>  				iclog = iclog->ic_next;
>  				continue;
>  			}
> +			spin_unlock(&log->l_icloglock);
>  
> -			/*
> -			 * Running callbacks will drop the icloglock which means
> -			 * we'll have to run at least one more complete loop.
> -			 */
> -			cycled_icloglock = true;
>  			xlog_state_do_iclog_callbacks(log, iclog);
> +			cycled_icloglock = true;
> +
> +			spin_lock(&log->l_icloglock);
>  			if (XLOG_FORCED_SHUTDOWN(log))
>  				wake_up_all(&iclog->ic_force_wait);
>  			else
> -- 
> 2.31.1
> 
