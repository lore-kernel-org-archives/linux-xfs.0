Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBEE3MuH028068
	for <linux-xfs@oss.sgi.com>; Sun, 14 Dec 2008 08:03:22 -0600
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6B56C172DC68
	for <linux-xfs@oss.sgi.com>; Sun, 14 Dec 2008 06:03:19 -0800 (PST)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id JMurumEvDZoJfEbU
	for <linux-xfs@oss.sgi.com>; Sun, 14 Dec 2008 06:03:19 -0800 (PST)
MIME-Version: 1.0
Message-ID: <18757.4606.966139.10342@tree.ty.sabi.co.uk>
Date: Sun, 14 Dec 2008 14:02:38 +0000
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
In-Reply-To: <1229225480.16555.152.camel@localhost>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
	<493A9BE7.3090001@sandeen.net>
	<alpine.DEB.1.10.0812130724340.18746@p34.internal.lan>
	<200812131826.25280.Martin@lichtvoll.de>
	<4943F37B.8080405@sandeen.net>
	<1229225480.16555.152.camel@localhost>
From: xf2@xf2.for.sabi.co.UK (Peter Grandi)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Linux XFS <linux-xfs@oss.sgi.com>, Linux RAID <linux-raid@vger.kernel.org>

First of all, why are you people sending TWO copies to the XFS
mailing list? (to both linux-xfs@oss.sgi.com and xfs@oss.sgi.com).

>>> At the moment it appears to me that disabling write cache
>>> may often give more performance than using barriers. And
>>> this doesn't match my expectation of write barriers as a
>>> feature that enhances performance.

>> Why do you have that expectation?  I've never seen barriers
>> advertised as enhancing performance.  :)

This entire discussion is based on the usual misleading and
pointless avoidance of the substance, in particular because of
stupid, shallow diregard for the particular nature of the
"benchmark" used.

Barriers can be used to create atomic storage transaction for
metadata or data. For data, they mean that 'fsync' does what is
expected to do. It is up to the application to issue 'fsync' as
often or as rarely as appropriate.

For metadata, it is the file system code itself that uses
barriers to do something like 'fsync' for metadata updates, and
enforce POSIX or whatever guarantees.

The "benchmark" used involves 290MB of data in around 26k files
and directories, that is the average inode size is around 11KB.

That means that an inode is created and flushed to disk every
11KB written; a metadata write barrier happens every 11KB.

A synchronization every 11KB is a very high rate, and it will
(unless the disk host adapter or the disk controller are clever
mor have battery backed memory for queues) involve a lot of
waiting for the barrier to complete, and presumably break the
smooth flow of data to the disk with pauses.

Also whether or not the host adapter or the conroller write
cache are disabled, 290MB will fit inside most recent hosts' RAM
entirely, and even adding 'sync' at the end will not help that
much as to helping with a meaningful comparison.

> My initial thoughts were that write barriers would enhance
> performance, in that, you could have write cache on.

Well, that all depends on whether the write caches (in the host
adapter or the controller) are persistent and how frequently
barriers are issued.

If the write caches are not persistent (at least for a while),
the hard disk controller or the host adapter cannot have more
than one barrier completion request in flight at a time, and if
a barrier completion is requested every 11KB that will be pretty
constraining.

Barriers are much more useful when the host adapter or the disk
controller can cache multiple transactions and then execute them
in the order in which barriers have been issued, so that the
host can pipeline transactions down to the last stage in the
chain, instead of operating the last stages synchronously or
semi-synchronously.

But talking about barriers in the context of metadata, and for a
"benchmark" which has a metadata barrier every 11KB, and without
knowing whether the storage subsystem can queue multiple barrier
operations seems to be pretty crass and meangingless, if not
misleading. A waste of time at best.

> So its really more of an expectation that wc+barriers on,
> performs better than wc+barriers off :)

This is of course a misstatement: perhaps you intended to write
that ''wc on+barriers on'' would perform better than ''wc off +
barriers off'.

As to this apparent anomaly, I am only mildly surprised, as
there are plenty of similar anomalies (why ever should have a
very large block device readahead to get decent performance from
MD block devices?), due to poorly ill conceived schemes in all
sorts of stages of the storage chain, from the sometimes
comically misguided misdesigns in the Linux block cache or
elevators or storage drivers, to the often even worse
"optimizations" embedded in the firmware of host adapters and
hard disk controllers.

Consider for example (and also as a hint towards less futile and
meaningless "benchmarks") the 'no-fsync' option of 'star', the
reasons for its existence and for the Linux related advice:

  http://gd.tuwien.ac.at/utils/schilling/man/star.html

    =AB-no-fsync
          Do not call  fsync(2)  for  each  file  that  has  been
          extracted  from  the archive. Using -no-fsync may speed
          up extraction on operating systems with slow  file  I/O
          (such  as  Linux),  but includes the risk that star may
          not be able to detect extraction  problems  that  occur
          after  the  call to close(2).=BB

Now ask yourself if you know whether GNU tar does 'fsync' or not
(a rather interesting detail, and the reasons why may also be
interesting...).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
