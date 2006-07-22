Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 22 Jul 2006 10:45:28 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6MHj3DW015116
	for <linux-xfs@OSS.SGI.com>; Sat, 22 Jul 2006 10:45:16 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.62 #1)
	id 1G4LJm-0003zp-Rg
	for <linux-xfs@OSS.SGI.com>; Sat, 22 Jul 2006 18:31:10 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <17602.24798.454081.144575@base.ty.sabi.co.UK>
Date: Sat, 22 Jul 2006 18:31:10 +0100
Subject: Re: stable xfs
In-Reply-To: <20060720061209.GA18135@tuatara.stupidest.org>
References: <1153150223.4532.24.camel@localhost.localdomain>
	<17595.47312.720883.451573@base.ty.sabi.co.UK>
	<1153262166.2669.267.camel@localhost.localdomain>
	<17597.27469.834961.186850@base.ty.sabi.co.UK>
	<1153272044.2669.282.camel@localhost.localdomain>
	<20060719055621.GA1491@tuatara.stupidest.org>
	<17598.3876.565887.172598@base.ty.sabi.co.UK>
	<20060720061209.GA18135@tuatara.stupidest.org>
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <linux-xfs@oss.sgi.com>

>>> On Wed, 19 Jul 2006 23:12:09 -0700, Chris Wedgwood
>>> <cw@f00f.org> said:

[ ... ]

pg> But write barriers are difficult to achieve, and when
pg> achieved they are often unreliable, except on enterprise
pg> level hardware, because many disks/host adapters/...  simply
pg> lie as to whether they have actually started writing (never
pg> mind finished writing, or written correctly) stuff.

cw> IDE/SATA doesn't have barrier to lie about

Actually a very few ATA/SATA do have write barriers, but that is
a just a nitpick, because it is hard to get to them, and anyhow
Linux does not take advantage much :-).

cw> (the kernel has to flush and wait in those cases).

But ATA/SATA flush and wait have the same problems as write
barriers, except worse: disks and ATA/SATA cards do lie too as
to cache flushing. Just getting an ATA/SATA driver or card
manufacturer to tell whether completion of cache flush is
reported when the command is received, or when writing has
started, or when writing has ended, is pretty difficult.

cw> [ ... ] Sanely written applications shouldn't lose data. [
cw> ... ] any sane database should be safe, it will fsync or
cw> similar as needed this is also true for sane MTAs

Sure, in optimal conditions where people running the system and
writing applications know exactly what they are doing and the
storage subsystem has the right semantics, then things are
good. Problem is, ''sanity'' is not entirely common in IT, as
the archives of this mailing list show abundantly.

cw> i've actually tested sitations where transactions were in
cw> flight and i've dropped power on a rack of disks and
cw> verified that when it came up all transactions that we
cw> claimed to have completed really did

I hope that this was with an Altix or equivalently robustly and
advisedly engineered system and storage subsystem... (and I
don't get any commission from SGI :->).

cw> i've also done lesser things will SATA disks and email and
cw> it usually turns out to also be reliable for the most part

Ehehehe here :-). I like the «usually» and «most part». But my
argument is that I guess that is what the 'ext3' designers, but
not the XFS ones, have targeted.

The difference here between XFS and 'ext3' is that with 'ext3'
(and similar) even a not very aware sysadm running on a not very
well chosen system can get ''just works''. Just the 'commit=5'
default of 'ext3' makes *a very large* difference.

My overall message is that using XFS on a system that «usually»
and for the «most part» ''just works'' is not very appropriate...
