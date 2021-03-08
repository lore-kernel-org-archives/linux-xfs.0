Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDAFDC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 23:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA1B365256
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Mar 2021 23:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbhCHXi5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 18:38:57 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:36396 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231339AbhCHXiW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 18:38:22 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BCD598289A9;
        Tue,  9 Mar 2021 10:38:20 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lJPS7-000JdC-T9; Tue, 09 Mar 2021 10:38:19 +1100
Date:   Tue, 9 Mar 2021 10:38:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/45] xfs: CIL work is serialised, not pipelined
Message-ID: <20210308233819.GA74031@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-16-david@fromorbit.com>
 <20210308231432.GD3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308231432.GD3419940@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=Lu78EtWdppn6Y5Bnps4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 03:14:32PM -0800, Darrick J. Wong wrote:
> On Fri, Mar 05, 2021 at 04:11:13PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Because we use a single work structure attached to the CIL rather
> > than the CIL context, we can only queue a single work item at a
> > time. This results in the CIL being single threaded and limits
> > performance when it becomes CPU bound.
> > 
> > The design of the CIL is that it is pipelined and multiple commits
> > can be running concurrently, but the way the work is currently
> > implemented means that it is not pipelining as it was intended. The
> > critical work to switch the CIL context can take a few milliseconds
> > to run, but the rest of the CIL context flush can take hundreds of
> > milliseconds to complete. The context switching is the serialisation
> > point of the CIL, once the context has been switched the rest of the
> > context push can run asynchrnously with all other context pushes.
> > 
> > Hence we can move the work to the CIL context so that we can run
> > multiple CIL pushes at the same time and spread the majority of
> > the work out over multiple CPUs. We can keep the per-cpu CIL commit
> > state on the CIL rather than the context, because the context is
> > pinned to the CIL until the switch is done and we aggregate and
> > drain the per-cpu state held on the CIL during the context switch.
> > 
> > However, because we no longer serialise the CIL work, we can have
> > effectively unlimited CIL pushes in progress. We don't want to do
> > this - not only does it create contention on the iclogs and the
> > state machine locks, we can run the log right out of space with
> > outstanding pushes. Instead, limit the work concurrency to 4
> > concurrent works being processed at a time. THis is enough
> 
> Four?  Was that determined experimentally, or is that a fundamental
> limit of how many cil checkpoints we can working on at a time?  The
> current one, the previous one, and ... something else that was already
> in progress?

No fundamental limit, but....

> > concurrency to remove the CIL from being a CPU bound bottleneck but
> > not enough to create new contention points or unbound concurrency
> > issues.

spinlocks in well written code scale linearly to 3-4 CPUs banging on
them frequently.  Beyond that they start to show non-linear
behaviour before they break down completely at somewhere between
8-16 threads banging on them. If we have 4 CIL writes going on, we
have 4 CPUs banging on the log->l_icloglock through xlog_write()
through xlog_state_get_iclog_space() and then releasing the iclogs
when they are full. We then have iclog IO completion banging on the
icloglock to serialise completion can change iclog state on
completion.

Hence a 4 CIL push works, we're starting to get back to the point
where the icloglock will start to see non-linear access cost. This
was a problem before delayed logging removed the icloglock from the
front end transaction commit path where it could see unbound
concurrency and was the hottest lock in the log.

Allowing a limited amount of concurrency prevents us from
unnecessarily allowing wasteful and performance limiting lock
contention from occurring. And given that I'm only hitting the
single CPU limit of the CIL push when there's 31 other CPUs all
running transactions flat out, having 4 CPUs to run the same work is
more than enough. Especially as those 31 other CPUs running
transactions are already pushing VFS level spinlocks
(sb->sb_inode_list_lock, dentry ref count locking, etc) to breakdown
point so we're not going to be able to push enough change into the
CIL to keep 4 CPUs fully busy any time soon.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
