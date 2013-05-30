Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 412997F37
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 00:40:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DCE61AC003
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 22:40:35 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id 2JLry0TSCZUTyHc0 for
	<xfs@oss.sgi.com>; Wed, 29 May 2013 22:40:34 -0700 (PDT)
Date: Thu, 30 May 2013 01:40:32 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <1824023060.8558101.1369892432333.JavaMail.root@redhat.com>
In-Reply-To: <20130530052049.GK29466@dastard>
References: <510292845.4997401.1369279175460.JavaMail.root@redhat.com>
	<1985929268.4997720.1369279277543.JavaMail.root@redhat.com>
	<20130523035115.GY24543@dastard>
	<986348673.5787542.1369385526612.JavaMail.root@redhat.com>
	<20130527053608.GS29466@dastard>
	<1588848128.8530921.1369885528565.JavaMail.root@redhat.com>
	<20130530052049.GK29466@dastard>
Subject: Re: 3.9.3: Oops running xfstests
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: stable@vger.kernel.org, xfs@oss.sgi.com



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: xfs@oss.sgi.com, stable@vger.kernel.org
> Sent: Thursday, May 30, 2013 1:20:49 PM
> Subject: Re: 3.9.3: Oops running xfstests
> 
> On Wed, May 29, 2013 at 11:45:28PM -0400, CAI Qian wrote:
> > Also reproduced this on 3.9.4 on several different machines.
> 
> How? what workload are you running that causes it to occur?
I have been running the following workloads, trinity, ltp (including
oom tests and some filesystem tests), some hugetlbfs tests, selinux
test suite, tracepoint tests, connectathon tests and then xfstests.
I am still trying to narrow down the minimal workload that could
reproduce this.
> 
> <snip stack trace showing page overrun in
> xfs_attr_leaf_compact/xfs_attr_leaf_moveents>
> 
> > System information is below:
> > 
> > + cat /proc/mounts
> ....
> > /dev/mapper/rhel_hp--xw9400--02-root / xfs
> > rw,seclabel,relatime,attr2,inode64,noquota 0 0
> > /dev/mapper/rhel_hp--xw9400--02-home /home xfs
> > rw,seclabel,relatime,attr2,inode64,noquota 0 0
> > /dev/sda1 /boot xfs rw,seclabel,relatime,attr2,inode64,noquota 0 0
> 
> Which of these filesystems did it happen on? Or some other
> filesystem not mounted when you took this snapshot?
+ export TEST_DEV=/dev/mapper/rhel_hp--bl495cg5--02-swap
+ TEST_DEV=/dev/mapper/rhel_hp--bl495cg5--02-swap
+ export TEST_DIR=/mnt/testarea/test
+ TEST_DIR=/mnt/testarea/test
+ export SCRATCH_DEV=/dev/mapper/rhel_hp--bl495cg5--02-home
+ SCRATCH_DEV=/dev/mapper/rhel_hp--bl495cg5--02-home
+ export SCRATCH_MNT=/mnt/testarea/scratch
+ SCRATCH_MNT=/mnt/testarea/scratch
+ mkdir -p /mnt/testarea/test
home = /dev/mapper/rhel_hp--bl495cg5--02-home
+ mkdir -p /mnt/testarea/scratch
+ mkfs.xfs -f /dev/mapper/rhel_hp--bl495cg5--02-swap
meta-data=/dev/mapper/rhel_hp--bl495cg5--02-swap isize=256    agcount=4, agsize=510976 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=2043904, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
+ mkfs.xfs -f /dev/mapper/rhel_hp--bl495cg5--02-home
meta-data=/dev/mapper/rhel_hp--bl495cg5--02-home isize=256    agcount=4, agsize=1103872 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=4415488, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> And can you post the xfs_info output of the filesystems under test,
> too?
xfs_info: /dev/mapper/rhel_hp--bl495cg5--02-swap is not a mounted XFS filesystem
+ echo

+ xfs_info /dev/mapper/rhel_hp--bl495cg5--02-home
meta-data=/dev/mapper/rhel_hp--bl495cg5--02-home isize=256    agcount=4, agsize=1103872 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=4415488, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
CAI Qian
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
