Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q37GoJB5038833 for <xfs@oss.sgi.com>; Sat, 7 Apr 2012 11:50:19 -0500
Received: from woodbine.london.02.net (woodbine.london.02.net
	[87.194.255.145]) by cuda.sgi.com with ESMTP id
	jWdRvGV7NSDPl317 for <xfs@oss.sgi.com>;
	Sat, 07 Apr 2012 09:50:17 -0700 (PDT)
Received: from ty.sabi.co.UK (87.194.99.40) by woodbine.london.02.net (8.5.140)
	id 4F70C6670046067A for xfs@oss.sgi.com; Sat, 7 Apr 2012 17:50:16 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1SGVlP-0000jk-7w
	for <xfs@oss.sgi.com>; Sat, 07 Apr 2012 14:33:11 +0100
MIME-Version: 1.0
Message-ID: <20352.16918.404710.960311@tree.ty.sabi.co.UK>
Date: Sat, 7 Apr 2012 14:33:10 +0100
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
In-Reply-To: <CAAxjCEwNAOMUypaORP=BcJmdT3=GBykAYFjJD54_ixnLc+O6SQ@mail.gmail.com>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20349.63706.913104.777446@tree.ty.sabi.co.UK>
	<20350.65390.662663.682964@tree.ty.sabi.co.UK>
	<CAAxjCEwNAOMUypaORP=BcJmdT3=GBykAYFjJD54_ixnLc+O6SQ@mail.gmail.com>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

>> As to 'ext4' and doing (euphemism) insipid tests involving
>> peculiar setups, there is an interesting story in this post:

>> =A0http://oss.sgi.com/archives/xfs/2012-03/msg00465.html

> I really don't see the connection to this thread. You're
> advocating mostly that tar use fsync on every file, which to
> me seems absurd.

Rather different: I am pointing out that there is a fundamental
problem, that the spectrum of safety/speed tradeoffs covers 2
orders of magnitude as to speed, and that for equivalent points
XFS and 'ext4' don't perform that differently (factor of 2 in
this particular "test", which is sort of "noise").

  Note: it is Schilling who advocates for 'tar' to 'fsync' every
    file, and he gives some pretty good reasons why that should
    be the default, and why that should not be that expensive,
    (which I is a bit optimistic0. My advocacy in that thread
    was that having different safety/speed tradeoffs is a good
    thing, if they are honestly represented as tradeoffs.

So it is likely if there is a significant difference you are
getting a different tradeoff even if you may not *want* a
different tradeoff.

  Note: JFS and XFS are more or less as good as it gets as to
    "general purpose" filesystems, and when people complain
    about "speed" of them odds are that they are using either
    improperly, or in corner cases, or there is a problem in the
    application or storage layer. To get something better than
    JFS or XFS one must look at filesystems based on radically
    different tradeoffs, like NILFS2 (log), OCFS2 (shareable) or
    BTRFS (COW). In your case perhaps NILFS2 would give best
    results.

And that's what seems to be happening: 'ext4' seems to commit
metadata and data in spacewise order, XFS in timewise order,
because the seek order on writeout probably reflects the order
in which files were extracted from the 'tar' file.

> If the system goes down halfway through tar extraction, I
> would delete the tree and untar again. What do I care if some
> files are corrupt, when the entire tree is incomplete anyway?

Maybe you don't care; but filesystems are not psychic (they use
hardwired and adaptive policy, not predictive) and given that
most people seem to care the default for XFS is to try harder to
keep metadata durable.

Also various versions of 'tar' have options that allow
continuing rather than restarting an extraction because some
people prefer that.

> [ ... ] It's just that untarring large source trees is a very
> typical workload for me.

Well, it makes a lot of difference whether you are creating an
extreme corner case just to see what happens, or whether you
have a real problem, even a corner case problem, about which you
have to make some compromise.

The problem you have described seems rather strange:

  * You write a lot of little files to memory, as you have way
    more memory than data.
  * The whole is written out to a relatively RAID6 in one go, on
    a storage layer that can do 500-700MB/s but does 1/5th of that.
  * You don't do anything else with the files.

> And I just don't want to accept that XFS cannot do better than
> being several orders of magnitude slower than ext4 (speaking
> of binary orders of magnitude).

> As I see it, both file systems give the same guarantees:
> 1) That upon completion of sync, all data is readily available
>    on permanent storage.
> 2) That the file system metadata doesn't suffer corruption,
>    should the system lose power during the operation.

Yes, but they also give you some *implicit* guarantees that are
different. For example that:

  * XFS spreads out files for you so you can better take
    advantage of parallelism in your storage layer, and further
    allocations are more resistant to fragmentation.

  * 'ext4' probably commits in a different and less safe order
    from XFS. If the storage layer rearranged IO order this
    might matter a lot less.

You may not care about either, but then you are doing something
very special.

For example, if you were to use your freshly written sources to
do a build, then conceivably spreading the files over 4 AGs
means that the builds can be much quicker on a system with
available hardware parallelism.

Also, *you* don't care about the order in which losses would
happen, and how much, if the system crashes, but most users tend
to want to avoid repeating work, because either they are not
copying data, or the copy is huge and they don't want to restart
it from the beginning.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
