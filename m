Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 495AD7F52
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 15:31:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B7024AC03C
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 13:31:40 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id rvhBj4OumqZpuHgC
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 13:31:39 -0700 (PDT)
Message-ID: <52716CAC.5040607@hardwarefreak.com>
Date: Wed, 30 Oct 2013 15:31:40 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: agsize and performance
References: <CALtWs4-q==CXVZ=jjRnrZGANP98y2Gyot_DV_hGTgxQoRF25UA@mail.gmail.com>	<20131030095903.GA8077@citd.de>
	<CALtWs494cAew-SxMZqZecA+RHSOpAxhQpps-o6Cbe5Qj1GybFw@mail.gmail.com>
In-Reply-To: <CALtWs494cAew-SxMZqZecA+RHSOpAxhQpps-o6Cbe5Qj1GybFw@mail.gmail.com>
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
To: K T <mailkarthikt@gmail.com>, Matthias Schniedermeyer <ms@citd.de>
Cc: xfs@oss.sgi.com

On 10/30/2013 9:46 AM, K T wrote:
> I meant sync not fsync(O_SYNC flag).
> 
> My main question is why there is better throughput when I make the agsize
> smaller?

The transfer rate of a spinning rust drive is greatest on the outer
cylinders and least on the inner cylinders.

A default mkfs.xfs with 4 AGs causes the first directory created to be
placed in AG0 on the outer cylinders.  The 4th dir will be placed in AG3
on the inner cylinders.  Thus writing to the 4th directory will be
significantly slower, 4x or more, than to the 1st directory.

With 3726 allocation groups, the first few hundred directories you
create will be on the outer cylinders of the drive and writes to these
will be about the same speed, and much greater than to AG3 in the
default case.

You omitted data showing which AGs your tests were writing to in each
case, as best I could tell.  But given the above, it's most likely that
this is the cause of the behavior you are seeing.



> On Wed, Oct 30, 2013 at 5:59 AM, Matthias Schniedermeyer <ms@citd.de> wrote:
> 
>> On 29.10.2013 18:10, K T wrote:
>>> Hi,
>>>
>>> I have a 1 TB SATA disk(WD1003FBYX) with XFS. In my tests, I preallocate
>> a
>>> bunch of 10GB files and write data to the files one at a time. I have
>>> observed that the default mkfs setting(4 AGs) gives very low throughput.
>>> When I reformat the disk with a agsize of 256mb(agcount=3726), I see
>> better
>>> throughput. I thought with a bigger agsize, the files will be made of
>> fewer
>>> extents and hence perform better(due to lesser entries in the extent map
>>> getting updated). But, according to my tests, the opposite seems to be
>>> true. Can you please explain why this the case? Am I missing something?
>>>
>>> My test parameters:
>>>
>>> mkfs.xfs -f /dev/sdbf1
>>> mount  -o inode64 /dev/sdbf1 /mnt/test
>>> fallocate -l 10G fname
>>> dd if=/dev/zero of=fname bs=2M count=64 oflag=direct,sync conv=notrunc
>> seek=0
>>
>> I get the same bad performance with your dd statement.
>>
>> fallocate -l 10G fname
>> time dd if=/dev/zero of=fname bs=2M count=64 oflag=direct,sync
>> conv=notrunc seek=0
>> 64+0 records in
>> 64+0 records out
>> 134217728 bytes (134 MB) copied, 4,24088 s, 31,6 MB/s
>>
>> After pondering the really hard to read dd-man-page.
>> Sync is for 'synchronized' I/O. aka REALLY BAD PERFORMANCE. And i assume
>> you don't really that.
>>
>> I think what you meant is fsync. (a.k.a. File (and Metadata) has hit
>> stable-storage before dd exits).
>> That is: conv=fsync
>>
>> So:
>> time dd if=/dev/zero of=fname bs=2M count=64 oflag=direct
>> conv=notrunc,fsync seek=0
>> 64+0 records in
>> 64+0 records out
>> 134217728 bytes (134 MB) copied, 1,44088 s, 93,2 MB/s
>>
>> That gets much better performance, and in my case it can't get any
>> better because the HDD (and encryption) just can't go any faster.
>>
>>
>>
>>
>> --
>>
>> Matthias
>>
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
