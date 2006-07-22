Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 22 Jul 2006 10:45:29 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6MHjHDW015160
	for <linux-xfs@oss.sgi.com>; Sat, 22 Jul 2006 10:45:17 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.62 #1)
	id 1G4L2h-0003z3-9k
	for <linux-xfs@oss.sgi.com>; Sat, 22 Jul 2006 18:13:31 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17602.23734.534732.678392@base.ty.sabi.co.UK>
Date: Sat, 22 Jul 2006 18:13:26 +0100
Subject: Re: stable xfs
In-Reply-To: <1153320304.2691.56.camel@localhost.localdomain>
References: <1153150223.4532.24.camel@localhost.localdomain>
	<17595.47312.720883.451573@base.ty.sabi.co.UK>
	<1153262166.2669.267.camel@localhost.localdomain>
	<17597.27469.834961.186850@base.ty.sabi.co.UK>
	<1153272044.2669.282.camel@localhost.localdomain>
	<20060719055621.GA1491@tuatara.stupidest.org>
	<17598.3876.565887.172598@base.ty.sabi.co.UK>
	<1153320304.2691.56.camel@localhost.localdomain>
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <linux-xfs@oss.sgi.com>

>>> On Wed, 19 Jul 2006 10:45:04 -0400, Ming Zhang
>>> <mingz@ele.uri.edu> said:

[ ... ]

>> Also, if one does a number of smaller RAID5s, is each one a
>> separate filesystem or they get aggregated, for example with
>> LVM with ''concat''? Either way, how likely is is that the
>> consequences have been thought through?
>> 
>> I would personally hesitate to recommend either, especially a
>> two-level arrangement where the base level is a RAID5.

mingz> could u give us some hints on this?

Well, RAID5 itself is in general a very bad idea, as well argued
here: <URL:http://WWW.BAARF.com/> and a LVM based concat (which is
the slow version of RAID0) of RAID5 volumes has quite terrible
performance and redundancy aspects that nicely match those of
RAID5.

Imagine a 4TB volume build as a concat/span of 4 RAID5 volumes,
each done as a 1TB RAID5 of 4+1 250GB disks. Under which
conditions do you lose the whole lot?

Compare the same with a RAID0 of RAID1 pairs...

mingz> since it is really popular to have a FS/LV/MD structure

Sure, and it is also really popular to do 5+1 or 11+1 RAID5s and
to stuff them all with disks of the same model, and even from the
same shipping carton...

mingz> and I believe LVM is designed for this purpose.

Yes and no. LVM's main purpose, if any, is to outgrow the
limitation on the number of partitions in most, and PC-based
in particular, partitioning schemes. This means that LVM is
of benefit only in very few cases, those where one needs a lot
of partitions (as such, not as a cheap quota scheme).

[ ... ]

>> ''who cares if the metadata is consistent, if my 3TiB
>> application database is unusable (and I don't do backups
>> because after all it is a concat of RAID5s, backups are not
>> necessary) as there is a huge gap in some data file, and my
>> users are yelling at me, and it is not my fault''

>> The tradeoff in XFS is that if you know exactly what you are
>> doing you get extra performance...

mingz> then i think unless you disable all write cache,

Not even then, because storage subsystems often do lie about
that. Only very clever system integrators and usually only those
with a big wallet can manage to build storage subsystems with
reliable caching semantics (including write barriers).

mingz> none of the file system can achieve this goal.

Well, some people might want to argue that a filesystem *should
not* be designed to achieve that goal, because it is a goal that
does not make sense in an ideal world in which people know exactly
what they are doing.

mingz> or maybe ext3 with both data and metadata into log might
mingz> do this?

Well, 'data=ordered' and especially 'data=journal' (and the low
default value of 'commit=5') most often give at a moderate cost
the illusion that the file system and storage system ''just
work'', when they don't. This creates issues when discussing the
relative merits of 'ext3' vs. other filesystems which are less
forgiving.

Eventually the XFS and 'ext3' designers seem to have chosen very
different assumptions about their user base:

* the XFS designers probably assumed that their user based would
  be big iron people with a high degree of understanding of
  storage systems and optimal hardware conditions, and interested
  in maximally scalable performance (e.g. Altix customers in HPC);

* the 'ext3' guys seem to have assumed their user base would be
  general users slamming together stuff on the cheap without much
  awareness or thought as to storage system engineering, and
  interested in ''just works, most of the time''.
