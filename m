Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 22 Jul 2006 10:45:33 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6MHjLDW015192
	for <linux-xfs@OSS.SGI.com>; Sat, 22 Jul 2006 10:45:21 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.62 #1)
	id 1G4LZj-00040s-3Z
	for <linux-xfs@OSS.SGI.com>; Sat, 22 Jul 2006 18:47:39 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <17602.25786.352484.487632@base.ty.sabi.co.UK>
Date: Sat, 22 Jul 2006 18:47:38 +0100
Subject: Re: stable xfs
In-Reply-To: <1153404502.2768.50.camel@localhost.localdomain>
References: <1153150223.4532.24.camel@localhost.localdomain>
	<17595.47312.720883.451573@base.ty.sabi.co.UK>
	<1153262166.2669.267.camel@localhost.localdomain>
	<17597.27469.834961.186850@base.ty.sabi.co.UK>
	<1153272044.2669.282.camel@localhost.localdomain>
	<17598.2129.999932.67127@base.ty.sabi.co.UK>
	<1153314670.2691.14.camel@localhost.localdomain>
	<20060720061527.GB18135@tuatara.stupidest.org>
	<1153404502.2768.50.camel@localhost.localdomain>
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <linux-xfs@oss.sgi.com>

>>> On Thu, 20 Jul 2006 10:08:22 -0400, Ming Zhang
>>> <mingz@ele.uri.edu> said:

[ ... ]

mingz> hope i never need to run repair,

A ''strategic'' attitude :-).

mingz> but i do need to defrag from time to time.

As to defrag, I reckon that defrag-in-place is a very bad idea,
but I have to admit that contrary evidence exists, and I was
rather surprised to read this:

  http://OSS.SGI.com/archives/xfs/2006-03/msg00110.html

   «> How many people defrag their filesystems using xfs_fsr
    > /dev/PARTITION if their fragmentation is > 50% etc?  Does
    > anyone regularly defrag their production filesystems or
    > just defrag their filesystems on a regular basis?

    We have several hundred production filesystems defragmented
    every night.»

Even so I think that defragment-by-copy is a much better option.

mingz> [ ... ] we mainly handle large media files like 20-50GB.
mingz> [ ....] hope this does not hold true for a 15x750GB SATA
mingz> raid5. ;)
mingz> [ ... ] say XFS can make use of parallel storage by using
mingz> multiple allocation groups. but XFS need to be built over
mingz> one block device. so if i have 4 smaller raid, i have to
mingz> use LVM to glue them before i create XFS over it right?

Well, I'll just hint that I cannot find euphemisms suitable for
expressing what I think of this setup :-).

mingz> but then u said XFS over LVM or N MD is not good?

It was me saying that [euphemism alert!] I would not recommend a
setup like that without understanding very well the consequences.
