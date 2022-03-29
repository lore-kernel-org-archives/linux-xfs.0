Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F16B7C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Mar 2022 00:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbiC2AjD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Mar 2022 20:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiC2AjC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Mar 2022 20:39:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5991F9FE3
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 17:37:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAF91B815A5
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 00:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B2FC340F0;
        Tue, 29 Mar 2022 00:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648514238;
        bh=NJGG3+jRpJ7yszpt3mhFNpEjQPN0Du63fFRUDvB5St8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EsB2v+SEeE/21GwJLqKNLgL0utEaGZztM/wVaDnEcSIhgnLX6WBnr1FPZ2gfH91a6
         4A44057Fv4RaBkVp+LizoafUQktHysD2DjcCM6Fe5/xAYeTGePrG6nremBwNE/qRsI
         ViM1SD/PEqF0tIv7jjgp+MtJSK5JT6QFLu+QJgUsTPkN3mYlzj/nvoO9V1ydOOyJiR
         hKg1XamCT82/rwto91UAXgM9iU0HAL8S/Wd4eHokVMeqjVRrx1rzH3bkDXqcFCZ4Zw
         sj+3xcSV/Ed43eyJLI36DPNL8EWVFZlmglQSjbwmqEImSNa6fVQ8lUG+3d6jmY8nO1
         oQdT17fTRRGkQ==
Date:   Mon, 28 Mar 2022 17:37:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/6] xfs: xfs: shutdown during log recovery needs to mark
 the log shutdown
Message-ID: <20220329003717.GE27690@magnolia>
References: <20220324002103.710477-1-david@fromorbit.com>
 <20220327225534.GQ1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220327225534.GQ1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 28, 2022 at 09:55:34AM +1100, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> When a checkpoint writeback is run by log recovery, corruption
> propagated from the log can result in writeback verifiers failing
> and calling xfs_force_shutdown() from
> xfs_buf_delwri_submit_buffers().
> 
> This results in the mount being marked as shutdown, but the log does
> not get marked as shut down because:
> 
>         /*
>          * If this happens during log recovery then we aren't using the runtime
>          * log mechanisms yet so there's nothing to shut down.
>          */
>         if (!log || xlog_in_recovery(log))
>                 return false;
> 
> If there are other buffers that then fail (say due to detecting the
> mount shutdown), they will now hang in xfs_do_force_shutdown()
> waiting for the log to shut down like this:
> 
>   __schedule+0x30d/0x9e0
>   schedule+0x55/0xd0
>   xfs_do_force_shutdown+0x1cd/0x200
>   ? init_wait_var_entry+0x50/0x50
>   xfs_buf_ioend+0x47e/0x530
>   __xfs_buf_submit+0xb0/0x240
>   xfs_buf_delwri_submit_buffers+0xfe/0x270
>   xfs_buf_delwri_submit+0x3a/0xc0
>   xlog_do_recovery_pass+0x474/0x7b0
>   ? do_raw_spin_unlock+0x30/0xb0
>   xlog_do_log_recovery+0x91/0x140
>   xlog_do_recover+0x38/0x1e0
>   xlog_recover+0xdd/0x170
>   xfs_log_mount+0x17e/0x2e0
>   xfs_mountfs+0x457/0x930
>   xfs_fs_fill_super+0x476/0x830
> 
> xlog_force_shutdown() always needs to mark the log as shut down,
> regardless of whether recovery is in progress or not, so that
> multiple calls to xfs_force_shutdown() during recovery don't end
> up waiting for the log to be shut down like this.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

That sounds like a pretty straightforward premise.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 6166348ce1d1..5f3f943c34b9 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3729,11 +3729,7 @@ xlog_force_shutdown(
>  {
>  	bool		log_error = (shutdown_flags & SHUTDOWN_LOG_IO_ERROR);
>  
> -	/*
> -	 * If this happens during log recovery then we aren't using the runtime
> -	 * log mechanisms yet so there's nothing to shut down.
> -	 */
> -	if (!log || xlog_in_recovery(log))
> +	if (!log)
>  		return false;
>  
>  	/*
> @@ -3742,10 +3738,16 @@ xlog_force_shutdown(
>  	 * before the force will prevent the log force from flushing the iclogs
>  	 * to disk.
>  	 *
> -	 * Re-entry due to a log IO error shutdown during the log force is
> -	 * prevented by the atomicity of higher level shutdown code.
> +	 * When we are in recovery, there are no transactions to flush, and
> +	 * we don't want to touch the log because we don't want to perturb the
> +	 * current head/tail for future recovery attempts. Hence we need to
> +	 * avoid a log force in this case.
> +	 *
> +	 * If we are shutting down due to a log IO error, then we must avoid
> +	 * trying to write the log as that may just result in more IO errors and
> +	 * an endless shutdown/force loop.
>  	 */
> -	if (!log_error)
> +	if (!log_error && !xlog_in_recovery(log))
>  		xfs_log_force(log->l_mp, XFS_LOG_SYNC);
>  
>  	/*
