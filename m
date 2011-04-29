Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3TEvcZT067723 for <xfs@OSS.SGI.com>; Fri, 29 Apr 2011 09:57:39 -0500
Received: from hermes1.dur.ac.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC6CE1558E17
	for <xfs@OSS.SGI.com>; Fri, 29 Apr 2011 08:01:11 -0700 (PDT)
Received: from hermes1.dur.ac.uk (hermes1.dur.ac.uk [129.234.248.1]) by
	cuda.sgi.com with ESMTP id 7dUhZa1rZXOmf149 for
	<xfs@OSS.SGI.com>; Fri, 29 Apr 2011 08:01:11 -0700 (PDT)
Received: from smtphost4.dur.ac.uk (smtphost4.dur.ac.uk [129.234.252.4])
	by hermes1.dur.ac.uk (8.13.8/8.13.7) with ESMTP id p3TF0uKL019611
	for <xfs@OSS.SGI.com>; Fri, 29 Apr 2011 16:01:00 +0100
Received: from ty.sabi.co.UK (o1.phyip3.dur.ac.uk [129.234.186.1])
	by smtphost4.dur.ac.uk (8.13.8/8.13.7) with ESMTP id p3TF0ilZ008255
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <xfs@OSS.SGI.com>; Fri, 29 Apr 2011 16:00:44 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1QFpBN-0005J7-WE
	for <xfs@OSS.SGI.com>; Fri, 29 Apr 2011 16:00:38 +0100
MIME-Version: 1.0
Message-ID: <19898.53907.842827.480883@tree.ty.sabi.co.UK>
Date: Fri, 29 Apr 2011 16:00:35 +0100
Subject: Re: xfs performance problem
In-Reply-To: <4DB75C6D.1080901@inf.ethz.ch>
References: <4DB72084.8020205@inf.ethz.ch> <4DB74331.3030804@hardwarefreak.com>
	<4DB75C6D.1080901@inf.ethz.ch>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: Linux fs XFS <xfs@oss.sgi.com>


[ ... ]

> On my raid-1 ext3, extracting a kernel archive:
[ ... ]
> real    0m21.769s
[ ... ]
> real    2m20.522s

> This is of course with delaylog enabled. I don't think a
> difference of a factor 7 is normal, given that writing to a
> raid-0 (xfs numbers) is supposed to be faster than writing to
> raid-1 (ext3 numbers)

Indeed, and as some other commenters have tried to explain, in
most cases the wrong number is the one for 'ext3' on RAID1 (way
too small). Even the number for XFS and RAID0 'delaylog' is a
wrong number (somewhat small) in many cases.

There are 38000 files in 440MB in 'linux-2.6.38.tar', ~40% of
them are smaller than 4KiB and ~60% smaller than 8KiB. Also you
didn't flush caches, and you don't say whether the filesystems
are empty or full or at the same position on the disk.

Can 'ext3' really commit 1900 small files per second (including
directory updates) to a filesystem on a RAID1 that probably can
do around 100 IOPS? That would be amazing news.

Despite decades of seeing it happen, I keep being astonished by
how many people (some with decades of "experience") just don't
understand IOPS and metadata and commits and caching and who
think "performance" is whatever number they can get with their
clever "benchmarks".

[ ... ]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
