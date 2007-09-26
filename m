Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 09:27:55 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8QGRkHD016313
	for <linux-xfs@oss.sgi.com>; Wed, 26 Sep 2007 09:27:48 -0700
Date: Wed, 26 Sep 2007 12:27:46 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [UNSURE] Re: mkfs options for a 16x hw raid5 and xfs (mostly
 large files)
In-Reply-To: <20070926145417.GC30287@p15145560.pureserver.info>
Message-ID: <Pine.LNX.4.64.0709261227260.15219@p34.internal.lan>
References: <20070923093841.GH19983@p15145560.pureserver.info>
 <18166.25242.174049.175729@base.ty.sabi.co.UK> <20070926145417.GC30287@p15145560.pureserver.info>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ralf Gross <Ralf-Lists@ralfgross.de>
Cc: linux-xfs@oss.sgi.com



On Wed, 26 Sep 2007, Ralf Gross wrote:

> Peter Grandi schrieb:
>> Ralf> Hi, we have a new large raid array, the shelf has 48 disks,
>> Ralf> the max. amount of disks in a single raid 5 set is 16.
>>
>> Too bad about that petty limitation ;-).
>
> Yeah, I prefer 24x RAID 5 without spare. Why waste so much space ;)
>
> After talking to the people that own the data and wanted to use as
> much as possible space of the device, we'll start with four 12/11
> disk RAID 6 volumes (47 disk + 1 spare). That's ~12% less space than
> before with five RAID 5 volumes. I think this is a good compromise
> between safety and max.  usable disk space.
>
> There's only one point left: will the RAID 6 during a rebuild be able
> to deliver 2-3 streams of 17MB/s. Write performance is not the point
> then, but the clients will be running simulations for up to 5 days and
> need this (more or less) constant data rate. Now that I'm getting
> ~400 MB/s (which is limited by the FC controller) this should be
> possible.
>
>> Ralf> There will be one global spare disk, thus we have two raid 5
>> Ralf> with 15 data disks and one with 14 data disk.
>>
>> Ahhh a positive-thinking, can-do, brave design ;-).
>
> We have a 60 slot tape lib too (well, we'll have next week...I hope).
> I know that raid != backup.
>
>> [ ... ]
>> Ralf> Each client then needs a data stream of about 17 MB/s
>> Ralf> (max. 5 clients are expected to acces the data in parallel).
>>
>> Do the requirements include as features some (possibly several)
>> hours of ''challenging'' read performance if any disk fails or
>> total loss of data if another disks fails during that time? ;-)
>
> The data then is still on USB disks and on tape. Maybe I'll pull out
> a disk of one of the new RAID 6 volumes and see how much the read
> performance drops. At the moment only one test bed is active, thus 17
> MB/s would be ok. Later with 5 test beds 5 x 17 MB/s are needed (if
> they are online at the same time).
>
>> IIRC Google have reported 5% per year disk failure rates across a
>> very wide mostly uncorrelated population, you have 48 disks,
>> perhaps 2-3 disks per year will fail. Perhaps more and more often,
>> because they will likely be all from the same manufacturer, model,
>> batch and spinning in the same environment.
>
> Hey, these are ENTERPRISE disks ;) As far as I know, we couldn't even
> use other disks than the ones that the manufacturer provides (modified
> firmware?).
>
>> Ralf> [ ... ] I expect the fs, each will have a size of 10-11 TB,
>> Ralf> to be filled > 90%. I know this is not ideal, but we need
>> Ralf> every GB we can get.
>>
>> That "every GB we can get" is often the key in ''wide RAID5''
>> stories. Cheap as well as fast and safe, you can have it all with
>> wide RAID5 setups, so the salesmen would say ;-).
>
> I think we now have found a reasonable solution.
>
>> Ralf> [ ... ] Stripe Size : 960 KB (15 x 64 KM)
>> Ralf> [ ... ] Stripe Size : 896 KB (14 x 64 KB)
>>
>> Pretty long stripes, I wonder what happens when a whole stripe
>> cannot be written at once or it can but is not naturally aligned
>> ;-).
>
> I'm still confused bye the chunk/stripe and block size values. The
> block size of the HW-RAID is fixed to 512 bytes, I think that a bit
> small.
>
> Also, I first thought about wasting disk space with larger
> chunk/stripe sizes (HW RAID), but as the OS/FS doesn't necessarily
> know about the values, it can't be true - unlike the FS block size
> which defines the smallest possible file size.
>
>> Ralf> [ ... ] about 150 MB/s in seq. writing
>>
>> Surprise surprise ;-).
>>
>> Ralf> (tiobench) and 160 MB/s in seq.  reading.
>>
>> This is sort of low. If there something that RAID5 can do sort of
>> OK is reads (if there are no faults). I'd look at the underlying
>> storage system and the maximum performance that you can get out of
>> a single disk.
>
> /sbin/blockdev --setra 16384  /dev/sdc
>
> was the key to ~400 MB/s read performance.
>
>> I have seen a 45-drive 500GB storage subsystem where each drive
>> can deliver at most 7-10MB/s (even if the same disk standalone in
>> an ordinary PC can do 60-70MB/s), and the supplier actually claims
>> so in their published literature (that RAID product is meant to
>> compete *only* with tape backup subsystems). Your later comment
>> that "The raid array is connect to the server by fibre channel"
>> makes me suspect that it may be the same brand.
>>
>> Ralf> This is ok,
>>
>> As the total aggregate requirement is 5x17MB/s this is probably
>> the case [as long as there are no drive failures ;-)].
>>
>> Ralf> but I'm curious what I could get with tuned xfs parameters.
>>
>> Looking at the archives of this mailing list the topic ''good mkfs
>> parameters'' reappears frequently, even if usually for smaller
>> arrays, as many have yet to discover the benefits of 15-wide RAID5
>> setups ;-). Threads like these may help:
>>
>>   http://OSS.SGI.com/archives/xfs/2007-01/msg00079.html
>>   http://OSS.SGI.com/archives/xfs/2007-05/msg00051.html
>
> I've seen some of JP's postings before. I couldn't get much more
> performace with the sw/su options, I got the best results with the
> default values. But I haven't tried external logs yet.
>
> Ralf
>
>

  /sbin/blockdev --setra 16384  /dev/sdc

was the key to ~400 MB/s read performance.

Nice, what do you get for write speed?

Justin.
