Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BE2DA7F37
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 12:28:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 81AA930405F
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 10:28:49 -0800 (PST)
Received: from app1b.xlhost.de (mailout173.xlhost.de [84.200.252.173]) by
	cuda.sgi.com with ESMTP id jCHXIsHMqMKxkUDC for
	<xfs@oss.sgi.com>; Wed, 25 Nov 2015 10:28:45 -0800 (PST)
Message-ID: <5655FDDA.9050502@5t9.de>
Date: Wed, 25 Nov 2015 19:28:42 +0100
From: Lutz Vieweg <lvml@5t9.de>
MIME-Version: 1.0
Subject: Re: Does XFS support cgroup writeback limiting?
References: <5652F311.7000406@5t9.de> <20151123202619.GE26718@dastard>
	<56538E6A.6030203@5t9.de> <20151123232052.GI26718@dastard>
In-Reply-To: <20151123232052.GI26718@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/24/2015 12:20 AM, Dave Chinner wrote:
> Just make the same mods to XFS as the ext4 patch here:
>
> http://www.spinics.net/lists/kernel/msg2014816.html

I read at http://www.spinics.net/lists/kernel/msg2014819.html
about this patch:

> Journal data which is written by jbd2 worker is left alone by
> this patch and will always be written out from the root cgroup.

If the same was done for XFS, wouldn't this mean a malicious
process could still stall other processes' attempts to write
to the filesystem by performing arbitrary amounts of meta-data
modifications in a tight loop?

>> After all, this functionality is the last piece of the
>> "isolation"-puzzle that is missing from Linux to actually
>> allow fencing off virtual machines or containers from DOSing
>> each other by using up all I/O bandwidth...
>
> Yes, I know, but no-one seems to care enough about it to provide
> regression tests for it.

Well, I could give it a try, if a shell script tinkering with
control groups parameters (which requires root privileges and
could easily stall the machine) would be considered adequate for
the purpose.

I would propose a test to be performed like this:

0) Identify a block device to test on. I guess some artificially
    speed-limited DM device would be best?
    Set the speed limit to X/100 MB per second, with X configurable.

1) Start 4 "good" plus 4 "evil" subprocesses competing for
    write-bandwidth on the block device.
    Assign the 4 "good" processes to two different control groups ("g1", "g2"),
    assign the 4 "evil" processes to further two different control
    groups ("e1", "e2"), so 4 control groups in total, with 2 tasks each.

2) Create 3 different XFS filesystem instances on the block
    device, one for access by only the "good" processes,
    on for access by only the "evil" processes, one for
    shared access by at least two "good" and two "evil"
    processes.

3) Behaviour of the processes:

    "Good" processes will attempt to write a configured amount
    of data (X MB) at 20% of the speed limit of the block device, modifying
    meta-data at a moderate rate (like creating/renaming/deleting files
    every few megabytes written).
    Half of the "good" processes write to their "good-only" filesystem,
    the other half writes to the "shared access" filesystem.

    Half of the "evil" processes will attempt to write as much data
    as possible into open files in a tight endless loop.
    The other half of the "evil" processes will permanently
    modify meta-data as quickly as possible, creating/renaming/deleting
    lots of files, also in a tight endless loop.
    Half of the "evil" processes writes to the "evil-only" filesystem,
    the other half writes to the "shared access" filesystem.


4) Test 1: Configure all 4 control groups to allow for the same
    buffered write rate percentage.

    The test is successful if all "good processes" terminate successfully
    after a time not longer than it would take to write 10 times X MB to the
    rate-limited block device.

    All processes to be killed after termination of all good processes or
    some timeout. If the timeout is reached, the test is failed.


5) Test 2: Configure "e1" and "e2" to allow for "zero" buffered write rate.

    The test is successful if the "good processes" terminate successfully
    after a time not longer than it would take to write 5 times X MB to the
    rate-limited block device.

    All processes to be killed after termination of all good processes or
    some timeout. If the timeout is reached, the test is failed.

6) Cleanup: unmount test filesystems, remove rate-limited DM device, remove
    control groups.

What do you think, could this be a reasonable plan?

Regards,

Lutz Vieweg


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
