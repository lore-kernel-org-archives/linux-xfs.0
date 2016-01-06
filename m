Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3CC567F37
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 16:05:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2B75F8F804C
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2016 14:05:00 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	d14vI9JowqR4ZABg for <xfs@oss.sgi.com>;
	Wed, 06 Jan 2016 14:04:57 -0800 (PST)
Date: Thu, 7 Jan 2016 09:04:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs and swift
Message-ID: <20160106220454.GI21461@dastard>
References: <CAC2B=ZGX2bkEhdgCrpS2X5v+SpAg0jtxZ19vk_9+O9aHME-FSA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAC2B=ZGX2bkEhdgCrpS2X5v+SpAg0jtxZ19vk_9+O9aHME-FSA@mail.gmail.com>
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
To: Mark Seger <mjseger@gmail.com>
Cc: Laurence Oberman <loberman@redhat.com>, Linux fs XFS <xfs@oss.sgi.com>

On Wed, Jan 06, 2016 at 10:15:25AM -0500, Mark Seger wrote:
> I've recently found the performance our development swift system is
> degrading over time as the number of objects/files increases.  This is a
> relatively small system, each server has 3 400GB disks.  The system I'm
> currently looking at has about 70GB tied up in slabs alone, close to 55GB
> in xfs inodes and ili, and about 2GB free.  The kernel
> is 3.14.57-1-amd64-hlinux.

So you go 50M cached inodes in memory, and a relatively old kernel.

> Here's the way the filesystems are mounted:
> 
> /dev/sdb1 on /srv/node/disk0 type xfs
> (rw,noatime,nodiratime,attr2,nobarrier,inode64,logbufs=8,logbsize=256k,sunit=512,swidth=1536,noquota)
> 
> I can do about 2000 1K file creates/sec when running 2 minute PUT tests at
> 100 threads.  If I repeat that tests for multiple hours, I see the number
> of IOPS steadily decreasing to about 770 and the very next run it drops to
> 260 and continues to fall from there.  This happens at about 12M files.

According to the numbers you've provided:

	lookups		creates		removes
Fast:	1550		1350		300
Slow:	1000		 900		250

This is pretty much what I'd expect on the XFS level when going from
a small empty filesystem to one containing 12M 1k files.

That does not correlate to your numbers above, so it's not at all
clear that there is realy a problem here at the XFS level.

> The directory structure is 2 tiered, with 1000 directories per tier so we
> can have about 1M of them, though they don't currently all exist.

That's insane.

The xfs directory structure is much, much more space, time, IO and
memory efficient that a directory hierachy like this. The only thing
you need a directory hash hierarchy for is to provide sufficient
concurrency for your operations, which you would probably get with a
single level with one or two subdirs per filesystem AG.

What you are doing is spreading the IO over thousands of different
regions on the disks, and then randomly seeking between them on
every operation. i.e. your workload is seekbound, and your directory
structure is has the effect of /maximising/ seeks per operation...


> I've written a collectl plugin that lets me watch many of the xfs stats in

/me sighs and points at PCP: http://pcp.io

> real-time and also have a test script that exercises the swift PUT code
> directly and so eliminates all the inter-node communications.  This script
> also allows me to write to the existing swift directories as well as
> redirect to an empty structure so mimics clean environment with no existing
> subdirectories.

Yet that doesn't behave like an empty filesystem, which is clearly
shown by the fact the caches are full of inodes that are't being
used by the test. It also points out that allocation of new inodes
will follow the old logarithmic search speed degradation, because
you're kernel is sufficiently old that it doesn't support the free
inode btree feature...

> I'm attaching some xfs stats during the run and hope they're readable.
> These values are in operations/sec and each line is 1 second's worth of
> data.  The first set of numbers is on the clean directory and the second on
> the existing 12M file one.  At the bottom of these stats are also the xfs
> slab allocations as reported by collectl.  I can also watch these during a
> test and can see the number of inode and ilo objects steadily grow at about
> 1K/sec, which is curious since I'm only creating about 300.

It grows at exactly the rate of the lookups beng done, which is what
is expected. i.e. for each create being done, there are other
lookups being done first. e.g. directories, other objects to
determine where to create the new one, lookup has to be done before
removes (which there are significant number of), etc.
> 
> If there is anything else I can provide just let me know.
> 
> I don't fully understand all the xfs stats but what does jump out at me is
> the XFS read/write ops have increased by a factor of about 5 when the
> system is slower.

Which means your application is reading/writing 5x as much
information from the filesystem when it is slow. That's not a
filesystem problem - your applicaiton is having to traverse/modify
5x as much information for each object it is creating/modifying.
There's a good chance that's a result of your massively wide
object store directory heirarchy....

i.e. you need to start by understanding what your application is
doing in terms of IO, configuration and algorithms and determine
whether that is optimal before you start looking at whether the
filesystem is actually the bottleneck.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
