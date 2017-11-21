Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56598 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750772AbdKUO2E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Nov 2017 09:28:04 -0500
Subject: Re: [PATCH] xfs_io: implement ranged fiemap query
References: <c1bec5de-57de-a451-08b9-80376b635d28@redhat.com>
 <20171121052531.GH2749@eguan.usersys.redhat.com>
 <b7ca2898-12b5-c03b-dab7-38807370433c@suse.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <a49d4579-a841-b57a-afe7-58148f6e2ed0@redhat.com>
Date: Tue, 21 Nov 2017 08:27:52 -0600
MIME-Version: 1.0
In-Reply-To: <b7ca2898-12b5-c03b-dab7-38807370433c@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>, Eryu Guan <eguan@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 11/21/17 8:18 AM, Nikolay Borisov wrote:
> 
> 
> On 21.11.2017 07:25, Eryu Guan wrote:
>> On Fri, Nov 17, 2017 at 11:22:07AM -0600, Eric Sandeen wrote:
>>> From: Nikolay Borisov <nborisov@suse.com>
>>>
>>> Currently the fiemap implementation of xfs_io doesn't support making ranged
>>> queries. This patch implements two optional arguments which take the starting
>>> offset and the length of the region to be queried.
>>>
>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>> [sandeen: simplify/rewrite ranged logic]
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>>
>>> ---
>>>
>>> I think this is a simpler approach.  There are some questions about how
>>> the fiemap command should handle holes and ranges, however.
>>>
>>> First and foremost, the kernel will return any extent(s) which overlap(s)
>>> with the requested range.  Holes are simply inferred by xfs_io from the
>>
>> So it's expected that data range won't be truncated on boundaries? e.g.
>>
>> # xfs_io -fc "pwrite 4k 4k" -c "pwrite 12k 4k" -c fsync -c "fiemap" -c "fiemap 6k 2k" testfile
>> wrote 4096/4096 bytes at offset 4096
>> 4 KiB, 1 ops; 0.0000 sec (300.481 MiB/sec and 76923.0769 ops/sec)
>> wrote 4096/4096 bytes at offset 12288
>> 4 KiB, 1 ops; 0.0000 sec (781.250 MiB/sec and 200000.0000 ops/sec)
>> testfile:
>>         0: [0..7]: hole
>>         1: [8..15]: 1300882584..1300882591
>>         2: [16..23]: hole
>>         3: [24..31]: 1300882592..1300882599
>> testfile:
>>         0: [8..15]: 1300882584..1300882591  <=== not truncated on range boundaries
>> xfs_io: ioctl(FS_IOC_FIEMAP) ["testfile"]: Invalid argument
> 
> Fixed the invalid argument, however I have another question, you are
> right that the output is no truncated on range boundaries for extents,
> however for holes it is:
> 

Ok this starts to get a little philosophical.  The kernel will return
the entire extent that intersects with the requested range, as far as I can
tell.  And the kernel doesn't return holes at all.

So we have to decide how we actually wish to report the information
which has been provided by the kernel, and what is most useful to the
user (and what is most useful for testing the kernel interface).

My approach was to print the entire extent returned by the kernel.  If the
range had a hole on either side - i.e. the returned extent(s) did not start
or stop on the requested boundary, I printed that hole, but truncated it to
the requested range, for one main reason: We don't know where those holes
start and stop, because we did not request any information beyond their
range.

> xfs_io -fc "pwrite 4k 4k" -c "pwrite 12k 4k" -c "fsync" -c "fiemap" -c
> "fiemap 6k 4k" testfile
> wrote 4096/4096 bytes at offset 4096
> 4 KiB, 1 ops; 0.0000 sec (186,012 MiB/sec and 47619,0476 ops/sec)
> wrote 4096/4096 bytes at offset 12288
> 4 KiB, 1 ops; 0.0000 sec (1,272 GiB/sec and 333333,3333 ops/sec)
> testfile:
> 	0: [0..7]: hole
> 	1: [8..15]: 87260408..87260415
> 	2: [16..23]: hole
> 	3: [24..31]: 87260416..87260423
> testfile:
> 	0: [8..15]: 87260408..87260415
> 	1: [16..19]: hole <===== truncated on range boundaries
> 
> This discrepancy currently doesn't break any tests and I think it's
> rather minor but I'd like people's opinion on whether it's ok. Actually
> fixing it might be a bit cumbersome since this would mean we need to do
> another fiemap query to get the next extent and I doubt it it's worth it.

*nod*
 
> 
> Btw with this patch it's not even necessary to change the existing
> xfstest punchole tests i.e. the output fixup and the change in the
> output files. So this patch is definitely better.

Yeah, I think it's best to not change longstanding behavior.
 
> 
> 
>>
>> And the "Invalid argument" looks suspicious too. Note that I applied
>> this patch on top of latest for-next branch.
>>
>> Another very minor issue on the extent sequence number:
>>
>> # xfs_io -fc "pwrite 4k 4k" -c "pwrite 12k 4k" -c fsync -c "fiemap" -c "fiemap 4k 8k" testfile
>> wrote 4096/4096 bytes at offset 4096
>> 4 KiB, 1 ops; 0.0000 sec (325.521 MiB/sec and 83333.3333 ops/sec)
>> wrote 4096/4096 bytes at offset 12288
>> 4 KiB, 1 ops; 0.0000 sec (781.250 MiB/sec and 200000.0000 ops/sec)
>> testfile:
>>         0: [0..7]: hole
>>         1: [8..15]: 1300882584..1300882591
>>         2: [16..23]: hole
>>         3: [24..31]: 1300882592..1300882599
>> testfile:
>>         0: [8..15]: 1300882584..1300882591
>>         2: [16..23]: hole>
>> Range "4k 8k" includes two extents, from the full-file fiemap result
>> the extents are continuous (extent 1 2), but the range results list the
>> extents as 0 and 2. It should be continuous too?
> 
> Fixed in next version.

Thanks :)

-Eric

