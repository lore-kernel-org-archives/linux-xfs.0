Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28757C3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 14:04:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E848222CF7
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 14:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729819AbfHTOEu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 10:04:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49796 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728248AbfHTOEu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Aug 2019 10:04:50 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 942C131752AB;
        Tue, 20 Aug 2019 14:04:49 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CAB75C205;
        Tue, 20 Aug 2019 14:04:48 +0000 (UTC)
Date:   Tue, 20 Aug 2019 10:04:46 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     kaixuxia <xiakaixu1987@gmail.com>, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
Message-ID: <20190820140446.GC14307@bfoster>
References: <5f2ab55c-c1ef-a8f2-5662-b35e0838b979@gmail.com>
 <20190815233630.GU6129@dread.disaster.area>
 <65790fd5-5915-9318-8737-d81899d73e9e@gmail.com>
 <20190816145310.GB54929@bfoster>
 <20190817014023.GV6129@dread.disaster.area>
 <20190817132006.GA60618@bfoster>
 <20190819102017.GA6129@dread.disaster.area>
 <20190819142809.GA2875@bfoster>
 <20190820010455.GO7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820010455.GO7777@dread.disaster.area>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 20 Aug 2019 14:04:49 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 20, 2019 at 11:04:55AM +1000, Dave Chinner wrote:
> On Mon, Aug 19, 2019 at 10:28:09AM -0400, Brian Foster wrote:
> > On Mon, Aug 19, 2019 at 08:20:17PM +1000, Dave Chinner wrote:
> > > On Sat, Aug 17, 2019 at 09:20:06AM -0400, Brian Foster wrote:
> > > > On Sat, Aug 17, 2019 at 11:40:23AM +1000, Dave Chinner wrote:
> > > > > I like this patch because it means we are starting to reach the
> > > > > end-game of this architectural change.  This patch indicates that
> > > > > people are starting to understand the end goal of this work: to
> > > > > break up big transactions into atomic chains of smaller, simpler
> > > > > linked transactions.  And they are doing so without needing to be
> > > > > explicitly told "this is how we want complex modifications to be
> > > > > done". This is _really good_. :)
> > > > > 
> > > > > And that leads me to start thinking about the next step after that,
> > > > > which I'd always planned it to be, and that is async processing of
> > > > > the "atomic multi-transaction operations". That, at the time, was
> > > > > based on the observation that we had supercomputers with thousands
> > > > > of CPUs banging on the one filesystem and we always had CPUs to
> > > > > spare. That's even more true these days: lots of filesytem
> > > > > operations still single threaded so we have huge amounts of idle CPU
> > > > > to spare. We could be using that to speed up things like rsync,
> > > > > tarball extraction, rm -rf, etc.
> > > > > 
> > > > 
...
> > > Basically applying that to create, rename, etc. It's more complex
> > > because we have to guarantee ordering of operations, but
> > > fundamentally there is nothing stopping us from doing something liek
> > > this on create:
> > > 
> > 
> > Right, my next big question was going to be around maintaining/enforcing
> > ordering (if necessary) around whatever operations end up async
> > deferred. I didn't want to go there because I wasn't really clear on the
> > goal.
> 
> Stuff like ordering of operations are implementation issues, not
> really anything to do with the big picture. Big picture says "user
> visible ordering should be maintained", how to achieve that with
> async processing is something we'll work out how deal with when we
> actually start prototyping async functionality. That's a long way
> off yet, so you're not going to get specific answers to "how do we
> implement this specific thing" - the best you'll get is "sequence
> numbering of some sort"....
> 

Either way, that sounds more like "requirements" to me. All I'm saying
is there needs to be some kind of broader design description before
implementation.

> > > here's a synchronous create, but with async transaction processing:
> > > 
> > > 	DEFINE_WAIT(wait);
> > > 
> > > 	trans alloc
> > > 	lock dir inode
> > > 	log intent {
> > > 		dir = dp
> > > 		op = file create
> > > 		name = <xfs_name>
> > > 		mode = mode
> > > 		wait = wait
> > > 	}
> > > 	xfs_defer_finish(intent, wait)
> > > 		-> commits intent
> > > 		-> punts rest of work to worker thread
> > > 			-> when all is done, will wakeup(wait)
> > > 		-> sleeps on wait
> > > 	unlock dir
> > > 
> > > This could eventually become an async create by restructuring it
> > > kinda like this:
> > > 
> > > 	ip = xfs_inode_alloc();
> > > 
> > > 	<initialise and set up inode, leave XFS_INEW/I_NEW set>
> > > 
> > > 	grab dir sequence number
> > > 	trans alloc
> > > 	log intent {
> > > 		dir = dp
> > > 		seq = dir_seq
> > > 		op = file create
> > > 		name = <xfs_name>
> > > 		mode = mode
> > > 		ip = ip
> > > 	}
> > > 	xfs_defer_finish(intent)
> > > 		-> commits intent
> > > 		-> punts rest of creation work to worker thread
> > > 			when complete, will clear XFS_INEW/I_NEW
> > > 
> > > 	return instantiated inode to caller
> > > 
> > 
> > So for this example, is this async to userspace or to some intermediate
> > level in XFS to facilitate creation batching or some such?
> 
> What needs to be done async is determined by the initial intent
> setup and then xfs_defer_finish() will run what needs to be done
> sync to keep userspace happy and defer everything else.  e.g. we
> might need to run dirent mods sync so lookup/readdir behave
> appropriately, but then everything else can be deferred to an async
> context. 
> 
> Don't ask for specifics, because there aren't any. General answers
> is all you are going to get at this point because that's all the
> high level architecture provides. The details of any specific answer
> will change as we slowly change the code to make use of new in
> memory tracking structures and fine-grained intent based operations.
> 

I'm not asking for specifics. I'm asking for clarification on observable
behavior of the pseudocode you posted above. The bit you've described
below around how I_NEW works indirectly answers the question, for the
most part.

> > It sounds
> > kind of like a delayed inode allocation mechanism, though that might be
> > a challenge to expose to userspace if we don't do enough to at least
> > acquire a physical inode number.
> 
> That's not a new problem - the VFS already solves that problem
> on lookup with the I_NEW flag. i.e. new references will block until
> the inode is fully instantiated and the I_NEW flag is cleared. We
> also have XFS_INEW to do the same thing internally in XFS. IOWs, we
> already have infrastructure to block async lookups if we need
> information that is only instantiately during allocation....
> 
> > > Anyone one who looks this inode up after creation will block
> > > on XFS_INEW/I_NEW flag bits. The caller that created the inode
> > > will be able to operate on it straight away....
> > > 
> > > SO converting to async processing is really requires several steps.
> > > 
> > > 	1. convert everything to intent logging and defer
> > > 	   operations
> > 
> > The approach makes sense, this all sounds like mostly mechanism.
> 
> I wasn't detailing the high level design - I was describing the
> process we'd need to undertake to get to async processing to
> indicate how far off it actually is. :)
> 

Ok.

> > What's
> > still lacking is a high level design description to justify large scale
> > developmental decisions like "converting everything to intent logging."
> > Particularly since whatever new intents we create will need to be
> > supported indefinitely once they're released in the wild. Note that I'm
> > sure you're working/thinking in design -> implement mode and can see
> > some of these decisions more clearly, but the rest of us shouldn't have
> > to piece together the design story from implementation details. ;)
> 
> What justification is needed? We went through all that years ago -
> I've got historical records from XFS meetings in 2004 that document
> all these problems and many of the potential solutions. e.g. delayed
> logging is one of the things brought up in those documents. IOWs,
> we've proven time and time again that the limitation of
> metadata performance in XFS is physical logging, and using
> fine-grained intent logging has long been seen as a solution to the
> problem for almost as long.
> 

The same justification that's required for every patch we merge..? I
think you're misreading me here. I'm saying if you wanted to pose the
idea of starting to turn arbitrary ops into deferred ops for the purpose
of the grand async future, I haven't to this point seen any kind of
design description or some such that justifies making that kind of
change.

> That is reflected in the title of the document I pointed you at:
> "Improving metadata performance by reducing journal overhead". That
> whole section of the document at is based around one thing -
> improving journalling efficiency by reducing the journalling
> overhead.
> 

Logical logging is unrelated to my questions around the idea of async
deferred operations. Note that I'm not saying these two things aren't
part of a progression or aren't technically interdependent or anything
of that nature. I'm saying the logical logging approach is documented,
has quantifiable value and we have examples of it today, as you've gone
into detail on below. There's no need to argue any of that here.

I do note that you're referring to the explicit intent/done instances
(like what this patch creates for unlinked list removal) and instances
of logical logging (such as icreate) interchangeably. I'm not going to
quibble over terminology (i.e. no need to go into that here), but note
that I'm only digging at the notion of creating more instances of the
former for the purpose of async deferred operations. The icreate
transaction isn't a deferred operation and intent logging as it relates
to logical logging is orthogonal to this patch.

In fact, I'd argue this patch is more likely to increase transaction
overhead than reduce it because it's (ab)using a mechanism to break down
complex transactions into multiple for something that isn't complex
enough to require it. IOW, we've added a transaction roll and and
intent/done item pair that must be logged without any corresponding
changes to reduce log overhead of the core operation via logical
logging.

...
> 
> > For example, even with the examples discussed here it's not clear to me
> > we need to define an intent for unlinked list removal. We've already
> > discussed methods to make removal further asynchronous than it already
> > is at a higher level that doesn't depend on asynchronous transaction
> > processing at all. Even if unlinked removal did end up deferred in
> > certain use cases, that should be dictated by redesign of particular
> > higher level operations (which may or may not require that granular of
> > an intent).
> 
> The part of inode unlink Darrick is working on making async is the
> part when userspace has dropped it's final reference to the unlinked
> inode. i.e. after userspace is done with it. The unlinked inode is
> in reclaim at that point, and we can do what we want with it. i.e.
> it's an inode reclaim optimisation, not something that userspace
> will ever see or notice.
> 

That's precisely my point. That's the operation this patch turns into a
deferred operation (and intent/done sequence), and that's why I'm trying
to understand why/how this relates to some future async dfops processing
scheme.

> That is, the actual part of unlinking the inode from the directory
> and adding it to the AGI unlinked list is still synchonous, and
> still blocks userspace. We want that part async, too, so we can get
> all the entries removed from directories and the directory unlinked
> before we start processing any of the inode unlinks...
> 
> And, FWIW, AGI unlinked list addition/removal should really be made
> an intent rather than physically logging the iunlink field in the
> inode buffer.
> 
> > > e.g. rm -rf becomes "load all the inodes into memory as we log
> > > dirent removal, when the dir unlink is logged, truncate the dir
> > > inode they are all gone. Sort all the inodes into same cluster/chunk
> > > groups, free all the inodes in a single inobt/finobt record
> > > update...."
> > > 
> > 
> > This sounds like a great example to run through a design description for
> > or (even better) an RFC. It clearly depends on some mechanical things
> > like conversion of some operations to use intents and enhancements to
> > deferred processing to provide an async execution context. It also may
> > depend on some less mechanical things like ordering rules and a batching
> > detection heuristic, but things like that can be easily fudged for an
> > RFC.
> 
> Sure, that will all come in time. You're asking about things that
> are still a few years away from being realised. There's still a lot
> of work to do before we get anywhere near the "lets start making
> things async and batching" point in time.
> 
> > It also presents an opportunity to demonstrate value. While this all
> > sounds like a nice approach in theory, there are still interesting
> > questions like how much this improves performance over the aggregation
> > provided by delayed logging, what object locking looks like across the
> > new separation between process transaction processing and deferred/async
> > transaction processing, whether intent granularity needs to
> > fundamentally change from the approach we've taken so far (that hasn't
> > been with consideration for async processing, etc).
> 
> Intent based logging is easily an order of magnitude, maybe two
> orders of magnitude more efficient than physical logging on for 64kB
> block size filesystems. You can see from above the gains that are
> realised, and there is plenty of other filesystems and research out
> there that demonstrate the efficiency gains associated with logical
> intent logging.  IOWs, the path we are already on (moving to intent
> based logging) is well grounded in both theory and reality, and so
> it really does not need any further justification.
> 
> The async processing side of things is the next step beyond - saying
> that "we've got a lot of things to consider here" is stating the
> bleeding obvious. It's the big picture goal I've had in mind for a
> long time, but there's no point in getting into any sort of detailed
> design while we are still several steps away from having a platform
> we can start actually prototyping functionality on. 
> 

It's perfectly reasonable to me to say that it's far too early to reason
about how the grand async future is going to work. To be fair, you're
the one who brought it up. :) I'm just following up with questions to
try and understand what you're talking about when you use that to say
that you like this patch. I'm not asking for detailed design. I'm simply
asking you provide enough to relate this patch to your "big picture
goal." Most of what I'm getting back is either very nebulous or
complaints about the questions, so my opinion on the patch hasn't really
changed.

Again, that's all fine if it's too early to answer these questions..
just don't expect to convince me in the same thread that something as
detailed as an unlinked list removal deferred operation is a fait
accompli to support a design vision that is too far out to describe an
association with. You might have been thinking about this for a long
time and so see it that way, and I suppose that's somewhat informative
with you being a steward of XFS architecture and all (which is part of
why I'm asking and not ignoring :), but that otherwise doesn't make for
a useful discussion or a compelling argument for people who might want
to understand the goal and can't read your mind.

FWIW, the rm -rf example makes a lot more sense and helps explain much
more of a general idea of what you're talking about than what I had
before. The only conclusion I can draw from this as it relates to this
patch, however, is that it might be useful down the road, or it might
not. That's good enough for me for the time being.

> Hence I haven't spend any time on trying to document it because we
> haven't set all the foundations it needs in concrete yet. That we
> are starting to talk about it is indicative that we're getting close
> to needing a new set of "Ideas for XFS" that lay out this stuff in a
> more concrete fashion, but we aren't quite there yet....
> 
> And, realistically, we have to be aware that async processing by
> itself may not realise any gains at all. The gains I see being
> significant come from batching multiple async modifications into
> single operations, not from a direct conversion to async processing
> But we can't do batching if we don't have infrastructure that allows
> large numbers of operations to be performed in an asynchronous
> manner.
> 

Yep, that's another open question to me: whether there's a tradeoff
between too much asynchrony vs. the current appoach, whether it be with
too much context switching and transaction churn on boxes with fewer
CPUs, or driving too deep queues of async ops, etc. Big picture or not,
implementation detail or not, categorize questions like that however you
like. To me, those are fundamental factors into decisions over things
like the granularity/design of async tasks and associated intents. If we
can't practically reason about that yet, then it's kind of hard to
reason about deferring some random low level operation in service of
that undefined model.

Brian

> That's where comparisons with delayed logging falls down. Delayed
> logging is possible because it sits behind an interface that allows
> async processing of operations. i.e. The CIL is the batch processing
> mechanism built underneath an async interface, it's not an async
> mechanism itself. We've got to add the equivalent of the async
> transaction commit interface before we can even think about how
> batching operations could be done. Async first, batching later.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
