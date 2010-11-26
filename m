Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAQ8F8wr137811 for <xfs@oss.sgi.com>; Fri, 26 Nov 2010 02:15:08 -0600
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CAA6F1C774FA
	for <xfs@oss.sgi.com>; Fri, 26 Nov 2010 00:16:45 -0800 (PST)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id 1oWQEKT1jDetxByk for
	<xfs@oss.sgi.com>; Fri, 26 Nov 2010 00:16:45 -0800 (PST)
Date: Fri, 26 Nov 2010 09:16:22 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Verify filesystem is aligned to stripes
Message-ID: <20101126091622.264830fa@galadriel.home>
In-Reply-To: <4CEEE9BC.2030401@hardwarefreak.com>
References: <4CED5BFC.8000906@shiftmail.org> <20101125054607.GM13830@dastard>
	<4CEE0995.9030900@hardwarefreak.com>
	<20101125101537.GD12187@dastard>
	<4CEEE9BC.2030401@hardwarefreak.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

Le Thu, 25 Nov 2010 16:57:00 -0600 vous =E9criviez:

> Looking at the stripe size, which is equal to 64 sectors per array
> member drive (448 sectors total), how exactly is a sub 4KB mail file
> (8 sectors) going to be split up into equal chunks across a 224KB RAID
> stripe?

It won't, it will simply end on one drive (actually one mirror).
However because the mirrors are striped together, all drives in the
array will be sollicited in my experience, that's why you need at least
as many writing threads as there are stripes to reach the top IOPS. In
your case, writing 56 4K files simultaneously will effectively write on
all drives at once, hopefully (depends upon the filesystem allocation
policy though).

>  Does 220KB of the stripe merely get wasted? =


It's not wasted, it just remains unallocated. What's wasted is
potential IO performance.

What appears from the benchmarks I ran along the year is that anyway
you turn it, whatever caching, command tag queuing and reordering
your're using, a single thread can't reach maximal IOPS throughput on
an array, i. e. writing on all drives simultaneously; a single thread
writing to the fastest RAID 10 with 4K or 8K IOs can't do much better
than with a single drive, 200 to 300 IOPS for a 15k drive.

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
