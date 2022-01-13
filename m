Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE36AC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jan 2022 18:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237569AbiAMSfk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Jan 2022 13:35:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44340 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237559AbiAMSfb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jan 2022 13:35:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DA7EB82325
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jan 2022 18:35:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3308EC36AEB;
        Thu, 13 Jan 2022 18:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642098929;
        bh=gnyDHRQOx0NmM9ao1Bt9JV3wpZ783o7bhOL/YFqO9qQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WWhqITcfxkJoSbET1bd9n0Dn3TbzO6Msh5MMyI3GXBiT5KtsEDdigS54Z5W9rC67E
         aI3/TF+1fGqsspMDS5n7g+fpxPiI3NactVKjOmERK8u9HIk1vbdjiBOLrRFFfisf9C
         ifA8Ku/aCnLLD1nfbo9AyLqlc4GpBqqCLpWgyw1EbxMWCStOYWHAYcCHwlBHkBBmWd
         3HB6zLgnITzBw7VhoDdhemaJlH9DSDlyd4cpXMa793umgV1wfOt33sksure6zLg+wP
         BnxszfH9TiS+WACCuuucnpALqU6UR52CUJpu5pJW5OCYbAHH1Ve75gKRSIO0ze2yMz
         8piY+8onphReQ==
Date:   Thu, 13 Jan 2022 10:35:28 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: flush inodegc workqueue tasks before cancel
Message-ID: <20220113183528.GE19198@magnolia>
References: <20220113133701.629593-1-bfoster@redhat.com>
 <20220113133701.629593-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113133701.629593-2-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 13, 2022 at 08:37:00AM -0500, Brian Foster wrote:
> The xfs_inodegc_stop() helper performs a high level flush of pending
> work on the percpu queues and then runs a cancel_work_sync() on each
> of the percpu work tasks to ensure all work has completed before
> returning.  While cancel_work_sync() waits for wq tasks to complete,
> it does not guarantee work tasks have started. This means that the
> _stop() helper can queue and instantly cancel a wq task without
> having completed the associated work. This can be observed by
> tracepoint inspection of a simple "rm -f <file>; fsfreeze -f <mnt>"
> test:
> 
> 	xfs_destroy_inode: ... ino 0x83 ...
> 	xfs_inode_set_need_inactive: ... ino 0x83 ...
> 	xfs_inodegc_stop: ...
> 	...
> 	xfs_inodegc_start: ...
> 	xfs_inodegc_worker: ...
> 	xfs_inode_inactivating: ... ino 0x83 ...
> 
> The first few lines show that the inode is removed and need inactive
> state set, but the inactivation work has not completed before the
> inodegc mechanism stops. The inactivation doesn't actually occur
> until the fs is unfrozen and the gc mechanism starts back up. Note
> that this test requires fsfreeze to reproduce because xfs_freeze
> indirectly invokes xfs_fs_statfs(), which calls xfs_inodegc_flush().
> 
> When this occurs, the workqueue try_to_grab_pending() logic first
> tries to steal the pending bit, which does not succeed because the
> bit has been set by queue_work_on(). Subsequently, it checks for
> association of a pool workqueue from the work item under the pool
> lock. This association is set at the point a work item is queued and
> cleared when dequeued for processing. If the association exists, the
> work item is removed from the queue and cancel_work_sync() returns
> true. If the pwq association is cleared, the remove attempt assumes
> the task is busy and retries (eventually returning false to the
> caller after waiting for the work task to complete).
> 
> To avoid this race, we can flush each work item explicitly before
> cancel. However, since the _queue_all() already schedules each
> underlying work item, the workqueue level helpers are sufficient to
> achieve the same ordering effect. E.g., the inodegc enabled flag
> prevents scheduling any further work in the _stop() case. Use the
> drain_workqueue() helper in this particular case to make the intent
> a bit more self explanatory.

/me wonders why he didn't think of drain/flush_workqueue in the first
place.  Hm.  Well, the logic looks sound so,

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

and I'll go give this a spin.

--D

> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 22 ++++------------------
>  1 file changed, 4 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index d019c98eb839..7a2a5e2be3cf 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1852,28 +1852,20 @@ xfs_inodegc_worker(
>  }
>  
>  /*
> - * Force all currently queued inode inactivation work to run immediately, and
> - * wait for the work to finish. Two pass - queue all the work first pass, wait
> - * for it in a second pass.
> + * Force all currently queued inode inactivation work to run immediately and
> + * wait for the work to finish.
>   */
>  void
>  xfs_inodegc_flush(
>  	struct xfs_mount	*mp)
>  {
> -	struct xfs_inodegc	*gc;
> -	int			cpu;

>  	if (!xfs_is_inodegc_enabled(mp))
>  		return;
>  
>  	trace_xfs_inodegc_flush(mp, __return_address);
>  
>  	xfs_inodegc_queue_all(mp);
> -
> -	for_each_online_cpu(cpu) {
> -		gc = per_cpu_ptr(mp->m_inodegc, cpu);
> -		flush_work(&gc->work);
> -	}
> +	flush_workqueue(mp->m_inodegc_wq);
>  }
>  
>  /*
> @@ -1884,18 +1876,12 @@ void
>  xfs_inodegc_stop(
>  	struct xfs_mount	*mp)
>  {
> -	struct xfs_inodegc	*gc;
> -	int			cpu;
> -
>  	if (!xfs_clear_inodegc_enabled(mp))
>  		return;
>  
>  	xfs_inodegc_queue_all(mp);
> +	drain_workqueue(mp->m_inodegc_wq);
>  
> -	for_each_online_cpu(cpu) {
> -		gc = per_cpu_ptr(mp->m_inodegc, cpu);
> -		cancel_work_sync(&gc->work);
> -	}
>  	trace_xfs_inodegc_stop(mp, __return_address);
>  }
>  
> -- 
> 2.31.1
> 
