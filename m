Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n81CmI4r175077 for <xfs@OSS.SGI.com>; Tue, 1 Sep 2009 07:48:38 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB388415FE9
	for <xfs@OSS.SGI.com>; Tue,  1 Sep 2009 05:49:04 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id ZZuDEwsSwuArvu31
	for <xfs@OSS.SGI.com>; Tue, 01 Sep 2009 05:49:04 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1MiQfO-000376-N7
	for <xfs@OSS.SGI.com>; Tue, 01 Sep 2009 10:32:46 +0000
MIME-Version: 1.0
Message-ID: <19100.63566.98250.185404@tree.ty.sabi.co.uk>
Date: Tue, 1 Sep 2009 10:32:46 +0000
Subject: Re: zero size file after power failure with kernel 2.6.30.5
In-Reply-To: <200909010918.37886@zmi.at>
References: <200908292102.21710@zmi.at> <4A99A80C.9010307@sandeen.net>
	<19100.22644.149019.555685@tree.ty.sabi.co.uk>
	<200909010918.37886@zmi.at>
From: pg_xf2@xf2.sabi.co.UK (Peter Grandi)
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
To: Linux XFS <xfs@oss.sgi.com>

[ ... ]

>> Then 'mount' with '-o sync' [ ... ]

> Yes. I could also simply switch back to reiserfs, where I
> never had this kind of issue, despite lots of crashes etc.

Other people have a very different impression. Like 'ext3'
ReiserFS does ordered writes, but those don't necessarily help
because of the colossal amount of buffering that happens anyhow
nowadays.

> [ ... ] maybe someone taps into the problem and can improve
> it.

It is foremost an application problem, and then a block layer
problem. The first is unsolvable ("user space sucks") in our
lifetimes, and the second depends on the goodwill of the
proprietors of the relevant kernel subsystem.

As to application design, XFS is targeted at heavily parallel
workloads on large storage arrays; its design takes advantage of
what API semantics permit to improve that use case, and relies
on applications making use of those API semantics properly.

If that and having good scalable performance at the same time
requires having dual power supplies, redundant storage paths,
and battery backup, that is the typical platform on which XFS is
deployed.

> There was a similar problem with the change from ext3 to ext4,
> with a big discussion. Ext4 has been improved,

Actually it has been made worse, to compensate for bad
application and block layer behaviour.

Red Hat with 'ext4' have been trying to imply that an in-place
upgrade to an 'ext3' compatible filesystem can support every
possible point on the spectrum. Well, it turned out that they
cannot. So there have been motions towards supporting XFS in
5.4, to have a dual-filesystem strategy, which is what a large
number of their important enterprise customers do anyhow.

> [ ... ] In ext4 they reorganized the way metaupdates are done,
> maybe that can help xfs too.

But that makes performance worse in the large/paralell case.

> [ ... ] It seems kmail writes its config every 7 minutes, so
> it is vulnerable for 3 seconds then.

That won't help that much. Apps and the block layer are really
designed for older, gentler times. And never mind the clueless,
moronic "optimization" of Linux block layer plugging/unplugging.

Currently a single disk can write 100MB/s, memory sizes on many
_laptops_ are 4GB with potentially 1-2GB or 10-20s of writes
cached. On a server one can have RAIDs that can write at/s.

If applications and the block layer are misbehaving, and '-o
sync' is not used, even if one flushes cache every second, there
can still be dozens of MB (on a laptop) to some GB (on a server)
that get lost in that one second. The filesystem can try hard to
ensure that metadata gets written nearly immediately, ensuring
'fsck'-consistency, but it cannot do that for data in any
sensible way unless the application and the block layer do the
right thing, so data persistency is at best elusive.

> I've set vm.dirty_expire_centisecs = 1000 now to improve the
> situation a bit.

It does not help that not only the applications and the block
layer are misdesigned, but they also misdesigned for a time
where data rates were a lot lower, so outstanding updates were
bounded a lot lower.

There are workarounds and by careful patching and changing
default settings one can palliate the worst situations; but for
example 10 seconds of 'dirty_expire_centisecs' seems way too
long (IIRC you have a fairly large memory and RAID) and other
settings matter more.

I have written quite a bit in my blog about these issues, and
you may find this particular entry rather relevant:

  http://www.sabi.co.uk/blog/0707jul.html#070701

In general on a fast machine I would use:

  vm/dirty_ratio                  =4
  vm/dirty_background_ratio       =2
  vm/dirty_expire_centisecs       =400
  vm/dirty_writeback_centisecs    =200

or half of every one. Short flushing times also ensure more
continuous flushing (without huge periodic gulps), which can
significantly improve *write* performance for streaming
applications (XFS etc. delayed allocation is designed to improve
read performance despite the lack of preallocation).

This cannot be done on laptops, where short flushing times are
bad for power consumption, but at least they are battery backed,
and hopefully SSDs will save us anyhow.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
