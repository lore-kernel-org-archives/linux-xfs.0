Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 17:23:18 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l091NBqw013912
	for <linux-xfs@oss.sgi.com>; Mon, 8 Jan 2007 17:23:13 -0800
Date: Tue, 9 Jan 2007 12:22:12 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS and 2.6.18 -> 2.6.20-rc3
Message-ID: <20070109012212.GG44411608@melbourne.sgi.com>
References: <45A27BC7.2020709@exegy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45A27BC7.2020709@exegy.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Mr. Berkley Shands" <bshands@exegy.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Dave Lloyd <dlloyd@exegy.com>, linux-xfs@oss.sgi.com

On Mon, Jan 08, 2007 at 11:13:43AM -0600, Mr. Berkley Shands wrote:
> My testbench is a 4 core Opteron (dual 275's) into
> two LSI8408E SAS controllers, into 16 Seagate 7200.10 320GB satas.
> Redhat ES4.4 (Centos 4.4). A slightly newer parted is needed
> than the contemporary of Moses that is shipped with the O/S.
> 
> I have a standard burn in script that takes the 4 4-drive raid0's
> and puts a GPT label on them, aligns the partitions to stripe
> boundary's. It then proceeds to write 8GB files concurrently
> onto all 4 raid drives.

How many files are being written at the same time to each filesystem?
buffered or direct I/O? I/O size? how much memory in the machine?
What size I/Os are actually hitting the disks?

> Under 2.6.18.1 the write speeds start at 265MB/Sec and decrease
> mostly monotonically down to ~160MB/Sec, indicating that
> the files start on the outside (fastest tracks) and work in.

So you are filling the entire disk with this test?

> All 4 raids are within 7-8MB/Sec of each other (usually they
> are identical in speed).
>
> By the time of 2.6.20-rc3, the same testbench shows
> a 10% across the board decrease in throughput for writes.
> Reads are unaffected.

Reads being unaffected indicates the files are not being fragmented
badly.

> But now the allocation order for virgin file systems are random,

How did you determine this?

> usually starting at the slow 140MB/Sec, then bouncing up to 220MB/Sec,
> then around and around. No two raids get the same write speeds at the 
> same time.
> 
> Dave Lloyd (our in-house Idea Guy) looked at the allocation groups...
> Non-sequential, random...
> 
> What data would you like to see?

First thing to do is run a set of write tests to the _raw_ devices,
not to the filesystem so we can rule out a driver/hardware problem.

Can you do something as simple as concurrent writes to each raid lun
to see if .18 and .20 perform the same?

> The run logs from 2.6.18.1 and 2.6.20-rc3?
> Want the scripts?

Yes please.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
