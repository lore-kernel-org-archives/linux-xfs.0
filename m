Return-Path: <SRS0=maQ1=AO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DAC9C433E1
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jul 2020 06:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 382D720BED
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Jul 2020 06:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgGCGId (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Jul 2020 02:08:33 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:46495 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726237AbgGCGIc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Jul 2020 02:08:32 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 45F9110C54C;
        Fri,  3 Jul 2020 16:08:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jrEs3-0003Vv-6H; Fri, 03 Jul 2020 16:08:23 +1000
Date:   Fri, 3 Jul 2020 16:08:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs: automatic log item relog mechanism
Message-ID: <20200703060823.GK2005@dread.disaster.area>
References: <20200701165116.47344-1-bfoster@redhat.com>
 <20200701165116.47344-6-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701165116.47344-6-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=KSIizm1rcbKzFqhy2_YA:9 a=CjuIK1q_8ugA:10 a=Grnb8HPFGUAA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 01, 2020 at 12:51:11PM -0400, Brian Foster wrote:
> Now that relog reservation is available and relog state tracking is
> in place, all that remains to automatically relog items is the relog
> mechanism itself. An item with relogging enabled is basically pinned
> from writeback until relog is disabled. Instead of being written
> back, the item must instead be periodically committed in a new
> transaction to move it forward in the physical log. The purpose of
> moving the item is to avoid long term tail pinning and thus avoid
> log deadlocks for long running operations.
> 
> The ideal time to relog an item is in response to tail pushing
> pressure. This accommodates the current workload at any given time
> as opposed to a fixed time interval or log reservation heuristic,
> which risks performance regression. This is essentially the same
> heuristic that drives metadata writeback. XFS already implements
> various log tail pushing heuristics that attempt to keep the log
> progressing on an active fileystem under various workloads.
> 
> The act of relogging an item simply requires to add it to a
> transaction and commit. This pushes the already dirty item into a
> subsequent log checkpoint and frees up its previous location in the
> on-disk log. Joining an item to a transaction of course requires
> locking the item first, which means we have to be aware of
> type-specific locks and lock ordering wherever the relog takes
> place.
> 
> Fundamentally, this points to xfsaild as the ideal location to
> process relog enabled items. xfsaild already processes log resident
> items, is driven by log tail pushing pressure, processes arbitrary
> log item types through callbacks, and is sensitive to type-specific
> locking rules by design. The fact that automatic relogging
> essentially diverts items between writeback or relog also suggests
> xfsaild as an ideal location to process items one way or the other.
> 
> Of course, we don't want xfsaild to process transactions as it is a
> critical component of the log subsystem for driving metadata
> writeback and freeing up log space. Therefore, similar to how
> xfsaild builds up a writeback queue of dirty items and queues writes
> asynchronously, make xfsaild responsible only for directing pending
> relog items into an appropriate queue and create an async
> (workqueue) context for processing the queue. The workqueue context
> utilizes the pre-reserved log reservation to drain the queue by
> rolling a permanent transaction.
> 
> Update the AIL pushing infrastructure to support a new RELOG item
> state. If a log item push returns the relog state, queue the item
> for relog instead of writeback. On completion of a push cycle,
> schedule the relog task at the same point metadata buffer I/O is
> submitted. This allows items to be relogged automatically under the
> same locking rules and pressure heuristics that govern metadata
> writeback.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

A note while it's still fresh in my mind: memory reclaim is going to
force relogging of items whether they need it or not. The inode
shrinker pushes the AIL to it's highest current LSN, which means the
first shrinker invocation will relog the items. Sustained memory
pressure will result in this sort of behaviour

	AIL				AIL relog workqueue
cycle 1:
	relog item
		-> move to relog queue
	relog item
		-> move to relog queue
	....
	relog item
		-> move to relog queue

	queue work to AIL relog workqueue
	<sleep 20ms>

					iterates relog items
					  ->relog
					  commit

cycle 2:
	relog item
		already queued
		marks AIL for log force
	relog item
		already queued
		marks AIL for log force
	....
	relog item
		-> move to relog queue

	<sleep 20ms>

cycle 3:
	xfs_log_force(XFS_LOG_SYNC)
	-> CIL flush
	   log io
	   log IO completes
	   relogged items reinserted in AIL
	....
	relog item
		-> move to relog queue
	relog item
		-> move to relog queue
	....
	relog item
		-> move to relog queue

	queue work to AIL relog workqueue
	<sleep 20ms>

					iterates relog items
					  ->relog
					  commit
<repeat>

So it looks like when there is memory pressure we are going to
trigger a relog every second AIL push cycle, and a synchronous log
force every other log cycle.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
