Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p548ExaE067343 for <xfs@oss.sgi.com>; Sat, 4 Jun 2011 03:14:59 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB4421E3D0B9
	for <xfs@oss.sgi.com>; Sat,  4 Jun 2011 01:14:57 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id kUHMf3VDyhQ6fMEf
	for <xfs@oss.sgi.com>; Sat, 04 Jun 2011 01:14:57 -0700 (PDT)
Message-ID: <4DE9E97D.30500@hardwarefreak.com>
Date: Sat, 04 Jun 2011 03:14:53 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: I/O hang, possibly XFS, possibly general
References: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>	<20110603004247.GA28043@infradead.org>	<20110603013948.GX561@dastard>
	<BANLkTi=FjSzSZJXGofVjtiUe2ZNvki2R-Q@mail.gmail.com>
In-Reply-To: <BANLkTi=FjSzSZJXGofVjtiUe2ZNvki2R-Q@mail.gmail.com>
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
To: Paul Anderson <pha@umich.edu>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On 6/3/2011 10:59 AM, Paul Anderson wrote:

Hi Paul,

When I first replied to this thread I didn't recognize your name, thus
forgot our off-list conversation.  Sorry bout that.

> Good HW RAID cards are on order - seems to be backordered at least a
> few weeks now at CDW.  Got the batteries immediately.

As I mentioned, the 9285-8E is very new product, but I didn't realize it
was *that* new.  Sorry you're having to wait for them.

> That will give more options for test and deployment.

Others have made valid points WRT the down sides of wide stripe parity
arrays.  I've mentioned many times I loathe parity RAID due to those
reasons, and others, but it's mandatory in your case due to the reasons
you previously stated.

If such arguments are sufficiently convincing, and you can afford to
lose the capacity of 2 more disks per chassis to parity, and increase
complexity a bit, you may want to consider 3 x 7 drive RAID5 arrays per
backplane, 6 drive stripe width, 18 total arrays concatenated,  216 AGs,
6 AGs per array, 216TB raw storage per server, if my math is correct.
That instead of the concatenated 6 x 21 drive RAID6 arrays I previously
mentioned.

You'd have 3 arrays per backplane/cable and thus retain some isolation
advantages for troubleshooting, with the same spares arrangement.  Your
overall resiliency, mathematical/theoretical anyway, to drive failure
should actually increase slightly as you would have 3 drives per
backplane worth of parity instead of 2, and array rebuild time would be
~1/3rd that of the 21 drive array, somewhat negating the dual parity
advantage of RAID6 as the odds of drive failure during a rebuild tend to
increase with the duration of the rebuild.

> Not sure what I can do about the log - man page says xfs_growfs
> doesn't implement log moving.  I can rebuild the filesystems, but for
> the one mentioned in this theread, this will take a long time.

See the logdev mount option.  Using two mirrored drives was recommended,
I'd go a step further and use two quality "consumer grade", i.e. MLC
based, SSDs, such as:

http://www.cdw.com/shop/products/Corsair-Force-Series-F40-solid-state-drive-40-GB-SATA-300/2181114.aspx

Rated at 50K 4K write IOPS, about 150 times greater than a 15K SAS drive.

> I'm guessing we'll need to split out the workload - aside from the
> differences in file size and use patterns, they also have
> fundamentally different values (the high metadata dataset happens to
> be high value relative to the low metadata/large file dataset).

LSI is touting significantly better parity performance for the 9265/9285
vs LSI's previous generation cards for which they claim peaks of ~2700
MB/s sequential read and ~1800 MB/s write.  The new cards have double
the cache of the previous, so I would think write performance would
increase more than read.  I'm really interested in seeing your test
results with your workloads Paul.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
