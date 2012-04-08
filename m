Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q38LgOUM205841 for <xfs@oss.sgi.com>; Sun, 8 Apr 2012 16:42:25 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id aHpgu5OjkLCY01zV
	for <xfs@oss.sgi.com>; Sun, 08 Apr 2012 14:42:23 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id A1F9C6C0F7
	for <xfs@oss.sgi.com>; Sun,  8 Apr 2012 16:42:22 -0500 (CDT)
Message-ID: <4F82063F.4070609@hardwarefreak.com>
Date: Sun, 08 Apr 2012 16:42:23 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<20352.28730.273834.568559@tree.ty.sabi.co.UK>
	<4F8074EC.2030108@gmail.com>
In-Reply-To: <4F8074EC.2030108@gmail.com>
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
To: xfs@oss.sgi.com

On 4/7/2012 12:10 PM, Joe Landman wrote:
> On 04/07/2012 12:50 PM, Peter Grandi wrote:
> 
>>    * Your storage layer does not seem to deliver parallel
>>      operations: as the ~100MB/s overall 'ext4' speed and the
>>      seek graphs show, in effect your 4+2 RAID6 performs in this
>>      case as if it were a single drive with a single arm.
> 
> This is what lept out at me.  I retried a very similar test (pulled
> Icedtea 2.1, compiled it, tarred it, measured untar on our boxen).  I
> was getting a fairly consistent 4 +/- delta seconds.

That's an interesting point.  I guess I'd chalked the low throughput up
to high seeks.

> 100MB/s on some supposedly fast drives with a RAID card indicates that
> either the RAID is badly implemented, the RAID layout is suspect, or
> similar.  He should be getting closer to N(data disks) * BW(single disk)
> for something "close" to a streaming operation.

Reading this thread seems to indicate you're onto something Joe:
http://h30499.www3.hp.com/t5/System-Administration/Extremely-slow-io-on-cciss-raid6/td-p/4214888

Add this to the mix:
"The HP Smart Array P400 is HP's first PCI-Express (PCIe) serial
attached SCSI (SAS) RAID controller"

That's from:
http://h18000.www1.hp.com/products/servers/proliantstorage/arraycontrollers/smartarrayp400/index.html

First gen products aren't always duds, but the likelihood is often much
higher.  Everyone posting to that forum is getting low throughput, and
most of them are testing streaming reads/writes, not massively random IO
as is Stefan's case.

> This isn't suggesting that he didn't hit some bug which happens to over
> specify use of ag=0, but he definitely had a weak RAID system (at best).
> 
> If he retries with a more capable system, or one with a saner RAID
> layout (16k chunk size?  For spinning rust?  Seriously?  Short stroking
> DB layout?), an agcount of 32 or higher, and still sees similar issues,
> then I'd be more suspicious of a bug.

Or merely a weak/old product.  The P400 was an entry level RAID HBA,
HP's first PCIe/SAS RAID card.  It was discontinued quite some time ago.
 The use of DDR2/533 memory indicates it's design stage started probably
somewhere around 2004, 8 years ago.

Now that I've researched the P400, and assuming Stefan currently has the
card firmware optimally configured, I'd bet this workload is simply
overwhelming the RAID ASIC.  To confirm this, simply configure each
drive as a RAID0 array, so all 6 drives are exported as block devices.
Configure them as an md RAID6 and test the workload.  Be sure to change
the Linux elevator to noop first since you're using hardware write cache:

$ echo deadline > /sys/block/sd[a-e]/queue/scheduler

Execute this 6 times, once for each of the 6 drives, changing the device
name each time, obviously.  This is not a persistent change.

The gap between EXT4 and XFS will likely still exist, but overall
numbers should jump substantially Northward, if the problem is indeed a
slow RAID ASIC.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
