Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p52LOiq1223195 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 16:24:44 -0500
Received: from mail-ew0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED588499227
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 14:24:39 -0700 (PDT)
Received: from mail-ew0-f53.google.com (mail-ew0-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id qC58SSEOu2E3SR3v
	for <xfs@oss.sgi.com>; Thu, 02 Jun 2011 14:24:39 -0700 (PDT)
Received: by ewy8 with SMTP id 8so548989ewy.26
	for <xfs@oss.sgi.com>; Thu, 02 Jun 2011 14:24:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19943.56524.969126.59978@tree.ty.sabi.co.UK>
References: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>
	<19943.56524.969126.59978@tree.ty.sabi.co.UK>
Date: Thu, 2 Jun 2011 17:24:39 -0400
Message-ID: <BANLkTim978GhfamN=TEFULP5GdfMu02-7w@mail.gmail.com>
Subject: Re: I/O hang, possibly XFS, possibly general
From: Paul Anderson <pha@umich.edu>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.uk>
Cc: Linux fs XFS <xfs@oss.sgi.com>

Hi Peter - I appreciate the feedback!

The background for this is that we live in an extreme corner case of
the world - our use case is dealing with 1GiB to 100GiB files at
present, and in the future probably to 500GiB files (aggregated data
from multiple deep sequencing runs).

The data itself has very odd lifecycle behavior, as well - since it is
research, the different stages are still being sorted out, but some
stages are essentially write once, read once, maybe keep, maybe
discard, depending on the research scenario.

Parenthetically, I will note there are numerous other issues and
problems that impose constraints beyond what is noted here -
conventional work flow, research problems, budgets, rack space, rack
power, time and more.

On Thu, Jun 2, 2011 at 2:56 PM, Peter Grandi <pg_xf2@xf2.for.sabi.co.uk> wr=
ote:
>> This morning, I had a symptom of a I/O throughput problem in which
>> dirty pages appeared to be taking a long time to write to disk.
>
> That can happen because of a lot of reasons, like elevator
> issues (CFQ has serious problems) and even CPU scheduler issues,
> RAID HA firmware problems (if you are using one, and you seem to
> be using MD, but then you may be using several in JBOD mode to
> handle all the disks), or problems with the Linux page cache
> (read ahead, the abominable plugger) or the flusher (the
> defaults are not so hot). Sometimes there are odd resonances
> between the page cache and multiple layers od MD or LVM too.

All JBOD chassis (SuperMicro SC 847's)... been experimenting with the
flusher, will look at the others.

>
> Lots of people have been burned even with much simpler setups
> than the one you describe below:

No doubt.

>
>> The system is a large x64 192GiB dell 810 server running
>> 2.6.38.5 from kernel.org - the basic workload was data
>> intensive - concurrent large NFS (with high metadata/low
>> filesize),
>
> Very imaginative. :-)
>
>> rsync/lftp (with low metadata/high file size)
>
> More suitable, but insignificant compared to this:

The rsync job currently appear to be causing the issue - it was
rsyncing around 250,000 files.  If the copy had already been done, the
rsync is fast (i.e. stat is fast, despite the numbers), but when it
starts moving data, the IOPS pegs and seems to be the limiting factor.

>
>> all working in a 200TiB XFS volume on a software MD raid0 on
>> top of 7 software MD raid6, each w/18 drives.
>
> That's rather more than imaginative :-). But this is a family
> oriented mailing list so I can't use appropriate euphemisms,
> because they no longer look like euphemisms.

We most likely live in different worlds - this is a pure research
group with "different" constraints than those you're probably used to.
 Not my choice, but 4-10X the cost per unit of storage is currently
not an option.

>> [ ... ] (the array can readily do >1000MiB/second for big
>> I/O). [ ... ]
>
> In a very specific narrow case, and you can get that with a lot
> less disks. You have 126 drives that can each do 130MB/s (outer
> tracks), so you should be getting 10GB/s :-).

The raw hardware will do about 5GiB/sec - near as I can tell, this is
saturating the pci-e bus (maybe main memory).

With XFS freshly installed, it was doing around 1400MiB/sec write, and
around 1900MiB/sec read - 10 parallel high throughput processes read
or writing as fast as possible (which actually is our use case).

> Also, your 1000MiB/s set probably is not full yet, so that's
> outer tracks only, and when it fills up, data gets into the
> inner tracks, and get a bit churned, then the real performances
> will "shine" through.

Yeah - overall, I expect it to drop - perhaps 50%?  I dunno.  The
particular filesystem being discussed is 80% full at the moment.

>> I did "echo 3 > /proc/sys/vm/drop_caches" repeatedly and
>> noticed that according to top, the total amount of cached data
>> would drop down rapidly (first time had the big drop), but
>> still be stuck at around 8-10Gigabytes.
>
> You have to watch '/proc/meminfo' to check the dirty pages in
> the cache. But you seem to have 8-10GiB of dirty pages in your
> 192GiB system. Extraordinarily imaginative.

Will watch that - yes, too many dirty pages in RAM - defaults are far
from optimal here.

>
>> While continuing to do this, I noticed finally that the cached
>> data value was in fact dropping slowly (at the rate of
>> 5-30MiB/second), and in fact finally dropped down to
>> approximately 60Megabytes at which point the stuck dpkg
>> command finished, and I was again able to issue sync commands
>> that finished instantly.
>
> Fantastic stuff, is that cached data or cached and dirty data?
> Guessing that it is cached and dirty (also because of the
> "Subject" line), do you really want to have several GiB of
> cached dirty pages?

After watching it reach steady state at around 60M, it appears not to
be dirty, as a sync command returned immediately and had no effect on
that value.

No, I do not want lots of dirty pages, however, I'm also aware that if
those are just data pages, it represents a few seconds of system
operation.

> Do you want these to be zillions of little metadata transactions
> scattered at random all over the place? =A0How "good" (I hesitate
> to use the very word in the context) is this more than imaginative
> RAID60 set at writing widely scattered small transactions?



>> [ ... ] =A0since we will have 5 of these machines running at
>> very high rates soon.
>
> Look forward to that :-).

We are, actually, it is a tremendous improvement over what we've been using.

>
>> Also, any suggestions for better metadata
>
> Use some kind of low overhead database if you need a database,
> else pray :-)

No database will work that I'm aware of, at least for the end data storage.

>
>> or log management are very welcome.
>
> Separate drives/flash SSD/RAM SSD. As previously revealed by a
> question I asked, Linux MD does full-width stripe updates with
> RAID6. The wider, the better of course :-).
>
>> This particular machine is probably our worst, since it has
>> the widest variation in offered file I/O load (tens of
>> millions of small files, thousands of >1GB files).
>
> Wide variation is not the problem, and neither is the machine,
> it is the approach.

All other approaches I am aware of cost more.  I favor Lustre, but the
infrastructure costs alone for a 2-5PB system will tend to be
exceptional.  Not that we may have much choice - the system we have is
well beyond the limits of what we should really be doing - however,
the constraints are also exceptional.

>> If this workload is pushing XFS too hard,
>
> XFS is a very good design within a fairly well defined envelope,
> and often the problems are more with Linux or application
> issues, but you may be a bit outside that envelope (euphemism
> alert), and you need to work on the grain of the storage system
> (understatement of the week).

>
>> I can deploy new hardware to split the workload across
>> different filesystems.
>
> My usual recommendation is to default (unless you have
> extraordinarily good arguments otherwise, and almost nobody
> does) to use RAID10 sets of at most 10 pairs (of "enterprise"
> drives of no more than 1TB each), with XFS or JFS depending on
> workload, as many servers as needed (if at all possible located
> topologically near to their users to avoid some potentially
> nasty network syndromes like incast), and forget about having a
> single large storage pool. Other details as to the flusher
> (every 1-2 seconds), elevator (deadline or noop), ... can matter
> a great deal.

re RAID10 specifically, I'd love to do something better - however the
process is currently severely cost and space constrained.

> If you do need a single large storage pool almost the only
> reasonable way currently (even if I have great hopes for
> GlusterFS) is Lustre or one of its forks (or much simpler
> imitators like DPM), and that has its own downsides (it takes a
> lot of work), but a single large storage pool is almost never
> needed, at most a single large namespace, and that can be
> instantiated with an automounter (and Lustre/DPM/.... is in
> effect a more sophisticated automounter).

"It takes a lot of work" is another reason we aren't readily able to
go to other architectures, despite their many advantages.

>
> If you know better go ahead and build 200TB XFS filesystems on
> top of a 7x(16+2) drive RAID60 and put lots of small files in
> them (or whatever) and don't even think about 'fsck' because you
> "know" it will never happen. And what about backing up one of
> those storage sets to another one? That can happen in the
> "background" of course, with no extra load :-).

fsck happens in less than a day, likewise rebuilding all RAIDs...
backups are interesting - it is impossible in the old scenario (our
prior generation storage) - possible now due to higher disk and
network bandwidth.  Keep in mind our ultimate backup is tissue
samples.

> Just realized another imaginative detail: a 126 drive RAID60 set
> delivering 200TB, looks like that you are using 2TB drives. Why
> am I not surprised? It would be just picture-perfect if they
> were low cost "eco" drives, and only a bit less so if they were
> ordinary drives without ERC. Indeed cost conscious budget heroes
> can only suggest using 2TB drives in a 126-drive RAID60 set even
> for a small-file metadata intensive workload, because IOPS and
> concurrent RW are obsolete concepts in many parts of the world.

We fortunately are were able to afford reasonably good enterprise drives.

2TB drives are mandatory - there simply isn't enough available space
in the data center otherwise.

The bulk of the work is not small-file - almost all is large files.

> Disclaimer: some smart people I know built knowingly a similar
> and fortunately much smaller collection of RAID6 sets because
> that was the least worst option for them, and since they know
> that it will not fill up before they can replace it, they are
> effectively short-stroking all those 2TB drives (I still would
> have bought ERC ones if possible) so it's cooler than it looks.

That is precisely the situation here - it is the "least worst" option.

>
>> Thanks very much for any thoughts or suggestions,
>
> * Don't expect to slap together a lot of stuff at random and it
> =A0working just like that. But then if you didn't expect that you
> =A0wouldn't have done any of the above.
>
> * "My usual recommendation" above is freely given yet often
> =A0worth more than months/years of very expensive consultants.
>
> * This mailing list is continuing proof that the "let's bang it
> =A0together, it will just work" club is large.

Research is research - not my choice of how it is done, either.

Paul


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
