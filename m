Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p52J6YPM218903 for <xfs@OSS.SGI.com>; Thu, 2 Jun 2011 14:06:36 -0500
Received: from woodbine.london.02.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A10201660B44
	for <xfs@OSS.SGI.com>; Thu,  2 Jun 2011 12:06:32 -0700 (PDT)
Received: from woodbine.london.02.net (woodbine.london.02.net
	[87.194.255.145]) by cuda.sgi.com with ESMTP id
	z7TBCSbPD5fS0ndU for <xfs@OSS.SGI.com>;
	Thu, 02 Jun 2011 12:06:32 -0700 (PDT)
Received: from ty.sabi.co.UK (87.194.99.40) by woodbine.london.02.net (8.5.133)
	id 4D8CD8C901C52D3C for xfs@OSS.SGI.com; Thu, 2 Jun 2011 20:06:31 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1QSD45-0007SG-VT
	for <xfs@OSS.SGI.com>; Thu, 02 Jun 2011 19:56:18 +0100
MIME-Version: 1.0
Message-ID: <19943.56524.969126.59978@tree.ty.sabi.co.UK>
Date: Thu, 2 Jun 2011 19:56:12 +0100
Subject: Re: I/O hang, possibly XFS, possibly general
In-Reply-To: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>
References: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

> This morning, I had a symptom of a I/O throughput problem in which
> dirty pages appeared to be taking a long time to write to disk.

That can happen because of a lot of reasons, like elevator
issues (CFQ has serious problems) and even CPU scheduler issues,
RAID HA firmware problems (if you are using one, and you seem to
be using MD, but then you may be using several in JBOD mode to
handle all the disks), or problems with the Linux page cache
(read ahead, the abominable plugger) or the flusher (the
defaults are not so hot). Sometimes there are odd resonances
between the page cache and multiple layers od MD or LVM too.

Lots of people have been burned even with much simpler setups
than the one you describe below:

> The system is a large x64 192GiB dell 810 server running
> 2.6.38.5 from kernel.org - the basic workload was data
> intensive - concurrent large NFS (with high metadata/low
> filesize),

Very imaginative. :-)

> rsync/lftp (with low metadata/high file size)

More suitable, but insignificant compared to this:

> all working in a 200TiB XFS volume on a software MD raid0 on
> top of 7 software MD raid6, each w/18 drives.

That's rather more than imaginative :-). But this is a family
oriented mailing list so I can't use appropriate euphemisms,
because they no longer look like euphemisms.

> [ ... ] (the array can readily do >1000MiB/second for big
> I/O). [ ... ]

In a very specific narrow case, and you can get that with a lot
less disks. You have 126 drives that can each do 130MB/s (outer
tracks), so you should be getting 10GB/s :-).

Also, your 1000MiB/s set probably is not full yet, so that's
outer tracks only, and when it fills up, data gets into the
inner tracks, and get a bit churned, then the real performances
will "shine" through.

> I did "echo 3 > /proc/sys/vm/drop_caches" repeatedly and
> noticed that according to top, the total amount of cached data
> would drop down rapidly (first time had the big drop), but
> still be stuck at around 8-10Gigabytes.

You have to watch '/proc/meminfo' to check the dirty pages in
the cache. But you seem to have 8-10GiB of dirty pages in your
192GiB system. Extraordinarily imaginative.

> While continuing to do this, I noticed finally that the cached
> data value was in fact dropping slowly (at the rate of
> 5-30MiB/second), and in fact finally dropped down to
> approximately 60Megabytes at which point the stuck dpkg
> command finished, and I was again able to issue sync commands
> that finished instantly.

Fantastic stuff, is that cached data or cached and dirty data?
Guessing that it is cached and dirty (also because of the
"Subject" line), do you really want to have several GiB of
cached dirty pages?

Do you want these to be zillions of little metadata transactions
scattered at random all over the place?  How "good" (I hesitate
to use the very word in the context) is this more than imaginative
RAID60 set at writing widely scattered small transactions?

> [ ... ]  since we will have 5 of these machines running at
> very high rates soon.

Look forward to that :-).

> Also, any suggestions for better metadata

Use some kind of low overhead database if you need a database,
else pray :-)

> or log management are very welcome.

Separate drives/flash SSD/RAM SSD. As previously revealed by a
question I asked, Linux MD does full-width stripe updates with
RAID6. The wider, the better of course :-).

> This particular machine is probably our worst, since it has
> the widest variation in offered file I/O load (tens of
> millions of small files, thousands of >1GB files).

Wide variation is not the problem, and neither is the machine,
it is the approach.

> If this workload is pushing XFS too hard,

XFS is a very good design within a fairly well defined envelope,
and often the problems are more with Linux or application
issues, but you may be a bit outside that envelope (euphemism
alert), and you need to work on the grain of the storage system
(understatement of the week).

> I can deploy new hardware to split the workload across
> different filesystems.

My usual recommendation is to default (unless you have
extraordinarily good arguments otherwise, and almost nobody
does) to use RAID10 sets of at most 10 pairs (of "enterprise"
drives of no more than 1TB each), with XFS or JFS depending on
workload, as many servers as needed (if at all possible located
topologically near to their users to avoid some potentially
nasty network syndromes like incast), and forget about having a
single large storage pool. Other details as to the flusher
(every 1-2 seconds), elevator (deadline or noop), ... can matter
a great deal.

If you do need a single large storage pool almost the only
reasonable way currently (even if I have great hopes for
GlusterFS) is Lustre or one of its forks (or much simpler
imitators like DPM), and that has its own downsides (it takes a
lot of work), but a single large storage pool is almost never
needed, at most a single large namespace, and that can be
instantiated with an automounter (and Lustre/DPM/.... is in
effect a more sophisticated automounter).

If you know better go ahead and build 200TB XFS filesystems on
top of a 7x(16+2) drive RAID60 and put lots of small files in
them (or whatever) and don't even think about 'fsck' because you
"know" it will never happen. And what about backing up one of
those storage sets to another one? That can happen in the
"background" of course, with no extra load :-).

Just realized another imaginative detail: a 126 drive RAID60 set
delivering 200TB, looks like that you are using 2TB drives. Why
am I not surprised? It would be just picture-perfect if they
were low cost "eco" drives, and only a bit less so if they were
ordinary drives without ERC. Indeed cost conscious budget heroes
can only suggest using 2TB drives in a 126-drive RAID60 set even
for a small-file metadata intensive workload, because IOPS and
concurrent RW are obsolete concepts in many parts of the world.

Disclaimer: some smart people I know built knowingly a similar
and fortunately much smaller collection of RAID6 sets because
that was the least worst option for them, and since they know
that it will not fill up before they can replace it, they are
effectively short-stroking all those 2TB drives (I still would
have bought ERC ones if possible) so it's cooler than it looks.

> Thanks very much for any thoughts or suggestions,

* Don't expect to slap together a lot of stuff at random and it
  working just like that. But then if you didn't expect that you
  wouldn't have done any of the above.

* "My usual recommendation" above is freely given yet often
  worth more than months/years of very expensive consultants.

* This mailing list is continuing proof that the "let's bang it
  together, it will just work" club is large.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
