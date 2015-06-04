Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 597237F78
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 19:36:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 49F9A304043
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 17:35:57 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	lrV7CyyAUcBB9XYP for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2015 17:35:49 -0700 (PDT)
Date: Thu, 4 Jun 2015 10:35:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Syncd
Message-ID: <20150604003546.GS24666@dastard>
References: <CABppvi6pC4qEFZUTesbT0v5agbd67MP4dEoUbaVFwEyCv4h21g@mail.gmail.com>
	<20150410063210.GJ15810@dastard>
	<CABppvi4e_xEMY7tDHtEo6miZcN2AZ-mFMHXKaUS0hfpx6AMt0w@mail.gmail.com>
	<20150410072100.GL13731@dastard>
	<CABppvi437S9e+DEFOi6ECPu8=AnEK0V=5rRmU5Of1_XtWiQbfA@mail.gmail.com>
	<20150410131245.GK15810@dastard>
	<CABppvi68E6n+pr6X8TMOBhicVB4mrJbyyvm89r56rRVqSjf1Zg@mail.gmail.com>
	<20150603035719.GO24666@dastard>
	<CABppvi4AzQyaUm25_ombXR0Om04mUcHKtFd0ug_iKRxqa+NsOg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABppvi4AzQyaUm25_ombXR0Om04mUcHKtFd0ug_iKRxqa+NsOg@mail.gmail.com>
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

On Wed, Jun 03, 2015 at 04:18:20PM -0700, Shrinand Javadekar wrote:
> Here you go!

Thanks!

> /dev/mapper/35000c50062e6a12b-part2 /srv/node/r1 xfs
> rw,nosuid,nodev,noexec,noatime,nodiratime,attr2,nobarrier,inode64,logbufs=8,noquota
> 0 0
.....
> meta-data=/dev/mapper/35000c50062e6a7eb-part2 isize=256    agcount=64, agsize=11446344 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=732566016, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=357698, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

Ok, so agcount=64 is unusual, especially for a single disk
filesystem. What was the reason for doing this?

> - Workload causing the problem:
> 
> Openstack Swift. This is what it's doing:
> 
> 1. A path like /srv/node/r1/objects/1024/eef/tmp already exists.
> /srv/node/r1 is the mount point.
> 2. Creates a tmp file, say tmpfoo in the patch above. Path:
> /srv/node/r1/objects/1024/eef/tmp/tmpfoo.
> 3. Issues a 256KB write into this file.
> 4. Issues an fsync on the file.
> 5. Closes this file.
> 6. Creates another directory named "deadbeef" inside "eef" if it
> doesn't exist. Path /srv/node/r1/objects/1024/eef/deadbeef.
> 7. Moves file tmpfoo into the deadbeef directory using rename().
> /srv/node/r1/objects/1023/eef/tmp/tmpfoo -->
> /srv/node/r1/objects/1024/eef/deadbeef/foo.data
> 8. Does a readdir on /srv/node/r1/objects/1024/eef/deadbeef/
> 9. Iterates over all files obtained in #8 above. Usually #8 gives only one file.

Oh. We've already discussed this problem in a previous thread:

http://oss.sgi.com/archives/xfs/2015-04/msg00256.html

Next time, please make sure you start with a reference to previous
discussions on the same topic.

Specifically, that discussion touched on problems your workload
induces in metadata layout and locality:

http://oss.sgi.com/archives/xfs/2015-04/msg00300.html

And you are using agcount=64 on these machines, so that's going to
cause you all sorts of locality problems, which will translate into
seek bound IO performance....

> - IOStat and vmstat output
> (attached)

I am assuming these are 1 second samples, based on your 18s fast/12s
slow description earlier.

The vmstat shows fast writeback at 150-200MB/s, with no idle time,
anything up to 200 processes in running or blocked state and 20-30%
iowait, followed by idle CPU time with maybe 10 running/blocked
processes, writeback at 15-20MB/s with 70% idle time and 30% iowait.

IOWs, the workload is cyclic - lots of incoming data with lots of
throughput, followed by zero incoming data processing on only small
amounts of writeback.

The iostat shows that when the system is running at 150MB/s, the IO
service time is ~7ms (running ~130 IOPS per drive) and the average
IO size is around 170kB, with a request queue depth of 20-30 IOs.
Device utilisation is 100%, so throughput is seek bound.

When the system is mostly idle, the throughput is essentially
running a random 4k IO write workload - 180 IOPS, request size 4k,
service time 5ms, request queue depth ~140, average wait ~800ms,
device utilisation 100%. Again, seek bound, the only difference is
the IO size.

The vmstat information implies that front end application processing
is stopping for some period of time, but it does not indicate why it
is doing so.  When the disks are doing 4k writeback, can you grab
the output of 'echo w > /proc/sysrq-trigger' from dmesg and post the
output? That will tell us if the front end processing is blocked on
the filesystem at all...

> - Trace cmd report
> Too big to attach. Here's a link:
> https://www.dropbox.com/s/3xxe2chsv4fsrv8/trace_report.txt.zip?dl=0

Downloading now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
