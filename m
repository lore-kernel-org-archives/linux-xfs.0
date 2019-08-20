Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 739B7C3A5A0
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 01:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F3D422CE8
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 01:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbfHTBGH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Aug 2019 21:06:07 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58159 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728615AbfHTBGH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Aug 2019 21:06:07 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 815F13622E3;
        Tue, 20 Aug 2019 11:06:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hzsZz-0001XJ-5a; Tue, 20 Aug 2019 11:04:55 +1000
Date:   Tue, 20 Aug 2019 11:04:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     kaixuxia <xiakaixu1987@gmail.com>, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
Message-ID: <20190820010455.GO7777@dread.disaster.area>
References: <5f2ab55c-c1ef-a8f2-5662-b35e0838b979@gmail.com>
 <20190815233630.GU6129@dread.disaster.area>
 <65790fd5-5915-9318-8737-d81899d73e9e@gmail.com>
 <20190816145310.GB54929@bfoster>
 <20190817014023.GV6129@dread.disaster.area>
 <20190817132006.GA60618@bfoster>
 <20190819102017.GA6129@dread.disaster.area>
 <20190819142809.GA2875@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819142809.GA2875@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=k_SJVGh1nHqu_K4IxgAA:9 a=niOfX3Dfk4gMlgVk:21
        a=aAlmpVJ3dtocFb9h:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 19, 2019 at 10:28:09AM -0400, Brian Foster wrote:
> On Mon, Aug 19, 2019 at 08:20:17PM +1000, Dave Chinner wrote:
> > On Sat, Aug 17, 2019 at 09:20:06AM -0400, Brian Foster wrote:
> > > On Sat, Aug 17, 2019 at 11:40:23AM +1000, Dave Chinner wrote:
> > > > I like this patch because it means we are starting to reach the
> > > > end-game of this architectural change.  This patch indicates that
> > > > people are starting to understand the end goal of this work: to
> > > > break up big transactions into atomic chains of smaller, simpler
> > > > linked transactions.  And they are doing so without needing to be
> > > > explicitly told "this is how we want complex modifications to be
> > > > done". This is _really good_. :)
> > > > 
> > > > And that leads me to start thinking about the next step after that,
> > > > which I'd always planned it to be, and that is async processing of
> > > > the "atomic multi-transaction operations". That, at the time, was
> > > > based on the observation that we had supercomputers with thousands
> > > > of CPUs banging on the one filesystem and we always had CPUs to
> > > > spare. That's even more true these days: lots of filesytem
> > > > operations still single threaded so we have huge amounts of idle CPU
> > > > to spare. We could be using that to speed up things like rsync,
> > > > tarball extraction, rm -rf, etc.
> > > > 
> > > 
> > > I haven't read back through the links yet, but on a skim the "async"
> > > part of this sounds like a gap in what is described in the sections
> > > referenced above (which sounds more like changing log formats to
> > > something more logical than physical). I'm pretty familiar with all of
> > > the dfops bits to this point, the async bit is what I'm asking about...
> > > 
> > > What exactly are you thinking about making async that isn't already? Are
> > > you talking about separating in-core changes from backend
> > > ordering/logging in general and across the board?
> > 
> > Yup, separating the work we have to do from the process context that
> > needs it to be done.
> > 
> > Think about a buffered write. All we need to do in process context
> > is reserve space and copy the data into the kernel. The rest of it
> > is done asynchornously in the background, and can be expedited by
> > fsync().
> > 
> 
> Yep, makes sense.
> 
> > Basically applying that to create, rename, etc. It's more complex
> > because we have to guarantee ordering of operations, but
> > fundamentally there is nothing stopping us from doing something liek
> > this on create:
> > 
> 
> Right, my next big question was going to be around maintaining/enforcing
> ordering (if necessary) around whatever operations end up async
> deferred. I didn't want to go there because I wasn't really clear on the
> goal.

Stuff like ordering of operations are implementation issues, not
really anything to do with the big picture. Big picture says "user
visible ordering should be maintained", how to achieve that with
async processing is something we'll work out how deal with when we
actually start prototyping async functionality. That's a long way
off yet, so you're not going to get specific answers to "how do we
implement this specific thing" - the best you'll get is "sequence
numbering of some sort"....

> > here's a synchronous create, but with async transaction processing:
> > 
> > 	DEFINE_WAIT(wait);
> > 
> > 	trans alloc
> > 	lock dir inode
> > 	log intent {
> > 		dir = dp
> > 		op = file create
> > 		name = <xfs_name>
> > 		mode = mode
> > 		wait = wait
> > 	}
> > 	xfs_defer_finish(intent, wait)
> > 		-> commits intent
> > 		-> punts rest of work to worker thread
> > 			-> when all is done, will wakeup(wait)
> > 		-> sleeps on wait
> > 	unlock dir
> > 
> > This could eventually become an async create by restructuring it
> > kinda like this:
> > 
> > 	ip = xfs_inode_alloc();
> > 
> > 	<initialise and set up inode, leave XFS_INEW/I_NEW set>
> > 
> > 	grab dir sequence number
> > 	trans alloc
> > 	log intent {
> > 		dir = dp
> > 		seq = dir_seq
> > 		op = file create
> > 		name = <xfs_name>
> > 		mode = mode
> > 		ip = ip
> > 	}
> > 	xfs_defer_finish(intent)
> > 		-> commits intent
> > 		-> punts rest of creation work to worker thread
> > 			when complete, will clear XFS_INEW/I_NEW
> > 
> > 	return instantiated inode to caller
> > 
> 
> So for this example, is this async to userspace or to some intermediate
> level in XFS to facilitate creation batching or some such?

What needs to be done async is determined by the initial intent
setup and then xfs_defer_finish() will run what needs to be done
sync to keep userspace happy and defer everything else.  e.g. we
might need to run dirent mods sync so lookup/readdir behave
appropriately, but then everything else can be deferred to an async
context. 

Don't ask for specifics, because there aren't any. General answers
is all you are going to get at this point because that's all the
high level architecture provides. The details of any specific answer
will change as we slowly change the code to make use of new in
memory tracking structures and fine-grained intent based operations.

> It sounds
> kind of like a delayed inode allocation mechanism, though that might be
> a challenge to expose to userspace if we don't do enough to at least
> acquire a physical inode number.

That's not a new problem - the VFS already solves that problem
on lookup with the I_NEW flag. i.e. new references will block until
the inode is fully instantiated and the I_NEW flag is cleared. We
also have XFS_INEW to do the same thing internally in XFS. IOWs, we
already have infrastructure to block async lookups if we need
information that is only instantiately during allocation....

> > Anyone one who looks this inode up after creation will block
> > on XFS_INEW/I_NEW flag bits. The caller that created the inode
> > will be able to operate on it straight away....
> > 
> > SO converting to async processing is really requires several steps.
> > 
> > 	1. convert everything to intent logging and defer
> > 	   operations
> 
> The approach makes sense, this all sounds like mostly mechanism.

I wasn't detailing the high level design - I was describing the
process we'd need to undertake to get to async processing to
indicate how far off it actually is. :)

> What's
> still lacking is a high level design description to justify large scale
> developmental decisions like "converting everything to intent logging."
> Particularly since whatever new intents we create will need to be
> supported indefinitely once they're released in the wild. Note that I'm
> sure you're working/thinking in design -> implement mode and can see
> some of these decisions more clearly, but the rest of us shouldn't have
> to piece together the design story from implementation details. ;)

What justification is needed? We went through all that years ago -
I've got historical records from XFS meetings in 2004 that document
all these problems and many of the potential solutions. e.g. delayed
logging is one of the things brought up in those documents. IOWs,
we've proven time and time again that the limitation of
metadata performance in XFS is physical logging, and using
fine-grained intent logging has long been seen as a solution to the
problem for almost as long.

That is reflected in the title of the document I pointed you at:
"Improving metadata performance by reducing journal overhead". That
whole section of the document at is based around one thing -
improving journalling efficiency by reducing the journalling
overhead.

The biggest issue we have is physical journalling is expensive in
terms of CPU, memory and IO bandwidth. Delayed logging knocked IO
bandwidth down by a factor of 10x, but it came at the cost of
substantial additional CPU and more than doubled the memory
footprint of the transaction subsystem. That's because it added
another layer of buffering (2 layers if you count shadow buffers)
to aggregate all the physical changes that have been made to
objects.

You can see how this affects performance by comparing 4kB block size
performance with 64kB block size performance. 4kB is far faster
because physical logging results in a 10x increase log IO bandwidth
for the same operations, a substantatial increase in memory
footprint and a huge increase in CPU usage as a result of larger
contiguous allocations and memcpy()s when logging changes. So
despite the fact we do less IOPS, the added overhead of everything
means 64kB block size only acheives 30-50% of the performance of 4kB
block size filesystems under heavy metadata modification workloads.

IOWs, the performance of the filesystem is still largely limited by
the physical logging of metadata in the journalling subsystem, and
the only way around that is to avoid physical logging of objects.

That's the architectural problem that intent logging solves. We move
away from the CPU, memory and bandwidth requirements of physical
logging to create atomic transactions and replace it with small,
logical changes that are chained together to create larger atomic
operations.

I mentioned icreate earlier as an example - perhaps adding numbers
to this will make it clear the gains we can realise via intent
logging. Creating an inode chunk on a v5 filesystem with physical
logging requires 64 inode core regions to be physically logged.
In terms of log item size for a single inode chunk:

	size = 64 * (2 * 128 + sizeof(ophdr))
	     = ~20kB per inode chunk

This requires a 20kB allocation, a heap of CPU processing to walk
the format bitmap multiple times, and then 20kB of log space to
write it.

Now do 100,000 inode creates/s - that's 15,000 inode clusters, so we
are talking 15,000 * 20kB = 300MB/s log bandwidth for the physical
inode clusters alone. And delayed logging can't mitigate this
because we don't relog inode buffers. So the icreate item replaced
this 20kB of physical log bandwidth with about 50 bytes of log
bandwidth and almost no CPU or log item memory overhead on during
transaction commit.

On my 32p test machine, I'm seeing inode creates rates of over
500,000/s, and that's using maybe 200MB/s of log bandwidthi with
icreate. Without the icreate transaction, we'd need 1.5-2GB/s of log
bandwidth to get this sort of performance.

It should be clear from this example just how much overhead we can
avoid by logging intents rather than physical changes. This is not
speculation, intent logging benefits are well proven theory....

> For example, even with the examples discussed here it's not clear to me
> we need to define an intent for unlinked list removal. We've already
> discussed methods to make removal further asynchronous than it already
> is at a higher level that doesn't depend on asynchronous transaction
> processing at all. Even if unlinked removal did end up deferred in
> certain use cases, that should be dictated by redesign of particular
> higher level operations (which may or may not require that granular of
> an intent).

The part of inode unlink Darrick is working on making async is the
part when userspace has dropped it's final reference to the unlinked
inode. i.e. after userspace is done with it. The unlinked inode is
in reclaim at that point, and we can do what we want with it. i.e.
it's an inode reclaim optimisation, not something that userspace
will ever see or notice.

That is, the actual part of unlinking the inode from the directory
and adding it to the AGI unlinked list is still synchonous, and
still blocks userspace. We want that part async, too, so we can get
all the entries removed from directories and the directory unlinked
before we start processing any of the inode unlinks...

And, FWIW, AGI unlinked list addition/removal should really be made
an intent rather than physically logging the iunlink field in the
inode buffer.

> > e.g. rm -rf becomes "load all the inodes into memory as we log
> > dirent removal, when the dir unlink is logged, truncate the dir
> > inode they are all gone. Sort all the inodes into same cluster/chunk
> > groups, free all the inodes in a single inobt/finobt record
> > update...."
> > 
> 
> This sounds like a great example to run through a design description for
> or (even better) an RFC. It clearly depends on some mechanical things
> like conversion of some operations to use intents and enhancements to
> deferred processing to provide an async execution context. It also may
> depend on some less mechanical things like ordering rules and a batching
> detection heuristic, but things like that can be easily fudged for an
> RFC.

Sure, that will all come in time. You're asking about things that
are still a few years away from being realised. There's still a lot
of work to do before we get anywhere near the "lets start making
things async and batching" point in time.

> It also presents an opportunity to demonstrate value. While this all
> sounds like a nice approach in theory, there are still interesting
> questions like how much this improves performance over the aggregation
> provided by delayed logging, what object locking looks like across the
> new separation between process transaction processing and deferred/async
> transaction processing, whether intent granularity needs to
> fundamentally change from the approach we've taken so far (that hasn't
> been with consideration for async processing, etc).

Intent based logging is easily an order of magnitude, maybe two
orders of magnitude more efficient than physical logging on for 64kB
block size filesystems. You can see from above the gains that are
realised, and there is plenty of other filesystems and research out
there that demonstrate the efficiency gains associated with logical
intent logging.  IOWs, the path we are already on (moving to intent
based logging) is well grounded in both theory and reality, and so
it really does not need any further justification.

The async processing side of things is the next step beyond - saying
that "we've got a lot of things to consider here" is stating the
bleeding obvious. It's the big picture goal I've had in mind for a
long time, but there's no point in getting into any sort of detailed
design while we are still several steps away from having a platform
we can start actually prototyping functionality on. 

Hence I haven't spend any time on trying to document it because we
haven't set all the foundations it needs in concrete yet. That we
are starting to talk about it is indicative that we're getting close
to needing a new set of "Ideas for XFS" that lay out this stuff in a
more concrete fashion, but we aren't quite there yet....

And, realistically, we have to be aware that async processing by
itself may not realise any gains at all. The gains I see being
significant come from batching multiple async modifications into
single operations, not from a direct conversion to async processing
But we can't do batching if we don't have infrastructure that allows
large numbers of operations to be performed in an asynchronous
manner.

That's where comparisons with delayed logging falls down. Delayed
logging is possible because it sits behind an interface that allows
async processing of operations. i.e. The CIL is the batch processing
mechanism built underneath an async interface, it's not an async
mechanism itself. We've got to add the equivalent of the async
transaction commit interface before we can even think about how
batching operations could be done. Async first, batching later.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
