Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n69ECls5032219 for <xfs@oss.sgi.com>; Thu, 9 Jul 2009 09:12:47 -0500
Received: from mail-bw0-f214.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E57A352592
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2009 07:13:23 -0700 (PDT)
Received: from mail-bw0-f214.google.com (mail-bw0-f214.google.com
	[209.85.218.214]) by cuda.sgi.com with ESMTP id
	qXHML4VkG5isvI6O for <xfs@oss.sgi.com>;
	Thu, 09 Jul 2009 07:13:23 -0700 (PDT)
Received: by bwz10 with SMTP id 10so174823bwz.20
	for <xfs@oss.sgi.com>; Thu, 09 Jul 2009 07:13:22 -0700 (PDT)
Message-ID: <4A55FAF7.5040908@gmail.com>
Date: Thu, 09 Jul 2009 16:13:11 +0200
From: Tomek Kruszona <bloodyscarion@gmail.com>
MIME-Version: 1.0
Subject: xfs_repair stops on "traversing filesystem..."
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

Hello!

I have a little problem with XFS filesystem that I have on one of my
machines. I try to make xfs_repair that was not making any problems
before, but xfs_repair stops on:

Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...

CPU usage grows up to 100%. I left it in the night hoping it will finish
job till morning, but the situation hasn't changed...

System is Debian Lenny with current updates and custom 2.6.30.1 kernel
xfsprogs-2.9.8. Filesysystem is placed on LVM2 Logical Volume.

I upgraded xfsprogs to 3.0.2 version and the problem still persists.
Then I reverted to 2.9.8 package from Debian Lenny.
Switching back to debian default 2.6.26 kernel doesn't help too.

I can mount this filesystem and operate on it.

Data on this system is not so crucial, because it's backup/testing
machine, but it would be great to keep this data, because synchronizing
14TB of data will take some time.

Output from xfs_info:
# xfs_info /mnt/storage/
meta-data=/dev/mapper/p02bvg-p02blv isize=256    agcount=32,
agsize=268435455 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=8410889216, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

Any ideas how to make xfs_repair working again?

Best regards,
Tomasz Kruszona





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
