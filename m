Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4753A7F61
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 13:45:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CA6AFAC009
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 11:45:47 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Zza5mXXQSOuGH1tE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jan 2014 11:45:45 -0800 (PST)
Date: Wed, 29 Jan 2014 11:45:38 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: FAST paper on ffsck
Message-ID: <20140129194538.GC8798@birch.djwong.org>
References: <20131209180149.GA6096@thunk.org> <20131212053047.GI31386@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131212053047.GI31386@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com

On Thu, Dec 12, 2013 at 04:30:47PM +1100, Dave Chinner wrote:
> On Mon, Dec 09, 2013 at 01:01:49PM -0500, Theodore Ts'o wrote:
> > Andreas brought up on today's conference call Kirk McKusick's recent
> > changes[1] to try to improve fsck times for FFS, in response to the
> > recent FAST paper covering fsck speed ups for ext3, "ffsck: The Fast
> > Filesystem Checker"[2]
> > 
> > [1] http://www.mckusick.com/publications/faster_fsck.pdf
> > [2] https://www.usenix.org/system/files/conference/fast13/fast13-final52_0.pdf
> 
> Interesting - it's all about trying to lay out data to get
> sequential disk access patterns during scanning (i.e. minimise disk
> seeks) to reduce fsck runtime. Fine in principle, but I think that
> it's a dead end you don't want to go down.
> 
> Why? Because it's the exact opposite of what you need for SSD based
> filesystems.  What fsck really needs is to be able to saturate the
> IOPS capability of the underlying device rather than optimising for
> bandwidth, and that means driving deep IO queue depths.
> 
> e.g I've dropped xfs_repair times on a 100TB test filesystem with 50
> million inodes from 25 minutes to 5 minutes simply by adding gobs of
> additional concurrency and ignoring sequential IO optimisations.
> It's driving bandwidth rates of 200-250MB/s simply due to the IOPS
> rate it is acheiving, not because I'm optimising IO patterns for
> sequential IO.
> 
> In fact, it dispatches so much IO now that the limitation is not the
> 60,000 IOPS that it is pulling from the underlying SSDs, but
> mmap_sem contention caused by 30-odd threads doing concurrent memory
> allocation to cache and store all the information that is being read
> from disk...

I've created a couple of experimental patches to speed up e2fsck.  The first
patch creates a new IO manager that mmap()s the device and simply memcpy()s
buffers in and out to do IO.  The second patch spawns a bunch of threads that
split up the work of scanning each block group in the hopes of faulting in all
the metadata off the disk ahead of the main e2fsck thread.

The upside is that on a cold system, the patches reduce e2fsck running time on
HDD RAIDs and SSDs by 30-40%.  On a warm system there's not much advantage.
The downside is that fsck tends to crash when it writes anything out.  I've
been meaning to send this out after I fix the write crash, but I've been
occupied with other things at work. :/

There's also a horrible case where on a disk where can_queue = 1, the disk
mostly just thrashes like mad and takes several times longer than regular fsck.
I could be wrong about that; I don't know if it's really can_queue = 1 or
simply having only one disk head that's the cause.

<shrug> I'll clean 'em up and send an RFC.

--D
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
