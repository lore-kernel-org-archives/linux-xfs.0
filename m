Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CB6897F7C
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 13:51:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AB18C8F8039
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 11:51:19 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id s3fED49BcAMDIzXC
	for <xfs@oss.sgi.com>; Mon, 09 Dec 2013 11:51:18 -0800 (PST)
Message-ID: <52A61F3A.7040504@hardwarefreak.com>
Date: Mon, 09 Dec 2013 13:51:22 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Sudden File System Corruption
References: <52A03513.6030408@hardwarefreak.com>	<CAPd9ww9hsOFK6pxqRY-YtLLAkkJHCuSi1BaM4n9=2XTjNVAn2Q@mail.gmail.com>	<CAPd9ww9QzFWUnLtzkdktd+fSX9pdft+wL6cvG2MzLpSdLko1dg@mail.gmail.com>	<52A191BA.20800@hardwarefreak.com>	<CAPd9ww8+W2VX2HAfxEkVN5mL1a_+=HDAStf1126WSE33Vb=VsQ@mail.gmail.com>	<52A302A9.9050509@hardwarefreak.com>	<CAPd9ww8ovd1rOCQdjUF=U_ji2SOjyBCG-eFjeWSPXr8L5Zg9-A@mail.gmail.com>	<52A401FF.9050506@hardwarefreak.com>	<20131208160339.5c45ab91@galadriel.home>	<52A5159F.2060309@hardwarefreak.com>
	<20131209014002.GP31386@dastard>
In-Reply-To: <20131209014002.GP31386@dastard>
Reply-To: stan@hardwarefreak.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: Mike Dacre <mike.dacre@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 12/8/2013 7:40 PM, Dave Chinner wrote:
> On Sun, Dec 08, 2013 at 06:58:07PM -0600, Stan Hoeppner wrote:
>> On 12/8/2013 9:03 AM, Emmanuel Florac wrote:
>>> Le Sat, 07 Dec 2013 23:22:07 -0600 vous =E9criviez:
>>>
>>>>> Thanks for the great advice, I think you are on to something
>>>>> there.  I will  =

>>>>
>>>> You're welcome.  Full disclosure:  I should have mentioned that I
>>>> haven't used CacheCade yet myself.  My statements WRT performance are
>>>> based on available literature and understanding of the technology.
>>>
>>> I didn't test thoroughly cachecade though I have a license code
>>> somewhere, however I've used the equivalent Adaptec feature and one SSD
>>> roughly double the IOPS of a RAID-6 array of 15k RPM SAS drives from
>>> about 4200 IOPS to 7500 IOPS.
>>
>> Emmanuel do you recall which SSD you used here?  7500 IOPS is very low
>> by today's standards.  What I'm wondering is if you had an older low
>> IOPS SSD, or, a modern high IOPS rated SSD that performed way below its
>> specs in this application.
> =

> It's most likely limited by the RAID firmware implementation, not
> the SSD.

In Emmanuel's case I'd guess the the X25 32GB is applying a little more
pressure to the brake calipers than his RAID card.  The 32GB X25 is
rated at 33K read IOPS but an abysmal 3.3K write IOPS.  So his 15K SAS
rust is actually capable of more write IOPS, at 4.2K.

http://ark.intel.com/products/56595/

His Adaptec 51645 has a 1.2GHz dual core PPC RAID ASIC and is rated at
250K IOPS.  This figure probably includes some wishful thinking on
Adaptec's part, but clearly the RAID ASIC is much faster than the Intel
X25 SSD, which is universally known to be a very very low performer.

>> The Samsung 840 Pro I recommended is rated at 90K 4K write IOPS and
>> actually hits that mark in IOmeter testing at a queue depth of 7 and
>> greater:
>> http://www.tomshardware.com/reviews/840-pro-ssd-toggle-mode-2,3302-3.html
> =

> Most RAID controllers can't saturate the IOPS capability of a single
> modern SSD - the LSI 2208 in my largest test box can't sustain much
> more than 30k write IOPS with the 1GB FBWC set to writeback mode,
> even though the writes are spread across 4 SSDs that can do about
> 200k IOPS between them.

2208 card w/4 SSDs and only 30K IOPS?  And you've confirmed these SSDs
do individually have 50K IOPS?  Four such SSDs should be much higher
than 30K with FastPath.  Do you have FastPath enabled?  If not it's now
a freebie with firmware 5.7 or later.  Used to be a pay option.  If
you're using an LSI RAID card w/SSDs you're spinning in the mud without
FastPath.

>> Its processor is a 3 core ARM Cortex R4 so it should excel in this RAID
>> cache application, which will likely have gobs of concurrency, and thus
>> a high queue depth.
> =

> That is probably 2x more powerful as the RAID controller's CPU...

3x 300MHz ARM cores at 0.5W vs 1x 800MHz PPC core at ~10W?  The PPC core
has significantly more transistors, larger caches, higher IPC.  I'd say
this Sammy chip has a little less hardware performance than a singe LSI
core, but not much less.  Two of them would definitely have higher
throughput than one LSI core.

>> Found a review of CacheCade 2.0.  Their testing shows near actual SSD
>> throughput.  The Micron P300 has 44K/16K read/write IOPS and their
>> testing hits 30K.  So you should be able to hit close to ~90K read/write
>> IOPS with the Samsung 840s.
>>
>> http://www.storagereview.com/lsi_megaraid_cachecade_pro_20_review
> =

> Like all benchmarks, take them with a grain of salt. There's nothing
> there about the machine that it was actually tested on, and the data
> sets used for most of the tests were a small fraction of the size of
> the SSD (i.e. all the storagemark tests used a dataset smaller than
> 10GB, and the rest were sequential IO).

The value in these isn't in the absolute numbers, but the relative
before/after difference with CacheCade enabled.

> IOW, it was testing SSD resident performance only, not the
> performance you'd see when the cache is full and having to page
> random data in and out of the SSD cache to/from spinning disks.

The CacheCade algorithm seems to be a bit smarter than that, and one has
some configuration flexibility.  If one has a 128 GB SSD and splits it
50/50 between read/write cache, that leaves 64 GB write cache.  The
algorithm isn't going to send large streaming writes to SSD when the
rust array is capable of greater throughput.

So the 64 GB write cache will be pretty much dedicated to small random
write IOs and some small streaming writes where the DRAM cache can't
flush to rust fast enough.  Coincidentally, fast random write IO is
where SSD cache makes the most difference, same as DRAM cache, by
decreasing real time seek rate of the rust.  I'm guessing most workloads
aren't going to do enough random write IOPS to fill 64 GB, and then
cause cache thrashing while the SSD tries to flush to the rust.

The DRAM cache on LSI controllers, in default firmware mode, buffers
every write and then flushes it disk, often with optimized ordering.  In
CacheCode mode only some writes are buffered to the SSD, and these
bypass the DRAM cache completely via FastPath.  The logic is load adaptive.

So an obvious, and huge, advantage to this is that one can have a mixed
workload with say a 1GB/s streaming write going through DRAM cache to
the rust, with a concurrent 20K IOPS random write workload going
directly to SSD cache.  Neither workload negatively impacts the other.
With a pure rust array the IOPS workload seeks the disks to death and
the streaming write crawls at a few MB/s.

The workload that Mike originally described is similar to the above, and
thus a perfect fit for CacheCade + FastPath.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
