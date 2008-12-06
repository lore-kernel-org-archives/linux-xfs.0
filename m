Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB6Ignj4002611 for <xfs@OSS.SGI.com>; Sat, 6 Dec 2008 12:42:49 -0600
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E28816CAED1
	for <xfs@OSS.SGI.com>; Sat,  6 Dec 2008 10:42:47 -0800 (PST)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id h1BIbWZdvVjnjwVG
	for <xfs@OSS.SGI.com>; Sat, 06 Dec 2008 10:42:47 -0800 (PST)
MIME-Version: 1.0
Message-ID: <18746.51094.473042.389299@tree.ty.sabi.co.uk>
Date: Sat, 6 Dec 2008 18:42:30 +0000
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
In-Reply-To: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux XFS <xfs@oss.sgi.com>, Linux RAID <linux-raid@vger.kernel.org>


> Someone should write a document with XFS and barrier support,
> if I recall, in the past, they never worked right on raid1 or
> raid5 devices, but it appears now they they work on RAID1,
> which slows down performance ~12 times!!

Of the many poorly misunderstood, misleading posts to the XFS
and RAID mailing lists this comparison is particularly bad:

> l1:~# /usr/bin/time tar xf linux-2.6.27.7.tar 
> 0.15user 1.54system 0:13.18elapsed 12%CPU (0avgtext+0avgdata 0maxresident)k
> 0inputs+0outputs (0major+325minor)pagefaults 0swaps
> l1:~#

> l1:~# /usr/bin/time tar xf linux-2.6.27.7.tar
> 0.14user 1.66system 2:39.68elapsed 1%CPU (0avgtext+0avgdata 0maxresident)k
> 0inputs+0outputs (0major+324minor)pagefaults 0swaps
> l1:~#

In the first case 'linux-2.6.27.7.tar' is in effect being
extracted to volatile memory (depending on memory size, flusher
parameters, etc., which are gleefully unreported), in the second
to persistent disk; even worse in the particular case it is a
fairly metadata intensive test (25k inodes), and writing lots of
metadata to disk (twice as in RAID1) as opposed to memory of
course is going to be slow.

Comparing the two makes no sense and imparts no useful
information. It would be more interesting to see an analysis
with data and argument as to whether the metadata layout of XFS
is good or bad or how it could be improved; the issue here is
metadata policies, not barriers.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
