Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p54CBupP079814 for <xfs@oss.sgi.com>; Sat, 4 Jun 2011 07:11:56 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 54ED91347C8F
	for <xfs@oss.sgi.com>; Sat,  4 Jun 2011 05:11:53 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 4S6hC1u2mNVvNMvF
	for <xfs@oss.sgi.com>; Sat, 04 Jun 2011 05:11:53 -0700 (PDT)
Message-ID: <4DEA2106.5000900@hardwarefreak.com>
Date: Sat, 04 Jun 2011 07:11:50 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: I/O hang, possibly XFS, possibly general
References: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>	<20110603004247.GA28043@infradead.org>	<20110603013948.GX561@dastard>	<BANLkTi=FjSzSZJXGofVjtiUe2ZNvki2R-Q@mail.gmail.com>	<4DE9E97D.30500@hardwarefreak.com>
	<20110604103247.GG561@dastard>
In-Reply-To: <20110604103247.GG561@dastard>
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
Cc: Paul Anderson <pha@umich.edu>, Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On 6/4/2011 5:32 AM, Dave Chinner wrote:
> On Sat, Jun 04, 2011 at 03:14:53AM -0500, Stan Hoeppner wrote:
>> On 6/3/2011 10:59 AM, Paul Anderson wrote:
>>> Not sure what I can do about the log - man page says xfs_growfs
>>> doesn't implement log moving.  I can rebuild the filesystems, but for
>>> the one mentioned in this theread, this will take a long time.
>>
>> See the logdev mount option.  Using two mirrored drives was recommended,
>> I'd go a step further and use two quality "consumer grade", i.e. MLC
>> based, SSDs, such as:
>>
>> http://www.cdw.com/shop/products/Corsair-Force-Series-F40-solid-state-drive-40-GB-SATA-300/2181114.aspx
>>
>> Rated at 50K 4K write IOPS, about 150 times greater than a 15K SAS drive.
> 
> If you are using delayed logging, then a pair of mirrored 7200rpm
> SAS or SATA drives would be sufficient for most workloads as the log
> bandwidth rarely gets above 50MB/s in normal operation.

Hi Dave.  I made the first reply to Paul's post, recommending he enable
delayed logging as a possible solution to his I/O hang problem.  I
recommended this due to his mention of super heavy metadata operations
at the time on his all md raid60 on plain HBA setup.  Paul did not list
delaylog when he submitted his 2.6.38.5 mount options:

inode64,largeio,logbufs=8,noatime

Being the author of the delayed logging code, I had expected you to
comment on this, either expounding on my recommendation, or shooting it
down, and giving the reasons why.

So, would delayed logging have possibly prevented his hang problem or
no?  I always read your replies at least twice, and I don't recall you
touching on delayed logging in this thread.  If you did and I missed it,
my apologies.

Paul will have 3 of LSI's newest RAID cards with a combined 3GB BBWC to
test with, hopefully soon.  With that much cache is an external log
device still needed?  With and/or without delayed logging enabled?

> If you have fsync heavy workloads, or are not using delayed logging,
> then you really need to use the RAID5/6 device behind a BBWC because
> the log is -seriously- bandwidth intensive. I can drive >500MB/s of
> log throughput on metadata intensive workloads on 2.6.39 when not
> using delayed logging or I'm regularly forcing the log via fsync.
> You sure as hell don't want to be running a sustained long term
> write load like that on consumer grade SSDs.....

Given that the max log size is 2GB, IIRC, and that most recommendations
I've seen here are against using a log that big, I figure such MLC
drives would be fine.  AIUI, modern wear leveling will spread writes
throughout the entire flash array before going back and over writing the
first sector.  Published MTBF on most MLC drives rates are roughly
equivalent to enterprise SRDs, 1+ million hours.

Do you believe MLC based SSDs are simply never appropriate for anything
but consumer use, and that only SLC devices should be used for real
storage applications?  AIUI SLC flash cells do have about a 10:1 greater
lifetime than MLC cells.  However, there have been a number of
articles/posts demonstrating math which shows a current generation
SandForce based MLC SSD, under a constant 100MB/s write stream, will run
for 20+ years, IIRC, before sufficient live+reserved spare cells burn
out to cause hard write errors, thus necessitating drive replacement.
Under your 500MB/s load, assuming that's constant, the drives would
theoretically last 4+ years.  If that 500MB/s load was only for 12 hours
each day, the drives would last 8+ years.  I wish I had one of those
articles bookmarked...

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
