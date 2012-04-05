Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q35JuIn4067406 for <xfs@OSS.SGI.com>; Thu, 5 Apr 2012 14:56:18 -0500
Received: from woodbine.london.02.net (woodbine.london.02.net
	[87.194.255.145]) by cuda.sgi.com with ESMTP id
	5o0F4h9YMmF7BIP1 for <xfs@OSS.SGI.com>;
	Thu, 05 Apr 2012 12:56:16 -0700 (PDT)
Received: from ty.sabi.co.UK (87.194.99.40) by woodbine.london.02.net (8.5.140)
	id 4F70C667003D4F52 for xfs@OSS.SGI.com; Thu, 5 Apr 2012 20:56:14 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1SFsmx-0006gK-1q
	for <xfs@OSS.SGI.com>; Thu, 05 Apr 2012 20:56:11 +0100
MIME-Version: 1.0
Message-ID: <20349.63706.913104.777446@tree.ty.sabi.co.UK>
Date: Thu, 5 Apr 2012 20:56:10 +0100
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
In-Reply-To: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
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

[ ... ]

> The filesystem operations I care about the most are the likes which
> involve thousands of small files across lots of directories, like
> large trees of source code. For my test, I created a tarball of a
> finished IcedTea6 build, about 2.5 GB in size. It contains roughly
> 200,000 files in 20,000 directories.

Ah another totally inappropriate "test" of something (euphemism)
insipid. The XFS mailing list gets regularly queries on this topic.

Apparently not many people have figured out in the Linux culture
that general purpose filesystems cannot handle well large groups
of small files, and since the beginning of computing various
forms of "aggregate" files have been used for that, like 'ar'
('.a') files from UNIX, which should have been used far more
commonly than has happened, and never mind things like BDB/GDBM
databases.

But many lazy application programmer like to use the filesystem
as a small-record database, it is so easy...

> [ ... ] I ran the tests with a current RHEL 6.2 kernel and
> also with a 3.3rc2 kernel. Both of them exhibited the same
> behavior. The disk hardware used was a SmartArray p400
> controller with 6x 10k rpm 300GB SAS disks in RAID 6. The
> server has plenty of RAM (64 GB). [ ... ]

Huge hardware, but (euphemism) imaginative setup, as among its
many defects RAID6 is particularly inappropriate for most small
file/metadata heavy operation.

> [ ... ] I created two directory hierarchies, each containing
> the unpacked tarball 20 times, which I rsynced simultaneously
> to the target filesystem. When this was done, I deleted one
> half of them, creating some free space fragmentation, and what
> I hoped would mimic real-world conditions to some degree.

Your test is less (euphemism) insignificant because you tried
to cope with filetree lifetime issues.

> [ ... ] disk head jumps about wildly between four zones which
> are written to in almost perfectly linear fashion.

> [ ... ] I am aware that no filesystem can be optimal,

Every filesystem can be close to optimal, just not for every
workload.

> but given that the entire write set -- all 2.5 GB of it -- is
> "known" to the file system, that is, in memory, wouldn't it be
> possible to write it out to disk in a somewhat more reasonable
> fashion?

That sounds to me like a (euphemism) strategic aim: why ever
should a filesystem optimize that special case? Especially given
that 

XFS does spread file allocations across AGs because it aims for
multihreaded operations, especially on RAID sets with several
independent (that is, not RAID6 with small writes) arms.

Unfortunately filesystems are not psychic and cannot use
predictive allocation policies, and have to cope with poorly
written applications that don't do advising (or 'fsync' properly
which is even worse). So some policies get hard-written in the
filesystem "flavor".

Your remedy, as you have noticed, is to tweak the filesystem
logic by changing the number of AGs, and you might also want to
experiment with the elevator (you seem to have forgotten about
that) and other block subsystem policies, and/or with the safety
vs.  latency tradeoffs available at the filesystem and storage
system levels.

There are many annoying details, and recentish version of XFS
try to help with the hideous hack of building an elevator inside
the filesystem code itself:

  http://oss.sgi.com/archives/xfs/2010-01/msg00011.html
  http://oss.sgi.com/archives/xfs/2010-01/msg00008.html

which however is sort of effective, because the Linux block IO
subsystem has several (euphemism) appalling issues.

> As can be seen from the time scale in the bottom part, the ext4
> version performed about 5 times as fast because of a much more
> disk-friendly write pattern.

Is it really disk friendly for every workload? Think about what
happens on 'ext4' there, and when it jumps between block groups,
and it is in effect doing commits in a different order. What
'ext4' does costs dearly on other workload types.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
