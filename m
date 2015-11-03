Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6623E7FCB
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 13:48:55 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0C33FAC005
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 11:48:51 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	mB8MEJG449veBnkA for <xfs@oss.sgi.com>;
	Tue, 03 Nov 2015 11:48:49 -0800 (PST)
Date: Wed, 4 Nov 2015 06:48:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Is it possible to change sunit of log section post-mkfs
Message-ID: <20151103194835.GE19199@dastard>
References: <5638A62D.1020802@dermichi.com> <20151103191132.GD19199@dastard>
	<56390BBE.6030102@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56390BBE.6030102@dermichi.com>
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
To: Michael Weissenbacher <mw@dermichi.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 03, 2015 at 08:32:14PM +0100, Michael Weissenbacher wrote:
> Hi Dave!
> 
> >>
> >> What i want to achieve is to set the log sunit to the maximum possible
> >> of 64 blks (=256KiB).
> On 2015-11-03 20:11, Dave Chinner wrote:
> > 
> > Why? Is there a performance problem with the default setting?
> > 
> I am seeing very bad performance of "rm" on this file system. Of course
> I know that RAID-6 is kind of a worst case setup for that workload. But
> I was hoping that aligning the log correctly plus increasing the stripe
> size would help. Wouldn't the file system write more of the log at once
> with a bigger sunit size; resulting in fewer RMW cycles?

"rm is slow" could be many, many thingsr. Generally rm is limited
by directory/inode read speed, not log IO. You need to find out
exactly what is "slow" in rm before going knob twiddling. Is there
iowait time? If so, what IO is generating the iowait? Is rm CPU bound?
Is the log sleeping waiting for buffer space? is the log tail
pushing? etc, etc.


> I am already using delaylog, inode64, nobarrier to mount the fs;
> lazy-count=1.

IOWs, the defaults.

> Maybe moving to an external log would be the best option?

You haven't even determined that there's a problem with the log yet.

Twiddling knobs does not solve problems. Analyse the problem first,
understand where the "slowness" is coming from, and that
understanding will tell you is there's a knob that you can twiddle
to alleviate the problem.

Keep in mind that if you have lots of inodes, small files and/or
metadata intensive workloads, then it's very likely the RAID setup
is the problem, not the filesystem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
