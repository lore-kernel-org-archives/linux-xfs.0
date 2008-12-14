Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBEM2nuE024664 for <xfs@OSS.SGI.com>; Sun, 14 Dec 2008 16:02:49 -0600
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 347871E58B
	for <xfs@OSS.SGI.com>; Sun, 14 Dec 2008 14:02:47 -0800 (PST)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id PaTLpxzeMF2VufiD
	for <xfs@OSS.SGI.com>; Sun, 14 Dec 2008 14:02:47 -0800 (PST)
MIME-Version: 1.0
Message-ID: <18757.33373.744917.457587@tree.ty.sabi.co.uk>
Date: Sun, 14 Dec 2008 22:02:05 +0000
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
In-Reply-To: <200812141912.59649.Martin@lichtvoll.de>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
	<1229225480.16555.152.camel@localhost>
	<18757.4606.966139.10342@tree.ty.sabi.co.uk>
	<200812141912.59649.Martin@lichtvoll.de>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Linux XFS <xfs@oss.sgi.com>, Linux RAID <linux-raid@vger.kernel.org>

[ ... ]

> But - as far as I understood - the filesystem doesn't have to
> wait for barriers to complete, but could continue issuing IO
> requests happily. A barrier only means, any request prior to
> that have to land before and any after it after it.

> It doesn't mean that the barrier has to land immediately and
> the filesystem has to wait for this. At least that always was
> the whole point of barriers for me. If thats not the case I
> misunderstood the purpose of barriers to the maximum extent
> possible.

Unfortunately that seems the case.

The purpose of barriers is to guarantee that relevant data is
known to be on persistent storage (kind of hardware 'fsync').

In effect write barrier means "tell me when relevant data is on
persistent storage", or less precisely "flush/sync writes now
and tell me when it is done". Properties as to ordering are just
a side effect.

That is, the application (file system in the case of metadata,
user process in the case of data) knows that a barrier operation
is complete, it knows that all data involved in the barrier
operation are on persistent storage. In case of serially
dependent transactions, applications do wait until the previous
transaction is completed before starting the next one (e.g.
creating potentially many files in the same directory, something
that 'tar' does).

  "all data involved" is usually all previous writes, but in
  more sophisticated cases it can be just specific writes.

When an applications at transaction end points (for a file
system, metadata updates) issues a write barrier and then waits
for its completion.

If the host adapter/disk controllers don't have persistent
storage, then completion (should) only happen when the data
involved is actually on disk; if they do have it, then multiple
barriers can be outstanding, if the host adapter/disk controller
does support multiple outstanding operations (e.g. thanks to
tagged queueing).

The best case is when the IO subsystem supports all of these:

* tagged queueing: multiple write barriers can be outstanding;

* fine granule (specific writes, not all writes) barriers: just
  metadata writes need to be flushed to persistent storage, not
  any intervening data writes too;

* the host adapter and/or disk controller have persistent
  caches: as long as those caches have space, barriers can
  complete immediately, without waiting a write to disk.

It just happens that typical contemporary PC IO subsystems (at
the hardware level, not the Linux level) have none of those
features, except sometimes for NCQ which is a reduced form of
TCQ, and apparently is not that useful.

Write barriers are also useful without persistent caches, if
there is proper tagged queueing and fine granularity.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
