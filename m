Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8JKwGGv249553 for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 15:58:16 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Yr8plY5d8Vh84pOK for <xfs@oss.sgi.com>;
	Wed, 19 Sep 2012 13:59:27 -0700 (PDT)
Date: Thu, 20 Sep 2012 06:59:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: OOM on quotacheck (again?)
Message-ID: <20120919205924.GC31501@dastard>
References: <5059D2B4.8010300@blafoo.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5059D2B4.8010300@blafoo.org>
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
To: blafoo <mail@blafoo.org>
Cc: xfs@oss.sgi.com

On Wed, Sep 19, 2012 at 04:12:04PM +0200, blafoo wrote:
> Hi all,
> 
> for the last couple of days i've been trying to compile a new kernel for
> our webserver-platform which is based on debian-squeeze.
> 
> Hardware: a mix of Dell PE2850, 2950, R710
> - raid-10 with 4 disks (old setup, PE2850)
> - raid-1 system, raid-10 content (current setup)
> - currently running linux-2.6.37 custom built, vmalloc set to default
> (128MB)

Which implies you are running a 32 bit kernel even on 64 bit CPUs
(e.g. R710).

> 
> All systems have an xfs-filesystem as their content-partition and have
> group-quota enabled (no other xfs-settings active). the
> content-partition varies in size between 250GB and 1TB and contains
> between 3 and 10 million files.
> 
> Every time i try to mount the xfs-file-system and a quota-check is
> needed, the server goes out of memory (oom). I can easily reproduce this
> by rebooting the server, resetting the quota-flags with

No surprise if you are running an i686 kernel (32 bit). You've got
way more inodes than can fit in the kernel memory segment.

> xfs_db -x -c 'sb 0' -c 'write qflags 0'
> 
> and rerun the quota-check.
> 
> This is true for various kernels but not all. What i've tried so far:
> 
> 2.6.37.x - fails with OOM
> 2.6.39.4 - suprisingly works (see below why)
> 3.2.29 - fails with OOM
> 3.4.10 - fails with OOM

8a00ebe xfs: Ensure inode reclaim can run during quotacheck

$ git describe --contains 8a00ebe
v3.5-rc1~91^2~54

So the OOM problem was fixed in 3.5.

> 3.6.0rc5 - fails with vmalloc error (XFS (sda7): xfs_buf_get_map: failed
> to map pages), with vmalloc=256 the systems hangs on mount infitly.

Running on a x86-64 kernel will make the vmalloc problem go away.
There's very little we can do about the limited vmalloc address
space on i686 kernels. As it is, the known recent regression in this
space:

bcf62ab xfs: Fix overallocation in xfs_buf_allocate_memory()

$ git describe --contains bcf62ab
v3.6-rc1~42^2~35

was fixed in 3.6-rc1, so I'm not really that sure why you'd be
running out of vmalloc space as there shouldn't be any metadata that
is vmalloc'd in your given filesystem configuration...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
