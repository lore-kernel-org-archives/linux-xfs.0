Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A19C0032E
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Oct 2023 00:41:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjJZAlL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Oct 2023 20:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjJZAlK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2023 20:41:10 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA986DC
        for <linux-xfs@vger.kernel.org>; Wed, 25 Oct 2023 17:41:08 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-1dd71c0a41fso197156fac.2
        for <linux-xfs@vger.kernel.org>; Wed, 25 Oct 2023 17:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1698280868; x=1698885668; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GU2EF68TAyDnaqti8zYiMcurK2LAR5C/7QwilGDojM8=;
        b=zQoeyjti+F3sgMM9+Ww7bD72MsYzJwLCYYDniSIAcGlOrJqt+90BMpczQ1ZYH4vqtt
         Mg30Nk6RtOKs7P5uaoRl/QKUh1CBwQD4+KMBzbxYKkSiPlPkou2D7kWRcDF6HAMQGCDT
         Pf7SrxJN8hUtstbGlVBrJCWL79GuaSDfWf5dV0/r23cxh72CO9+nG2q02AfTeEJwodYj
         pLRTMasGX4ukOf6z9ZFBbGKvmamJWnbSc9ZHVSgtw314M/sBB32nfvuSIA7MQWSwWmAT
         pZGa1GKYgF2Ghk9iQlTqhVLFv4ck+SIYf980rTAnCnJ9RtirwvDwtgmT9CwvMBvq6cyX
         u7iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698280868; x=1698885668;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GU2EF68TAyDnaqti8zYiMcurK2LAR5C/7QwilGDojM8=;
        b=XTJlNy8cbfaNVCOyJId07hwclWjpkkDITKmEUf4FUBwY8V0UwY5GQxwhA0oM0VtgKd
         4cfUJ8ixOGnCMKSfQ+IMV8y3EurnYafGvC6pO2RK9jpJQfP6GyRuo0OnZv547/UUuBl5
         mFBQWGMqM1uyUJh+O8WurCynxhMbSmGD7WevlQ+41FvZlzUZkrs8Ys7XwhXRk3mGxX+D
         5S+VkIa4LadBh25iLIKN5e+HrLtDSvGTFWr+tHmaZxKWITfSh3dj7E+VKvFA3KgbIxev
         GJXM4oouhlZAVIHmyZyGxwWrgPVIYeLJxxgcJWZSrI8ke075k+Ckp79i7L+4/OUjHnfE
         vJyg==
X-Gm-Message-State: AOJu0YwDZeaHP31pQSi0zmJKPoF62SZnALeEPb8oA+hYBTVc9bC5foHW
        S5JLy9S/appPLYt8jsbjPbrezA==
X-Google-Smtp-Source: AGHT+IGDM6X9sIztF9mLFV8npw1yzLBcZFnDy/PMfbcv1LomzYn2cQJiEe9lpDKR8tNLRFzdLuobAQ==
X-Received: by 2002:a05:6871:4391:b0:1bb:a227:7008 with SMTP id lv17-20020a056871439100b001bba2277008mr20729738oab.3.1698280867767;
        Wed, 25 Oct 2023 17:41:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id m4-20020a63ed44000000b005b8f3293bf2sm2856250pgk.88.2023.10.25.17.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 17:41:06 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qvoQp-003xxO-2w;
        Thu, 26 Oct 2023 11:41:03 +1100
Date:   Thu, 26 Oct 2023 11:41:03 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v2] xfs: up(ic_sema) if flushing data device fails
Message-ID: <ZTm1n2I3bif0h4er@dread.disaster.area>
References: <20231025225848.3437904-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231025225848.3437904-1-leah.rumancik@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 25, 2023 at 03:58:48PM -0700, Leah Rumancik wrote:
> We flush the data device cache before we issue external log IO. If
> the flush fails, we shut down the log immediately and return. However,
> the iclog->ic_sema is left in a decremented state so let's add an up().
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
> There is a second early return / shutdown. Make sure the up() happens
> for it as well.
> 
> Fixes: b5d721eaae47 ("xfs: external logs need to flush data device")
> Fixes: 842a42d126b4 ("xfs: shutdown on failure to add page to log bio")
> Fixes: 7d839e325af2 ("xfs: check return codes when flushing block devices")
> Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
> 
> Notes:
>     v1->v2:
>      - use goto instead of multiple returns
>      - add Fixes tags
> 
>  fs/xfs/xfs_log.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 51c100c86177..8ae923e00eb6 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1925,20 +1925,17 @@ xlog_write_iclog(
>  		 * avoid shutdown re-entering this path and erroring out again.
>  		 */
>  		if (log->l_targ != log->l_mp->m_ddev_targp &&
> -		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev)) {
> -			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
> -			return;
> -		}
> +		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev))
> +			goto shutdown;
>  	}
>  	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
>  		iclog->ic_bio.bi_opf |= REQ_FUA;
>  
>  	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
>  
> -	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count)) {
> -		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
> -		return;
> -	}
> +	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count))
> +		goto shutdown;
> +
>  	if (is_vmalloc_addr(iclog->ic_data))
>  		flush_kernel_vmap_range(iclog->ic_data, count);
>  
> @@ -1959,6 +1956,10 @@ xlog_write_iclog(
>  	}
>  
>  	submit_bio(&iclog->ic_bio);
> +	return;
> +shutdown:
> +	up(&iclog->ic_sema);
> +	xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);

Hmmmm. So we'll leave an unreferenced, unlocked iclog in a SYNCING
state where something else can access it, then hope that the
shutdown gets to it first and that it cleans it all up? That doesn't
seem completely safe to me.

At entry to this function, if the log is already shut down, it runs
xlog_state_done_syncing() to force the iclog and it's attached state
to be cleaned up before dropping the lock and returning.

If I look at xlog_ioend_work(), if it gets an error it does the
shutdown, then calls xlog_state_done_syncing() to clean up the iclog
and attached state, then drops the lock.

Hence it appears to me that the error handling for a fatal errors in
IO submission should match the io completion error handling. i.e the
error stack for this function should look like this:

....
	if (xlog_is_shutdown(log))
		goto out_done_sync;
....
	if (error)
		goto out_do_shutdown;
....
out_do_shutdown:
	xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
out_done_sync:
	xlog_state_done_syncing(iclog);
	up(&iclog->ic_sema);
}

Thoughts?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
