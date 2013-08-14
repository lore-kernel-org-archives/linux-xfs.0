Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E519F7F58
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 12:31:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 90679AC007
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 10:31:39 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id p3HzGQErHJwdHaoZ
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 10:31:38 -0700 (PDT)
Message-ID: <520BBEFB.9030002@hardwarefreak.com>
Date: Wed, 14 Aug 2013 12:31:39 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Failure growing xfs with linux 3.10.5
References: <52073905.8010608@allmail.net> <5207D9C4.7020102@sandeen.net>
	<52090C6C.6060604@allmail.net> <20130813000453.GQ12779@dastard>
	<520A5132.6090608@allmail.net> <520B1B4F.9070800@hardwarefreak.com>
	<520B9CCF.1040908@allmail.net>
In-Reply-To: <520B9CCF.1040908@allmail.net>
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
To: Michael Maier <m1278468@allmail.net>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 8/14/2013 10:05 AM, Michael Maier wrote:
> Stan Hoeppner schrieb:
>> On 8/13/2013 10:30 AM, Michael Maier wrote:
>>> Dave Chinner wrote:
>>>> [ re-ccing the list, because finding this is in everyone's interest ]
...
...
>>>> FWIW, how many times has this filesystem ben grown?
>>>
>>> I can't say for sure, about 4 or 5 times?
>>>
>>>> Did it start
>>>> with only 32 AGs (i.e. 10TB in size)?
>>>
>>>>>>> 10TB? No. The device just has 3 TB. You most probably meant 10GB?
>>> I'm not sure, but it definitely started with > 100GB.
>>
>> According to your xfs_info output that I highlighted above, and assuming
>> my math here is correct,
>>
>> (((7700480*4096)/1048576)*42)= 1,263,360 GB or ~1.23 TB
>>
>> this filesystem was 1.23 TB w/42 AGs before the grow operation.
>> Assuming defaults were used during mkfs.xfs it would appear the initial
>> size of this filesystem was ~120GB.  And it would appear it has been
>> grown to ~10x its original size, and from 4 AGs to 42 AGs.  That seems
>> like a lot of growth, to me.  And Dave states the latest grow operation
>> was to 45 AGs, which would yield a ~1.32TB filesystem, not 3TB.
> 
> He wrote about 10TB (=Terra(!) Byte). The entire HD only has 3 TB.
> 10TB is impossible!

I was referring to the 3TB you mention above.  I misunderstood that to
mean the size of the filesystem, but you did clearly state "device".
Sorry about the oversight there.

> The last growfs was about 100GB. The FS was grown lots of times
> since the initial creation one or two years ago.

Yes, this is the critical information Dave was looking for which relates
to xfs_growfs failing.

> About the sizes before the last grow and after it: see
> http://www.spinics.net/lists/xfs/msg21032.html

Unrelated to the grow bug, I'm wondering why you started so small and
are growing an XFS in such small chunks, a great number of times, over a
period of years, on a single 3TB disk, instead of making a 3TB XFS out
of the gate.

If you keep growing until you consume the disk, you'll have ~100
allocation groups.  Typically you'd want to have no more than 4 AGs per
spindle.  You already have 42 (or 45) which will tend to seek the disk
to death with many workloads, driving latency through the roof and
decreasing throughput substantially.  Do you notice any performance
problems yet?  Or is this XFS strictly being used as a WORM like backup
silo?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
