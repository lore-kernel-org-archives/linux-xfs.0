Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:64099
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751167AbdIMWC3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Sep 2017 18:02:29 -0400
Date: Thu, 14 Sep 2017 08:01:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: add regression test for DAX mount option usage
Message-ID: <20170913220108.GX10621@dastard>
References: <20170908152805.GA16646@linux.intel.com>
 <20170908212153.14880-1-ross.zwisler@linux.intel.com>
 <20170912064411.GR10621@dastard>
 <20170912153820.GA5000@linux.intel.com>
 <20170912234729.GW10621@dastard>
 <20170913144215.GA12395@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170913144215.GA12395@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: fstests@vger.kernel.org, Eryu Guan <eguan@redhat.com>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Sep 13, 2017 at 08:42:15AM -0600, Ross Zwisler wrote:
> On Wed, Sep 13, 2017 at 09:47:29AM +1000, Dave Chinner wrote:
> 
> <>
> 
> > I think similar concerns exist with using perf, too....
> 
> I though that using perf addressed both concerns?
> 
> > > > So what happens when the user is already tracing the test to
> > > > find a bug and the test turns all their tracing off?
> 
> By using perf we isolate our tracing from whatever other tracing is happening
> in the system.  So, unlike the case where we were messing with a system-wide
> ftrace knob, we run perf on our executable, and someone else can run perf on
> their executable, and they don't collide.

Yes, you've addressed the "gets inteh way of other tracing concern,
but it's doesn't address the "it's an ugly way to determine a
feature is active" concerns. It also creates an implicit stable
tracepoint out of whatever you are looking at. i.e. that tracepoint
can't go away, nor can it change functionality once a userspace app
depends on it's current semantics to function correctly.

And....

> > > > Regardless of this screwing up developer bug triage, do we really
> > > > want to add a dependency on kernel tracing into the test harness?
> 
> Yep, you're right that this adds a dependency on perf.  But unfortunately,
> without using either perf or ftrace, I don't know of a way to detect whether
> or not DAX is actually being used.  Can you think of another way?

... if there isn't a programmatic interface to tell applications
that DAX is in use, then perhaps we're missing a formal userspace
API that we should have, yes?

> I tried to do this correctly and just skip the test with _notrun
> if perf isn't available on the host system.  This is the same
> thing that happens if you are missing other dependencies for a
> test (some other command (chacl, getfattr, setfattr) not present,
> quota tools not installed, required users not present, etc).

Sure, but if we have user configurable functionality, then using
something like ftrace/perf to discover if it's turned is indicative
of a bigger problem. i.e. that the user can't tell if the
functionality they turned on/off is actually active or not.

That's a bug that needs fixing, not working around with
ftrace/perf in xfstests...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
