Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AA8777F37
	for <xfs@oss.sgi.com>; Sun, 29 Nov 2015 15:40:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8F8328F8033
	for <xfs@oss.sgi.com>; Sun, 29 Nov 2015 13:40:44 -0800 (PST)
Received: from app1a.xlhost.de (mailout173.xlhost.de [84.200.252.173]) by
	cuda.sgi.com with ESMTP id JRXC4pFiJEzDzMNU for
	<xfs@oss.sgi.com>; Sun, 29 Nov 2015 13:40:41 -0800 (PST)
Message-ID: <565B70F9.8060707@5t9.de>
Date: Sun, 29 Nov 2015 22:41:13 +0100
From: Lutz Vieweg <lvml@5t9.de>
MIME-Version: 1.0
Subject: Re: Does XFS support cgroup writeback limiting?
References: <5652F311.7000406@5t9.de> <20151123202619.GE26718@dastard>
	<56538E6A.6030203@5t9.de> <20151123232052.GI26718@dastard>
	<5655FDDA.9050502@5t9.de> <20151125213500.GK26718@dastard>
In-Reply-To: <20151125213500.GK26718@dastard>
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

On 11/25/2015 10:35 PM, Dave Chinner wrote:
>> 2) Create 3 different XFS filesystem instances on the block
>>     device, one for access by only the "good" processes,
>>     on for access by only the "evil" processes, one for
>>     shared access by at least two "good" and two "evil"
>>     processes.
>
> Why do you need multiple filesystems? The writeback throttling is
> designed to work within a single filesystem...

Hmm. Previously, I thought that the limiting of buffered writes
was realized by keeping track of the owners of dirty pages, and
that filesystem support was just required to make sure that writing
via a filesystem did not "anonymize" the dirty data. From what
I had read in blkio-controller.txt it seemed evident that limitations
would be accounted for "per block device", not "per filesystem", and
options like
> echo "<major>:<minor>  <rate_bytes_per_second>" > /cgrp/blkio.throttle.read_bps_device
document how to configure limits per block device.

Now after reading through the new Writeback section of blkio-controller.txt
again I am somewhat confused - the text states
> writeback operates on inode basis
and if that means inodes as in "file system inodes", this would
indeed mean limits would be enforced "per filesystem" - and yet
there are no options documented to specify limits for any specific
filesystem.

Does this mean some process writing to a block device (not via filesystem)
without "O_DIRECT" will dirty buffer pages, but those will not be limited
(as they are neither synchronous nor via-filesystem writes)?
That would mean VMs sharing some (physical or abstract) block device could
not really be isolated regarding their asynchronous write I/O...


> Metadata IO not throttled - it is owned by the filesystem and hence
> root cgroup.

Ouch. That kind of defeats the purpose of limiting evil processes'
ability to DOS other processes.
Wouldn't it be possible to assign some arbitrary cost to meta-data
operations - like "account one page write for each meta-data change
to the originating process of that change"? While certainly not
allowing for limiting to byte-precise limits of write bandwidth,
this would regain the ability to defend against DOS situations,
and for well-behaved processes, the "cost" accounted for their not-so-frequent
meta-data operations would probably not really hurt their writing
speed.


>>  The test is successful if all "good processes" terminate successfully
>>    after a time not longer than it would take to write 10 times X MB to the
>>    rate-limited block device.
 >
> if we are rate limiting to 1MB/s, then a 10s test is not long enough
> to reach steady state. Indeed, it's going to take at least 30s worth
> of IO to guarantee that we getting writeback occurring for low
> bandwidth streams....

Sure, the "X/100 MB per second" throttle to the scratch device
was meant to result in a minimal test time of > 100s.

> i.e. the test needs to run for a period of time and then measure
> the throughput of each stream, comparing it against the expected
> throughput for the stream, rather than trying to write a fixed
> bandwidth....

The reason why I thought it to be a good idea to have the "good" processes
use only a limited write rate was to make sure that the actual write
activity of those processes is spread out over enough time to make sure
that they could, after all, feel some "pressure back" from the operating
system that is applied only after the "bad" processes have filled up
all RAM dedicated to dirty buffer cache.

Assume the test instance has lots of memory and would be willing to
spend many Gigabytes of RAM for dirty buffer caches. Chances are that
in such a situation the "good" processes might be done writing their
limited amount of data almost instantaneously, because the data just
went to RAM.

(I understand that if one used the absolute "blkio.throttle.write*" options
pressure back could apply before the dirty buffer cache was maxed out,
but in real-world scenarios people will almost always use the relative
"blkio.weight" based limiting, after all, you usually don't want to throttle
processes if there is plenty of bandwidth left no other process wants
at the same time.)


Regards,

Lutz Vieweg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
