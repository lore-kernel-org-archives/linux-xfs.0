Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EB4537F3F
	for <xfs@oss.sgi.com>; Sun, 10 Mar 2013 01:54:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA66B304048
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 23:54:43 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id j142eyUNZXYKnpRs
	for <xfs@oss.sgi.com>; Sat, 09 Mar 2013 23:54:42 -0800 (PST)
Message-ID: <513C3C43.7080104@hardwarefreak.com>
Date: Sun, 10 Mar 2013 01:54:43 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Maximum file system size of XFS?
References: <20130309215121.0e614ef8@thinky> <513BB7C3.4050009@redhat.com>
	<20130309233940.3b7c0910@thinky> <513BDD6E.7010507@sandeen.net>
In-Reply-To: <513BDD6E.7010507@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com, Pascal <pa5ca1@gmx.de>

On 3/9/2013 7:10 PM, Eric Sandeen wrote:
> On 3/9/13 4:39 PM, Pascal wrote:
> 
>> Hello Ric,
>>
>> thank you for your answer. I am aware that there is a difference
>> between the maximum size under practical conditions and the theoretical
>> maximum. But I am looking for this theoretical number to use in within
>> in my thesis comparing file systems.
> 
> A thesis comparing actual scalability would be much more interesting
> than one comparing, essentially, the container size chosen for a disk
> block.  One could quickly write a filesystem which "can" be as large
> as a yottabyte, but it wouldn't really *mean* anything.

Agreed.  But if the OP must have the theoretical maximum, I think what's
in the SGI doc is the correct number.  Down below what the OP quoted
from the Features section, down in the Technical Specifications, we find:

" Maximum Filesystem Size

For Linux 2.4, 2 TB. For Linux 2.6 and beyond, when using 64 bit
addressing in the block devices layer (CONFIG_LBD) and a 64 bit
platform, filesystem size limit increases to 9 million terabytes (or the
device limits). For these later kernels on 32 bit platforms, 16TB is the
current limit even with 64 bit addressing enabled in the block layer."


I assume the OP's paper deals with the far distant future where
individual rusty disk drives have 1PB capacity, thus requiring 'only'
9,000 disk drives for a RAW 9EB XFS without redundancy, or 18,000 drives
for RAID10.  With today's largest drives at 4TB, it would take 2.25
million disk drives for a RAW 9EB capacity, 4.5 million for RAID10.  All
of this assuming my math is correct.  I don't regularly deal with 16
digit decimal numbers. ;)  I'm also assuming in this distant future that
rusty drives still lead SSD in price/capacity.  That may be an incorrect
assumption.  Dave can beat up on me in a couple of decades if my
assumption proves incorrect. ;)

For a 9EB XFS to become remotely practical, I'd say disk drive capacity
would have to reach 10 petabytes per drive.  This yields 1800 drives for
9EB in RAID10, or 3x 42U racks each housing 10x 4U 60 drive FC RAID
chassis, 600 drives per rack.  I keep saying RAID10 instead of RAID6
because I don't think anyone would want to attempt a RAID6 parity
rebuild of even a small 4+2 array of 10PB drives, if the sustained
interface rate continues to increase at the snails pace it has in
relation to aerial density.  Peak interface sustained data rate today is
about 200MB/s for the fastest rusty drives.  If we are lucky the 10PB
drives of the future will have a sustained interface rate of 20GB/s, or
100x today's fastest, which will allow for a mirroring operation to
complete in about 14 hours, which is still slower than with today's 4TB
drives, which take about 8 hours.

Note that a 20GB/s one way data rate of such a 10PB drive would saturate
a 16 lane PCI Express v3.0 slot (15GB/s), and eat 2/3rds of a v4.0 x16
slot's bandwidth (31GB/s, but won't ship until ~2016).  And since
current PCIe controller to processor interconnects are limited to about
12-20GB/s one way, PCIe b/w doesn't matter.  Thus, the throughput of our
our peripheral and system level interconnects much increase many fold as
well to facilitate the hardware that would enable an EB sized XFS.

And as Ric mentioned, the memory capacity requirements for executing
xfs_repair on a 9EB XFS would likely require a host machine with many
hundreds of times the memory capacity of system available today.  That
and/or a rewrite of xfs_repair to make more efficient use of RAM.

So in summary, an Exabyte scale XFS is simply not practical today, and
won't be for at least another couple of decades, or more, if ever.  The
same holds true for some of the other filesystems you're going to be
writing about.  Some of the cluster and/or distributed filesystems
you're looking at could probably scale to Exabytes today.  That is, if
someone had the budget for half a million hard drives, host systems,
switches, etc, the facilities to house it all, and the budget for power
and cooling.  That's 834 racks for drives alone, just under 1/3rd of a
mile long if installed in a single row.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
