Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p53MJq5Z035635 for <xfs@oss.sgi.com>; Fri, 3 Jun 2011 17:19:52 -0500
Received: from honeysuckle.london.02.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4BD051ED4244
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2011 15:19:49 -0700 (PDT)
Received: from honeysuckle.london.02.net (honeysuckle.london.02.net
	[87.194.255.144]) by cuda.sgi.com with ESMTP id
	sLADAHR7A5HMx7uk for <xfs@oss.sgi.com>;
	Fri, 03 Jun 2011 15:19:49 -0700 (PDT)
Received: from ty.sabi.co.UK (87.194.99.40) by honeysuckle.london.02.net
	(8.5.133)
	id 4DA2FC0B013130E8 for xfs@oss.sgi.com; Fri, 3 Jun 2011 23:19:48 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1QSciD-0004Tt-9j
	for <xfs@oss.sgi.com>; Fri, 03 Jun 2011 23:19:25 +0100
MIME-Version: 1.0
Message-ID: <19945.24042.711472.158523@tree.ty.sabi.co.UK>
Date: Fri, 3 Jun 2011 23:19:22 +0100
Subject: Re: I/O hang, possibly XFS, possibly general
In-Reply-To: <BANLkTim978GhfamN=TEFULP5GdfMu02-7w@mail.gmail.com>
References: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>
	<19943.56524.969126.59978@tree.ty.sabi.co.UK>
	<BANLkTim978GhfamN=TEFULP5GdfMu02-7w@mail.gmail.com>
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

> All JBOD chassis (SuperMicro SC 847's)... been experimenting
> with the flusher, will look at the others.

I think that from the symptoms you describe the hang happens
in the first instance because the number of dirty pages has hit
'dirty_background_ratio', after which all writes become
synchronous and this really works badly, especially with XFS.

To prevent that, and in general to prevent the accumulation of
lots of dirty pages, and sudden latency killing large bursts of
IO, it is quite important to tell the flusher to sync pretty
often and constantly.

For the Linux kernel by default permits the buildup of a mass of
dirty pages proportional to memory, which is a very bad idea, as
it should be proportional to write speed, with the idea that one
should not buffer more than 1 second or perhaps less of dirty
pages. In your case that's probably a few hundred MBs, and even
that is pretty bad in case of crashes.

The sw solution is to set the 'vm/dirty_*' tunables accordingly.

  vm/dirty_ratio=2
  vm/dirty_bytes=400000000

  vm/dirty_background_ratio=60
  vm/dirty_background_bytes=0

  vm/dirty_expire_centisecs=200
  vm/dirty_writeback_centisecs=400

The hw solution is to do that *and* use SAS/SATA host adapters
with (large) battery-backed buffers/cache (but still keeping
very few dirty pages in the Linux page cache). I would not use
them in hw RAID mode, also because so many hw RAID cards have
abominably buggy firmware, and I trust Linxu MD rather more.
Unfortunately it is difficult to recommend any specific host
adapter.

> The rsync job currently appear to be causing the issue - it
> was rsyncing around 250,000 files.  If the copy had already
> been done, the rsync is fast (i.e. stat is fast, despite the
> numbers), but when it starts moving data, the IOPS pegs and
> seems to be the limiting factor.

That's probably also some effect related to writing to the
intent log, and a RAID60 makes that very painful.

[ ... ]

> We most likely live in different worlds - this is a pure
> research group with "different" constraints than those you're
> probably used to.  Not my choice, but 4-10X the cost per unit
> of storage is currently not an option.

Then lots lots more smaller RAID5 sets, or even RAID6 if you are
sufficiently desparate.

Joined together at the namespace level, not with a RAID0. Do you
really need a single free space pool? I doubt it: you probably
are reading/generating data and storing it, so you instead of
having a single 200TB storage pool, you could have 20x10TB ones
and fill one after the other.

Also ideally much smaller RAID sets: 18 wide with double parity
beckons a world of read-modify-write pain, especially if the
metadata intent log is on the same logical block device.

The MD maintainer thinks that for his much smaller needs putting
the metadata intent logs on a speedy small RAID1 is good enough,
but I think that scales a fair bit. After all the maximum log
size for XFS is not that large (fortunately) and smaller is
better.

Having multiple smaller filesystems also help with having
multiple smaller metadata intent logs.

> With XFS freshly installed, it was doing around 1400MiB/sec
> write, and around 1900MiB/sec read - 10 parallel high
> throughput processes read or writing as fast as possible
> (which actually is our use case).

>> Also, your 1000MiB/s set probably is not full yet, so that's
>> outer tracks only, and when it fills up, data gets into the
>> inner tracks, and get a bit churned, then the real
>> performances will "shine" through.

> Yeah - overall, I expect it to drop - perhaps 50%?  I dunno.
> The particular filesystem being discussed is 80% full at the
> moment.

That's then fairly realistic, as it is getting well into the
inner tracks. Getting avobe 90% will cause trouble.

[ ... ]

>> But you seem to have 8-10GiB of dirty pages in your 192GiB
>> system. Extraordinarily imaginative.

> No, I do not want lots of dirty pages, however, I'm also aware
> that if those are just data pages, it represents a few seconds
> of system operation.

Only if written entirely sequentially. IOPS in random and
sequential are quite different.

> All other approaches I am aware of cost more. I favor Lustre,
> but the infrastructure costs alone for a 2-5PB system will
> tend to be exceptional.

Why? Lustre can run on your existing hw, and you need the
network anyhow (unless you compute several TB on one host and
store them on that host's disks, in which case you are lucky).

>> [ ... ] is Lustre or one of its forks (or much simpler
>> imitators like DPM), and that has its own downsides (it takes
>> a lot of work), but a single large storage pool is almost
>> never needed, at most a single large namespace, and that can
>> be instantiated with an automounter (and Lustre/DPM/.... is
>> in effect a more sophisticated automounter).

> "It takes a lot of work" is another reason we aren't readily
> able to go to other architectures, despite their many
> advantages.

But creating a 200TB volume and formatting it as XFS seems a
quick thing to do now, but soon you will need to cope with the
consequences.

Setting up Lustre takes more at the beginning, but will handle
your workload a lot better, and it handles much better having a
lot of smaller independently fsck-able pools and highly parallel
network operation.

It handles small files not so well, so some kind of NFS server
with XFS or better JFS for that would be nice.

There is a high throughput genomic data system at thre Sanger
Institute in Cambridge UK based on Lustre and it might inspire
you. This is a relatively old post, it has been in production
for a long time:

  http://threebit.net/mail-archive/bioclusters/msg00188.html
  http://www.slideshare.net/gcoates

Alternatively a number of smaller XFS filesystems as suggested
above, but you lose the extra integration/parallelism Lustre
gives.

[ ... ]

> fsck happens in less than a day,

It takes less than a day *if there is essentially no damage*,
otherwise it might take weeks.

> likewise rebuilding all RAIDs...

But the impact on performance will be terrifying, and if you
reduce resync speed, it will take much longer, and while it
rebuilds further failures will be far more likely, and that will
be a very long day.

Also consider that you have a 7-wide RAID0 of RAID6 sets; if one
of the RAID6 sets becomes much slower because of rebuild, odds
are this will impact *all* IO because of the RAID0.

If you are unlucky, you could end up with one of the RAID6
members of the RAID0 set being in rebuild quite a good
percentage of the time.

> backups are interesting - it is impossible in the old scenario
> (our prior generation storage) - possible now due to higher
> disk and network bandwidth.

But many people forget that a backup is often the most stressful
operation that can happen.

> Keep in mind our ultimate backup is tissue samples.

If you can regenerate the data even if expensively then avoid
RAID6. Two 8+1 RAID5 sets are better than a 16+2 RAID6 set, and
losing a bit more spare, three 5+1 RAID5 sets (10TB each) are
better still.

The reason are much smaller RMW stripe width, the ability to do
non-full-width RMW updates, much nicer rebuilds (1/2 or 1/3 of
the drives would be slowed down).

> 2TB drives are mandatory - there simply isn't enough available
> space in the data center otherwise.

Ah that's a pretty hard constraint then.

> The bulk of the work is not small-file - almost all is large
> files.

Then perhaps put the large file on XFS or Lustre and the small
file on JFS.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
