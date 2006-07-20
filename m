Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Jul 2006 23:12:43 -0700 (PDT)
Received: from smtp114.sbc.mail.mud.yahoo.com (smtp114.sbc.mail.mud.yahoo.com [68.142.198.213])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6K6CXDW031260
	for <linux-xfs@oss.sgi.com>; Wed, 19 Jul 2006 23:12:33 -0700
Date: Wed, 19 Jul 2006 23:12:09 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: stable xfs
Message-ID: <20060720061209.GA18135@tuatara.stupidest.org>
References: <1153150223.4532.24.camel@localhost.localdomain> <17595.47312.720883.451573@base.ty.sabi.co.UK> <1153262166.2669.267.camel@localhost.localdomain> <17597.27469.834961.186850@base.ty.sabi.co.UK> <1153272044.2669.282.camel@localhost.localdomain> <20060719055621.GA1491@tuatara.stupidest.org> <17598.3876.565887.172598@base.ty.sabi.co.UK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17598.3876.565887.172598@base.ty.sabi.co.UK>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Grandi <pg_xfs@xfs.for.sabi.co.UK>
Cc: Linux XFS <linux-xfs@oss.sgi.com>

On Wed, Jul 19, 2006 at 11:53:24AM +0100, Peter Grandi wrote:

> But write barriers are difficult to achieve, and when achieved they
> are often unreliable, except on enterprise level hardware, because
> many disks/host adapters/...  simply lie as to whether they have
> actually started writing (never mind finished writing, or written
> correctly) stuff.

IDE/SATA doesn't have barrier to lie about (the kernel has to flush
and wait in those cases).

> The metadata will be consistent, but metadata and data may well will
> be lost. So the filesystem is still ''corrupted'', at least from the
> point of view of a sysadm who just wants the filesystem to be
> effortlessly foolproof.

Sanely written applications shouldn't lose data.

> Look at it from the point of view of a ''practitioner'' sysadm:
>
>   ''who cares if the metadata is consistent, if my 3TiB
>   application database is unusable (and I don't do backups

any sane database should be safe, it will fsync or similar as needed

this is also true for sane MTAs


i've actually tested sitations where transactions were in flight and
i've dropped power on a rack of disks and verified that when it came
up all transactions that we claimed to have completed really did

i've also done lesser things will SATA disks and email and it usually
turns out to also be reliable for the most part
