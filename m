Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q35N7WTf086728 for <xfs@OSS.SGI.com>; Thu, 5 Apr 2012 18:07:32 -0500
Received: from woodbine.london.02.net (woodbine.london.02.net
	[87.194.255.145]) by cuda.sgi.com with ESMTP id
	qu0gejsWN3GkxQjl for <xfs@OSS.SGI.com>;
	Thu, 05 Apr 2012 16:07:30 -0700 (PDT)
Received: from ty.sabi.co.UK (87.194.99.40) by woodbine.london.02.net (8.5.140)
	id 4F70C667003DDB83 for xfs@OSS.SGI.com; Fri, 6 Apr 2012 00:07:28 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1SFvlz-0006kq-Go
	for <xfs@OSS.SGI.com>; Fri, 06 Apr 2012 00:07:23 +0100
MIME-Version: 1.0
Message-ID: <20350.9643.379841.771496@tree.ty.sabi.co.UK>
Date: Fri, 6 Apr 2012 00:07:23 +0100
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
In-Reply-To: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
From: pg_xf2@xf2.for.to.sabi.co.UK (Peter Grandi)
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

> [ ... ] tarball of a finished IcedTea6 build, about 2.5 GB in
> size. It contains roughly 200,000 files in 20,000 directories.
> [ ... ] given that the entire write set -- all 2.5 GB of it --
> is "known" to the file system, that is, in memory, wouldn't it
> be possible to write it out to disk in a somewhat more
> reasonable fashion?  [ ... ] The disk hardware used was a
> SmartArray p400 controller with 6x 10k rpm 300GB SAS disks in
> RAID 6. The server has plenty of RAM (64 GB).

On reflection this trigger for me an aside: traditional
filesystem types are designed for the case where the ratio is
the opposite, something like a 64GB data collection to process
and 2.5GB of RAM, and where therefore the issue is minimizing
ongoing disk accesses, not the upload from memory to disk of a
bulk sparse set of stuff.

The Sprite Log-structured File System was a design targeted at
large-memory systems, assuming that then writes are the issue
(especially as Sprite was network-based), and reads would mostly
happen from RAM, as in your (euphemism) insipid test.

I suspect that if the fundamental tradeoffs are inverted, then a
completely different design like a LFS might be appropriate.

But the above has a relationship to your (euphemism) unwise
concerns: the case where 200,000 files for 2.5GB are completely
written to RAM and then flushed as a whole to disk is not only
"untraditional" it is also (euphemism) peculiar: try by setting
the flusher to run rather often so that not more than 100-300MB
of dirty pages are left at any one time.

Which brings another subject: usually hw RAID host adapter have
cache, and have firmware that cleverly rearranges writes.

Looking at the specs of the P400:

  http://h18004.www1.hp.com/products/servers/proliantstorage/arraycontrollers/smartarrayp400/

it seems to me that it has standard 256MB of cache, and only
supports RAID6 with a battery backed write cache (wise!).

Which means that your Linux-level seek graphs may be not so
useful, because the host adapter may be drastically rearranging
the seek patterns, and you may need to tweak the P400 elevator,
rather than or in addition to the Linux elevator.

Unless possibly barriers are enabled, and even with a BBWC the
P400 writes through on receiving a barrier request. IIRC XFS is
rather stricter in issuing barrier requests than 'ext4', and you
may be seeing more the effect of that than the effect of aiming
to splitting the access patterns between 4 AGs to improve the
potential for multithreading (which you deny because you are
using what is most likely a large RAID6 stripe size with a small
IO intensive write workload, as previously noted).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
