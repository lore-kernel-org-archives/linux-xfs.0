Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0NBx0iW184421 for <xfs@oss.sgi.com>; Sat, 23 Jan 2010 05:59:00 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 175D5135AB3F
	for <xfs@oss.sgi.com>; Sat, 23 Jan 2010 03:59:58 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	hxSoI7tcLuU2ZGqu for <xfs@oss.sgi.com>;
	Sat, 23 Jan 2010 03:59:58 -0800 (PST)
Date: Sat, 23 Jan 2010 22:59:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] xfstests: define an INTENSITY level for testing
Message-ID: <20100123115955.GD25842@discord.disaster>
References: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A69B2@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A69B2@cf--amer001e--3.americas.sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 21, 2010 at 03:36:07PM -0600, Alex Elder wrote:
> I've often felt it would be nice if testing could be
> done to a specified level of intensity.  That way,
> for example, I could perform a full suite of tests
> but have them just do very basic stuff, so that I
> get coverage but without having to wait as long as
> is required for a hard-core test.  Similarly, before
> a release I'd like to run tests exhaustively, to
> make sure things get really exercised.

At first glance, this sounds like a good idea to control
the runtime of test runs.

However, after thinking about it for a while and reflecting on
the approach the QA group in ASG (long live ASG!) took for release
testing, I have a few concerns about using the concept in xfstests.

> Right now there is a "quick" group defined for xfstests,
> but what I'm talking about is more of a parameter applied
> to all tests so that certain functions could be lightly
> tested that might not otherwise be covered by one of the
> "quick" ones.  We might even be able to get rid of the
> "quick" group.  And an inherently long-running test
> might make itself not run if the intensity level was
> not high enough.

IIRC we introduced the "quick" group as a way to provide developers
sufficient coverage to flush out major bugs in patches quickly, not
provide complete test coverage. i.e. to speed up the development
process, not speed up or improve the QA process. Patches still need
to pass the "auto" group tests without regressions before being
posted for review....

> So I propse we defined a global, set in common.rc, which
> defines an integer 0 < INTENSITY <= 100, which would
> define how hard each test should push.  INTENSITY of
> 100, would cause all tests would do their most exhaustive
> and/or demanding exercises.  INTENSITY of 1 would do very
> superficial testing.  Default might be 50.

How would you solve the problem that "intensity" is very dependent
on the system the tests are being run on? e.g. Something run on an
SSD is going to run far faster than the same test on a UML instance
on a slow laptop disk, even though they run at the same "intensity"
level.

Another concern I have is that "intensity" might have different causes
on different systems.  e.g. on UML, it is forking new processes that
causes the massive slowdowns (300ms for a fork+exec on a 2GHz
Athlon64), not the amount of IO. Hence changing the number of files
or IOPS won't really change the runtime of tests significantly if
the problem is that the test runs "expr" 100,000 times. e.g:

http://git.kernel.org/?p=fs/xfs/xfstests-dev.git;a=commit;h=e714acc0ef37031b9a5a522703f2832f139c22e0

> Tests can simply ignore the INTENSITY value, and initially
> that will be the case for most tests.  It may not even make
> sense for a given test to have its activity scaled by this
> setting.  Once we define it though, tests can be adapted
> to make use of it where possible.
> 
> Below is a patch that shows how such feature might be
> used for tests 104 and 109.

/me looks at the changes

I think this is the wrong fix for decreasing test 104 runtime.
The fstress processes only need to run while the grows are in
progress, once they are complete the fsstress processes
can be killed rather than waited for. Using kill then wait
would reduce the runtime without potentially compromising the
test - if the number of ops are too low then fsstress doesn't run
long enough to effectively load up the filesystem during the grow
process to trigger the deadlock conditions.

For 109 I think changing the number of files compromises the initial
conditions required to trigger the deadlock on kernels <= 2.6.18.
It's an enospc test on a 160MB filesystem and the number of files it
uses is for fragementing free space sufficiently to trigger
out-of-order AG locking when ENOSPC in and AG occurs. Changing the
number of files results in different freespace fragmentation
patterns and  hence may not trigger the deadlock condition....

----

Stepping back and looking at this from an overall QA coverage point
of view, it seems to me that you are trying to make xfstests be
something that it is not intended to be. You want "exhaustive" test
coverage before a release, but xfstests have never been a vehicle
for exhaustive testing. That is, xfstests is really designed to
provide maximal code coverage with some load and stress tests
thrown in, but it is not intended to be the only testing mechanism
for the filesystem.

It might be instructive to go back and look at what the old SGI ASG
(long live ASG!) test group were doing (I hope it was archived!).
They were running xfstests on multiple platforms (x86_64, PPC and
ia64) for code coverage but not stress. To improve coverage, every
second xfstest run used a different set of non-default mkfs and
mount options to exercise different code paths (e.g. blocksize <
pagesize, directory block size > page size, etc) which otherwise
would not be tested.

There were separate test plans, procedures, processes and scripts to
execute long running stress and load tests. These were run as part
of the QA validation prior to major releases (the angle you appear
to be coming from, Alex) rather than day-to-day testing of the
current dev kernels.

More importantly, the load/stress tests weren't aimed at specific
XFS features (already handled by xfstests) - instead they were high
level tests aimed at trying to break the system.  e.g. one of the
stress tests was running tens of local processes creating and
destroying large and small files simultaneously with NFS clients
doing the same thing on the same filesystem whilst turning quotas on
and off randomly and running concurrent filesystem snapshots and
then mounting and running filesystem checks on the snapshots to
ensure they were consistent.  These tests would run for up to a week
at a time, so it takes dedicated resources to run this sort of
testing.

For load point tests, similar tests were run but the number of
processes creating load were varied over time so that the system
load varied between almost idle to almost 100% to ensure that
there weren't problems that light or medium loads exposed. Once
again these were long running tests on multiple platforms.

----

In my experience, exhaustive testing requires a combination of
testing from low level point tests (xfstests) all the way up to high
level system level integration tests. The methods and test processes
for these are different as the focus for the tests are different.

Hence I agree with your intent and reasoning behind intensity level
based stress testing, but I think that xfstests is not the right
sort of test suite to use for this type of testing. I think we'd
do better to try to recover some of the high level stress tests
and processes from the corpse of ASG than to try to use xfstests
for this....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
