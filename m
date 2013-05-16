Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8B60F7F3F
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 19:59:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7AE0A30404E
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 17:59:21 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	qzk1GUaVpaKH9Usj for <xfs@oss.sgi.com>;
	Wed, 15 May 2013 17:59:19 -0700 (PDT)
Date: Thu, 16 May 2013 10:59:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: high-speed disk I/O is CPU-bound?
Message-ID: <20130516005913.GE24635@dastard>
References: <518CFE7C.9080708@ll.mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <518CFE7C.9080708@ll.mit.edu>
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
To: David Oostdyk <daveo@ll.mit.edu>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

[cc xfs list, seeing as that's where all the people who use XFS in
these sorts of configurations hang out. ]

On Fri, May 10, 2013 at 10:04:44AM -0400, David Oostdyk wrote:
> Hello,
> 
> I have a few relatively high-end systems with hardware RAIDs which
> are being used for recording systems, and I'm trying to get a better
> understanding of contiguous write performance.
> 
> The hardware that I've tested with includes two high-end Intel
> E5-2600 and E5-4600 (~3GHz) series systems, as well as a slightly
> older Xeon 5600 system.  The JBODs include a 45x3.5" JBOD, a 28x3.5"
> JBOD (with either 7200RPM or 10kRPM SAS drives), and a 24x2.5" JBOD
> with 10kRPM drives.  I've tried LSI controllers (9285-8e, 9266-8i,
> as well as the integrated Intel LSI controllers) as well as Adaptec
> Series 7 RAID controllers (72405 and 71685).
> 
> Normally I'll setup the RAIDs as RAID60 and format them as XFS, but
> the exact RAID level, filesystem type, and even RAID hardware don't
> seem to matter very much from my observations (but I'm willing to
> try any suggestions).

Document them. There's many ways to screw them up and get bad
performance.

> As a basic benchmark, I have an application
> that simply writes the same buffer (say, 128MB) to disk repeatedly.
> Alternatively you could use the "dd" utility.  (For these
> benchmarks, I set /proc/sys/vm/dirty_bytes to 512M or lower, since
> these systems have a lot of RAM.)
> 
> The basic observations are:
> 
> 1.  "single-threaded" writes, either a file on the mounted
> filesystem or with a "dd" to the raw RAID device, seem to be limited
> to 1200-1400MB/sec.  These numbers vary slightly based on whether
> TurboBoost is affecting the writing process or not.  "top" will show
> this process running at 100% CPU.

Expected. You are using buffered IO. Write speed is limited by the
rate at which your user process can memcpy data into the page cache.

> 2.  With two benchmarks running on the same device, I see aggregate
> write speeds of up to ~2.4GB/sec, which is closer to what I'd expect
> the drives of being able to deliver.  This can either be with two
> applications writing to separate files on the same mounted file
> system, or two separate "dd" applications writing to distinct
> locations on the raw device.  (Increasing the number of writers
> beyond two does not seem to increase aggregate performance; "top"
> will show both processes running at perhaps 80% CPU).

Still using buffered IO, which means you are typically limited by
the rate at which the flusher thread can do writeback.

> 3.  I haven't been able to find any tricks (lio_listio, multiple
> threads writing to distinct file offsets, etc) that seem to deliver
> higher write speeds when writing to a single file.  (This might be
> xfs-specific, though)

How about using direct IO? Single threaded direct IO will beslower
than buffered IO, but throughput should scale linearly with the
number of threads if the IO size is large enough (e.g. 32MB).

> 4.  Cheap tricks like making a software RAID0 of two hardware RAID
> devices does not deliver any improved performance for
> single-threaded writes.  (Have not thoroughly tested this
> configuration fully with multiple writers, though.)

Of course not - you are CPU bound and nothing you do to the storage
will change that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
