Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46B9FC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Mar 2022 00:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbiC2AVD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Mar 2022 20:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbiC2AVD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Mar 2022 20:21:03 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF2DE0C9
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 17:19:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F1C20CE17A3
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 00:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD98C340EC;
        Tue, 29 Mar 2022 00:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648513158;
        bh=emByNcVqdW8mjSsqNClzImSYwWhRuABavNnnXSS8cxc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M4KkwdqLL09/Jw/es+HLnnJxdIiLuHMUzSGUtKneBhTJoIIFwQo7VMeTpNAjMVZaR
         vg38q6zLiLaIYSId0RNxJMNH5USooRNNEaRTegP/apQ5HTf7WJRGbfD6wAjwPs1NMw
         0lennPvbJpsdLNJ5IBJbVQNn+mVWq+HaZTduUDjGXzdGrdGkoTPZIizKxiNmbeHskm
         VzesMP+Ma+CJqxFcQmk/ce1zv130kaWFk+n9fASVKlsFX1hf9fYJf2AcxkR0OT+nuR
         Qbypfue6si0jxYvtd++h3sw8lYnGQCFlOoFqdLzpkU300JXs7Wm6C95EsPeCEF7O4k
         D54R87pgd7cUQ==
Date:   Mon, 28 Mar 2022 17:19:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: xfs_do_force_shutdown needs to block racing
 shutdowns
Message-ID: <20220329001917.GD27713@magnolia>
References: <20220324002103.710477-1-david@fromorbit.com>
 <20220324002103.710477-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324002103.710477-6-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 24, 2022 at 11:21:02AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we call xfs_forced_shutdown(), the caller often expects the
> filesystem to be completely shut down when it returns. However,
> if we have racing xfs_forced_shutdown() calls, the first caller sets
> the mount shutdown flag then goes to shutdown the log. The second
> caller sees the mount shutdown flag and returns immediately - it
> does not wait for the log to be shut down.
> 
> Unfortunately, xfs_forced_shutdown() is used in some places that
> expect it to completely shut down the filesystem before it returns
> (e.g. xfs_trans_log_inode()). As such, returning before the log has
> been shut down leaves us in a place where the transaction failed to
> complete correctly but we still call xfs_trans_commit(). This
> situation arises because xfs_trans_log_inode() does not return an
> error and instead calls xfs_force_shutdown() to ensure that the
> transaction being committed is aborted.
> 
> Unfortunately, we have a race condition where xfs_trans_commit()
> needs to check xlog_is_shutdown() because it can't abort log items
> before the log is shut down, but it needs to use xfs_is_shutdown()
> because xfs_forced_shutdown() does not block waiting for the log to
> shut down.
> 
> To fix this conundrum, first we make all calls to
> xfs_forced_shutdown() block until the log is also shut down. This
> means we can then safely use xfs_forced_shutdown() as a mechanism
> that ensures the currently running transaction will be aborted by
> xfs_trans_commit() regardless of the shutdown check it uses.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I always feel dirty looking at what __var_waitqueue does, but this does
make sense that everything must be shut down by the time
xfs_force_shutdown returns.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_fsops.c    |  6 +++++-
>  fs/xfs/xfs_log.c      |  1 +
>  fs/xfs/xfs_log_priv.h | 11 +++++++++++
>  3 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 33e26690a8c4..093a44aecec0 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -17,6 +17,7 @@
>  #include "xfs_fsops.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_log.h"
> +#include "xfs_log_priv.h"
>  #include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  #include "xfs_trace.h"
> @@ -528,8 +529,11 @@ xfs_do_force_shutdown(
>  	int		tag;
>  	const char	*why;
>  
> -	if (test_and_set_bit(XFS_OPSTATE_SHUTDOWN, &mp->m_opstate))
> +
> +	if (test_and_set_bit(XFS_OPSTATE_SHUTDOWN, &mp->m_opstate)) {
> +		xlog_shutdown_wait(mp->m_log);
>  		return;
> +	}
>  	if (mp->m_sb_bp)
>  		mp->m_sb_bp->b_flags |= XBF_DONE;
>  
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 6879d6d19d68..4336eb804a4a 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3909,6 +3909,7 @@ xlog_force_shutdown(
>  	xlog_state_shutdown_callbacks(log);
>  	spin_unlock(&log->l_icloglock);
>  
> +	wake_up_var(&log->l_opstate);
>  	return log_error;
>  }
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 80d77aac6fe4..401cdc400980 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -484,6 +484,17 @@ xlog_is_shutdown(struct xlog *log)
>  	return test_bit(XLOG_IO_ERROR, &log->l_opstate);
>  }
>  
> +/*
> + * Wait until the xlog_force_shutdown() has marked the log as shut down
> + * so xlog_is_shutdown() will always return true.
> + */
> +static inline void
> +xlog_shutdown_wait(
> +	struct xlog	*log)
> +{
> +	wait_var_event(&log->l_opstate, xlog_is_shutdown(log));
> +}
> +
>  /* common routines */
>  extern int
>  xlog_recover(
> -- 
> 2.35.1
> 
