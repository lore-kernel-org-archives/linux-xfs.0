Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F491C77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  1 May 2023 23:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjEAXKh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 May 2023 19:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjEAXKg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 May 2023 19:10:36 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB3B1708
        for <linux-xfs@vger.kernel.org>; Mon,  1 May 2023 16:10:35 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1aae1bb61edso24159525ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 01 May 2023 16:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682982635; x=1685574635;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vG4WCkoeXP5y8YPRulJBwEv/iRhWK55Lban+rQOjDCQ=;
        b=4ZTlTv+OzmEqLRfqfdwQWM2kEb1F/0S/7SW19UN7OpNl6siWcIlgmLsFkyvL60QS+W
         B6MO9jEseUMwi3hT9xlqjabO3iDpaER5Xv6irYNJn9lvmvhfZ0pOujde7zC3pg9uB17n
         Yvt9UpretVT1O/6SW9Yoz1Q4X6r2VuBnNuU0YmVPGJhaKV5PpGfWCJB+96JAHShe16zi
         /so0fpFElDym8V+MXT75WXUpjokPi2soG/E44B7GgYYucDFFb1e1BGvc8WrjfaS54sX2
         xEFo4volIh0FV8SDS/ZWj6Jrgu9uhfyj8g/PY3yd/gl/TCBQm+JA2dlRp8upfij3jb4D
         P3Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682982635; x=1685574635;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vG4WCkoeXP5y8YPRulJBwEv/iRhWK55Lban+rQOjDCQ=;
        b=dn2Ac6LODagnzXbLJgeK6DpQQvnqq10K4EOTNmL3QgnRLfL6uvv4CnhRABEn9PYIl6
         T1dXYUPry+URGr90kOeOBq93zPtBXS2UB3H0rV4UqWtLIFLCOINlzeaRnDVsxZG1RjjB
         2EBr5i5VSp4LE+JdO0lKxUO3YZX1wrEOVrrRXz6HzK+JpahLqkwUjTId249xHLCNB36V
         +pBUxqnPLjodSXfYeSGr8/ma66w9+HKEgMUluNaZE7AuuwHMRoZk2vDNkuTg0OgKOWLk
         VFjpuagBV9H8jVF9Jx+toVJAbUjgXpX/rbL5JakzwdMm9Dc4ScVTDDnkAGG0Hkyegfmw
         VlxQ==
X-Gm-Message-State: AC+VfDzC+RaLgHL5tf9659eqfK7POaWdulavqY9h3TSGRnEj3TCKnWJe
        5WgYgL12szO7oWa1yva0T8GCig==
X-Google-Smtp-Source: ACHHUZ75EPfK7X58TIP83uFyZrUIpIZ+ImPYhncq2jA0pGR/mjWGHmCMGsbJeFpx7wnCZuUy9kASMw==
X-Received: by 2002:a17:902:db08:b0:1a9:b9ae:333b with SMTP id m8-20020a170902db0800b001a9b9ae333bmr19126242plx.27.1682982634695;
        Mon, 01 May 2023 16:10:34 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id x10-20020a170902b40a00b001ab05aaaf8fsm543386plr.104.2023.05.01.16.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 16:10:34 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ptcf9-00AEbj-KS; Tue, 02 May 2023 09:10:31 +1000
Date:   Tue, 2 May 2023 09:10:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: fix xfs_inodegc_stop racing with
 mod_delayed_work
Message-ID: <20230501231031.GZ3223426@dread.disaster.area>
References: <168296563922.290156.2222659364666118889.stgit@frogsfrogsfrogs>
 <168296566181.290156.8222119111826465372.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168296566181.290156.8222119111826465372.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 01, 2023 at 11:27:41AM -0700, Darrick J. Wong wrote:
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
> 
> Hence, it is correct to replace the drain_workqueue call with a loop
> that drains the inodegc llists.
> 
> Fixes: 6191cf3ad59f ("xfs: flush inodegc workqueue tasks before cancel")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_icache.c |   32 +++++++++++++++++++++++++++-----
>  1 file changed, 27 insertions(+), 5 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
