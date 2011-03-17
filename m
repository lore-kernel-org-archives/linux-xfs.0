Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2HNaDH7001141 for <xfs@oss.sgi.com>; Thu, 17 Mar 2011 18:36:18 -0500
Received: from busoni.debian.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C29AF13C33C8
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2011 16:39:07 -0700 (PDT)
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id VfxuwJTsyIRSmDEP for
	<xfs@oss.sgi.com>; Thu, 17 Mar 2011 16:39:07 -0700 (PDT)
Subject: Bug#618730: xfsprogs: xfs_quota -xc "report -Nt /xfs_test" i.e. cause
	error "XFS_GETQUOTA: No such process"
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.618730.B.130040502728116@bugs.debian.org>
Content-Type: multipart/mixed; boundary="===============7436659676756291069=="
MIME-Version: 1.0
From: Thomas Blomenkamp <tblomenk@math.uni-bielefeld.de>
Message-ID: <20110317233011.23073.36060.reportbug@store1b.math.uni-bielefeld.de>
Date: Fri, 18 Mar 2011 00:30:11 +0100
Reply-To: Thomas Blomenkamp <tblomenk@math.uni-bielefeld.de>,
        618730@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Debian Bug Tracking System <submit@bugs.debian.org>

This is a multi-part MIME message sent by reportbug.


--===============7436659676756291069==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Package: xfsprogs
Version: 3.1.4
Severity: normal
Tags: squeeze patch

Consider the following situation:

A block-device with xfs-filesystem is mounted on /xfs_test and the xfs_quota option is enabled (i.e. by mounting with option uqnoenforce).

Then if you use the prog. xfs_quota to get a report of the user quota on /xfs, you get sth. like this:

foobar:~#xfs_quota -xc "report -Nt /xfs_test"

root          2019836          0          0     00 [--------]

XFS_GETQUOTA: No such process
XFS_GETQUOTA: No such process
XFS_GETQUOTA: No such process
XFS_GETQUOTA: No such process
XFS_GETQUOTA: No such process

I have attached a patch which worked fine for me.

I want to thank Eric Sandeen for fixing this bug and refer to http://patchwork.xfs.org/patch/1714/


Regards, Thomas


-- System Information:
Debian Release: 6.0
  APT prefers squeeze-updates
  APT policy: (500, 'squeeze-updates'), (500, 'stable')
Architecture: amd64 (x86_64)

Kernel: Linux 2.6.32-5-amd64 (SMP w/8 CPU cores)
Locale: LANG=en_US.UTF-8, LC_CTYPE=en_US.UTF-8 (charmap=UTF-8)
Shell: /bin/sh linked to /bin/dash

Versions of packages xfsprogs depends on:
ii  libblkid1                     2.17.2-9   block device id library
ii  libc6                         2.11.2-10  Embedded GNU C Library: Shared lib
ii  libreadline5                  5.2-7      GNU readline and history libraries
ii  libuuid1                      2.17.2-9   Universally Unique ID library

xfsprogs recommends no packages.

Versions of packages xfsprogs suggests:
pn  acl                           <none>     (no description available)
pn  attr                          <none>     (no description available)
pn  quota                         <none>     (no description available)
ii  xfsdump                       3.0.4      Administrative utilities for the X

-- no debconf information

--===============7436659676756291069==
Content-Type: text/x-diff; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="xfsprogs_quota_report_fix.patch"

diff -crB xfsprogs-3.1.4/quota/report.c xfsprogs-3.1.4_quota_fix/quota/report.c
*** xfsprogs-3.1.4/quota/report.c	2009-04-27 07:48:02.000000000 +0200
--- xfsprogs-3.1.4_quota_fix/quota/report.c	2011-03-17 23:03:06.479607647 +0100
***************
*** 302,308 ****
  	int		count;
  
  	if (xfsquotactl(XFS_GETQUOTA, dev, type, id, (void *)&d) < 0) {
! 		if (errno != ENOENT && errno != ENOSYS)
  			perror("XFS_GETQUOTA");
  		return 0;
  	}
--- 302,308 ----
  	int		count;
  
  	if (xfsquotactl(XFS_GETQUOTA, dev, type, id, (void *)&d) < 0) {
! 		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH)
  			perror("XFS_GETQUOTA");
  		return 0;
  	}

--===============7436659676756291069==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7436659676756291069==--
