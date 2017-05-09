Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39372 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750805AbdEIRrx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 May 2017 13:47:53 -0400
Date: Tue, 9 May 2017 13:47:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: make fatal assert failures conditional in debug
 mode
Message-ID: <20170509174749.GD3241@bfoster.bfoster>
References: <1493991086-18817-1-git-send-email-bfoster@redhat.com>
 <20170505230943.GG17542@dastard>
 <20170508125530.GA29840@bfoster.bfoster>
 <20170508231448.GH17542@dastard>
 <20170509131129.GA3241@bfoster.bfoster>
 <20170509153704.GN5973@birch.djwong.org>
 <20170509170047.GC3241@bfoster.bfoster>
 <20170509172011.GQ5973@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170509172011.GQ5973@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Tue, May 09, 2017 at 10:20:11AM -0700, Darrick J. Wong wrote:
> On Tue, May 09, 2017 at 01:00:50PM -0400, Brian Foster wrote:
> > On Tue, May 09, 2017 at 08:37:04AM -0700, Darrick J. Wong wrote:
> > > On Tue, May 09, 2017 at 09:11:31AM -0400, Brian Foster wrote:
> > > > On Tue, May 09, 2017 at 09:14:48AM +1000, Dave Chinner wrote:
> > > > > On Mon, May 08, 2017 at 08:55:32AM -0400, Brian Foster wrote:
> > > > > > On Sat, May 06, 2017 at 09:09:43AM +1000, Dave Chinner wrote:
> > > > > > > On Fri, May 05, 2017 at 09:31:26AM -0400, Brian Foster wrote:
> > > > > > > > XFS currently supports two debug modes: XFS_WARN enables assert
> > > > > > > > failure warnings and XFS_DEBUG converts assert failures to fatal
> > > > > > > > errors (via BUG()) and enables additional runtime debug code.
> > > > > > > > 
> > > > > > > > While the behavior to BUG the kernel on assert failure is useful in
> > > > > > > > certain test scenarios, it is also useful for development/debug to
> > > > > > > > enable debug mode code without having to crash the kernel on an
> > > > > > > > assert failure.
> > > > > > > > 
> > > > > > > > To provide this additional flexibility, update XFS debug mode to not
> > > > > > > > BUG() the kernel by default and create a new XFS kernel
> > > > > > > > configuration option to enable fatal assert failures when debug mode
> > > > > > > > is enabled. To provide backwards compatibility with current
> > > > > > > > behavior, enable the fatal asserts option by default when debug mode
> > > > > > > > is enabled.
> > > > > > > > 
> > > > > > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > > > > 
> > > > > > > Just a suggestion, but why make this a compile time option? Why not
> > > > > > > a sysfs variable under /sys/fs/xfs/debug? That would be far more
> > > > > > > useful to me - a single kernel that can be configure to just warn or
> > > > > > > bug() dynamically. That will save us from having to rebuild a kernel
> > > > > > > just to enable this functionality, then rebuild again to turn it
> > > > > > > off..
> > > > > > > 
> > > > > > 
> > > > > > I hadn't really considered that approach. The obvious drawback for me is
> > > > > > that whatever option is not default has to be reset on every boot or
> > > > > > module reload,
> > > > > 
> > > > > That's what sysctl is for.
> > > > > 
> > > > 
> > > > I suppose that helps, but only partially. It's still an extra step on a
> > > > new system (re: think disposable test system environments). I also don't
> > > > think it helps across module reloads (?), which means in certain cases
> > > > I'm most likely just back to holding a local patch to comment out the
> > > > BUG() (which is fine too).
> > > 
> > > How about a runtime config variable (sysctl, module param,
> > > {sys,config,debug}fs knob...) and a Kconfig option to set the default
> > > value of the knob?  That enables dangerous group xfstests to switch off
> > > the crash-on-assert behavior and allows developers to preconfigure
> > > whatever's most convenient for them.
> > > 
> > 
> > Yeah, that's what I was alluding to wrt the sidetrack discussion below.
> > I'm still curious what the use case is for runtime switching of assert
> > behavior alone (I don't think the xfstests case would be helped by
> > it..?), but I don't object to including both if a knob is useful for
> 
> Some XFS code does things like:
> 
> if (badness) {
> 	ASSERT(0);
> 	return -EFSCORRUPTED;
> }
> 
> Other parts do:
> 
> ASSERT(!badness);
> /* code that basically does nothing if badness */
> return nothinghappened;
> 
> In both of these cases, we can return something to userspace to indicate
> that the requested operation didn't happen or went bonkers somewhere...
> however there's the ASSERT there to make the badness fail noisily for
> debug kernels.
> 

Sure.. where today "noisely" is defined by whether the kernel config
enables XFS_WARN or XFS_DEBUG. Where does runtime configuration of
whether assert failures call BUG() come into play here?

> Moreover, some of the fuzzer tests do something like this:
> 
> 1. mkfs + populate fs
> 2. corrupt fs
> 3. try to use fs to see if we hit an error code
> 4. unmount + xfs_repair
> 5. retry step 3
> 
> It would be useful for this particular case to be able to keep going
> after an ASSERT, because (provided we don't blow up internal kernel
> state) we're effectively testing that xfs_repair actually fixes things
> that make the kernel unhappy.
> 
> The really nasty xfs_scrub/xfs_repair fuzz tests systematically corrupt
> every field in a metadata object, so they do:
> 
> 1. mkfs + populate fs
> 2. for every field in <someobject>:
>    a. corrupt field
>    b. try to use fs to see if we hit an error code
>    c. unmount + xfs_repair (or xfs_scrub)
>    d. retry step 3
> 
> Since we're doing all fields in a loop, it would be helpful to be able
> to run temporarily with BUG*() disabled so that we can try to stumble on
> to the next field and generate a more thorough report instead of
> crashing at the first sign of badness.
> 

Hmm, Ok. So if you have a test that intentionally corrupts the fs and
proceeds to use it, then assert failures can be expected. The purpose of
the test is not necessarily to run "clean," but more to validate that
the kernel doesn't keel over and presumably that xfs_repair can recover.

That seems like a reasonable argument to me, but do these tests actually
depend on DEBUG code? Or is it simply that it's arguably wrong to panic
during a test that expects to cause assert failures, and thus we'd like
to override that particular behavior from the test if DEBUG mode happens
to be enabled?

Brian

> > somebody. My purpose/motivation for this was more based on the idea that
> > I rarely, if ever, have a need for assert failures to bug the kernel.
> > I'd like to be able to just turn it off in my default configs (without
> > disrupting the cases where it is useful).
> 
> Like you, I also have patches that quiet down the various warnings.
> Would be nice not to have to keep carrying those.
> 
> > > > > > the latter of which tends to be a common action in my use
> > > > > > cases (e.g., adding debug code to do specialized debugging or for some
> > > > > > new development work and reloading xfs as a kernel module). It's kind of
> > > > > > the opposite problem for general regression testing if we were to change
> > > > > > the default from BUG() to warn, for example. The tester would have to
> > > > > > remember to (or know) to twiddle the knob if one is expecting assert
> > > > > > failures to generate a BUG() and crash report.
> > > > > 
> > > > > Default would be the same as today - BUG on assert - so this
> > > > > wouldn't matter.
> > > > > 
> > > > 
> > > > Yes, the above is an analogy.
> > > > 
> > > > > > So for me, the ability to live switch between BUG() or warn in debug
> > > > > > mode doesn't add value. In fact, it is less ideal than just being able
> > > > > > to (re)compile a kernel module and load it with expected behavior. That
> > > > > 
> > > > > Who uses kernel modules for testing? I just use monolithic kernels
> > > > > because I can boot a new kernel in less time than it takes copy in
> > > > > and reload a new module to the test machine.
> > > 
> > > I do, because usually my code isn't so bad that it trashes the kernel
> > > state to the point of needing a reboot.  Lucky me. :P
> > > 
> > 
> > Such arrogance! :D
> > 
> > > (Now granted the test machine boots so slowly I go for a walk and the
> > > VMs boot so quickly I barely lose any time, so I don't really care one
> > > way or another... :))
> > > 
> > > > I use kernel modules quite a bit. For one, I tend to use test machines
> > > > that can take a minute or two to boot. Even when using a local vm,
> > > > copying a kernel module and reloading works quite well for me for
> > > > development, because I may have various contexts (i.e., screen/tmux
> > > > sessions) that I prefer not to lose and I tend to work iteratively.
> > > > 
> > > > But this is anecdotal... I don't think it matters much what workflow is
> > > > the one true best for testing or development. Rather, the question is
> > > > whether a workflow is common and useful to enough people to justify a
> > > > configuration option.
> > > > 
> > > > > > said, that's just my admittedly selfish use case. The ability to switch
> > > > > > off BUG() at all is still an improvement over the current situation, so
> > > > > > I'm open to a runtime knob if that is the more broadly useful solution.
> > > > > > Care to elaborate on how that is more useful to you?
> > > > > 
> > > > > e.g. think of the dangerous tests in xfstests that don't get run
> > > > > because they fire an assert and kill the test machine. have the test
> > > > > harness set "warn only" for the dangerous tests and now those tests
> > > > > are no longer dangerous and can be run as part of the auto group...
> > > > > 
> > > > 
> > > > It looks like the majority of the dangerous tests are tagged as such
> > > > because they historically (and legitimately) panic, crash or hang a
> > > > system. I don't think they are any more or less dangerous based on
> > > > assert behavior. Indeed, a quick check with the latest kernel doesn't
> > > > result in any dangerous test failures in either XFS_DEBUG or XFS_WARN
> > > > mode (though one or two were skipped).
> > > > 
> > > > > > A bit of a sidetrack...
> > > > > > 
> > > > > > To me, runtime live switching seems a bit more appropriate for something
> > > > > > at a higher level of enabling/disabling debug mode entirely as opposed
> > > > > > to solely assert behavior (for which it seems like overkill). A couple
> > > > > > problems with that are bloating the kernel and efficiency associated
> > > > > > with losing the ability to compile out asserts, both of which may make
> > > > > > something like that not realistic.
> > > > > > 
> > > > > > I do wonder, however, whether we could condense the current kernel
> > > > > > configuration into effectively two logical modes: production and debug.
> > > > > > The latter debug mode simply compiles in all of the debug code, but
> > > > > > supports various sub-modes: disabled, warn, debug (as today)[1]. The
> > > > > 
> > > > > We've talked about this in the past and enabling debug like
> > > > > having the allocator run random selection paths rather than optimal
> > > > > paths can lead to premature freespace fragmetnation and aging of the
> > > > > filesystem - exactly what you don't want for a production system
> > > > > you're trying to diagnose a problem on.
> > > > > 
> > > > 
> > > > Good point. I agree that we wouldn't want to enable things like the
> > > > random allocation algorithms, randomly doing sparse inode allocations
> > > > and such things that generally affect the structure on disk.
> > > > 
> > > > As mentioned previously, we can be more granular than the current binary
> > > > toggle for debug mode. E.g., we could separate diagnostic mechanisms
> > > > from test coverage mechanisms and enable the latter at a higher debug
> > > > level or with a separate option entirely, if desired. IOW, I don't think
> > > > that's a difficult problem to solve.
> > > 
> > > Agreed.
> > > 
> > > > > Also, there's debug code that doesn't scale well (such as extent
> > > > > list checking) and that sort of thing can badly affect performance -
> > > > > these are gotchas in debug builds that production diagnositic
> > > > > kernels should not trip over....
> > > > > 
> > > > 
> > > > Yeah, but I think there's a host of other things one can already enable
> > > > on a debug kernel package (I'm thinking about all of the memory related
> > > > bits, etc.) that can kill performance just as much, if not worse. It's
> > > > still a separate debug package after all. However, that is a good
> > > > argument for debug modes to be disabled by default (or effectively set
> > > > to XFS_WARN as it is defined today) in such configs, because there is no
> > > > guarantee the debug kernel is installed to debug an XFS problem.
> > > > 
> > > > > > default debug sub-mode can be selected at kernel compile time and
> > > > > > toggled at runtime. So effectively, a debug enabled kernel has the
> > > > > > ability to support arbitrary modes and a production kernel still has all
> > > > > > of that crap compiled out. This would allow, for example, a distro debug
> > > > > > kernel package to ship and enable actual debug code at runtime rather
> > > > > > than be limited to XFS_WARN, which is at least what we (rh) do today.
> > > > > > Thoughts? Useful, overkill?
> > > > > 
> > > > > XFS_WARN was the tradeoff for getting useful assert information out
> > > > > of production machines without impacting performance, allocation,
> > > > > etc by enabling the full debug code. I don't think anything has
> > > > > changed that alters that tradeoff since we added XFS_WARN...
> > > > > 
> > > > 
> > > > I'm not following the logic here... I don't think there's anything
> > > > inherently wrong with XFS_WARN as it is deployed today. I was just
> > > > suggesting that if we're going to think about providing dynamic debug
> > > > options, perhaps there's more benefit to step back and expose some of
> > > > the other diagnostic mechanisms that we have available rather than
> > > > simply to toggle assert behavior. IOWs, let the kernel config control
> > > > what is compiled in or not rather than behavior and let runtime
> > > > configuration control behavior.
> > > 
> > > Agreed here too, though I think it's acceptable to have a Kconfig option
> > > to set the default values of the knob(s).
> > > 
> > 
> > Yep. The more I thought about the above, I'd expect it would actually
> > require the configuration side of things to basically have two options.
> > First, a selector to compile debug capabilities into the kernel or not.
> > Second, and dependent on the first, a menu option or something that
> > selects the default mode on module load (e.g., Disabled, Warn only,
> > Diagnostic, XXXdangerXXXdontusethisunlessyouhackXFS), where the mode is
> > also selectable at runtime. We could effectively do something similar
> > just for assert behavior in debug mode.
> 
> Yes.  I'd start with assert behavior in debug mode since we're already
> talking about it and carrying patches around.
> 
> --D
> 
> > 
> > Brian
> > 
> > > --D
> > > 
> > > > Brian
> > > > 
> > > > > Cheers,
> > > > > 
> > > > > Dave.
> > > > > -- 
> > > > > Dave Chinner
> > > > > david@fromorbit.com
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
