Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 58DFC29DF9
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 08:16:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4729A304053
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 06:16:19 -0700 (PDT)
Received: from excellency.alwaysdata.net (excellency.alwaysdata.net
	[185.31.40.199]) by cuda.sgi.com with ESMTP id h87tv2DN6pKtHTF2
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Jul 2014 06:16:17 -0700 (PDT)
Received: from [10.250.1.10] (helo=Cyril-Macbook.local)
	by excellency.alwaysdata.net with esmtpsa
	(TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32) (Exim 4.77)
	(envelope-from <cbay@excellency.fr>) id 1X9ZvP-000zM7-AJ
	for xfs@oss.sgi.com; Tue, 22 Jul 2014 15:16:11 +0200
Message-ID: <53CE6415.8080607@excellency.fr>
Date: Tue, 22 Jul 2014 15:16:05 +0200
From: "Cyril B." <cbay@excellency.fr>
MIME-Version: 1.0
Subject: Forced quotacheck after unclean unmount since 3.11, bisected
Reply-To: cbay@excellency.fr
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

I've noticed that since Linux 3.11, quotacheck always happen after 
unclean unmounts. Is this expected? It didn't happen on previous Linux 
versions.

A bisect shows that this commit is responsible:
xfs: Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD
id: 83e782e1a1cc0159888e58e14dfc8f3289663338

Relevant dmesg:
[    8.844063] XFS (md4): Mounting Filesystem
[    9.054023] XFS (md4): Starting recovery (logdev: internal)
[    9.331785] XFS (md4): Ending recovery (logdev: internal)
[    9.383856] XFS (md4): Quotacheck needed: Please wait.
[   48.427732] XFS (md4): Quotacheck: Done.

More details:
   * vanilla kernel
   * on top of mdadm (RAID1)
   * xfsprogs 3.1.5
   * mount options: noatime,nosuid,nodev,grpquota,inode64
   * xfs_info:
meta-data=/dev/md4               isize=256    agcount=4, 
agsize=119997280 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=479989120, imaxpct=5
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=234369, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Thanks,

-- 
Cyril B.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
