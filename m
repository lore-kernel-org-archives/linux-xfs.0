Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7FFAC4332B
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 01:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A6626528C
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 01:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhCIBzn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 20:55:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:37870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229520AbhCIBzl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 20:55:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52FCD65270;
        Tue,  9 Mar 2021 01:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615254941;
        bh=7dmNyp2p1ouU4kmM6EA/3iKMx+lyMAcHl8uq0EqXI0g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k87k7FvGx6LVbQdzka9ntDp8MewzPFsG3dp9fMNrdLxXa4nyD6ydDGFy82OQ9Yp1B
         Z8Le3RyQFh4CGZbgX6xXyEA5tawIIqTCTTXpM9M1vcQAPEnkkJ3htJOY8vJ6zAu9ZD
         ehnZmEtazNvm9XA+eJsTeI4TlewTnaFqGbs7FP+yRJ3uZhrSDAwikI3v/iGwlIpw0y
         /EVSq5BlGyzoTOsa426cRTEGOAU08za5lMvlz56wWO+jVC3LQgTmFk4QH90pv3q+jg
         ZsHX1TOWZuvNSXbiZY4IfLyFFi3rfP1ySVBo7gExYoxE9g1EToufmuQwfcgBtNZZVu
         k1pIhRGx+MNPA==
Date:   Mon, 8 Mar 2021 17:55:40 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/45] xfs: CIL work is serialised, not pipelined
Message-ID: <20210309015540.GY7269@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-16-david@fromorbit.com>
 <20210308231432.GD3419940@magnolia>
 <20210308233819.GA74031@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308233819.GA74031@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 09, 2021 at 10:38:19AM +1100, Dave Chinner wrote:
> On Mon, Mar 08, 2021 at 03:14:32PM -0800, Darrick J. Wong wrote:
> > On Fri, Mar 05, 2021 at 04:11:13PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Because we use a single work structure attached to the CIL rather
> > > than the CIL context, we can only queue a single work item at a
> > > time. This results in the CIL being single threaded and limits
> > > performance when it becomes CPU bound.
> > > 
> > > The design of the CIL is that it is pipelined and multiple commits
> > > can be running concurrently, but the way the work is currently
> > > implemented means that it is not pipelining as it was intended. The
> > > critical work to switch the CIL context can take a few milliseconds
> > > to run, but the rest of the CIL context flush can take hundreds of
> > > milliseconds to complete. The context switching is the serialisation
> > > point of the CIL, once the context has been switched the rest of the
> > > context push can run asynchrnously with all other context pushes.
> > > 
> > > Hence we can move the work to the CIL context so that we can run
> > > multiple CIL pushes at the same time and spread the majority of
> > > the work out over multiple CPUs. We can keep the per-cpu CIL commit
> > > state on the CIL rather than the context, because the context is
> > > pinned to the CIL until the switch is done and we aggregate and
> > > drain the per-cpu state held on the CIL during the context switch.
> > > 
> > > However, because we no longer serialise the CIL work, we can have
> > > effectively unlimited CIL pushes in progress. We don't want to do
> > > this - not only does it create contention on the iclogs and the
> > > state machine locks, we can run the log right out of space with
> > > outstanding pushes. Instead, limit the work concurrency to 4
> > > concurrent works being processed at a time. THis is enough
> > 
> > Four?  Was that determined experimentally, or is that a fundamental
> > limit of how many cil checkpoints we can working on at a time?  The
> > current one, the previous one, and ... something else that was already
> > in progress?
> 
> No fundamental limit, but....
> 
> > > concurrency to remove the CIL from being a CPU bound bottleneck but
> > > not enough to create new contention points or unbound concurrency
> > > issues.
> 
> spinlocks in well written code scale linearly to 3-4 CPUs banging on
> them frequently.  Beyond that they start to show non-linear
> behaviour before they break down completely at somewhere between
> 8-16 threads banging on them. If we have 4 CIL writes going on, we
> have 4 CPUs banging on the log->l_icloglock through xlog_write()
> through xlog_state_get_iclog_space() and then releasing the iclogs
> when they are full. We then have iclog IO completion banging on the
> icloglock to serialise completion can change iclog state on
> completion.
> 
> Hence a 4 CIL push works, we're starting to get back to the point
> where the icloglock will start to see non-linear access cost. This
> was a problem before delayed logging removed the icloglock from the
> front end transaction commit path where it could see unbound
> concurrency and was the hottest lock in the log.
> 
> Allowing a limited amount of concurrency prevents us from
> unnecessarily allowing wasteful and performance limiting lock
> contention from occurring. And given that I'm only hitting the
> single CPU limit of the CIL push when there's 31 other CPUs all
> running transactions flat out, having 4 CPUs to run the same work is
> more than enough. Especially as those 31 other CPUs running
> transactions are already pushing VFS level spinlocks
> (sb->sb_inode_list_lock, dentry ref count locking, etc) to breakdown
> point so we're not going to be able to push enough change into the
> CIL to keep 4 CPUs fully busy any time soon.

It might be nice to leave that as a breadcrumb, then, in case the
spinlock scalability problems ever get solved.

	/*
	 * Limit ourselves to 4 CIL push workers per log to avoid
	 * excessive contention of the icloglock spinlock.
	 */
	error = alloc_workqueue(..., 4, ...);

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
