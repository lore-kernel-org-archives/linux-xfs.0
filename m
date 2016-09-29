Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 938147CA1
	for <xfs@oss.sgi.com>; Thu, 29 Sep 2016 04:15:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 64A488F8035
	for <xfs@oss.sgi.com>; Thu, 29 Sep 2016 02:15:09 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39]) by
	cuda.sgi.com with ESMTP id uGPD09VA3NifCAGA (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 29 Sep 2016 02:15:07 -0700 (PDT)
Subject: Bug#839129: xfsprogs: xfs_fsr XFS_IOC_SWAPEXT failed: ino=[xxxxxxx]:
	Invalid argument
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.839129.B.14751404126321@bugs.debian.org>
MIME-Version: 1.0
From: Daniele Di Domizio <daniele.didomizio@eurac.edu>
Message-ID: <147513949292.17377.13641668789408577436.reportbug@calc06.gm.eurac.edu>
Date: Thu, 29 Sep 2016 10:58:12 +0200
Reply-To: Daniele Di Domizio <daniele.didomizio@eurac.edu>,
	839129@bugs.debian.org
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
To: Debian Bug Tracking System <submit@bugs.debian.org>

Package: xfsprogs
Version: 4.3.0+nmu1
Severity: important

xfs_fsr reports this error when launched from command line (or from a cron job):

# xfs_fsr /dev/sda2
/ start inode=0
XFS_IOC_SWAPEXT failed: ino=134390661: Invalid argument

This error message is also logged in the kernel log:

[1876280.379978] XFS (sda2): xfs_swap_extents: inode 0x802a385 format is incompatible for exchanging.


-- System Information:
Debian Release: stretch/sid
  APT prefers testing
  APT policy: (500, 'testing')
Architecture: amd64 (x86_64)

Kernel: Linux 4.6.0-1-amd64 (SMP w/8 CPU cores)
Locale: LANG=en_US.UTF-8, LC_CTYPE=en_US.UTF-8 (charmap=UTF-8)
Shell: /bin/sh linked to /bin/dash
Init: sysvinit (via /sbin/init)

Versions of packages xfsprogs depends on:
ii  libblkid1     2.28.1-1
ii  libc6         2.23-5
ii  libreadline5  5.2+dfsg-3+b1
ii  libuuid1      2.28.1-1

xfsprogs recommends no packages.

Versions of packages xfsprogs suggests:
ii  acl      2.2.52-3
ii  attr     1:2.4.47-2
pn  quota    <none>
ii  xfsdump  3.1.6+nmu1

-- no debconf information

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
