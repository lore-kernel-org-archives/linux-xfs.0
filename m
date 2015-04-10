Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D25CD7F87
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 01:32:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CD32F304048
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 23:32:29 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	yscYX7qQCadQVL0d for <xfs@oss.sgi.com>;
	Thu, 09 Apr 2015 23:32:27 -0700 (PDT)
Date: Fri, 10 Apr 2015 16:32:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Syncd
Message-ID: <20150410063210.GJ15810@dastard>
References: <CABppvi6pC4qEFZUTesbT0v5agbd67MP4dEoUbaVFwEyCv4h21g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABppvi6pC4qEFZUTesbT0v5agbd67MP4dEoUbaVFwEyCv4h21g@mail.gmail.com>
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
To: Shrinand Javadekar <shrinand@maginatics.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 09, 2015 at 09:23:55PM -0700, Shrinand Javadekar wrote:
> Hi,
> 
> I am using the XFS filesystem as the backend for Openstack Swift. On
> my setup, I have a single server with 8 data disks; each of them is
> one XFS volume.
> 
> I am running a workload which does many concurrent writes of 256K
> files into the XFS volumes. Openstack Swift takes care of evenly
> distributing the data across all the 8 disks. It also uses extended
> attributes for each of the files it writes. It also explicitly does a
> fsync() at the end for each file.

What's xfssyncd? :P

$ ps waux |grep [x]fs
root       192  0.0  0.0      0     0 ?        S<   Mar16   0:00 [xfsalloc]
root       193  0.0  0.0      0     0 ?        S<   Mar16   0:00 [xfs_mru_cache]
root       194  0.0  0.0      0     0 ?        S<   Mar16   0:00 [xfslogd]
root       196  0.0  0.0      0     0 ?        S<   Mar16   0:00 [xfs-data/md0]
root       197  0.0  0.0      0     0 ?        S<   Mar16   0:00 [xfs-conv/md0]
root       198  0.0  0.0      0     0 ?        S<   Mar16   0:00 [xfs-cil/md0]
root       199  0.1  0.0      0     0 ?        S    Mar16  40:27 [xfsaild/md0]
$

Oh, right, it's that workqueue we removed in late 2012 (in the 3.7
cycle) because it was redundant. The only remaining fragment of it
is the xfslogd. What kernel are you running?

> I am seeing a behavior where the system pretty much stalls for ~5
> seconds after every 30 seconds. I see that the # of ios goes up but
> the actual write bandwidth during this 5 second period is very low
> (see attached images). After a fair bit of investigation, we've
> narrowed down the problem to XFS's syncd (fs.xfs.xfssyncd_centisecs).
> This runs at a default interval of 30 seconds.

It's doing background inode reclaim which, under some circumstances,
involves truncating specualtive allocation beyond EOF before reclaim
occurs, which results in transactions and inode writeback. It was
highly inefficient, which is why we replaced it.

> I have a couple of questions:
> 
> 1. If all file writes are done with an fsync() at the end, what is
> xfssyncd doing for several seconds?
> 2. How does xfssyncd actually work across several disks? Currently, it
> seems that when it runs, it pretty much stalls the entire system.

xfssyncd was actually a workqueue, so it services multiple
filesystems at once. Before that, there was a kernel thread per
filesystem for it. Anyway, it's doing lots of random write IO and
saturating your disks, which will stall any system that is dependent
on IO throughput to function.

> 3. I see that fs.xfs.xfssyncd_centisecs is the parameter to tune the
> interval. But that doesn't give us much. Increasing the interval
> simply postpones the work. When xfssyncd runs, it takes more time. Are
> there any other options I can try to make xfssyncd not stall the
> system when it runs?

Upgrade your kernel to something more recent, and the problem should
go away.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
