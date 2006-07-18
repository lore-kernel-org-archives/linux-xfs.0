Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Jul 2006 16:12:02 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6INBlDW016495
	for <linux-xfs@oss.sgi.com>; Tue, 18 Jul 2006 16:11:48 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.62 #1)
	id 1G2ylm-0005Md-Ir
	for <linux-xfs@oss.sgi.com>; Wed, 19 Jul 2006 00:14:26 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17597.27469.834961.186850@base.ty.sabi.co.UK>
Date: Wed, 19 Jul 2006 00:14:21 +0100
Subject: Re: stable xfs
In-Reply-To: <1153262166.2669.267.camel@localhost.localdomain>
References: <1153150223.4532.24.camel@localhost.localdomain>
	<17595.47312.720883.451573@base.ty.sabi.co.UK>
	<1153262166.2669.267.camel@localhost.localdomain>
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <linux-xfs@oss.sgi.com>

>>> On Tue, 18 Jul 2006 18:36:06 -0400, Ming Zhang
>>> <mingz@ele.uri.edu> said:

mingz> [ .. ] example on what is an improper use?

Well, this mailing list is full of them :-). However it is
easier to say what is an optimal use:

  * A 64 bit system.
  * With a large, parallel storage system.
  * The block IO system handles all storage errors.
  * With backups of the contents of the storage system.

In other words, an Altix in an enterprise computing room... :-)

Something like 64 bit systems running a UNIX-like OS, one system
production and one for backup, each with some TiB of RAID10
storage, both with UPSes giving a significant amount of uptime,
and extensive hot swapping abilities. If you got that, XFS can
give really good performance quite safely.

My impression is that the design of XFS was based on a focus on
performance, at the file system level, via on-disk layout,
massive ''transactions'', and parallel IO requests, assuming
that the block IO subsystem handles every storage error issue
both transparently and gracefully.

It is _possible_, and may even be appropriate after carefully
thinking it through, to use XFS in a 32 bit system without UPS,
and with no storage system redundancy, and with device errors
not handled by the block IO system, and with little parallelism
in the storage subsystem; e.g. a SOHO desktop or server.

But then I have seen people building RAIDs stuffing in a couple
dozen drives from the same shipping box, so improper use of XFS
is definitely a second order issue at that kind of level :-).
