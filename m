Return-Path: <SRS0=Mbmt=WN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87CB9C3A59B
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Aug 2019 13:20:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47A152133F
	for <linux-xfs@archiver.kernel.org>; Sat, 17 Aug 2019 13:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbfHQNUL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Aug 2019 09:20:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42622 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725784AbfHQNUL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 17 Aug 2019 09:20:11 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B62FDA2E0EE;
        Sat, 17 Aug 2019 13:20:10 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AD2A5166A2;
        Sat, 17 Aug 2019 13:20:08 +0000 (UTC)
Date:   Sat, 17 Aug 2019 09:20:06 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     kaixuxia <xiakaixu1987@gmail.com>, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH] xfs: Fix agi&agf ABBA deadlock when performing rename
 with RENAME_WHITEOUT flag
Message-ID: <20190817132006.GA60618@bfoster>
References: <5f2ab55c-c1ef-a8f2-5662-b35e0838b979@gmail.com>
 <20190815233630.GU6129@dread.disaster.area>
 <65790fd5-5915-9318-8737-d81899d73e9e@gmail.com>
 <20190816145310.GB54929@bfoster>
 <20190817014023.GV6129@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190817014023.GV6129@dread.disaster.area>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Sat, 17 Aug 2019 13:20:10 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Aug 17, 2019 at 11:40:23AM +1000, Dave Chinner wrote:
> On Fri, Aug 16, 2019 at 10:53:10AM -0400, Brian Foster wrote:
> > On Fri, Aug 16, 2019 at 04:09:39PM +0800, kaixuxia wrote:
> > > 
> > > 
> > > On 2019/8/16 7:36, Dave Chinner wrote:
> > > > On Tue, Aug 13, 2019 at 07:17:33PM +0800, kaixuxia wrote:
> > > > > In this patch we make the unlinked list removal a deferred operation,
> > > > > i.e. log an iunlink remove intent and then do it after the RENAME_WHITEOUT
> > > > > transaction has committed, and the iunlink remove intention and done
> > > > > log items are provided.
> > > > 
> > > > I really like the idea of doing this, not just for the inode unlink
> > > > list removal, but for all the high level complex metadata
> > > > modifications such as create, unlink, etc.
> > > > 
> > > > The reason I like this is that it moves use closer to being able to
> > > > do operations almost completely asynchronously once the first intent
> > > > has been logged.
> > > > 
> > > 
> > > Thanks a lot for your comments.
> > > Yeah, sometimes the complex metadata modifications correspond to the
> > > long and complex transactions that hold more locks or other common
> > > resources, so the deferred options may be better choices than just
> > > changing the order in one transaction.
> > > 
> > 
> > I can't speak for Dave (who can of course chime in again..) or others,
> > but I don't think he's saying that this approach is preferred to the
> > various alternative approaches discussed in the other subthread. Note
> > that he also replied there with another potential solution that doesn't
> > involve deferred operations.
> 
> Right, two separate things. One: fixing the bug doesn't require
> deferred operations.
> 
> Two: async deferred operations is the direction we've been heading
> in for a long, long time.
> 

Ok, we're on the same page in terms of these being separate issues.

I think we might have different thoughts on the application of the term
async, because deferred operations != async in my mind. The latter makes
me think of various potential (and semi-crazy) behavior changes that I'm
not going to go into because I'd rather ask for context than guess at
what you're thinking.

> > Rather, I think he's viewing this in a much longer term context around
> > changing more of the filesystem to be async in architecture.
> 
> Right, in terms of longer term context.
> 
> > Personally,
> > I'd have a ton more questions around the context of what something like
> > that looks like before I'd support starting to switch over less complex
> > operations to be deferred operations based on the current dfops
> > mechanism.
> >
> > The mechanism works and solves real problems, but it also has
> > tradeoffs that IMO warrant the current model of selective use. Further,
> > it's nearly impossible to determine what other fundamental
> > incompatibilities might exist without context on bigger picture design.
> 
> The "bigger picture" takes up a lot of space in my head, and it has
> for a long time. However, here you are worrying about implementation
> details around the dfops mechanisms - that's not big picture
> thinking.
> 

Right, I was intentionally trying to focus on the bug because I got the
impression that the patch author believes adding a log incompat bit and
some refactoring makes this patch acceptable for merge to fix the lock
ordering bug.

That of course doesn't mean this intent patch might not be useful
towards such unrelated and bigger changes down the road, particularly if
the author wanted to dig into that effort..

> Big picture thinking is about how all the pieces fit together, not
> how a specific piece of the picture is implemented. The design and
> implementation of the dfops mechanism is going to change over time,
> but the architectural function it performs will not change.
> 
> The architectural problem the "intent and deferral" mechanism solves
> is that XFS's original "huge complex transaction" model broke down
> when we started trying to add more functionality to each individual
> transaction. This first came to light in the late 90s, when HSMs
> required attributes and attributes could not be added atomically in
> creation operations. So all sorts of problems occurred on crashes,
> which mean HSMs had to scan filesytsems after a crash to find files
> with inconsistent attributes (hence bulkstat!). The problem still
> exists today with security attributes, default acls, etc.
> 
> And then we started wanting to add parent pointers. Which require
> atomic manipulation of attributes in directory modification
> transactions. Oh dear.  And then came desires to add rmap, which
> needed their own atomic additions to every transaction in the
> filesysetm that allocated or freed space. And then reflink, with
> it's requirements.
> 

Yep, I'm pretty familiar with most of this at this point.

> The transaction model basically broke down - it couldn't do what we
> needed.  You can see some of the ideas I had more than 10 years ago
> about how we'd need to morph XFS to support the flexibility in
> transactional modifications we needed here:
> 
> http://xfs.org/index.php/Improving_Metadata_Performance_By_Reducing_Journal_Overhead#Operation_Based_Logging
> http://xfs.org/index.php/Improving_Metadata_Performance_By_Reducing_Journal_Overhead#Atomic_Multi-Transaction_Operations
> 

I don't recall going through this, though, at least any time recent
enough that I'd probably be able to grok it. Thanks for the reference,
I'll give it a read.

> The "operation based logging" mechanism is essentially how we are
> using intents in deferred operations. Another example is the icreate
> item, which just logs the location of the inode chunk we need
> to initialise, rahter than logging the physical initialisation
> directly.
> 
> The problem that Darrick solved with the deferred operations was the
> "atomic multi-transaction operations" problem - i.e. how to link all
> these smaller, individual atomic modifications into a much larger
> fail-safe atomic operation without blowing out the log reservation
> to cover every single possible change that could be made.
> 
> Now, keep in mind that the potential mechanisms/implementations I
> talk about in those links are way out of date. It's the concepts and
> direction - the bigger picture - that I'm demonstrating here. So
> don't get stuck on "but that mechanism won't work", rather see it
> for what it actually is - ideas for how we go from complex, massive
> transactions to flexible agreggated chains of small, individual
> intent-based transactions.
> 

Sure. I think you misinterpret my response about not wanting to start
deferring arbitrary operations right now into being some reflection on
thoughts of future use of said mechanism. I'm 1.) indicating that I don't
think the current mechanism warrants arbitrary use (because that's what
this patch we're discussing right now fundamentally does) and 2.) asking
for context around that longer term vision, because right now I have
_zero_.

IOW, my feedback is on this patch and not a reflection on some future
design that I have no notion of in my head. I'm very much interested in
hearing/reading more about the longer term vision here, but I'm also
very much against this patch (right now, for its documented purpose). :)

> IOWs, dfops is just infrastructure to provide the intent chaining
> functionality required by the "aggregated chains" modification
> architecture. If we have to modify the dfops infrastructure to solve
> problems along the way, then thats just fine. It's just a mechanism
> we used to implement a piece of the bigger picture - dfops is not a
> feature in the bigger picture at all.....
> 

*nod*

> In terms of the bigger picture, the work Allison is doing to
> re-architect the attribute manipulations around deferred operations
> for parent pointers is breaking the new ground here. It's slow going
> because it's the first major conversion to the "new way", but it's
> telling us about all the things the dfops mechanism doesn't provide.
> Conversions of other operations will be simpler as the dfops
> infrastructure will be more capable as a result of the attribute
> conversion.
> 

I'm aware, I've been reviewing that code.

> But kind in mind that it is the conversion of attribute modification
> to chained intents that is the big picture work here - dfops is just
> the mechanism it uses. i.e. It's the conversion to the "operation
> based logging + atomic multi-transaction" architecture that allows
> us to add attribute modifications into directory operations and
> guarantee the dir and attr mods are atomic.
> 
> From that perspective, dfops is just the implementation mechanism that
> makes the architectural big picture change possible. dfops will need
> change and morph as necessary to support these changes, but those
> changes are not architectural or big picture items - they are just
> implementation details....
> 
> I like this patch because it means we are starting to reach the
> end-game of this architectural change.  This patch indicates that
> people are starting to understand the end goal of this work: to
> break up big transactions into atomic chains of smaller, simpler
> linked transactions.  And they are doing so without needing to be
> explicitly told "this is how we want complex modifications to be
> done". This is _really good_. :)
> 
> And that leads me to start thinking about the next step after that,
> which I'd always planned it to be, and that is async processing of
> the "atomic multi-transaction operations". That, at the time, was
> based on the observation that we had supercomputers with thousands
> of CPUs banging on the one filesystem and we always had CPUs to
> spare. That's even more true these days: lots of filesytem
> operations still single threaded so we have huge amounts of idle CPU
> to spare. We could be using that to speed up things like rsync,
> tarball extraction, rm -rf, etc.
> 

I haven't read back through the links yet, but on a skim the "async"
part of this sounds like a gap in what is described in the sections
referenced above (which sounds more like changing log formats to
something more logical than physical). I'm pretty familiar with all of
the dfops bits to this point, the async bit is what I'm asking about...

What exactly are you thinking about making async that isn't already? Are
you talking about separating in-core changes from backend
ordering/logging in general and across the board? Or opportunistically
making certain deferred operations async if the result of such
operations is not required to be complete by the time the issuing
operation returns to userspace? For example, a hole punch needs to
modify the associated file before it returns, but we might not care if
the associated block freeing operation has completed or not before the
punch returns (as long as the intent is logged) because that's not a
hard requirement of the higher level operation. Whereas the current
behavior is that the extent free operation is deferred, but it is not
necessarily async at the operational level (i.e. the async logging
nature of the CIL notwithstanding). Hm?

Brian

> I mapped out 10-15 years worth of work for XFS back in 2008, and
> we've been regularly ticking off boxes on the implementation
> checklist ever since. We're actually tracking fairly well on the
> "done in 15yrs" timeline at the moment. Async operation is at the
> end of that checklist...
> 
> What I'm trying to say is that the bigger picture here has been out
> there for a long time, but you have to look past the trees to see
> it. Hopefully now that I've pointed out the forest, it will be
> easier to see :)
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
