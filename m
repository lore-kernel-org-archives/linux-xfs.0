Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Sep 2007 02:26:42 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8T9QapA024685
	for <linux-xfs@OSS.SGI.com>; Sat, 29 Sep 2007 02:26:39 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.66 #1)
	id 1IbYaz-0003IA-W0
	for <linux-xfs@OSS.SGI.com>; Sat, 29 Sep 2007 10:26:46 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18174.6741.713682.563043@base.ty.sabi.co.UK>
Date: Sat, 29 Sep 2007 10:26:45 +0100
Subject: Re: Truncated Filesystem
In-Reply-To: <Pine.LNX.4.58.0709282214540.14057@puck.litech.org>
References: <Pine.LNX.4.58.0709281734490.14057@puck.litech.org>
	<Pine.LNX.4.64.0709281821390.12203@p34.internal.lan>
	<46FD9006.6050807@sandeen.net>
	<46FD959E.5030009@zytor.com>
	<Pine.LNX.4.58.0709282048440.14057@puck.litech.org>
	<alpine.LRH.0.9999.0709282145490.22882@hogwarts.egr.duke.edu>
	<Pine.LNX.4.58.0709282214540.14057@puck.litech.org>
From: pg_mh@sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <linux-xfs@oss.sgi.com>

>>> On Fri, 28 Sep 2007 22:15:18 -0400 (EDT), Benjamin Carr
>>> <bcarr@whoi.edu> said:

[ ... ]

bcarr> climate:~ benc$ sudo parted /dev/sdc check 1
bcarr> Warning: Partition 1 is 2005GB, but the file system is 13TB.
bcarr> Yeah, that is a problem.

Note that unless you have a compelling reason to partition it
may be easiest to use the block devices directly, or else your
next question will likely be about poor performance because of
misaligned striping :-).
