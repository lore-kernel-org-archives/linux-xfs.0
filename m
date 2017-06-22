Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46876 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750932AbdFVMkt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jun 2017 08:40:49 -0400
Date: Thu, 22 Jun 2017 08:40:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/2 V4] Resubmit items failed during writeback
Message-ID: <20170622124047.GA34265@bfoster.bfoster>
References: <20170616105445.3314-1-cmaiolino@redhat.com>
 <20170619135120.GD25516@bfoster.bfoster>
 <20170619174203.GA4733@birch.djwong.org>
 <20170619185111.GA29903@bfoster.bfoster>
 <20170621004550.GF4733@birch.djwong.org>
 <20170621101526.GC28914@bfoster.bfoster>
 <20170621110349.xhucfxyratu4qmym@eorzea.usersys.redhat.com>
 <20170621115132.GE28914@bfoster.bfoster>
 <20170621165416.GI4733@birch.djwong.org>
 <20170622120528.ala3ofmjvrdxx7ye@eorzea.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170622120528.ala3ofmjvrdxx7ye@eorzea.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Jun 22, 2017 at 02:05:28PM +0200, Carlos Maiolino wrote:
> Thanks for the reply folks.
> 
> > > > > > > > > Hi Carlos,
> > > > > > > > > 
> > > > > > > > > I pointed out the last things that I'm aware of that I think need to be
> > > > > > > > > fixed in this series (along with a few nits here and there). That said,
> > > > > > > > > it's already been pointed out that we probably want an xfstests test
> > > > > > > > > case to go along with this before it would be merged. Is that something
> > > > > > > > > you are still planning on?
> > > > > > > > > 
> > > > 
> > > > Well, I am sure planing a xfstests for this case, I just didn't stop to work on
> > > > it yet, and well, I wasn't expecting to have the test done before merging this
> > > > patchset, is this a requirement? If so, I'll work on that before finishing this
> > > > series, otherwise I'll just finish the series and then move to the xfstests.
> > > > 
> > > 
> > > I think it's reasonable to expect to at least have an xfstests test
> > > posted and available for review before this is merged, but I'll defer to
> > > Darrick on that. I don't think you necessarily have to stop working on
> > > these patches to get the xfstests done (i.e., maybe start putting
> > > something together after the next version goes out for review?), but
> > > that's just my .02. ;)
> > 
> > Yes, it's fine to have testcases out for review, even if we haven't
> > finalized all the debugging knobs necessary.
> > 
> 
> I agree here, that it's good to have the test on xfstests, and I apologize for
> my desire to postpone it, it's not laziness (I promise :). I was just considering
> the amount of time it's taking to have this problem fixed while I've seen reports
> of people hitting this problem more and more often.
> But well, I already have a test case for that, I didn't integrate it into
> xfstests yet because my test isn't 100% automated yet, once I need to wait for
> xfsaild to start flushing such buffers, my current test cases asks the user (me :),
> to hit <enter> when xfsaild runs.
> 
> Btw, any hint on how could I automate that? For now, I was considering to
> monitor the stats of the filesystem in question, specifically the "push_ail"
> stats, and move the test forward when the push_ail statistics starts to show the
> issue, but it doesn't sound as a decent approach to me.
> 
> 

Taking a quick look at something I have laying around that you sent
previously (I assume the test hasn't changed much), I see we basically
create an overprovisioned dm-thin vol, mount it and dio write to it
until we start to see async write failures. So is the purpose of the
wait that we need the AIL to push and ultimately fail the associated
buffers before we attempt an unmount? If so, I'm wondering if you could
xfs_freeze the fs rather than wait (it looks like freeze sync pushes the
AIL)..?

> > > 
> > > I think we all agree that generic error injection (which Darrick has
> > > started playing with, but I haven't looked at yet) doesn't need to be
> > > bundled with this series (I hope we didn't scare you there ;). What I
> > > was asking for is a single patch that adds error injection in one spot
> > > with a configurable frequency. I'll refer to commit 609adfc2ed ("xfs:
> > > debug mode log record crc error injection") again because it is a simple
> > > example of a small DEBUG only hunk of code and boilerplate code to add a
> > > sysfs knob.
> > > 
> 
> I'll keep this in mind, and try to work on something like that :)
> 

I think error injection would make this test more straightforward
because you can explicitly control when I/Os fail and there's no need to
play around with dm-thin. That of course doesn't mean there isn't value
in having a test for fs' in dm-thin out of space conditions in general.
:)

Note that it's probably better to refer to Darrick's errortags series at
this point rather than adding a custom knob like the bad crc patch does
above. See how patch 4 in that series ports over the drop_writes
mechanism, for example. It looks like it should only be an
XFS_TEST_ERROR() injection point and a couple or so new defines to add
the knob, default value, etc.

Brian

> > 
> > Agree.  I'd love to live in a world where most of my review process is
> > examining the overall approach to make sure that it integrates well with
> > the design and letting the automated tests look for bugs in the
> > implementation details, though obviously we're not there.
> > 
> > --D
> > 
> > > Brian
> > > 
> > > [1] In reality, I'm going to do this myself if necessary. I'm just
> > > asking to save myself some time (and possibly encourage similar testing
> > > from others). ;)
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
