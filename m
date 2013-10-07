Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 27DB87F4E
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 10:16:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1488F8F8049
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 08:16:44 -0700 (PDT)
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id VsK0DQ99xed33uPl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 07 Oct 2013 08:16:39 -0700 (PDT)
Date: Mon, 7 Oct 2013 17:16:37 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: xfs_repair refuses to run on cleanly mountable partition
Message-ID: <20131007151637.GA280@x4>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs-oss <xfs@oss.sgi.com>

x4 ~ # xfs_repair -V
xfs_repair version 3.2.0-alpha1

x4 ~ # mount -o logbsize=256k /dev/sdc1 /mnt
...
[ 6419.592649] XFS (sdc1): Mounting Filesystem
[ 6419.642480] XFS (sdc1): Ending clean mount

x4 ~ # xfs_info /dev/sdc1
meta-data=/dev/sdc1              isize=256    agcount=4, agsize=61047552 blks
         =                       sectsz=4096  attr=2, projid32bit=0
         =                       crc=0
data     =                       bsize=4096   blocks=244190208, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=119233, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

x4 ~ # umount /mnt

x4 ~ # xfs_repair /dev/sdc1
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_repair.  If you are unable to mount the filesystem, then use
the -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
