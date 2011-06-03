Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p531dr1F235346 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 20:39:54 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D8C6D6E2D9
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 18:39:51 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	phGOGRDfYheeYoAx for <xfs@oss.sgi.com>;
	Thu, 02 Jun 2011 18:39:51 -0700 (PDT)
Date: Fri, 3 Jun 2011 11:39:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: I/O hang, possibly XFS, possibly general
Message-ID: <20110603013948.GX561@dastard>
References: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>
	<20110603004247.GA28043@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110603004247.GA28043@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Paul Anderson <pha@umich.edu>, xfs-oss <xfs@oss.sgi.com>

On Thu, Jun 02, 2011 at 08:42:47PM -0400, Christoph Hellwig wrote:
> On Thu, Jun 02, 2011 at 10:42:46AM -0400, Paul Anderson wrote:
> > This morning, I had a symptom of a I/O throughput problem in which
> > dirty pages appeared to be taking a long time to write to disk.
> > 
> > The system is a large x64 192GiB dell 810 server running 2.6.38.5 from
> > kernel.org - the basic workload was data intensive - concurrent large
> > NFS (with high metadata/low filesize), rsync/lftp (with low
> > metadata/high file size) all working in a 200TiB XFS volume on a
> > software MD raid0 on top of 7 software MD raid6, each w/18 drives.  I
> > had mounted the filesystem with inode64,largeio,logbufs=8,noatime.
> 
> A few comments on the setup before trying to analze what's going on in
> detail.  I'd absolutely recommend an external log device for this setup,
> that is buy another two fast but small disks, or take two existing ones
> and use a RAID 1 for the external log device.  This will speed up
> anything log intensive, which both NFS, and resync workloads are lot.
> 
> Second thing if you can split the workloads into multiple volumes if you
> have two such different workloads, so thay they don't interfear with
> each other.
> 
> Second a RAID0 on top of RAID6 volumes sounds like a pretty worst case
> for almost any type of I/O.  You end up doing even relatively small I/O
> to all of the disks in the worst case.  I think you'd be much better
> off with a simple linear concatenation of the RAID6 devices, even if you
> can split them into multiple filesystems
> 
> > The specific symptom was that 'sync' hung, a dpkg command hung
> > (presumably trying to issue fsync), and experimenting with "killall
> > -STOP" or "kill -STOP" of the workload jobs didn't let the system
> > drain I/O enough to finish the sync.  I probably did not wait long
> > enough, however.
> 
> It really sounds like you're simply killloing the MD setup with a
> log of log I/O that does to all the devices.

And this is one of the reasons why I originally suggested that
storage at this scale really should be using hardware RAID with
large amounts of BBWC to isolate the backend from such problematic
IO patterns.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
