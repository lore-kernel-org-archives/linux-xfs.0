Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C40F6C2D0F8
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 03:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F057206B8
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 03:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgEMDm2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 23:42:28 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:44023 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725929AbgEMDm1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 23:42:27 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 3EA845A9787
        for <linux-xfs@vger.kernel.org>; Wed, 13 May 2020 13:42:23 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYiHl-0002KC-To
        for linux-xfs@vger.kernel.org; Wed, 13 May 2020 13:42:21 +1000
Date:   Wed, 13 May 2020 13:42:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [XFS SUMMIT] AIL Behavioural Issues
Message-ID: <20200513034221.GB2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=mwZ7tl_EvyoBUuxWSyQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Topic:	AIL Behavioural Issues

Scope:
	Performance
	Efficiency
	Scalability

Proposal:

The XFS AIL numerous issues on high performance storage and
highly concurrent workloads. These can be broken down into several
categories:

1. Tracks too many redundant objects

We track inodes and dquots individually in the AIL, but we push
them as groups based on the backing buffer for the objects. For
inodes, this means we can have 32 inode items in the AIL for a
single buffer. We push the first inode and queue the buffer to the
delwri list, then we have to skip the other 31 inodes on that buffer
in the AIL.

This typically shows up as having a "success to flushing" ratio of
~30:1 in the AIL stats. We are doing 30x more work that we need to
inserting, iterating, and removing inodes in the AIL than required
to flush them. dquots have a similar problem.

So the question becomes this: how do we efficiently track related
objects that share a common backing object through the AIL? For
inodes, I'm attempting to do this with ordered buffers, but that is
proving to have a lot of lock ordering issues associated with it.

Perhaps there is a better way? Discuss.

2. Creates massive IO lists and so iteration latency can be multiple
  seconds as IO submission blocks

When tail pushing, the AIL will just keep building a delayed write
buffer list as long as it doesn't get stuck or hit it's target. This
can result in a submission list tens of thousands of buffers long
and hence the IO submission process ends up blocking on full request
queues and being throttled to the rate at which IO completions
occur. On slow storage, this can result in the AIL being blocked for
seconds (or more) while it works through the submission list.

If the item that pins the tail of the log is at the end of the
submission list, then the transaction reservations also block
waiting for the tail of the log to move, and hence everything in the
filesystem stops until submissions and IO completes. Then the AIL
does another scan, creates another huge list, and blocks again....

The long lists have the advantage that sorting them allows good IO
merging to take place. This reduces the IO time for slow disks
because it reduces seeks, but then the long list still takes a long
time to work through. It's a catch-22 situation.

Several things to discuss:
	- shorter lists to reduce submission latency
	- 2-dimensional AIL lists
		- existing LSN ordered list
		- additional daddr ordered list
	- no sorting?
	- immediate dispatch rather than delwri lists?
	- IO submission in a separate thread


3. Can block on CIL pushing

When the AIL hits pinned items, it will eventually issue a log force
to try to get them unpinned and so make progress. It does this when
it reaches it's target and there pinned objects that couldn't be
pushed prior to reaching the target.

The log force, while not a synchronous log force, still ends up
blocking on the CIL push to flush everything to the iclogs. This,
unfortunately, typically results in the CIL push blocking waiting
for iclog submission and IO completion as the amount of dirty
metadata in the CIL is greater than iclogs * iclogs_size. Hence tail
pushing can actually block behind log writes rather than just
triggering a CIL push to occur in the background and continuing to
scan for items to push.

discussion points:
	- do we even care if we hit pinned buffers in the AIL push
	  anymore?
	- do we actually need to wait for the CIL flush in the
	  AIL code?
	- do any async log forces need to wait for the CIL flush?
	- do we need a separate "background CIL push" API for
	  the AIL to use?

4. Single threaded

Because the AIL is single threaded, there is a hard limit on the
amount of scanning and IO submission work it can do, and any place
it blocks takes away from it's capacity to flush dirty metadata to
disk.

Discussion points:
	- how long can we get away with efficiency improvements to
	  keep ahead of tens to hundreds of CPUs dirtying metadata?
	- how do break up multi-threaded pushing?
	- can we use multiple AILs (e.g. 1 per AG) and co-ordinate
	  flush targets across them?
	- if we can parallelise the AIL, how much do we care about
	  other improvements?


5. Does not control it's own activity

Typically the AIL is invoked to push on dirty metadata items when
the log reservations pass 75% of the size of the log. This works
great when the log is small because we hit the threshold quickly and
frequently and so the AIL is essentially being told to "just keep
working".

However, when we have large journals, 75% of the log can be 1.5GB of
space, and so it can take some time for the AIL to be woken to do
work. If lots of modifications are taking place, then the log can
run out of space before the AIL has taken any significant action to
start writeback, and because there are so many objects in the AIL it
struggles initially to reach a steady state where tail pushing keeps
enough log space free that incoming transaction reservations don't
have to use the slow wait path.

To make matters more complex, other events will cause the AIL to try
to push everything to disk. Every 30s the log worker comes along and
tells the AIL to "push everything". And every time memory reclaim
runs the shrinker tells the AIL to "push everything". This often
cause the AIL to walk into recently committed and relogged objects
to try to push them, often resulting finding pinned objects and
hence issuing frequent (and unnecessary) log forces to try to unpin
them.

Hence under heavy loads, the AIL really ends up just trying to push
everything all the time, and that ends up exacerbating the
inefficiencies and blocking issues that result from long IO lists
and log forces.

The question I'm asking here is whether this should be turned upside
down. That is, rather than have random callers tell the AIL what it
should do, the AIL itself should decide when are where to push
items. The AIL knows exactly how much space is active in the log -
the head and tail of the AIL define the on-disk log head and tail -
nad when combined with visibility of the amount of unused
reservation space we have a pretty good idea of:

	a) how quickly pushing and IO completions is moving the
	   tail forwards;
	b) how quicly the head is being moved forwards by the
	   workload committing transactions; and
	c) how much demand there is for log space by the workload
	   transaction reservation rate.

From this information we should be able to determine how much work
we need to do, and how long we can leave items in the AIL before we
need to flush them. If there is no reservation pressure, we don't
need to rush to push the tail of the log. If we are moving the tail
of the log faster than the workload is moving the head, then we
don't have to flush the AIL flat out all the time. And so on.

So this is a discussion opportunity to design a better tail pushing
algorithm that is not dependent on being told what to do, but
instead use observation of the rate of change of critical metrics to
determine the rate at which we need to do push work....

-- 
Dave Chinner
david@fromorbit.com
