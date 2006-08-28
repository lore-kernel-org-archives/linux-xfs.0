Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Aug 2006 18:43:29 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7S1hHDW013396
	for <linux-xfs@OSS.SGI.com>; Sun, 27 Aug 2006 18:43:17 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.62 #1)
	id 1GHW49-0008Lr-Qw
	for <linux-xfs@OSS.SGI.com>; Mon, 28 Aug 2006 02:37:29 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <17650.18647.754049.828428@base.ty.sabi.co.UK>
Date: Mon, 28 Aug 2006 02:37:27 +0100
Subject: Re: libxfs_initbuf can't memalign 4096 bytes: Cannot allocate memory
In-Reply-To: <20060827205119.GA10325@apartia.fr>
References: <20060827072810.GA4098@apartia.fr>
	<20060827204222.GB12065@tuatara.stupidest.org>
	<20060827205119.GA10325@apartia.fr>
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <linux-xfs@oss.sgi.com>

>>> On Sun, 27 Aug 2006 22:51:19 +0200, Louis-David Mitterrand
>>> <vindex+lists-xfs@apartia.org> said:

>> [ ... ] xfs_repair: libxfs_initbuf can't memalign 4096 bytes:
>> Cannot allocate memory [ ... ]

> I had 2GB RAM and a 300GB swap partition and was monitoring
> memory consumption with "top": it never went over 3BG before
> failing.

The default 3GiB address space limit per process on a 32 bit
system is rather well documented, for a summary:

  http://WWW.sabi.co.UK/Notes/#060821c

Let's mention this classic entry again:

  http://OSS.SGI.com/archives/linux-xfs/2005-08/msg00045.html

   «> > Your filesystem (8TiB) may simply bee too large for your
    > > system to be able to repair. Try mounting it on a 64bit
    > > system with more RAM in it and repairing it from there.

    Now that linux supports larger than 2TiB filesystems on 32
    bit systems, this is true for Linux as well.»

A previous entry in the same thread might help too:

  http://OSS.SGI.com/archives/linux-xfs/2005-08/msg00037.html

   «> I try xfs_check and xfs_ncheck (and more progs) with
    > +200GB swap, but no different! less than 1 second and get
    > out of memory.

    Swap won't help if you're running an ia32 (32bit) kernel -
    you have a per-process memory limit of 1-4GiB (depending on
    kernel and config). The amount of physical memory and swap
    does not change this limitation.»

Trying hard to avoid looking at what «has been discussed many
times previously» is a great time saving strategy! :-)
