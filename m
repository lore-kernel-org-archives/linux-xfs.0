Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5D3uG0W073972 for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 22:56:16 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id bRysQxQjTfkzqgjo
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 20:56:15 -0700 (PDT)
Message-ID: <4FD80F5E.3080007@hardwarefreak.com>
Date: Tue, 12 Jun 2012 22:56:14 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS hangs and freezes with LSI 9265-8i controller on high i/o
References: <4FD66513.2000108@xsnews.nl> <20120612011812.GK22848@dastard>
	<4FD766A7.9030908@xsnews.nl> <20120613011950.GN22848@dastard>
In-Reply-To: <20120613011950.GN22848@dastard>
Reply-To: stan@hardwarefreak.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: Matthew Whittaker-Williams <matthew@xsnews.nl>, xfs@oss.sgi.com

On 6/12/2012 8:19 PM, Dave Chinner wrote:
> On Tue, Jun 12, 2012 at 05:56:23PM +0200, Matthew Whittaker-Williams wrote:

>> RAID Level          : Primary-6, Secondary-0, RAID Level Qualifier-3
>> Size                : 40.014 TB
>> State               : Optimal
>> Strip Size          : 64 KB
>> Number Of Drives    : 24
> .....
>> Virtual Drive: 1 (Target Id: 1)
>> Name                :
>> RAID Level          : Primary-6, Secondary-0, RAID Level Qualifier-3
>> Size                : 40.014 TB
>> State               : Optimal
>> Strip Size          : 1.0 MB
>> Number Of Drives    : 24

> The reason, I'd suggest, is that you've chosen the wrong RAID volume
> type for your workload. Small random file read and write workloads
> like news and mail spoolers are IOPS intensive workloads and do
> not play well with RAID5/6. RAID5/6 really only work well for large
> files with sequential access patterns - you need to use RAID1/10 for
> IOPS intensive workloads because they don't suffer from the RMW
> cycle problem that RAID5/6 has for small writes. The iostat output
> will help clarify whether this is really the problem or not...

If it is the problem, you'll want to consider something like the
following, assuming your working files are somewhat evenly spread over
24 or more directories and/or subdirectories.

1.  For each 24 drive JBOD, create 3x 8 drive RAID10s, strip 64KB.  That
yields a relatively small stripe of 256KB over 4 spindles.  Should be a
good fit for small file random IOPS.

2.  Make an md linear array of the 3 hardware RAID10 arrays, such as:

~$ mdadm -C /dev/md0 -n3 -l linear /dev/sd[abc]

3.  Create your stripe aligned XFS over the md linear array:

~$ mkfs.xfs -d su=64K,sw=4 agcount=24

This will yield excellent small file IOPS, ~1800 peak at the spindles,
while still giving a decent ~400MB/s kick if you have some streaming
workloads from time to time.  Absolute XFS small file high IOPS
performance is attained with a linear array of RAID1 pairs, but with 12
physical device names this tends to get unwieldy in mdadm.  And as I
mentioned this hybrid architecture still allows decent streaming
performance if you need it.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
