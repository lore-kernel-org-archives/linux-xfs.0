Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2CEPi2Z081189 for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 09:26:04 -0500
Received: from rgminet12.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7EB441C38F6D
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 07:25:21 -0700 (PDT)
Received: from rgminet12.oracle.com (rcsinet12.oracle.com [148.87.113.124]) by
	cuda.sgi.com with ESMTP id q2eYeXAlhoPXjeD1 for
	<xfs@oss.sgi.com>; Thu, 12 Mar 2009 07:25:21 -0700 (PDT)
Subject: Re: LWN article: 4K disk sectors
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <200903121258.51497@zmi.at> <49B909CC.7080402@sandeen.net>
	<200903121452.16419@zmi.at>
Date: Thu, 12 Mar 2009 10:23:30 -0400
In-Reply-To: <200903121452.16419@zmi.at> (Michael Monnerie's message of "Thu\,
	12 Mar 2009 14\:52\:16 +0100")
Message-ID: <yq1bps6q0pp.fsf@sermon.lab.mkp.net>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

>>>>> "Michael" == Michael Monnerie <michael.monnerie@is.it-management.at> writes:

Michael> I thought that it's a limitation of the Linux kernel in more
Michael> parts than just the filesystem (like block cache), that sector
Michael> sizes must be 512B.

Nope.  We've supported bigger sector sizes for years because of CD-ROMs,
mainframe DASD, etc.


Michael> If I had a 4K drive, would that be usable with XFS already?

# cat /sys/block/sdc/queue/hw_sector_size 
4096
# xfs_info /mnt
meta-data=/dev/sdc1              isize=256    agcount=16, agsize=5113686 blks
         =                       sectsz=4096  attr=0
data     =                       bsize=4096   blocks=81818976, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

-- 
Martin K. Petersen	Oracle Linux Engineering

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
