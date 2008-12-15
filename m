Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBFIniKj029699
	for <linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 12:49:47 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 31C5F1733A4B
	for <linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 10:49:41 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id 7Jf6IGlHIGRrQyab for
	<linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 10:49:41 -0800 (PST)
Received: from shambhala.lichtvoll.local
	(DSL01.83.171.170.108.ip-pool.NEFkom.net [83.171.170.108])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id B4E055AE18
	for <linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 19:49:05 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Date: Mon, 15 Dec 2008 19:48:59 +0100
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
	<200812141912.59649.Martin@lichtvoll.de>
	<18757.33373.744917.457587@tree.ty.sabi.co.uk>
	(sfid-20081215_095747_992215_AEAEC38B)
In-Reply-To: <18757.33373.744917.457587@tree.ty.sabi.co.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812151948.59870.Martin@lichtvoll.de>
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
To: linux-xfs@oss.sgi.com

Am Sonntag 14 Dezember 2008 schrieb Peter Grandi:
> [ ... ]
> > But - as far as I understood - the filesystem doesn't have to
> > wait for barriers to complete, but could continue issuing IO
> > requests happily. A barrier only means, any request prior to
> > that have to land before and any after it after it.
> >
> > It doesn't mean that the barrier has to land immediately and
> > the filesystem has to wait for this. At least that always was
> > the whole point of barriers for me. If thats not the case I
> > misunderstood the purpose of barriers to the maximum extent
> > possible.
>
> Unfortunately that seems the case.
>
> The purpose of barriers is to guarantee that relevant data is
> known to be on persistent storage (kind of hardware 'fsync').
>
> In effect write barrier means "tell me when relevant data is on
> persistent storage", or less precisely "flush/sync writes now
> and tell me when it is done". Properties as to ordering are just
> a side effect.

Interesting to know. Thanks for long explaination.

Unfortunately in my understanding none of this is reflected by

Documentation/block/barrier.txt

Especially this mentions:

---------------------------------------------------------------------
I/O Barriers
============
Tejun Heo <htejun@gmail.com>, July 22 2005

I/O barrier requests are used to guarantee ordering around the barrier
requests.  Unless you're crazy enough to use disk drives for
implementing synchronization constructs (wow, sounds interesting...),
the ordering is meaningful only for write requests for things like
journal checkpoints.  All requests queued before a barrier request
must be finished (made it to the physical medium) before the barrier
request is started, and all requests queued after the barrier request
must be started only after the barrier request is finished (again,
made it to the physical medium)

In other words, I/O barrier requests have the following two properties.

1. Request ordering

Requests cannot pass the barrier request.  Preceding requests are
processed before the barrier and following requests after.

Depending on what features a drive supports, this can be done in one
of the following three ways.

i. For devices which have queue depth greater than 1 (TCQ devices) and
support ordered tags, block layer can just issue the barrier as an
ordered request and the lower level driver, controller and drive
itself are responsible for making sure that the ordering constraint is
met.  Most modern SCSI controllers/drives should support this.

NOTE: SCSI ordered tag isn't currently used due to limitation in the
      SCSI midlayer, see the following random notes section.

ii. For devices which have queue depth greater than 1 but don't
support ordered tags, block layer ensures that the requests preceding
a barrier request finishes before issuing the barrier request.  Also,
it defers requests following the barrier until the barrier request is
finished.  Older SCSI controllers/drives and SATA drives fall in this
category.

iii. Devices which have queue depth of 1.  This is a degenerate case
of ii.  Just keeping issue order suffices.  Ancient SCSI
controllers/drives and IDE drives are in this category.


2. Forced flushing to physical medium

Again, if you're not gonna do synchronization with disk drives (dang,
it sounds even more appealing now!), the reason you use I/O barriers
is mainly to protect filesystem integrity when power failure or some
other events abruptly stop the drive from operating and possibly make
the drive lose data in its cache.  So, I/O barriers need to guarantee
that requests actually get written to non-volatile medium in order.

There are four cases,

i. No write-back cache.  Keeping requests ordered is enough.

ii. Write-back cache but no flush operation.  There's no way to
guarantee physical-medium commit order.  This kind of devices can't to
I/O barriers.

iii. Write-back cache and flush operation but no FUA (forced unit
access).  We need two cache flushes - before and after the barrier
request.

iv. Write-back cache, flush operation and FUA.  We still need one
flush to make sure requests preceding a barrier are written to medium,
but post-barrier flush can be avoided by using FUA write on the
barrier itself.
---------------------------------------------------------------------

I do not see any mention of "tell me when its finished" in that file. It 
just mentions that a cache flush has to be issued before the write 
barrier and then it shall issue the barrier either as a FUA (forced unit 
access) request or it shall issue a cache flush after the barrier 
request. No where it is written that this has to happen immediately. The 
documentation file is mainly about ordering requests instead and that 
cache flushes may be used to enforce that regular requests cannot pass 
barrier requests.

Nor do I understand why the filesystem needs to know whether a barrier has 
been completed - it just needs to know whether the block device / driver 
can handle barrier requests. If the filesystem knows that requests are 
written with certain order constraint, then it shouldn't matter when they 
are written. When should be a choice of the user on how much data she / 
he risks to loose in case of a sudden interruption of writing out 
requests.

Thus I think the mentioned documentation is at least misleading, if your 
description matches the actual implementation of write barriers. Then I 
think it should be adapted, changed.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
