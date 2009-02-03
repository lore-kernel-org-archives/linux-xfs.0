Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n136BWSH039564 for <xfs@oss.sgi.com>; Tue, 3 Feb 2009 00:11:33 -0600
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C0CADD893
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2009 22:10:51 -0800 (PST)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id skRupEg7KZilEoYI for
	<xfs@oss.sgi.com>; Mon, 02 Feb 2009 22:10:51 -0800 (PST)
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by postoffice2.aconex.com (Spam Firewall) with ESMTP id 8F05E84C5E
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 17:10:50 +1100 (EST)
Received: from postoffice.aconex.com (postoffice.yarra.acx [192.168.102.1]) by
	postoffice2.aconex.com with ESMTP id e3I0pX4e2weibMUP for
	<xfs@oss.sgi.com>; Tue, 03 Feb 2009 17:10:50 +1100 (EST)
Received: from [192.168.5.24] (melho0.aconex.com [203.89.192.141])
	by postoffice.aconex.com (Postfix) with ESMTP id 677B392C312
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 17:10:50 +1100 (EST)
Subject: [Fwd: Bug#513821: xfsprogs: xfs_growfs does not work]
From: Nathan Scott <nscott@aconex.com>
Date: Tue, 03 Feb 2009 17:07:36 +1100
Message-Id: <1233641256.5518.83.camel@verge.scott.net.au>
Mime-Version: 1.0
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

Is this issue known (Eric?) in 2.10.2?

thanks!

-------- Forwarded Message --------
From: TANIGUCHI Takaki <takaki@asis.media-as.org>
Reply-To: TANIGUCHI Takaki <takaki@asis.media-as.org>,
513821@bugs.debian.org
To: Debian Bug Tracking System <submit@bugs.debian.org>
Subject: Bug#513821: xfsprogs: xfs_growfs does not work
Date: Sun, 01 Feb 2009 23:43:27 +0900

Package: xfsprogs
Version: 2.10.2-1
Severity: important

xfs_growfs does not work. But when I use i686 kernel, xfs_growfs work fine.

/# LANG=C xfs_growfs /home
meta-data=/dev/mapper/vgraid-home isize=256    agcount=16, agsize=163840 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=2621440, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=2560, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=65536  blocks=0, rtextents=0
xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid argument
data blocks changed from 2621440 to 0
inode max percent changed from 25 to 0
log blocks changed from 2560 to 0
log changed from internal to external
realtime extent size changed from 16 to 0
/# 


-- System Information:
Debian Release: 5.0
  APT prefers unstable
  APT policy: (500, 'unstable'), (500, 'testing')
Architecture: i386 (x86_64)

Kernel: Linux 2.6.26-1-amd64 (SMP w/1 CPU core)
Locale: LANG=ja_JP.UTF-8, LC_CTYPE=ja_JP.UTF-8 (charmap=UTF-8)
Shell: /bin/sh linked to /bin/bash

Versions of packages xfsprogs depends on:
ii  libc6                         2.7-18     GNU C Library: Shared libraries
ii  libreadline5                  5.2-3.1    GNU readline and history libraries
ii  libuuid1                      1.41.3-1   universally unique id library

xfsprogs recommends no packages.

Versions of packages xfsprogs suggests:
pn  attr                          <none>     (no description available)
pn  dvhtool                       <none>     (no description available)
pn  quota                         <none>     (no description available)
ii  xfsdump                       2.2.48-1   Administrative utilities for the X

-- no debconf information



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
