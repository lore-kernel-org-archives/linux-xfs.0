Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Oct 2007 07:34:27 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9LEYI1N016377
	for <xfs@OSS.SGI.com>; Sun, 21 Oct 2007 07:34:22 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.66 #1)
	id 1IjaZQ-00012s-Hj
	for <xfs@OSS.SGI.com>; Sun, 21 Oct 2007 14:10:20 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18203.20410.194973.842271@base.ty.sabi.co.UK>
Date: Sun, 21 Oct 2007 14:10:18 +0100
Subject: Re: filesystem/disk paper seems to like XFS
In-Reply-To: <Pine.LNX.4.64.0710210416000.18612@p34.internal.lan>
References: <Pine.LNX.4.64.0710210416000.18612@p34.internal.lan>
From: pg_xfs@xfs.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <xfs@oss.sgi.com>

>>> On Sun, 21 Oct 2007 04:16:54 -0400 (EDT), Justin Piszcz
>>> <jpiszcz@lucidpixels.com> said:

jpiszcz> What they do not talk about is how bad JFS "supposedly"
jpiszcz> gets after 1-2 years of usage regarding fragmentation

I have quite a bit of experience of JFS slowdown caused by
fragmentation as I use JFS for my root filesystem and after a
few months of very intense updates and rewrites overall speed
goes down by a factor of around 2.5 which seems to me to be
fairly good (at least as compared to a slowdown of a factor of 7
with 'ext3'). I have little idea of how much XFS slows down with
time, as I don't use it for my ''root'' filesystem, but it seems
comparable to JFS. This is not awesome either, but somewhat
understandable.

Part of the reason is that filesystem competitive benchmarks
that file system designers care about seem all about freshly
loaded filesystems; also it is not easy to do absolutely
equivalent updates...

And the claim to fame for XFS is not steady performance across
updates, it is high aggregate multi-process/multi-stream
performance *on a freshly constructed* filesystem (well, I have
seen impressive performance in such a case).

jpiszcz> and how there is no defragmenting tool for JFS.

I have thought about taking an existing attempt as a JFS
defragmenter and completing it, but I have realized that
in-place defragmentation is usually a very bad idea in almost
all cases, both for performance and safety reasons, and copying
and switching is the only sensible way. The argument is that in
most cases it is unsafe to defragment in-place without prior
backup, and the backup is a much faster way to ''straighten
out'' the files anyhow.

Of course this runs into the problem that one has to take the
filesystem offline for some time to switch, but then current
file systems are simply not designed (with the claimed exception
of ZFS suitably configured) as VLDBs (''a VLDB is a database
that is so large that it is impractical to take it offline to
backup''), just consider the 'fsck' time/space problem.
