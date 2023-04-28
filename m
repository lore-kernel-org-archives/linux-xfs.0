Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F3ABC77B73
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Apr 2023 02:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344811AbjD1C3z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 22:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344791AbjD1C3y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 22:29:54 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFEB268D
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 19:29:52 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1a66e7a52d3so69902015ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 19:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682648992; x=1685240992;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b6Qo2Wk5YDZsm2tdFfLGLkN2gHNjfGNW4q60UCI0UzY=;
        b=jfQ4Qh/fTPgJRKdkyKYU0RlqiRQxbFHXbZYPVyakIiURdf8JguxS2VtSPo85HaIulz
         u4BGNPjuu6CbWtkXmCNgBFhD8geTAWOGOewX9ADEezoCctWNOC9hceSkwE/fpT1GvLvs
         3qtF7Y1BjSf9oVB0Sy6A3ESYq0rtsooPlHkOfFkK5qzfV2U/M07d+5m3TScna3YUAKBW
         1ASKaoSyRiWe7MfxQS5iZpd32rbLEKSLjxjek/UeC5zpTkMU0iTg+OKTGskzIZP6gMGa
         ty4Fq7t4oHMho/590UdIQyVddETc+u5Jvfj8pu+yTgdYyG/4K/Dy9ncen3rbFJ5gKXox
         LUcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682648992; x=1685240992;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b6Qo2Wk5YDZsm2tdFfLGLkN2gHNjfGNW4q60UCI0UzY=;
        b=JNMJdis6hC91FzypFrD4VPqixHXz0FqkG/NZrBU97VoXezNQjhdCC8q9DfIcagkfoL
         kD7VVZ/Usu0eLrtl82P9WBSlabWjJfzz4aKeKwT86qHRlsIAOV+z7oX/fERIFP5nBjU5
         05DpkQn4yLY3k2L8VJRW3dVkdj3x6xobtflo0Oc28OwUhf5DUpPfzC6hB/rS5yRbM4Me
         +J3Z40yNHAS3HZ7yrifDM8lppwMjsPVQElqLSHiqcXadShTlgI+u2OrJCdu2YuchE1NT
         43fyQkZN0wDamYE93hf2WFVwCPDbZEsTKnWaTPmRcvInWIOSDIV8lNyQChDroBe6dkkS
         FMlw==
X-Gm-Message-State: AC+VfDyZj0rvn72yatwipVxc9cNBJewwXgdL+XdXgVB/fxuj4zBAqrgv
        nqIcMtDhg+oN3Py02DDf8Cpr9grz+n+sZdxzmmc=
X-Google-Smtp-Source: ACHHUZ5OHcQusK7SfNMITCX4LBTITos3HzWycW1YBDNT5wfGsNxC7cfTLSu9xdu7qVCJu7BMP4T+EA==
X-Received: by 2002:a17:903:6c8:b0:1a6:6fef:62f6 with SMTP id kj8-20020a17090306c800b001a66fef62f6mr3148927plb.30.1682648992258;
        Thu, 27 Apr 2023 19:29:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id 30-20020a63125e000000b0051b70c8d446sm11825361pgs.73.2023.04.27.19.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 19:29:51 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1psDrn-008iJj-LW; Fri, 28 Apr 2023 12:29:47 +1000
Date:   Fri, 28 Apr 2023 12:29:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: fix xfs_inodegc_stop racing with
 mod_delayed_work
Message-ID: <20230428022947.GU3223426@dread.disaster.area>
References: <168263576040.1719564.2454266085026973056.stgit@frogsfrogsfrogs>
 <168263578315.1719564.9753279529602110442.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168263578315.1719564.9753279529602110442.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 27, 2023 at 03:49:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> syzbot reported this warning from the faux inodegc shrinker that tries
> to kick off inodegc work:
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 102 at kernel/workqueue.c:1445 __queue_work+0xd44/0x1120 kernel/workqueue.c:1444
> RIP: 0010:__queue_work+0xd44/0x1120 kernel/workqueue.c:1444
> Call Trace:
>  __queue_delayed_work+0x1c8/0x270 kernel/workqueue.c:1672
>  mod_delayed_work_on+0xe1/0x220 kernel/workqueue.c:1746
>  xfs_inodegc_shrinker_scan fs/xfs/xfs_icache.c:2212 [inline]
>  xfs_inodegc_shrinker_scan+0x250/0x4f0 fs/xfs/xfs_icache.c:2191
>  do_shrink_slab+0x428/0xaa0 mm/vmscan.c:853
>  shrink_slab+0x175/0x660 mm/vmscan.c:1013
>  shrink_one+0x502/0x810 mm/vmscan.c:5343
>  shrink_many mm/vmscan.c:5394 [inline]
>  lru_gen_shrink_node mm/vmscan.c:5511 [inline]
>  shrink_node+0x2064/0x35f0 mm/vmscan.c:6459
>  kswapd_shrink_node mm/vmscan.c:7262 [inline]
>  balance_pgdat+0xa02/0x1ac0 mm/vmscan.c:7452
>  kswapd+0x677/0xd60 mm/vmscan.c:7712
>  kthread+0x2e8/0x3a0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
> 
> This warning corresponds to this code in __queue_work:
> 
> 	/*
> 	 * For a draining wq, only works from the same workqueue are
> 	 * allowed. The __WQ_DESTROYING helps to spot the issue that
> 	 * queues a new work item to a wq after destroy_workqueue(wq).
> 	 */
> 	if (unlikely(wq->flags & (__WQ_DESTROYING | __WQ_DRAINING) &&
> 		     WARN_ON_ONCE(!is_chained_work(wq))))
> 		return;
> 
> For this to trip, we must have a thread draining the inodedgc workqueue
> and a second thread trying to queue inodegc work to that workqueue.
> This can happen if freezing or a ro remount race with reclaim poking our
> faux inodegc shrinker and another thread dropping an unlinked O_RDONLY
> file:
> 
> Thread 0	Thread 1	Thread 2
> 
> xfs_inodegc_stop
> 
> 				xfs_inodegc_shrinker_scan
> 				xfs_is_inodegc_enabled
> 				<yes, will continue>
> 
> xfs_clear_inodegc_enabled
> xfs_inodegc_queue_all
> <list empty, do not queue inodegc worker>
> 
> 		xfs_inodegc_queue
> 		<add to list>
> 		xfs_is_inodegc_enabled
> 		<no, returns>
> 
> drain_workqueue
> <set WQ_DRAINING>
> 
> 				llist_empty
> 				<no, will queue list>
> 				mod_delayed_work_on(..., 0)
> 				__queue_work
> 				<sees WQ_DRAINING, kaboom>
> 
> In other words, everything between the access to inodegc_enabled state
> and the decision to poke the inodegc workqueue requires some kind of
> coordination to avoid the WQ_DRAINING state.  We could perhaps introduce
> a lock here, but we could also try to eliminate WQ_DRAINING from the
> picture.
> 
> We could replace the drain_workqueue call with a loop that flushes the
> workqueue and queues workers as long as there is at least one inode
> present in the per-cpu inodegc llists.  We've disabled inodegc at this
> point, so we know that the number of queued inodes will eventually hit
> zero as long as xfs_inodegc_start cannot reactivate the workers.
> 
> There are four callers of xfs_inodegc_start.  Three of them come from the
> VFS with s_umount held: filesystem thawing, failed filesystem freezing,
> and the rw remount transition.  The fourth caller is mounting rw (no
> remount or freezing possible).
> 
> There are three callers ofs xfs_inodegc_stop.  One is unmounting (no
> remount or thaw possible).  Two of them come from the VFS with s_umount
> held: fs freezing and ro remount transition.

Ok, so effectively we are using s_umount to serialise inodegc
start/stop transitions.

....

> @@ -1911,24 +1916,39 @@ xfs_inodegc_flush(
>  
>  /*
>   * Flush all the pending work and then disable the inode inactivation background
> - * workers and wait for them to stop.
> + * workers and wait for them to stop.  Do not call xfs_inodegc_start until this
> + * finishes.
>   */
>  void
>  xfs_inodegc_stop(
>  	struct xfs_mount	*mp)
>  {

I'd prefer to document that these two functions should not be called
without holding the sb->s_umount lock rather than leaving the
serialisation mechanism undocumented. When we add the exclusive
freeze code for the fscounter scrub sync, that's also going to hold
the sb->s_umount lock while inodegc is stopped and started, right?


> +	bool			rerun;
> +
>  	if (!xfs_clear_inodegc_enabled(mp))
>  		return;
>  
> +	/*
> +	 * Drain all pending inodegc work, including inodes that could be
> +	 * queued by racing xfs_inodegc_queue or xfs_inodegc_shrinker_scan
> +	 * threads that sample the inodegc state just prior to us clearing it.
> +	 * The inodegc flag state prevents new threads from queuing more
> +	 * inodes, so we queue pending work items and flush the workqueue until
> +	 * all inodegc lists are empty.
> +	 */
>  	xfs_inodegc_queue_all(mp);
> -	drain_workqueue(mp->m_inodegc_wq);
> +	do {
> +		flush_workqueue(mp->m_inodegc_wq);
> +		rerun = xfs_inodegc_queue_all(mp);
> +	} while (rerun);

Would it be worth noting that we don't use drain_workqueue() because
it doesn't allow other unserialised mechanisms to reschedule inodegc
work while the draining is in progress?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
