Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Jul 2006 03:51:55 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6JApiDW012911
	for <linux-xfs@oss.sgi.com>; Wed, 19 Jul 2006 03:51:45 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.62 #1)
	id 1G39gC-0000zR-Vx
	for <linux-xfs@oss.sgi.com>; Wed, 19 Jul 2006 11:53:25 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <17598.3876.565887.172598@base.ty.sabi.co.UK>
Date: Wed, 19 Jul 2006 11:53:24 +0100
Subject: Re: stable xfs
In-Reply-To: <20060719055621.GA1491@tuatara.stupidest.org>
References: <1153150223.4532.24.camel@localhost.localdomain>
	<17595.47312.720883.451573@base.ty.sabi.co.UK>
	<1153262166.2669.267.camel@localhost.localdomain>
	<17597.27469.834961.186850@base.ty.sabi.co.UK>
	<1153272044.2669.282.camel@localhost.localdomain>
	<20060719055621.GA1491@tuatara.stupidest.org>
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <linux-xfs@oss.sgi.com>

[ ... ]

mingz> when u say large parallel storage system, you mean
mingz> independent spindles right? but most people will have all
mingz> disks configured in one RAID5/6 and thus it is not parallel
mingz> any more.

cw> it depends, you might have 100s of spindles in groups, you
cw> don't make a giant raid5/6 array with that many disks, you
cw> make a number of smaller arrays

Perhaps you are undestimating the ''if it can be done''
mindset...

Also, if one does a number of smaller RAID5s, is each one a
separate filesystem or they get aggregated, for example with
LVM with ''concat''? Either way, how likely is is that the
consequences have been thought through?

I would personally hesitate to recommend either, especially a
two-level arrangement where the base level is a RAID5.

[I am making an effort in this discussion to use euphemisms]

mingz> i think with write barrier support, system without UPS
mingz> should be ok.

cw> with barrier support a UPS shouldn't be necessary

Sure, «should» and «shouldn't» are nice hopeful concepts.

But write barriers are difficult to achieve, and when achieved
they are often unreliable, except on enterprise level hardware,
because many disks/host adapters/...  simply lie as to whether
they have actually started writing (never mind finished writing,
or written correctly) stuff.

To get reliable write barrier often one has to source special
cards or disks with custom firmware; or leave system integration
to the big expensive guys and buy an Altix or equivalent system
from Sun or IBM.

Besides I have seen many reports of ''corruption'' that cannot
be fixed by write barriers: many have the expectation that
*data* should not be lost, even if no 'fsync' is done, *as if*
'mount -o sync' or 'mount -o data=ordered'.

Of course that is a bit of an inflated expectation, but all that
the vast majority of sysadms care about is whether it ''just
works'', without ''wasting time'' figuring things out.

mingz> considering even u have UPS, kernel oops in other parts
mingz> still can take the FS down.

cw> but a crash won't cause writes to be 'reordered' [ ... ]

The metadata will be consistent, but metadata and data may well
will be lost. So the filesystem is still ''corrupted'', at least
from the point of view of a sysadm who just wants the filesystem
to be effortlessly foolproof. Anyhow, if a crash happens all
bets are off, because who knows *what* gets written.

Look at it from the point of view of a ''practitioner'' sysadm:

  ''who cares if the metadata is consistent, if my 3TiB
  application database is unusable (and I don't do backups
  because after all it is a concat of RAID5s, backups are not
  necessary) as there is a huge gap in some data file, and my
  users are yelling at me, and it is not my fault''

The tradeoff in XFS is that if you know exactly what you are
doing you get extra performance...
