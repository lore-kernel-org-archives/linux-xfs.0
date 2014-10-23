Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 212BD7F60
	for <xfs@OSS.SGI.com>; Thu, 23 Oct 2014 18:01:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 10377304051
	for <xfs@OSS.SGI.com>; Thu, 23 Oct 2014 16:01:28 -0700 (PDT)
Received: from honeysuckle.london.02.net (honeysuckle.london.02.net
	[87.194.255.144]) by cuda.sgi.com with ESMTP id
	qa2WUDYzvMjuTojD for <xfs@OSS.SGI.com>;
	Thu, 23 Oct 2014 16:01:26 -0700 (PDT)
Received: from ty.sabi.co.UK (94.192.123.208) by honeysuckle.london.02.net
	(8.5.140)
	id 53BD70B603AFBD3A for xfs@OSS.SGI.com; Fri, 24 Oct 2014 00:26:44 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.76 #1) id 1XhOhg-0000mR-6X
	for <xfs@OSS.SGI.com>; Thu, 23 Oct 2014 21:09:48 +0100
MIME-Version: 1.0
Message-ID: <21577.24715.712978.617220@tree.ty.sabi.co.uk>
Date: Thu, 23 Oct 2014 21:09:47 +0100
Subject: Re: Problem about very high Average Read/Write Request Time
In-Reply-To: <54492AD5.3040704@fastmail.fm>
References: <CALSoAzD4ccHXBuD6mT3ggqMf1j_kDEK-RNMOeRLq+N+NiWVQXg@mail.gmail.com>
	<20141018143848.3baf3266@galadriel.home>
	<21571.36364.518119.806191@tree.ty.sabi.co.uk>
	<5444C122.4080104@fastmail.fm>
	<21574.42382.795064.152229@tree.ty.sabi.co.uk>
	<54492AD5.3040704@fastmail.fm>
From: pg@xfs.list.sabi.co.UK (Peter Grandi)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Linux fs XFS <xfs@OSS.SGI.com>

[ ... ]

>>>>> There is a ratio of 31 (thirty one) between 'swidth' and
>>>>> 'sunit' and assuming that this reflects the geometry of the
>>>>> RAID5 set and given commonly available disk sizes it can be
>>>>> guessed that with amazing "bravery" someone has configured a
>>>>> RAID5 out of 32 (thirty two) high capacity/low IOPS 3TB
>>>>> drives, or something similar.
[ ... ]
>>>>> if the device name "/data/fhgfs/fhgfs_storage" is
>>>>> dedscriptive, this "brave" RAID5 set is supposed to hold the
>>>>> object storage layer of a BeeFS highly parallel filesystem,
>>>>> and therefore will likely have mostly-random accesses.
[ ... ]
>>>>> It is notable but not surprising that XFS works well even
>>>>> with such a "brave" choice of block storage layer, untainted
>>>>> by any "cowardly" consideration of the effects of RMW and
>>>>> using drives designed for capacity rather than IOPS.

>>>> Also if this testing was appropriate then it was because the
>>>> intended workload was indeed concurrent reads and writes to
>>>> the object store.

>>> Where do you get the assumption from that FhGFS/BeeGFS is
>>> going to do random reads/writes or the application of top of
>>> it is going to do that?

>> In this specific case it is not an assumption, thanks to the
>> prominent fact that the original poster was testing (locally I
>> guess) and complaining about concurrent read/writes, which
>> result in random like arm movement even if each of the read and
>> write streams are entirely sequential.

[ ... ]

> Low speed and high latencies are not sufficient information to
> speculate about the cause.

It is pleasing that you seem to know at least that by themselves
=ABLow speed and high latencies=BB are indeed not sufficient.

But in =ABthe specific case=BB what is sufficient to make a good guess
is what I wrote, which you seem to have been unable to notice or
understand.

>> BTW the 100MB/s aggregate over 31 drives means around 3MB/s
>> per drive, which seems pretty good for a RW workload with
>> mostly-random accesses with high RMW correlation.

> The op did not provide sufficient information about the IO
> pattern to know if there is RMW or random access involved.

The op of =ABthe specific case=BB reported that the XFS filesystem is
configured for a 32-wide RAID5 set and that:

 > when doing only reading / only writing , the speed is very
 > fast(~1.5G), but when do both the speed is very slow

and perhaps your did not notice that; or did not notice or
understand that I wrote subsequently, as you seemed to be
requesting a detailed explanation of my conclusion, that:

>> [ ... ] concurrent read/writes, which result in random like
>> arm movement even if each of the read and write streams are
>> entirely sequential. [ ... ]

Because then there are at least two hotspots, the read one and the
write one, except in the very special case that an application is
reading and writing the same block each time.

Even worse, since in =ABthe specific case=BB we have an "imaginative"
32-wide RAID5 unless the writes are exactly aligned with the large
stripes there is going to be a lot of RMW resulting in the arms
going back and forth (and even if aligned many RAID implementation
still end up doing a fair bit of RMW).

Knowing that and that it is a 32-wide RAID5 and the disks are 3TB
in size (low IOPS per GB) and that the result is poor for single
threaded but reasonable for double threaded, and that XFS in
general behaves pretty well should be sufficient to give a
reasonable guess:

 >>>>> This issue should be moved to the 'linux-raid' mailing list
 >>>>> as from the reported information it has nothing to do with
 >>>>> XFS.

But I am just repeating what you seem to have been unable to read
or understand...

PS: as to people following this discussions, there can be many
reasons why that 31-wide RAID5, which is such a very "brave"
setup, is behaving like that on randomish access patterns arising
from concurrent read-write, such as initial sync still going on,
not so good default settings or scheduling of so many hw (as
suggested by the 'sdc' instead of 'md$N') RAID HAs, etc., and some
of these interact with how XFS operates, but it is indeed a
discussion for the Linux RAID list at least first.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
