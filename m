Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 533F729DF5
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 17:44:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 36A788F8033
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 15:44:43 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2Y1He44WXHTGyfSS for <xfs@oss.sgi.com>;
	Mon, 30 Nov 2015 15:44:40 -0800 (PST)
Date: Tue, 1 Dec 2015 10:44:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Does XFS support cgroup writeback limiting?
Message-ID: <20151130234426.GP26718@dastard>
References: <5652F311.7000406@5t9.de> <20151123202619.GE26718@dastard>
	<56538E6A.6030203@5t9.de> <20151123232052.GI26718@dastard>
	<5655FDDA.9050502@5t9.de> <20151125213500.GK26718@dastard>
	<565B70F9.8060707@5t9.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <565B70F9.8060707@5t9.de>
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

On Sun, Nov 29, 2015 at 10:41:13PM +0100, Lutz Vieweg wrote:
> On 11/25/2015 10:35 PM, Dave Chinner wrote:
> >>2) Create 3 different XFS filesystem instances on the block
> >>    device, one for access by only the "good" processes,
> >>    on for access by only the "evil" processes, one for
> >>    shared access by at least two "good" and two "evil"
> >>    processes.
> >
> >Why do you need multiple filesystems? The writeback throttling is
> >designed to work within a single filesystem...
> 
> Hmm. Previously, I thought that the limiting of buffered writes
> was realized by keeping track of the owners of dirty pages, and
> that filesystem support was just required to make sure that writing
> via a filesystem did not "anonymize" the dirty data. From what
> I had read in blkio-controller.txt it seemed evident that limitations
> would be accounted for "per block device", not "per filesystem", and
> options like
> >echo "<major>:<minor>  <rate_bytes_per_second>" > /cgrp/blkio.throttle.read_bps_device
> document how to configure limits per block device.
> 
> Now after reading through the new Writeback section of blkio-controller.txt
> again I am somewhat confused - the text states
> >writeback operates on inode basis
> and if that means inodes as in "file system inodes", this would
> indeed mean limits would be enforced "per filesystem" - and yet
> there are no options documented to specify limits for any specific
> filesystem.
> 
> Does this mean some process writing to a block device (not via filesystem)
> without "O_DIRECT" will dirty buffer pages, but those will not be limited
> (as they are neither synchronous nor via-filesystem writes)?
> That would mean VMs sharing some (physical or abstract) block device could
> not really be isolated regarding their asynchronous write I/O...

You are asking the wrong person - I don't know how this is all
supposed to work, how it's supposed to be configured, how different
cgroup controllers are supposed to interact, etc. Hence my request
for regression tests before we say "XFS supports ...." because
without them I have no idea if something is desired/correct
behaviour or not...

> >Metadata IO not throttled - it is owned by the filesystem and hence
> >root cgroup.
> 
> Ouch. That kind of defeats the purpose of limiting evil processes'
> ability to DOS other processes.
> Wouldn't it be possible to assign some arbitrary cost to meta-data
> operations - like "account one page write for each meta-data change

No. Think of a file with millions of extents. Just reading a byte of
data will require pulling the entire extent map into memory, and so
doing hundreds of megabytes of IO and using that much memory.

> to the originating process of that change"? While certainly not
> allowing for limiting to byte-precise limits of write bandwidth,
> this would regain the ability to defend against DOS situations,

No, that won't help at all. In fact, it might even introduce new DOS
situations where we block a global metadata operation because it
doesn't have reservation space and so *everything* stops until that
metadata IO is dispatched and completed...

> Assume the test instance has lots of memory and would be willing to
> spend many Gigabytes of RAM for dirty buffer caches.

Most people will be running the tests on machines with limited
RAM and disk space, and so the tests really cannot depend on having
many multiple gigabytes of RAM available for correct operation....
Indeed, limiting dirty memory thresholds will be part of setting up
a predictable, reliable test scenario (e.g. via
/proc/sys/vm/dirty_bytes and friends).

> (I understand that if one used the absolute "blkio.throttle.write*" options
> pressure back could apply before the dirty buffer cache was maxed out,
> but in real-world scenarios people will almost always use the relative
> "blkio.weight" based limiting, after all, you usually don't want to throttle
> processes if there is plenty of bandwidth left no other process wants
> at the same time.)

Again, I have no idea how the throttling works or is configured, so
we need regression tests to cover both (all?) of these sorts of
common configuration scenarios.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
