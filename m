Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB6EYNs9021873 for <xfs@oss.sgi.com>; Sat, 6 Dec 2008 08:34:23 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38C6D1B94BD7
	for <xfs@oss.sgi.com>; Sat,  6 Dec 2008 06:34:22 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id 0tfaFMAuDZkQ3hfB for
	<xfs@oss.sgi.com>; Sat, 06 Dec 2008 06:34:22 -0800 (PST)
Date: Sat, 6 Dec 2008 09:28:50 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Message-ID: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
MIME-Version: 1.0
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
To: linux-raid@vger.kernel.org, xfs@oss.sgi.com
Cc: Alan Piszcz <ap@solarrain.com>

Someone should write a document with XFS and barrier support, if I recall,
in the past, they never worked right on raid1 or raid5 devices, but it
appears now they they work on RAID1, which slows down performance ~12 times!!

l1:~# /usr/bin/time tar xf linux-2.6.27.7.tar 
0.15user 1.54system 0:13.18elapsed 12%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+325minor)pagefaults 0swaps
l1:~#

l1:~# /usr/bin/time tar xf linux-2.6.27.7.tar
0.14user 1.66system 2:39.68elapsed 1%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+324minor)pagefaults 0swaps
l1:~#

Before:
/dev/md2        /               xfs     defaults,noatime  0       1

After:
/dev/md2        /               xfs     defaults,noatime,nobarrier,logbufs=8,logbsize=262144 0 1

There is some mention of it here:
http://oss.sgi.com/projects/xfs/faq.html#wcache_persistent

But basically I believe it should be noted in the kernel logs, FAQ or somewhere
because just through the process of upgrading the kernel, not changing fstab
or any other part of the system, performance can drop 12x just because the
newer kernels implement barriers.

Justin.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
