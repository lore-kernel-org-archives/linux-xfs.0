Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Oct 2007 07:34:31 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9LEYOmP016385
	for <xfs@OSS.SGI.com>; Sun, 21 Oct 2007 07:34:26 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.66 #1)
	id 1IjbPI-00016Z-QK
	for <xfs@OSS.SGI.com>; Sun, 21 Oct 2007 15:03:56 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <18203.23627.917581.549441@base.ty.sabi.co.UK>
Date: Sun, 21 Oct 2007 15:03:55 +0100
Subject: Re: filesystem/disk paper seems to like XFS
In-Reply-To: <Pine.LNX.4.64.0710210416000.18612@p34.internal.lan>
References: <Pine.LNX.4.64.0710210416000.18612@p34.internal.lan>
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <xfs@oss.sgi.com>

>>> On Sun, 21 Oct 2007 04:16:54 -0400 (EDT), Justin Piszcz
>>> <jpiszcz@lucidpixels.com> said:

> http://moo.nac.uci.edu/~hjm/sb/

Thanks for pointing to these tests, but as to their merit there
are quite a few details that to me seem somewhat unclear or naive.

One of the most amusing is this:

 «All the cards performed very well - bandwidth on large writes
  on a 16-disk RAID6 array was measured at >2GB/s on a large
  memory system and up to ~800MB/s on a RAM-constrained system.»

So we have 14 data disks each of which has a raw top (outer
tracks only) speed of around 60MB/s for a total of 840MB/s and
these cards can instead write at over 2000MBs through a file
systems? Hint: «on a large memory system» (and below «ability of
writes to be partially cached») :-). Looks to me that the test
is a complicated way to do 'hpdarm -T' :-).

Even the 800MB/s for the «RAM-constrained system» seems a bit
optimistic, as it is followed by:

 «Large reads were slower, reflecting the ability of writes to
  be partially cached, but were still measured at up to 570MB/s
  on a 16-disk RAID6.»

While to my skeptical eye the «large memory system» test is
about wholly cached writes, the the reported 800MB/s on RAID6
writes seems affected only by partial caching, but still rather
significantly so, as it is rather very unlikely that write speed
can exceed read speed on a RAID6 (assuming read speeds are
reasonable and the reported ones are). Indeed unless perfectly
aligned and sized writes are done (which is harder the wider the
RAID6 is) write speeds will be much lower than read speeds.

Therefore one of the conclusions:

 «The variable that contributed most to better performance was
  amount of system RAM. The more motherboard RAM your storage
  device has, the faster it will perform in almost all
  circumstances.»

seems to me somewhat optimistic, unless «The Storage Brick» is
to be renamed «The Page Cache Brick» :-).

It would be interesting to see more details on the experimental
setup, for example whether the test filesystems were unmounted
between test phases (something that is forgotten by many), RAID
creation parameters (chunk size, interleaving), filesystem
creation parameters (alignment, stride) but I cannot access
(insufficient permissions) the test script...

Also, there is no mention of choice of elevator and flush
parameters, which can have a very large impact on performance.
