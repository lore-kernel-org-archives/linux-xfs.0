Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:60329 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750839AbdEHXPQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 May 2017 19:15:16 -0400
Date: Tue, 9 May 2017 09:14:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: make fatal assert failures conditional in debug
 mode
Message-ID: <20170508231448.GH17542@dastard>
References: <1493991086-18817-1-git-send-email-bfoster@redhat.com>
 <20170505230943.GG17542@dastard>
 <20170508125530.GA29840@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170508125530.GA29840@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, May 08, 2017 at 08:55:32AM -0400, Brian Foster wrote:
> On Sat, May 06, 2017 at 09:09:43AM +1000, Dave Chinner wrote:
> > On Fri, May 05, 2017 at 09:31:26AM -0400, Brian Foster wrote:
> > > XFS currently supports two debug modes: XFS_WARN enables assert
> > > failure warnings and XFS_DEBUG converts assert failures to fatal
> > > errors (via BUG()) and enables additional runtime debug code.
> > > 
> > > While the behavior to BUG the kernel on assert failure is useful in
> > > certain test scenarios, it is also useful for development/debug to
> > > enable debug mode code without having to crash the kernel on an
> > > assert failure.
> > > 
> > > To provide this additional flexibility, update XFS debug mode to not
> > > BUG() the kernel by default and create a new XFS kernel
> > > configuration option to enable fatal assert failures when debug mode
> > > is enabled. To provide backwards compatibility with current
> > > behavior, enable the fatal asserts option by default when debug mode
> > > is enabled.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > 
> > Just a suggestion, but why make this a compile time option? Why not
> > a sysfs variable under /sys/fs/xfs/debug? That would be far more
> > useful to me - a single kernel that can be configure to just warn or
> > bug() dynamically. That will save us from having to rebuild a kernel
> > just to enable this functionality, then rebuild again to turn it
> > off..
> > 
> 
> I hadn't really considered that approach. The obvious drawback for me is
> that whatever option is not default has to be reset on every boot or
> module reload,

That's what sysctl is for.

> the latter of which tends to be a common action in my use
> cases (e.g., adding debug code to do specialized debugging or for some
> new development work and reloading xfs as a kernel module). It's kind of
> the opposite problem for general regression testing if we were to change
> the default from BUG() to warn, for example. The tester would have to
> remember to (or know) to twiddle the knob if one is expecting assert
> failures to generate a BUG() and crash report.

Default would be the same as today - BUG on assert - so this
wouldn't matter.

> So for me, the ability to live switch between BUG() or warn in debug
> mode doesn't add value. In fact, it is less ideal than just being able
> to (re)compile a kernel module and load it with expected behavior. That

Who uses kernel modules for testing? I just use monolithic kernels
because I can boot a new kernel in less time than it takes copy in
and reload a new module to the test machine.

> said, that's just my admittedly selfish use case. The ability to switch
> off BUG() at all is still an improvement over the current situation, so
> I'm open to a runtime knob if that is the more broadly useful solution.
> Care to elaborate on how that is more useful to you?

e.g. think of the dangerous tests in xfstests that don't get run
because they fire an assert and kill the test machine. have the test
harness set "warn only" for the dangerous tests and now those tests
are no longer dangerous and can be run as part of the auto group...

> A bit of a sidetrack...
> 
> To me, runtime live switching seems a bit more appropriate for something
> at a higher level of enabling/disabling debug mode entirely as opposed
> to solely assert behavior (for which it seems like overkill). A couple
> problems with that are bloating the kernel and efficiency associated
> with losing the ability to compile out asserts, both of which may make
> something like that not realistic.
> 
> I do wonder, however, whether we could condense the current kernel
> configuration into effectively two logical modes: production and debug.
> The latter debug mode simply compiles in all of the debug code, but
> supports various sub-modes: disabled, warn, debug (as today)[1]. The

We've talked about this in the past and enabling debug like
having the allocator run random selection paths rather than optimal
paths can lead to premature freespace fragmetnation and aging of the
filesystem - exactly what you don't want for a production system
you're trying to diagnose a problem on.

Also, there's debug code that doesn't scale well (such as extent
list checking) and that sort of thing can badly affect performance -
these are gotchas in debug builds that production diagnositic
kernels should not trip over....

> default debug sub-mode can be selected at kernel compile time and
> toggled at runtime. So effectively, a debug enabled kernel has the
> ability to support arbitrary modes and a production kernel still has all
> of that crap compiled out. This would allow, for example, a distro debug
> kernel package to ship and enable actual debug code at runtime rather
> than be limited to XFS_WARN, which is at least what we (rh) do today.
> Thoughts? Useful, overkill?

XFS_WARN was the tradeoff for getting useful assert information out
of production machines without impacting performance, allocation,
etc by enabling the full debug code. I don't think anything has
changed that alters that tradeoff since we added XFS_WARN...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
