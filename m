Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 10:47:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2OHlRK7031539
	for <xfs@OSS.SGI.com>; Mon, 24 Mar 2008 10:47:28 -0700
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6C2E36DDDB9
	for <xfs@OSS.SGI.com>; Mon, 24 Mar 2008 10:48:00 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138]) by cuda.sgi.com with ESMTP id b5bmz4F3RbhAVB9y for <xfs@OSS.SGI.com>; Mon, 24 Mar 2008 10:48:00 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.66 #1)
	id 1JdoXY-0002Fa-SV
	for <xfs@OSS.SGI.com>; Mon, 24 Mar 2008 15:24:48 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18407.51134.786769.234995@tree.ty.sabi.co.uk>
Date: Mon, 24 Mar 2008 15:24:46 +0000
Subject: Re: Poor VMWare disk performance on XFS partition
In-Reply-To: <47E7B3E4.1020205@thebarn.com>
References: <876423.51989.qm@web52006.mail.re2.yahoo.com>
	<Pine.LNX.4.64.0803240126501.4354@alienAngel.home.sk>
	<47E7B3E4.1020205@thebarn.com>
From: pg_xfs2@xfs2.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <xfs@oss.sgi.com>

>>> On Mon, 24 Mar 2008 09:00:04 -0500, Russell Cattelan
>>> <cattelan@thebarn.com> said:

>> [ ... ] Mount XFS partition with "nobarrier" option. [ ... ]

> I can verify that ... barriers are killers when running vmware
> guest disk/memory images. [ ... ]

But of course running VM images with 'nobarrier' is quite brave:
because it removes *any* integrity guarantee to IO initiated
inside the virtual machine.

This is because the only safe behaviour for a virtual machine
software is to turn all VM storage operations into synchronous
ones (or else detect the use of barriers inside the virtual
machine).

Of course this is going to be catastrophic with XFS's delayed
allocations, which relies on large numbers of outstanding writes
to coalesce them into large segments.

> [ ... ] The preallocation would also help out quite bit if you
> don't mind dedicating the disk space vs the sparse file method,
> which allow for over subscribing the physical space. [ ... ]

But sparse files are a crazy idea for virtual machines, because
the software inside is built on the idea that its storage is
allocated in contiguous volumes, and relies on that for its own
optimizations.

Or else one ends up with a CP/CMS situation where the "CMS"
inside the virtual machine is fully aware that it is running
inside a virtual machine and passes "out-of-bandwidth" hints to
the virtual machine software.
