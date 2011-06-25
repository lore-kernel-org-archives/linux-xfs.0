Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5PJo8Di135459
	for <linux-xfs@oss.sgi.com>; Sat, 25 Jun 2011 14:50:08 -0500
Received: from smtp1.task.com.br (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F31F92E4B5
	for <linux-xfs@oss.sgi.com>; Sat, 25 Jun 2011 12:49:56 -0700 (PDT)
Received: from smtp1.task.com.br (smtp1.task.com.br [174.37.54.130]) by
	cuda.sgi.com with ESMTP id Y9gyGhF7pySdZM1O for
	<linux-xfs@oss.sgi.com>; Sat, 25 Jun 2011 12:49:56 -0700 (PDT)
Message-ID: <4E063BC6.9000801@task.com.br>
Date: Sat, 25 Jun 2011 16:49:26 -0300
From: Marcus Pereira <marcus@task.com.br>
MIME-Version: 1.0
Subject: mkfs.xfs error creating large agcount an raid
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

I have an issue when creating xfs volume using large agcounts on raid 
volumes.

/dev/md0 is a 4 disks raid 0 array:

----------------------------------------
# mkfs.xfs -V
mkfs.xfs version 3.1.4

# mkfs.xfs -d agcount=1872 -b size=4096 /dev/md0 -f
Warning: AG size is a multiple of stripe width.  This can cause performance
problems by aligning all AGs on the same disk.  To avoid this, run mkfs with
an AG size that is one stripe unit smaller, for example 147840.
log stripe unit (524288 bytes) is too large (maximum is 256KiB)
log stripe unit adjusted to 32KiB
meta-data=/dev/md0               isize=256    agcount=1872, 
agsize=147968 blks
          =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=276810752, imaxpct=5
          =                       sunit=128    swidth=512 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=135168, version=2
          =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
mkfs.xfs: pwrite64 failed: No space left on device

# mkfs.xfs -d agcount=1871 -b size=4096 /dev/md0 -f
Warning: AG size is a multiple of stripe width.  This can cause performance
problems by aligning all AGs on the same disk.  To avoid this, run mkfs with
an AG size that is one stripe unit smaller, for example 147840.
log stripe unit (524288 bytes) is too large (maximum is 256KiB)
log stripe unit adjusted to 32KiB
meta-data=/dev/md0               isize=256    agcount=1871, 
agsize=147968 blks
          =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=276810752, imaxpct=5
          =                       sunit=128    swidth=512 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=135168, version=2
          =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

----------------------------------------------

Any agcount greater then 1871 will lead an error, below that is OK.
I have the same issue when creating xfs volumes on a lvm stripe but with 
different agcounts.

When the volume is not on an raid array any number of agcount is OK, so 
seems the problem is when sunit/swidth is used.

Marcus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
