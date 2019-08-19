Return-Path: <SRS0=Z/aa=WP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91AADC3A5A1
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 10:21:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68277204EC
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 10:21:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfHSKV3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Aug 2019 06:21:29 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:52391 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726703AbfHSKV2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Aug 2019 06:21:28 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id F26E243D040;
        Mon, 19 Aug 2019 20:21:24 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hzelt-0004Gw-Bk; Mon, 19 Aug 2019 20:20:17 +1000
Date:   Mon, 19 Aug 2019 20:20:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     kaixuxia <xiakaixu1987@gmail.com>, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
Message-ID: <20190819102017.GA6129@dread.disaster.area>
References: <5f2ab55c-c1ef-a8f2-5662-b35e0838b979@gmail.com>
 <20190815233630.GU6129@dread.disaster.area>
 <65790fd5-5915-9318-8737-d81899d73e9e@gmail.com>
 <20190816145310.GB54929@bfoster>
 <20190817014023.GV6129@dread.disaster.area>
 <20190817132006.GA60618@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190817132006.GA60618@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=6QYmVgRpAAAA:8 a=7-415B0cAAAA:8 a=R8h7EXXdWe5AwtPebWIA:9
        a=CjuIK1q_8ugA:10 a=hBeyHLqrtYWpXn6Xfe_q:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 17, 2019 at 09:20:06AM -0400, Brian Foster wrote:
> On Sat, Aug 17, 2019 at 11:40:23AM +1000, Dave Chinner wrote:
> > I like this patch because it means we are starting to reach the
> > end-game of this architectural change.  This patch indicates that
> > people are starting to understand the end goal of this work: to
> > break up big transactions into atomic chains of smaller, simpler
> > linked transactions.  And they are doing so without needing to be
> > explicitly told "this is how we want complex modifications to be
> > done". This is _really good_. :)
> > 
> > And that leads me to start thinking about the next step after that,
> > which I'd always planned it to be, and that is async processing of
> > the "atomic multi-transaction operations". That, at the time, was
> > based on the observation that we had supercomputers with thousands
> > of CPUs banging on the one filesystem and we always had CPUs to
> > spare. That's even more true these days: lots of filesytem
> > operations still single threaded so we have huge amounts of idle CPU
> > to spare. We could be using that to speed up things like rsync,
> > tarball extraction, rm -rf, etc.
> > 
> 
> I haven't read back through the links yet, but on a skim the "async"
> part of this sounds like a gap in what is described in the sections
> referenced above (which sounds more like changing log formats to
> something more logical than physical). I'm pretty familiar with all of
> the dfops bits to this point, the async bit is what I'm asking about...
> 
> What exactly are you thinking about making async that isn't already? Are
> you talking about separating in-core changes from backend
> ordering/logging in general and across the board?

Yup, separating the work we have to do from the process context that
needs it to be done.

Think about a buffered write. All we need to do in process context
is reserve space and copy the data into the kernel. The rest of it
is done asynchornously in the background, and can be expedited by
fsync().

Basically applying that to create, rename, etc. It's more complex
because we have to guarantee ordering of operations, but
fundamentally there is nothing stopping us from doing something liek
this on create:

here's a synchronous create, but with async transaction processing:

	DEFINE_WAIT(wait);

	trans alloc
	lock dir inode
	log intent {
		dir = dp
		op = file create
		name = <xfs_name>
		mode = mode
		wait = wait
	}
	xfs_defer_finish(intent, wait)
		-> commits intent
		-> punts rest of work to worker thread
			-> when all is done, will wakeup(wait)
		-> sleeps on wait
	unlock dir

This could eventually become an async create by restructuring it
kinda like this:

	ip = xfs_inode_alloc();

	<initialise and set up inode, leave XFS_INEW/I_NEW set>

	grab dir sequence number
	trans alloc
	log intent {
		dir = dp
		seq = dir_seq
		op = file create
		name = <xfs_name>
		mode = mode
		ip = ip
	}
	xfs_defer_finish(intent)
		-> commits intent
		-> punts rest of creation work to worker thread
			when complete, will clear XFS_INEW/I_NEW

	return instantiated inode to caller

Anyone one who looks this inode up after creation will block
on XFS_INEW/I_NEW flag bits. The caller that created the inode
will be able to operate on it straight away....

SO converting to async processing is really requires several steps.

	1. convert everything to intent logging and defer
	   operations
	2. start every modification with an intent and commit
	3. add wait events to each dfops chain
	4. run dfops in worker threads, calling wakeups when done
	5. convert high level code to do in-core modifications,
	   dfops runs on-disk transactions only
	6. get rid of high level waits for ops that don't need
	   to wait for transactional changes.

> Or opportunistically
> making certain deferred operations async if the result of such
> operations is not required to be complete by the time the issuing
> operation returns to userspace?

Well, that's obvious for things like unlink. But what such async
processing allows is things like bulk directory modifications
(e.g. rm -rf detection because the dir inode gets unlinked before
we've started processing any of the dirent removal ops) which can
greatly speed up operations.

e.g. rm -rf becomes "load all the inodes into memory as we log
dirent removal, when the dir unlink is logged, truncate the dir
inode they are all gone. Sort all the inodes into same cluster/chunk
groups, free all the inodes in a single inobt/finobt record
update...."

IOWs, moving to intent based logging allows us to dynamically change
the way we do operations - the intent defines what needs to be done,
but it doesn't define how it gets done. As such, bulk processing
optimisations become possible and those optimisations can be done
completely independently of the front end that logs the initial
intent.

> For example, a hole punch needs to
> modify the associated file before it returns, but we might not care if
> the associated block freeing operation has completed or not before the
> punch returns (as long as the intent is logged) because that's not a
> hard requirement of the higher level operation. Whereas the current
> behavior is that the extent free operation is deferred, but it is not
> necessarily async at the operational level (i.e. the async logging
> nature of the CIL notwithstanding). Hm?

Yup, exactly. Nothing says the extent has to be free by the time the
hole punch returns. The only rules we need to play by is that it
looks to userspace like there's hole, and if they run fsync then
there really is a hole.  Otherwise the scheduling of the work is
largely up to us.

Split front/back async processing like this isn't new - it's
something Daniel Phillips was trying to do with tux3. It deferred as
much as it could to the back end processing threads and did as
little as possible in the syscall contexts. See slide 14:

https://events.static.linuxfound.org/sites/events/files/slides/tux3.linuxcon.pdf

So the concept has largely been proven in other filesystems, it's
just that if you don't design something from scratch to be
asynchronous it can be difficult to retrofit...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
