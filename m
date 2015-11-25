Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 795087F37
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 15:35:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 668708F8033
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 13:35:22 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	wxugJnnlEpkQ5zdj for <xfs@oss.sgi.com>;
	Wed, 25 Nov 2015 13:35:14 -0800 (PST)
Date: Thu, 26 Nov 2015 08:35:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Does XFS support cgroup writeback limiting?
Message-ID: <20151125213500.GK26718@dastard>
References: <5652F311.7000406@5t9.de> <20151123202619.GE26718@dastard>
	<56538E6A.6030203@5t9.de> <20151123232052.GI26718@dastard>
	<5655FDDA.9050502@5t9.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5655FDDA.9050502@5t9.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Lutz Vieweg <lvml@5t9.de>
Cc: xfs@oss.sgi.com

On Wed, Nov 25, 2015 at 07:28:42PM +0100, Lutz Vieweg wrote:
> On 11/24/2015 12:20 AM, Dave Chinner wrote:
> >Just make the same mods to XFS as the ext4 patch here:
> >
> >http://www.spinics.net/lists/kernel/msg2014816.html
> 
> I read at http://www.spinics.net/lists/kernel/msg2014819.html
> about this patch:
> 
> >Journal data which is written by jbd2 worker is left alone by
> >this patch and will always be written out from the root cgroup.
> 
> If the same was done for XFS, wouldn't this mean a malicious
> process could still stall other processes' attempts to write
> to the filesystem by performing arbitrary amounts of meta-data
> modifications in a tight loop?

XFS doesn't have journal driver writeback, so no.

> >>After all, this functionality is the last piece of the
> >>"isolation"-puzzle that is missing from Linux to actually
> >>allow fencing off virtual machines or containers from DOSing
> >>each other by using up all I/O bandwidth...
> >
> >Yes, I know, but no-one seems to care enough about it to provide
> >regression tests for it.
> 
> Well, I could give it a try, if a shell script tinkering with
> control groups parameters (which requires root privileges and
> could easily stall the machine) would be considered adequate for
> the purpose.

xfstests is where such tests need to live. It would need
infrastructure to set up control groups and bandwidth limits...

> I would propose a test to be performed like this:
> 
> 0) Identify a block device to test on. I guess some artificially
>    speed-limited DM device would be best?
>    Set the speed limit to X/100 MB per second, with X configurable.

xfstests provides a scratch device that can be used for this.

> 
> 1) Start 4 "good" plus 4 "evil" subprocesses competing for
>    write-bandwidth on the block device.
>    Assign the 4 "good" processes to two different control groups ("g1", "g2"),
>    assign the 4 "evil" processes to further two different control
>    groups ("e1", "e2"), so 4 control groups in total, with 2 tasks each.
> 
> 2) Create 3 different XFS filesystem instances on the block
>    device, one for access by only the "good" processes,
>    on for access by only the "evil" processes, one for
>    shared access by at least two "good" and two "evil"
>    processes.

Why do you need multiple filesystems? The writeback throttling is
designed to work within a single filesystem...

I was thinking of something similar, but quite simple, using "bound"
and "unbound" (i.e. limited and unlimited) processes. e.g:

process 1 is unbound, does large sequential IO
process 2-N are bound to 1MB/s, do large sequential IO

Run for several minutes to reach a stable steady state behaviour.

if process 2-N do not receive 1MB/s throughput each, then throttling
of the unbound writeback processes is not working. Combinations
of this test using different read/write streams on each process
gives  multiple tests, verifies that block IO control works for both
read and write IO, not just writeback throttling.

And then other combinations of this sort of test, such as also
binding process 1 is bound to, say, 20MB/s. Repeating the tests can
then tell us if fast and slow bindings are working correctly.  i.e.
checking to ensure that process 1 doesn't exceed it's limits and all
the other streams stay within bounds, too.

> 3) Behaviour of the processes:
> 
>    "Good" processes will attempt to write a configured amount
>    of data (X MB) at 20% of the speed limit of the block device, modifying
>    meta-data at a moderate rate (like creating/renaming/deleting files
>    every few megabytes written).
>    Half of the "good" processes write to their "good-only" filesystem,
>    the other half writes to the "shared access" filesystem.
> 
>    Half of the "evil" processes will attempt to write as much data
>    as possible into open files in a tight endless loop.
>    The other half of the "evil" processes will permanently
>    modify meta-data as quickly as possible, creating/renaming/deleting
>    lots of files, also in a tight endless loop.
>    Half of the "evil" processes writes to the "evil-only" filesystem,
>    the other half writes to the "shared access" filesystem.

Metadata IO not throttled - it is owned by the filesystem and hence
root cgroup. There is no point in running tests that do large
amounts of journal/metadata IO as it is this will result in
uncontrollable and unpredictabe IO patterns and hence will give
unreliable test results.

We want to test the data bandwidth control algorithms work
appropriately in a controlled, repeatable environment.  Throwing all
sorts of uncontrollable IO at the device is a good /stress/ test, but
it is not going to tell us anything useful in terms of correctness
or reliably detect functional regressions.

> 4) Test 1: Configure all 4 control groups to allow for the same
>    buffered write rate percentage.
> 
>    The test is successful if all "good processes" terminate successfully
>    after a time not longer than it would take to write 10 times X MB to the
>    rate-limited block device.

if we are rate limiting to 1MB/s, then a 10s test is not long enough
to reach steady state. Indeed, it's going to take at least 30s worth
of IO to guarantee that we getting writeback occurring for low
bandwidth streams....

i.e. the test needs to run for a period of time and then measure
the throughput of each stream, comparing it against the expected
throughput for the stream, rather than trying to write a fixed
bandwidth....

> 5) Test 2: Configure "e1" and "e2" to allow for "zero" buffered write rate.
> 
>    The test is successful if the "good processes" terminate successfully
>    after a time not longer than it would take to write 5 times X MB to the
>    rate-limited block device.
> 
>    All processes to be killed after termination of all good processes or
>    some timeout. If the timeout is reached, the test is failed.
> 
> 6) Cleanup: unmount test filesystems, remove rate-limited DM device, remove
>    control groups.

control group cleanup will need to be added to the xfstests
infrastructure, but it handles everything else...

> What do you think, could this be a reasonable plan?

Yes, I think we can pull a reasonable set of baseline tests from an
approach like this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
