Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 27A037F75
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 03:21:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AF910AC003
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 01:21:51 -0700 (PDT)
Received: from morework.geizhals.at (morework.geizhals.at [78.142.138.3]) by
	cuda.sgi.com with ESMTP id TXilJxo6V7ZnOiSM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 01:21:48 -0700 (PDT)
Message-ID: <534E3D98.3000600@geizhals.at>
Date: Wed, 16 Apr 2014 10:21:44 +0200
From: Johannes Truschnigg <johannes.truschnigg@geizhals.at>
MIME-Version: 1.0
Subject: Re: Seeking XFS tuning advice for PostgreSQL on SATA SSDs/Linux-md
References: <534D24AB.1050605@geizhals.at> <20140415213408.GL15995@dastard>
In-Reply-To: <20140415213408.GL15995@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,

On 04/15/2014 11:34 PM, Dave Chinner wrote:
> On Tue, Apr 15, 2014 at 02:23:07PM +0200, Johannes Truschnigg wrote:
>> Hi list,
>> [...]
>> o Intel C606-based Dual 4-Port SATA/SAS HBA (PCIID 8086:1d68)
>
> How much write cache does this have?

It's a plain HBA; it doesn't have write cache (or a BBU) of its own.


>> o 6x Samsung 830 SSD with 512GB each, 25% reserved for HPA
>
> 830? That's the previous generation of drives - do you mean 840?

No, I really mean 830 - we've tested 840 EVO as well, and they performed =

quite well, too, however from what I've seen on the web the longevity of =

Samsung's TLC flash choice in 840 disks isn't as promising as those of =

the 830s MLC variant. We might be switching over to 840 EVO or one of =

their successors once the 830s wear out, or we need to expand capacity, =

but we do have a number of 830s in stock that we'll use first.


>> When benchmarking the individual SSDs with fio (using the libaio
>> backend), the IOPS we've seen were in the 30k-35k range overall for
>> 4K block sizes.
>
> They don't sustain that performance over 20+ minutes of constant IO,
> though. Even if you have 840s (I have 840 EVOs in my test rig), the
> sustained performance of 4k random write IOPS is somewhere around
> 4-6k each. See, for example, the performance consistency graphs here:
>
> http://www.anandtech.com/show/7173/samsung-ssd-840-evo-review-120gb-250gb=
-500gb-750gb-1tb-models-tested/6
>
> Especially the last one that shows a zoomed view of the steady state
> behaviour between 1400s and 2000s of constant load.

I used tkperf[0] to benchmark the devices, both on Intel's SAS HBA and =

on a LSI 2108 SAS RAID-Controller. I did runs for the 512GB 830 with 25% =

over-provisioning, and runs for 1TB 840 EVO with 0% op and 25% op (two =

different disks with the same firmware). tkperf tries hard to achieve =

steady state by torturing the devices for a few hours before the actual =

benchmarking takes place, and will only do so after that steady state =

has been reached.

 From what I've seen, the over-provisioning is absolutely crucial to get =

anywhere near acceptable performance; since Anandtech doesn't seem to =

use it, I'll trust my tests more.

For reference: the 750GB usable-space EVO clocked in at ~35k 4k IOPS on =

the LSI 2108, whilst the 1000GB usable-space sister disk still hasn't =

finished the benchmark run, because it's _so much slower_. The benchmark =

was started about ten days ago for both disks; the 750GB disk finished =

after some 2 or 3 days, and I'm _still_ waiting for the 1000GB disk to =

finish benchmarking. Only then I'll be able to look at the pretty graphs =

and tables tkperf generates, but when tailing the log and watching =

iostat, I can already draw some early conclusions as to how these two =

configurations perform, and they're not in the same ballpark at all.


> The 830 series are old enough that they were reviewed before this
> was considered an important metric for SSD comparison, and so there
> is no equivalent information available for them. However, they are
> likely to be significantly slower and less deterministic in their
> behaviour than the 840s under the same load...

Afaik, 840 EVO's relatively high peak performance stems from the DRAM =

buffer these disks supposedly have built in, while the 830 lacks that =

kind of trick. Given that the EVO's performance drops after that buffer =

has worked its magic, I'd actually expect the 830 to perform _more =

consistent_ (not necessarily better, even on average, though) than the =

840 EVO. We'll see if that holds true if/when we put 840 EVOs into =

service, I guess.


>> The host will be on the receiving end of a pg9.0
>> streaming replication cluster setup where the master handles ~50k
>> IOPS peak, and I'm thinking what'd be a good approach to design the
>> local storage stack (with availability in mind) in a way that has a
>> chance to keep up with our flash-based FC SAN.
>
> I'd be surprised if it can keep up after a couple of months of
> production level IO going to the SSDs...

Yeah, that remains to be seen, and it'll be very interesting - if =

anyone's interested, I'll be happy to share our learnings from this =

project once we have enough data worth talking about. Remember, the =

numbers I posted are _peak_ load at the master though, most of the time, =

we don't exceed 10k IOPS, and some of the time, the system is =

practically idle. That might give the SSD controllers enough time to =

work their garbage collection secret sauce magic, and sustain high(er) =

performance over most of their lifetimes.


>> After digging through linux-raid archives, I think the most sensible
>> approach are two-disk pairs in RAID1 that are concatenated via
>> either LVM2 or md (leaning towards the latter, since I'd expect that
>> to have a tad less overhead),
>
> I'd stripe them (i.e. RAID10), not concantenate them so as to load
> both RAID1 legs evenly.

Afaik, the problem with md is that each array (I'm pretty convinced that =

also holds true for RAID10, but I'm not 100% sure) only has one =

associated kernel thread for writes, which should make that kind of =

setup worse, at least in theory and in terms of achiveable parallelism, =

than the setup I described. I'd be very happy to see a comparison =

between the two setups for high-IOPS devices, but I haven't yet found =

one anywhere.


 > [...]
>> I've experimented with mkfs.xfs (on top of LVM only; I don't know if
>> it takes into account lower block layers and seen that it supposedly
>> chooses to default to an agcount of 4, which seems insufficient
>> given the max. bandwidth our setup should be able to provide.
>
> The number of AGs has no bearing on acheivable bandwidth. The number
> of AGs affects allocation concurrency. Hence if you have 24 CPU
> cores, I'd expect that you want 32 AGs. Normally with a RAID array
> this will be the default, but it seems that RAID1 is not triggering
> the "optimise for allocation concurrency" heuristics in mkfs....

Thanks, that is a very useful heads-up! What's the formula used to get =

to 32 AGs for 24 CPUs - just (num_cpus * 4/3), and is there a simple =

explanation for why this is an ideal starting point? And is that an =

advisable rule of thumb for xfs in general?


>> Apart from that, is there any kind of advice you can share for
>> tuning xfs to run postgres (9.0 initially, but we're planning to
>> upgrade to 9.3 or later eventually) on in 2014, especially
>> performance-wise?
>
> Apart from the AG count and perhaps tuning the sunit/swidth to match
> the RAID0 part of the equation, I wouldn't touch a thing unless you
> know that there's a problem that needs fixing and you know exactly
> what knob will fix the problem you have...

OK, I'll read up on stripe width impact and will (hopefully) have enough =

time to test a number of configs that should make sense.

Many thanks for your contribution and advice! :)

[0]: http://www.thomas-krenn.com/en/oss/tkperf.html

-- =

Mit freundlichen Gr=FC=DFen
Johannes Truschnigg
Senior System Administrator
--
mailto:johannes.truschnigg@geizhals.at (in dringenden F=E4llen bitte an =

info@geizhals.at)

Geizhals(R) - Preisvergleich Internet Services AG
Obere Donaustrasse 63/2
A-1020 Wien
Tel: +43 1 5811609/87
Fax: +43 1 5811609/55
http://geizhals.at =3D> Preisvergleich f=FCr =D6sterreich
http://geizhals.de =3D> Preisvergleich f=FCr Deutschland
http://geizhals.eu =3D> Preisvergleich EU-weit
Handelsgericht Wien | FN 197241K | Firmensitz Wien

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
