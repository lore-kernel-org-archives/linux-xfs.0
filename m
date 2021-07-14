Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4317FC12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 22:12:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28E44613C5
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 22:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbhGNWPZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 18:15:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231407AbhGNWPZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 18:15:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CFCE6101B;
        Wed, 14 Jul 2021 22:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626300753;
        bh=kN6RSbTIn9glxkPybSiwofPLQkbRtWRQzS7lp9/evQ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oLPq1xyMPE3Zp0il0UHWMOQ8KdlC1NkQU7TL8LN2+nmfY6BEwlategIAHzQmviJvy
         1dBGPlfPMdDGSZu1BVCz+tKcLqByOeQZV2x4nUviShv8EhBZlG/1WhnZk6bMEgVAcq
         KvnRIpXgsfLv5U6gZVYFpWY6gI1jYhYAD7FjGFGE63w49KApRghLgUtHGN7BBgNpX4
         k4QfXmY/mIJujww4PTV2x6QaEazYA/vnm3Rsej/TaeIYwP8sZs9y+Ank3z6N2E/bvE
         iYTHig8Tjf+52v6zEmsMamHC29XbFTURRcDe29W7/6aga//vKE4X5UXfL4OdrPi9Vg
         /DvykKgJjuLmg==
Date:   Wed, 14 Jul 2021 15:12:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: log head and tail aren't reliable during
 shutdown
Message-ID: <20210714221232.GR22402@magnolia>
References: <20210714031958.2614411-1-david@fromorbit.com>
 <20210714031958.2614411-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714031958.2614411-10-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 01:19:58PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> I'm seeing assert failures from xlog_space_left() after a shutdown
> has begun that look like:
> 
> XFS (dm-0): log I/O error -5
> XFS (dm-0): xfs_do_force_shutdown(0x2) called from line 1338 of file fs/xfs/xfs_log.c. Return address = xlog_ioend_work+0x64/0xc0
> XFS (dm-0): Log I/O Error Detected.
> XFS (dm-0): Shutting down filesystem. Please unmount the filesystem and rectify the problem(s)
> XFS (dm-0): xlog_space_left: head behind tail
> XFS (dm-0):   tail_cycle = 6, tail_bytes = 2706944
> XFS (dm-0):   GH   cycle = 6, GH   bytes = 1633867
> XFS: Assertion failed: 0, file: fs/xfs/xfs_log.c, line: 1310
> ------------[ cut here ]------------
> Call Trace:
>  xlog_space_left+0xc3/0x110
>  xlog_grant_push_threshold+0x3f/0xf0
>  xlog_grant_push_ail+0x12/0x40
>  xfs_log_reserve+0xd2/0x270
>  ? __might_sleep+0x4b/0x80
>  xfs_trans_reserve+0x18b/0x260
> .....
> 
> There are two things here. Firstly, after a shutdown, the log head
> and tail can be out of whack as things abort and release (or don't
> release) resources, so checking them for sanity doesn't make much
> sense. Secondly, xfs_log_reserve() can race with shutdown and so it
> can still fail like this even though it has already checked for a
> log shutdown before calling xlog_grant_push_ail().
> 
> So, before ASSERT failing in xlog_space_left(), make sure we haven't
> already shut down....
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Makes sense,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 51 +++++++++++++++++++++++++-----------------------
>  1 file changed, 27 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 01c20b42b2fc..6617cdccaf00 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1272,16 +1272,18 @@ xlog_assign_tail_lsn(
>   * wrap the tail, we should blow up.  Rather than catch this case here,
>   * we depend on other ASSERTions in other parts of the code.   XXXmiken
>   *
> - * This code also handles the case where the reservation head is behind
> - * the tail.  The details of this case are described below, but the end
> - * result is that we return the size of the log as the amount of space left.
> + * If reservation head is behind the tail, we have a problem. Warn about it,
> + * but then treat it as if the log is empty.
> + *
> + * If the log is shut down, the head and tail may be invalid or out of whack, so
> + * shortcut invalidity asserts in this case so that we don't trigger them
> + * falsely.
>   */
>  STATIC int
>  xlog_space_left(
>  	struct xlog	*log,
>  	atomic64_t	*head)
>  {
> -	int		free_bytes;
>  	int		tail_bytes;
>  	int		tail_cycle;
>  	int		head_cycle;
> @@ -1291,29 +1293,30 @@ xlog_space_left(
>  	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_bytes);
>  	tail_bytes = BBTOB(tail_bytes);
>  	if (tail_cycle == head_cycle && head_bytes >= tail_bytes)
> -		free_bytes = log->l_logsize - (head_bytes - tail_bytes);
> -	else if (tail_cycle + 1 < head_cycle)
> +		return log->l_logsize - (head_bytes - tail_bytes);
> +	if (tail_cycle + 1 < head_cycle)
>  		return 0;
> -	else if (tail_cycle < head_cycle) {
> +
> +	/* Ignore potential inconsistency when shutdown. */
> +	if (xlog_is_shutdown(log))
> +		return log->l_logsize;
> +
> +	if (tail_cycle < head_cycle) {
>  		ASSERT(tail_cycle == (head_cycle - 1));
> -		free_bytes = tail_bytes - head_bytes;
> -	} else {
> -		/*
> -		 * The reservation head is behind the tail.
> -		 * In this case we just want to return the size of the
> -		 * log as the amount of space left.
> -		 */
> -		xfs_alert(log->l_mp, "xlog_space_left: head behind tail");
> -		xfs_alert(log->l_mp,
> -			  "  tail_cycle = %d, tail_bytes = %d",
> -			  tail_cycle, tail_bytes);
> -		xfs_alert(log->l_mp,
> -			  "  GH   cycle = %d, GH   bytes = %d",
> -			  head_cycle, head_bytes);
> -		ASSERT(0);
> -		free_bytes = log->l_logsize;
> +		return tail_bytes - head_bytes;
>  	}
> -	return free_bytes;
> +
> +	/*
> +	 * The reservation head is behind the tail. In this case we just want to
> +	 * return the size of the log as the amount of space left.
> +	 */
> +	xfs_alert(log->l_mp, "xlog_space_left: head behind tail");
> +	xfs_alert(log->l_mp, "  tail_cycle = %d, tail_bytes = %d",
> +		  tail_cycle, tail_bytes);
> +	xfs_alert(log->l_mp, "  GH   cycle = %d, GH   bytes = %d",
> +		  head_cycle, head_bytes);
> +	ASSERT(0);
> +	return log->l_logsize;
>  }
>  
>  
> -- 
> 2.31.1
> 
