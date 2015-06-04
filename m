Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BBBCC7FC1
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 20:55:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 383E8AC001
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 18:55:26 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	RXlCT7eevU6vipYC for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2015 18:55:22 -0700 (PDT)
Date: Thu, 4 Jun 2015 11:55:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Syncd
Message-ID: <20150604015519.GH9143@dastard>
References: <20150410063210.GJ15810@dastard>
	<CABppvi4e_xEMY7tDHtEo6miZcN2AZ-mFMHXKaUS0hfpx6AMt0w@mail.gmail.com>
	<20150410072100.GL13731@dastard>
	<CABppvi437S9e+DEFOi6ECPu8=AnEK0V=5rRmU5Of1_XtWiQbfA@mail.gmail.com>
	<20150410131245.GK15810@dastard>
	<CABppvi68E6n+pr6X8TMOBhicVB4mrJbyyvm89r56rRVqSjf1Zg@mail.gmail.com>
	<20150603035719.GO24666@dastard>
	<CABppvi4AzQyaUm25_ombXR0Om04mUcHKtFd0ug_iKRxqa+NsOg@mail.gmail.com>
	<20150604003546.GS24666@dastard>
	<CABppvi66Yskf0OutB02v5ayD5DrYjAQ4aZUsAi+b9z9SX=hzUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABppvi66Yskf0OutB02v5ayD5DrYjAQ4aZUsAi+b9z9SX=hzUQ@mail.gmail.com>
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

On Wed, Jun 03, 2015 at 05:58:07PM -0700, Shrinand Javadekar wrote:
> Thanks Dave. Please see my responses inline.
> 
> On Wed, Jun 3, 2015 at 5:35 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Jun 03, 2015 at 04:18:20PM -0700, Shrinand Javadekar wrote:
> >> Here you go!
> >
> > Thanks!
> >
> >> /dev/mapper/35000c50062e6a12b-part2 /srv/node/r1 xfs
> >> rw,nosuid,nodev,noexec,noatime,nodiratime,attr2,nobarrier,inode64,logbufs=8,noquota
> >> 0 0
> > .....
> >> meta-data=/dev/mapper/35000c50062e6a7eb-part2 isize=256    agcount=64, agsize=11446344 blks
> >>          =                       sectsz=512   attr=2
> >> data     =                       bsize=4096   blocks=732566016, imaxpct=5
> >>          =                       sunit=0      swidth=0 blks
> >> naming   =version 2              bsize=4096   ascii-ci=0
> >> log      =internal               bsize=4096   blocks=357698, version=2
> >>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> >> realtime =none                   extsz=4096   blocks=0, rtextents=0
> >
> > Ok, so agcount=64 is unusual, especially for a single disk
> > filesystem. What was the reason for doing this?
> 
> I read few articles that recommend using an increased number of AGs,
> especially when there are large disks. I can use the default # of AGs
> (4?) and try again.

<sigh>

The Google Fallacy strikes again.

http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

> >> Openstack Swift. This is what it's doing:
> >>
> >> 1. A path like /srv/node/r1/objects/1024/eef/tmp already exists.
> >> /srv/node/r1 is the mount point.
> >> 2. Creates a tmp file, say tmpfoo in the patch above. Path:
> >> /srv/node/r1/objects/1024/eef/tmp/tmpfoo.
> >> 3. Issues a 256KB write into this file.
> >> 4. Issues an fsync on the file.
> >> 5. Closes this file.
> >> 6. Creates another directory named "deadbeef" inside "eef" if it
> >> doesn't exist. Path /srv/node/r1/objects/1024/eef/deadbeef.
> >> 7. Moves file tmpfoo into the deadbeef directory using rename().
> >> /srv/node/r1/objects/1023/eef/tmp/tmpfoo -->
> >> /srv/node/r1/objects/1024/eef/deadbeef/foo.data
> >> 8. Does a readdir on /srv/node/r1/objects/1024/eef/deadbeef/
> >> 9. Iterates over all files obtained in #8 above. Usually #8 gives only one file.
> >
> > Oh. We've already discussed this problem in a previous thread:
> >
> > http://oss.sgi.com/archives/xfs/2015-04/msg00256.html
> 
> Yes, we touched upon this earlier and found that all files were
> getting created in the same AG. We fixed that by and my current
> testing includes that fix.

Right, I noticed that looking at the inode allocation distribution.
It's pretty good (output is count, agno):

$$ awk '/xfs_ialloc_read_agi:/ {print $8}' trace_report.txt | sort -n |uniq -c
   1362 0
   1351 1
   1359 2
   1354 3
   1374 4
   1345 5
   1380 6
   1371 7
   1356 8
   1354 9
   1373 10
   1364 11
   1357 12
   1363 13
   1368 14
   1386 15
   1355 16
   1384 17
   1352 18
   1377 19
   1358 20
   1371 21
   1356 22
   1367 23
   1342 24
   1383 25
   1352 26
   1354 27
   1347 28
   1382 29
   1348 30
   1347 31
   1351 32
   1346 33
   1350 34
   1365 35
   1346 36
   1361 37
   1358 38
   1337 39
   1356 40
   1371 41
   1347 42
   1335 43
   1378 44
   1370 45
   1372 46
   1334 47
   1363 48
   1355 49
   1365 50
   1353 51
   1370 52
   1346 53
   1369 54
   1356 55
   1381 56
   1349 57
   1365 58
   1356 59
   1351 60
   1345 61
   1379 62
   1351 63

> > Specifically, that discussion touched on problems your workload
> > induces in metadata layout and locality:
> >
> > http://oss.sgi.com/archives/xfs/2015-04/msg00300.html
> >
> > And you are using agcount=64 on these machines, so that's going to
> > cause you all sorts of locality problems, which will translate into
> > seek bound IO performance....
> >
> >> - IOStat and vmstat output
> >> (attached)
> >
> > I am assuming these are 1 second samples, based on your 18s fast/12s
> > slow description earlier.
> 
> Yes, these are 1 seconds samples.
> 
> >
> > The vmstat shows fast writeback at 150-200MB/s, with no idle time,
> > anything up to 200 processes in running or blocked state and 20-30%
> > iowait, followed by idle CPU time with maybe 10 running/blocked
> > processes, writeback at 15-20MB/s with 70% idle time and 30% iowait.
> >
> > IOWs, the workload is cyclic - lots of incoming data with lots of
> > throughput, followed by zero incoming data processing on only small
> > amounts of writeback.
> 
> My understanding is that the workload is either
> 
> a) waiting for issued IOs to complete.
> b) not able to issue more IOs because XFS is busy flushing the journal entries.
> 
> Is this not true?

It's just an *observation* that the incoming processing has stopped
from the data presented, and it doesn't speak to the cause of why
incoming data is not being processed. You're jumping to conclusions
again before there is supporting evidence to make such a statement.

> > The vmstat information implies that front end application processing
> > is stopping for some period of time, but it does not indicate why it
> > is doing so.  When the disks are doing 4k writeback, can you grab
> > the output of 'echo w > /proc/sysrq-trigger' from dmesg and post the
> > output? That will tell us if the front end processing is blocked on
> > the filesystem at all...
> 
> Aah.. ok. Will do and get back to you soon.

See? more information is required. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
