Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D47DC7F3F
	for <xfs@oss.sgi.com>; Wed,  6 Feb 2013 13:28:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 701ACAC002
	for <xfs@oss.sgi.com>; Wed,  6 Feb 2013 11:28:12 -0800 (PST)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id a4iXP4F5pBt8OGlx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Feb 2013 11:28:11 -0800 (PST)
Message-ID: <5112AEC0.9000503@tlinx.org>
Date: Wed, 06 Feb 2013 11:28:00 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfs deadlock on buffer semaphore while reading directory
References: <20130202192007.GS30577@one.firstfloor.org>
	<510D6EDE.1080409@sgi.com> <510E054B.2070500@tlinx.org>
	<20130206004442.GS2667@dastard>
In-Reply-To: <20130206004442.GS2667@dastard>
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



Dave Chinner wrote:
> On Sat, Feb 02, 2013 at 10:35:55PM -0800, Linda Walsh wrote:
>> Odd thing about my current probs -- my current system has been up 12
>> days...but before that it had been up 43 days...
>>
>> I can't get the buffers to 'free' no matter what echo 3>
>> /proc/sys/vm/drop_caches does nothing.
> 
> What buffers are you talking about? The deadlock is in metadata buffer
> handling, which you can't directly see, and will never be able to entirely
> free via drop caches. 
> 
> if you are talking about what is reported by the "free" command, then that
> number can be ignored as it is mostly meaningless for XFS filesystems....

---

Supposedly it was cached fs-_data_ (not allocated buffers), that wasn't
dirty.  Something that should have been free-able, but was eating ~40G of
free memory and that couldn't (or wasn't being) "written out to swap", yet
wasn't being released to reduce memory pressure (I dunno if xfsdump's "OOM"
errors would trigger or give a hint to the kernel to release some non-dirty
fs-cache space, but from a system stability point of view, it seemed like it
"should" have).  Maybe only the failure of lower-order memory allocations
triggers mem-release routines, I dunno).

I'd guess it wasn't xfs metadata as that would be more likely temporarily
pinned in memory until it had been dealt with (examined, or modified for
output), but that's a pure guess.

Part of me wondered if it might have been some in-mem tmp-file, since Suse
has recently put "/run, /var/lock, /var/run and /media" on "tmpfs" (in
addition to more standard "/dev, /sys/fs/cgroup/{1 dir for each group}).

Other diskless in-mem fs's that securityfs, devpts, sysfs,
/proc/sys/fs/binfmt_misc, copies of /proc for chrooted procs,
&/proc/fs/nfsd.

Onees that might reserve space: debugfs and /dev/shm -- though both
indicated under 32M of space used (despite /tmp/shm having about 9G in
a sparse file).

---- None of those _appeared_ to be a problem, though with all the small
files in memory, its possible fragmentation was an issue.  It's something
that is a recent change that makes me a little uneasy.


	Nothing appeared to be glomming on to the memory  (max usage  was 10% by
'mbuffer' with 5G pinned to buffer xfsdump output, but total "Used" memory
(including 'Shared) was under 8G (on a 2x24G Numa config)..  It was a bit
weird.

	Have since rebooted with 3.6.7 and changed the SLAB/SLUB from the unqueued
(but better for cache-line usage which I though might help speed), to the
queued-general purpose).  Only been up ~12 hours, and previous problems
didn't appear till after > 1 week, BUT, simply moving to the new "git"
xfsdump cured the inability (with the old system, unreboooted) cured the
meta-data alloc failures).

	So no worries at this point...more than likely that patch to the xfs
utils/dump fixed the prob.

	Thanks again!

linda


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
