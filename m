Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBGA35iH000955
	for <linux-xfs@oss.sgi.com>; Tue, 16 Dec 2008 04:03:06 -0600
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B2B57173AE9C
	for <linux-xfs@oss.sgi.com>; Tue, 16 Dec 2008 02:03:02 -0800 (PST)
Received: from ty.sabi.co.UK ([192.100.78.57]) by cuda.sgi.com with ESMTP id
	E0VYutjBFb8yOPTN for <linux-xfs@oss.sgi.com>;
	Tue, 16 Dec 2008 02:03:02 -0800 (PST)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.68 #1) id 1LCMGQ-0001ry-4C
	for <linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 22:50:10 +0000
MIME-Version: 1.0
Message-ID: <18758.57121.570007.816329@tree.ty.sabi.co.uk>
Date: Mon, 15 Dec 2008 22:50:09 +0000
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
In-Reply-To: <200812151948.59870.Martin@lichtvoll.de>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
	<200812141912.59649.Martin@lichtvoll.de>
	<18757.33373.744917.457587@tree.ty.sabi.co.uk>
	<200812151948.59870.Martin@lichtvoll.de>
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
To: Linux XFS <linux-xfs@oss.sgi.com>

[ ... ]

>> The purpose of barriers is to guarantee that relevant data is
>> known to be on persistent storage (kind of hardware 'fsync').
>> In effect write barrier means "tell me when relevant data is
>> on persistent storage", or less precisely "flush/sync writes
>> now and tell me when it is done". Properties as to ordering
>> are just a side effect.

> [ ... ] Unfortunately in my understanding none of this is
> reflected by Documentation/block/barrier.txt

But we are talking about XFS and barriers here. That described
just a (flawed, buggy) mechanism to implement those. Consider
for example:

  http://www.xfs.org/index.php/XFS_FAQ#Write_barrier_support.
  http://www.xfs.org/index.php/XFS_FAQ#Q._Should_barriers_be_enabled_with_storage_which_has_a_persistent_write_cache.3F

In any case as to the kernel "barrier" mechanism, its
description is misleading because it heavily fixates on the
ordering issue, which is just a consequence, but yet mentions
the far more important "flush/sync" aspect.

Still, there is a lot of confusion about barrier support and
what it means at which level, as reflected in several online
discussions and the different behaviour of different kernel
versions.

> Especially this mentions:

  > [ ... ] All requests queued before a barrier request must be
  > finished (made it to the physical medium) before the barrier
  > request is started, and all requests queued after the
  > barrier request must be started only after the barrier
  > request is finished (again, made it to the physical medium)

This does say that the essential property is "made it to the
physical medium".

  > i. For devices which have queue depth greater than 1 (TCQ
  > devices) and support ordered tags, block layer can just
  > issue the barrier as an ordered request and the lower level
  > driver, controller and drive itself

Note that the terminology here is wrong: here "controller"
really means "host adapter", and "drive itself" actually means
"drive controller".

  > are responsible for making sure that the ordering constraint
  > is met.

This is subtly incorrect. The driver, host adapter and drive
controller should only keep queued multiple barrier requests if
their caches are persistent. But this seems corrected below in
the "Forced flushing to physical medium".

  > ii. For devices which have queue depth greater than 1 but
  > don't support ordered tags, block layer ensures that the
  > requests preceding a barrier request finishes before issuing
  > the barrier request.  Also, it defers requests following the
  > barrier until the barrier request is finished.  Older SCSI
  > controllers/drives and SATA drives fall in this category.

  > iii. Devices which have queue depth of 1.  This is a
  > degenerate case of ii. Just keeping issue order suffices.
  > Ancient SCSI controllers/drives and IDE drives are in this
  > category.

Both of these seem to match my discussion; here "requests" means
of course "write requests".

  > 2. Forced flushing to physical medium

  > Again, if you're not gonna do synchronization with disk
  > drives (dang, it sounds even more appealing now!), the
  > reason you use I/O barriers is mainly to protect filesystem
  > integrity when power failure or some other events abruptly
  > stop the drive from operating and possibly make the drive
                                      =======================
  > lose data in its cache.
    ======================

  > So, I/O barriers need to guarantee that requests actually
  > get written to non-volatile medium in order.

Here it is incorrect again: barriers need to guarantee both that
data gets written to non-volatile medium, and that this happens
in order, for serially dependent transactions.

  > There are four cases, [ ... ] We still need one flush to
  > make sure requests preceding a barrier are written to medium
  > [ ... ]

[ ... ]

> Nor do I understand why the filesystem needs to know whether a
> barrier has been completed - it just needs to know whether the
> block device / driver can handle barrier requests.

Perhaps you are thinking about an API like "issue barrier, wait
for barrier completion". But it can be instead "issue barrier,
this only returns when it is complete", or "issue barrier, any
subsequent write completes only when the barrier has been
executed" much to the same effect.  In the discussion of the
four cases above

> If the filesystem knows that requests are written with certain
> order constraint, then it shouldn't matter when they are written.

Ah it sure does, in two ways. Barriers are essentially a way to
implement 'fsync' or 'fdatasync', whether these are explicitly
issued by processes or implicitly by the file system code.

  > When should be a choice of the user on how much data she /
  > he risks to loose in case of a sudden interruption of
  > writing out requests.

Sure, and for *data* the user can issue 'fdatasync'/'msync' (or
the new 'sync_file_range'), and for metadata 'fsync'; or things
like implicit versions of these with filesystem options. But
once the 'fsync' or 'fdatasync' has been issued the file system
code must wait until flush/sync implicit in the barrier is
complete.

Anyhow what the kernel does with 'fsync'/'fdatasync', what the
host adapter or drive controller do, has been controversial, and
depending on Linux kernel versions and host adapter/drive
controller firmware versions different things happen.

Let's say that given this mess it is *exceptionally difficult*
to create an IO subsystem with properly working write barriers
(unless one buy SGI kit of course :->).

A couple of relevant threads:

http://groups.google.com/group/linux.kernel/tree/browse_frm/thread/d343e51655b4ac7c
http://kerneltrap.org/mailarchive/linux-kernel/2008/2/26/987744

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
