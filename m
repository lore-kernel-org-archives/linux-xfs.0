Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3NEcpOs200364 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 09:38:52 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	cjdDdcBTvWBCWZDR for <xfs@oss.sgi.com>;
	Mon, 23 Apr 2012 07:38:47 -0700 (PDT)
Date: Tue, 24 Apr 2012 00:38:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Still seeing hangs in xlog_grant_log_space
Message-ID: <20120423143843.GN9541@dastard>
References: <CADLDEKsP4DsXf_G07ub+a-ODbrJbsiprRJUX1fJdaQ41TB7+Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADLDEKsP4DsXf_G07ub+a-ODbrJbsiprRJUX1fJdaQ41TB7+Xg@mail.gmail.com>
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
To: Juerg Haefliger <juergh@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 23, 2012 at 02:09:53PM +0200, Juerg Haefliger wrote:
> Hi,
> 
> I have a test system that I'm using to try to force an XFS filesystem
> hang since we're encountering that problem sporadically in production
> running a 2.6.38-8 Natty kernel. The original idea was to use this
> system to find the patches that fix the issue but I've tried a whole
> bunch of kernels and they all hang eventually (anywhere from 5 to 45
> mins) with the stack trace shown below.

If you kill the workload, does the file system recover normally?

> Only an emergency flush will
> bring the filesystem back. I tried kernels 3.0.29, 3.1.10, 3.2.15,
> 3.3.2. From reading through the mail archives, I get the impression
> that this should be fixed in 3.1.

What you see is not necessarily a hang. It may just be that you've
caused your IO subsystem to have so much IO queued up it's completely
overwhelmed. How much RAM do you have in the machine?

> What makes the test system special is:
> 1) The test partition uses 1024 block size and 576b log size.

So you've made the log as physically small as possible on a tiny
(9GB) filesystem. Why?

> 2) The RAID controller cache is disabled.

And you've made the storage subsystem as slow as possible. What type
of RAID are you using, how many disks in the RAID volume, which type
of disks, etc?

> I can't seem to hit the problem without the above modifications.

How on earth did you come up with this configuration?

> For the IO workload I pre-create 8000 files with random content and
> sizes between 1k and 128k on the test partition. Then I run a tool
> that spawns a bunch of threads which just copy these files to a
> different directory on the same partition.

So, your workload also has a significant amount parallelism and
concurrency on a filesytsem with only 4 AGs? 

> At the same time there are
> other threads that rename, remove and overwrite random files in the
> destination directory keeping the file count at around 500.

And you've added as much concurrent metadata modification as
possible, too, which makes me wonder.....

> Let me know what other information I can provide to pin this down.

.... exactly what are you trying to acheive with this test?  From my
point of view, you're doing something completely and utterly insane.
You filesystem config and workload is so far outside normal
configurations and workloads that I'm not surprised you're seeing
some kind of problem.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
