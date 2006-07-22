Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 22 Jul 2006 10:45:31 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6MHjIDW015176
	for <linux-xfs@oss.sgi.com>; Sat, 22 Jul 2006 10:45:19 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.62 #1)
	id 1G4JY2-0003pG-6C
	for <linux-xfs@oss.sgi.com>; Sat, 22 Jul 2006 16:37:46 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <17602.17985.533632.85589@base.ty.sabi.co.UK>
Date: Sat, 22 Jul 2006 16:37:37 +0100
Subject: Re: stable xfs
In-Reply-To: <1153314670.2691.14.camel@localhost.localdomain>
References: <1153150223.4532.24.camel@localhost.localdomain>
	<17595.47312.720883.451573@base.ty.sabi.co.UK>
	<1153262166.2669.267.camel@localhost.localdomain>
	<17597.27469.834961.186850@base.ty.sabi.co.UK>
	<1153272044.2669.282.camel@localhost.localdomain>
	<17598.2129.999932.67127@base.ty.sabi.co.UK>
	<1153314670.2691.14.camel@localhost.localdomain>
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <linux-xfs@oss.sgi.com>

>>> On Wed, 19 Jul 2006 09:11:10 -0400, Ming Zhang
>>> <mingz@ele.uri.edu> said:

[ ... ]

mingz> what kind of "ram vs fs" size ratio here will be a
mingz> safe/good/proper one?  any rule of thumb? thanks! hope
mingz> not 1:1. :)

This is driven mostly by the space required by check/repair
(which can well be above 4GiB, so 64 bit systems are often
required):

  http://OSS.SGI.com/archives/linux-xfs/2005-08/msg00045.html

   «e.g. it took 1.5GiB RAM for 32bit xfs_check and 2.7GiB RAM
    for a 64bit xfs_check on a 1.1TiB filesystem with 3million
    inodes in it.»

It suggests that a 10TB filesystem might need from about 15
gigabytes of RAM (or swap, with corresponding slowdown), after
all only less than 0.2% of its size.

Anyhow, a system with lots of RAM to speedly check/repair an
XFS filesystem also benefits from the same RAM for caching and
delayed writing, so it is all for good (as long as one has a
perfectly reliable block IO subsystem).

Note that the 15 gigabytes in the example above are well above
what a 32 bit process can address, thus for multi-terabyte
filesystem one should really have a 64 bit system (from the same
article mentioned above):

  http://OSS.SGI.com/archives/linux-xfs/2005-08/msg00045.html

   «> > Your filesystem (8TiB) may simply bee too large for your
    > > system to be able to repair. Try mounting it on a 64bit
    > > system with more RAM in it and repairing it from there.
    > 
    > Sorry, but is this a joke?

    A joke? Absolutely not.

    Acheivable XFS filesystem sizes outgrew the capability of 32
    bit Irix systems to repair them several years ago. Now that
    linux supports larger than 2TiB filesystems on 32 bit
    systems, this is true for Linux as well.»
