Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q395DUAS034715 for <xfs@oss.sgi.com>; Mon, 9 Apr 2012 00:13:30 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id XXgcpiSz86BNSJDQ
	for <xfs@oss.sgi.com>; Sun, 08 Apr 2012 22:13:29 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 6C1226C0F7
	for <xfs@oss.sgi.com>; Mon,  9 Apr 2012 00:13:29 -0500 (CDT)
Message-ID: <4F826FFA.4050207@hardwarefreak.com>
Date: Mon, 09 Apr 2012 00:13:30 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20350.9643.379841.771496@tree.ty.sabi.co.UK>
	<20350.13616.901974.523140@tree.ty.sabi.co.UK>
	<CAAxjCEzkemiYin4KYZX62Ei6QLUFbgZESdwS8krBy0dSqOn6aA@mail.gmail.com>
	<20352.28730.273834.568559@tree.ty.sabi.co.UK>
	<4F8074EC.2030108@gmail.com> <4F82063F.4070609@hardwarefreak.com>
In-Reply-To: <4F82063F.4070609@hardwarefreak.com>
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

On 4/8/2012 4:42 PM, Stan Hoeppner wrote:
> On 4/7/2012 12:10 PM, Joe Landman wrote:
>> On 04/07/2012 12:50 PM, Peter Grandi wrote:
>>
>>>    * Your storage layer does not seem to deliver parallel
>>>      operations: as the ~100MB/s overall 'ext4' speed and the
>>>      seek graphs show, in effect your 4+2 RAID6 performs in this
>>>      case as if it were a single drive with a single arm.
>>
>> This is what lept out at me.  I retried a very similar test (pulled
>> Icedtea 2.1, compiled it, tarred it, measured untar on our boxen).  I
>> was getting a fairly consistent 4 +/- delta seconds.
> 
> That's an interesting point.  I guess I'd chalked the low throughput up
> to high seeks.
> 
>> 100MB/s on some supposedly fast drives with a RAID card indicates that
>> either the RAID is badly implemented, the RAID layout is suspect, or
>> similar.  He should be getting closer to N(data disks) * BW(single disk)
>> for something "close" to a streaming operation.
> 
> Reading this thread seems to indicate you're onto something Joe:
> http://h30499.www3.hp.com/t5/System-Administration/Extremely-slow-io-on-cciss-raid6/td-p/4214888

The P400 uses the LSISAS1078 chip, PowerPC 500MHz core, "2 hardware
RAID5/6 processors".  Some sequential benchmarks under Windows with
8x750GB SATA drives on an LSI 1078 based card show sequential RAID6
write rates of ~100MB/s.  RAID0 write rate of this card for 8 drives is
350MB/s.  These drives are capable of 50MB/s sustained writes, so the
RAID0 performance isn't far off the hardware max.

It seems the 1078 is simply not that quick with anything but pure
striping.  Hardware RAID10 write performance appears only about 50%
faster than RAID6.  The RAID6 speed is roughly 1/3rd of the RAID0 speed.
 So exporting the individual drives as I previously mentioned and using
mdraid6 should yield at least  a 3x improvement, assuming your CPUs
aren't already loaded down.

Or, as others have mentioned, simply install an MLC SSD and get 10-100x
more random throughput with XFS if you match the agcount to the number
of flash chips in the SSD.  XFS parallelism flexing its muscles once
again.  EXT4 won't improve as much as it will tend to write the flash
chips sequentially.  Newegg currently has two Mushkin 120GB models for
$120 each, both with 4/5 eggs.

http://www.newegg.com/Product/ProductList.aspx?Submit=ENE&N=100008120+600038484+50001504&QksAutoSuggestion=&ShowDeactivatedMark=False&Configurator=&IsNodeId=1&Subcategory=636&description=&hisInDesc=&Ntk=&CFG=&SpeTabStoreType=&AdvancedSearch=1&srchInDesc=

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
