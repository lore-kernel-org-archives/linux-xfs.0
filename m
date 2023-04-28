Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90763C77B60
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Apr 2023 04:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345141AbjD1E2U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Apr 2023 00:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345102AbjD1E2S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Apr 2023 00:28:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F861BFE
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 21:28:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E96563B09
        for <linux-xfs@vger.kernel.org>; Fri, 28 Apr 2023 04:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9B7C433EF;
        Fri, 28 Apr 2023 04:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682656095;
        bh=Vyl59dYfK3Os7dmiI/X3TFUKCMZphJV5t1dgBGqcNRU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kh0dESWB01ku38DNSx77LbfZwPUkYslY+fkJlCd5f1sZ1kSNfmBU5u++DK9qvbZVM
         /OItbUdRJwiamz7CYHK/i2vKwBDhZ+P00jR/wyw9CmcZMNFnGs84QsiqPEBr6xCJm8
         ti3E5kpY5CUX/8oKKD1FpZB7hjLz1RBEnQ8MMyYpJ6S2C/hMmjQyWmtRkYKC3Y5A+J
         /8Nz8B0XfcrsLhTtu+d4fhik5bdkyewggM5Qmk++wbr2FeEVTuOBKN93kULU3cGTdw
         ZKuF//FMjU3oWfjW7pfopci8GSxD7M8hpGxOiU2jKHpqR0fk42Wx8lTkLF7xo35dNF
         Z7mV75IErlGSQ==
Date:   Thu, 27 Apr 2023 21:28:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: fix xfs_inodegc_stop racing with
 mod_delayed_work
Message-ID: <20230428042815.GH59213@frogsfrogsfrogs>
References: <168263576040.1719564.2454266085026973056.stgit@frogsfrogsfrogs>
 <168263578315.1719564.9753279529602110442.stgit@frogsfrogsfrogs>
 <20230428022947.GU3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428022947.GU3223426@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 28, 2023 at 12:29:47PM +1000, Dave Chinner wrote:
> On Thu, Apr 27, 2023 at 03:49:43PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > syzbot reported this warning from the faux inodegc shrinker that tries
> > to kick off inodegc work:
> > 
> > ------------[ cut here ]------------
> > WARNING: CPU: 1 PID: 102 at kernel/workqueue.c:1445 __queue_work+0xd44/0x1120 kernel/workqueue.c:1444
> > RIP: 0010:__queue_work+0xd44/0x1120 kernel/workqueue.c:1444
> > Call Trace:
> >  __queue_delayed_work+0x1c8/0x270 kernel/workqueue.c:1672
> >  mod_delayed_work_on+0xe1/0x220 kernel/workqueue.c:1746
> >  xfs_inodegc_shrinker_scan fs/xfs/xfs_icache.c:2212 [inline]
> >  xfs_inodegc_shrinker_scan+0x250/0x4f0 fs/xfs/xfs_icache.c:2191
> >  do_shrink_slab+0x428/0xaa0 mm/vmscan.c:853
> >  shrink_slab+0x175/0x660 mm/vmscan.c:1013
> >  shrink_one+0x502/0x810 mm/vmscan.c:5343
> >  shrink_many mm/vmscan.c:5394 [inline]
> >  lru_gen_shrink_node mm/vmscan.c:5511 [inline]
> >  shrink_node+0x2064/0x35f0 mm/vmscan.c:6459
> >  kswapd_shrink_node mm/vmscan.c:7262 [inline]
> >  balance_pgdat+0xa02/0x1ac0 mm/vmscan.c:7452
> >  kswapd+0x677/0xd60 mm/vmscan.c:7712
> >  kthread+0x2e8/0x3a0 kernel/kthread.c:376
> >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
> > 
> > This warning corresponds to this code in __queue_work:
> > 
> > 	/*
> > 	 * For a draining wq, only works from the same workqueue are
> > 	 * allowed. The __WQ_DESTROYING helps to spot the issue that
> > 	 * queues a new work item to a wq after destroy_workqueue(wq).
> > 	 */
> > 	if (unlikely(wq->flags & (__WQ_DESTROYING | __WQ_DRAINING) &&
> > 		     WARN_ON_ONCE(!is_chained_work(wq))))
> > 		return;
> > 
> > For this to trip, we must have a thread draining the inodedgc workqueue
> > and a second thread trying to queue inodegc work to that workqueue.
> > This can happen if freezing or a ro remount race with reclaim poking our
> > faux inodegc shrinker and another thread dropping an unlinked O_RDONLY
> > file:
> > 
> > Thread 0	Thread 1	Thread 2
> > 
> > xfs_inodegc_stop
> > 
> > 				xfs_inodegc_shrinker_scan
> > 				xfs_is_inodegc_enabled
> > 				<yes, will continue>
> > 
> > xfs_clear_inodegc_enabled
> > xfs_inodegc_queue_all
> > <list empty, do not queue inodegc worker>
> > 
> > 		xfs_inodegc_queue
> > 		<add to list>
> > 		xfs_is_inodegc_enabled
> > 		<no, returns>
> > 
> > drain_workqueue
> > <set WQ_DRAINING>
> > 
> > 				llist_empty
> > 				<no, will queue list>
> > 				mod_delayed_work_on(..., 0)
> > 				__queue_work
> > 				<sees WQ_DRAINING, kaboom>
> > 
> > In other words, everything between the access to inodegc_enabled state
> > and the decision to poke the inodegc workqueue requires some kind of
> > coordination to avoid the WQ_DRAINING state.  We could perhaps introduce
> > a lock here, but we could also try to eliminate WQ_DRAINING from the
> > picture.
> > 
> > We could replace the drain_workqueue call with a loop that flushes the
> > workqueue and queues workers as long as there is at least one inode
> > present in the per-cpu inodegc llists.  We've disabled inodegc at this
> > point, so we know that the number of queued inodes will eventually hit
> > zero as long as xfs_inodegc_start cannot reactivate the workers.
> > 
> > There are four callers of xfs_inodegc_start.  Three of them come from the
> > VFS with s_umount held: filesystem thawing, failed filesystem freezing,
> > and the rw remount transition.  The fourth caller is mounting rw (no
> > remount or freezing possible).
> > 
> > There are three callers ofs xfs_inodegc_stop.  One is unmounting (no
> > remount or thaw possible).  Two of them come from the VFS with s_umount
> > held: fs freezing and ro remount transition.
> 
> Ok, so effectively we are using s_umount to serialise inodegc
> start/stop transitions.

Correct.

> ....
> 
> > @@ -1911,24 +1916,39 @@ xfs_inodegc_flush(
> >  
> >  /*
> >   * Flush all the pending work and then disable the inode inactivation background
> > - * workers and wait for them to stop.
> > + * workers and wait for them to stop.  Do not call xfs_inodegc_start until this
> > + * finishes.
> >   */
> >  void
> >  xfs_inodegc_stop(
> >  	struct xfs_mount	*mp)
> >  {
> 
> I'd prefer to document that these two functions should not be called
> without holding the sb->s_umount lock rather than leaving the
> serialisation mechanism undocumented.

Done.  "Caller must hold sb->s_umount to coordinate changes in the
inodegc_enabled state."

> When we add the exclusive
> freeze code for the fscounter scrub sync, that's also going to hold
> the sb->s_umount lock while inodegc is stopped and started, right?

Yes, the exclusive freeze mechanism takes all the same locks and makes
all the same state changes as regular freeze.

> 
> > +	bool			rerun;
> > +
> >  	if (!xfs_clear_inodegc_enabled(mp))
> >  		return;
> >  
> > +	/*
> > +	 * Drain all pending inodegc work, including inodes that could be
> > +	 * queued by racing xfs_inodegc_queue or xfs_inodegc_shrinker_scan
> > +	 * threads that sample the inodegc state just prior to us clearing it.
> > +	 * The inodegc flag state prevents new threads from queuing more
> > +	 * inodes, so we queue pending work items and flush the workqueue until
> > +	 * all inodegc lists are empty.
> > +	 */
> >  	xfs_inodegc_queue_all(mp);
> > -	drain_workqueue(mp->m_inodegc_wq);
> > +	do {
> > +		flush_workqueue(mp->m_inodegc_wq);
> > +		rerun = xfs_inodegc_queue_all(mp);
> > +	} while (rerun);
> 
> Would it be worth noting that we don't use drain_workqueue() because
> it doesn't allow other unserialised mechanisms to reschedule inodegc
> work while the draining is in progress?

I'll paste that right in!

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
