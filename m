Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5LFpd6Q088454 for <xfs@oss.sgi.com>; Thu, 21 Jun 2012 10:51:40 -0500
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id weM6l6eKKmT5vZXd (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Jun 2012 08:51:38 -0700 (PDT)
Received: from telerig.nabble.com ([192.168.236.162])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1ShjfW-0005Xb-84
	for xfs@oss.sgi.com; Thu, 21 Jun 2012 08:51:38 -0700
Message-ID: <34049469.post@talk.nabble.com>
Date: Thu, 21 Jun 2012 08:51:38 -0700 (PDT)
From: pkamala <priya.kamala@perpetual-data.com>
Subject: Possible memory allocation deadlock - kernel 3.2.1
MIME-Version: 1.0
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
To: xfs@oss.sgi.com


Hi all,

I am testing the kernel 3.2.1 (32-bit) XFS filesystem on a 1 TB LVM logical
volume. The volume currently has 3653816 files, 3655726 used inodes and 782G
free space. When the volume is mounted, quotacheck starts up and after about
5 minutes the oom-killer is triggered and starts killing processes. From the
message log, it looks like the system is running out of Normal memory. After
a while I see the following messages after which I power cycle the system:

XFS: possible memory allocation deadlock in kmem_zone_alloc (mode: 0x2d0)
XFS: possible memory allocation deadlock in xfs_buf_allocate_memory (mode:
0x250)

The kernel is configured for 2G/2G memory split. I tried setting
vm.overcommit_memory to 2 and vm.overcommit_ratio first to 80 and then 50
and that did not help.

The server has an Intel Quad core Xeon CPU X3450 @ 2.67GHz with 4 GB RAM.
The swap partition is 8GB in size.

Is this a known issue and if so, is a patch available? Is there a kernel
configuration parameter that can be adjusted to fix this?

Do let me know if you need additional information about the test setup or
kernel configuration.

Thanks for your help.

Priya


-- 
View this message in context: http://old.nabble.com/Possible-memory-allocation-deadlock---kernel-3.2.1-tp34049469p34049469.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
