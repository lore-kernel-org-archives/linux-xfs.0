Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qASDpoe8183289 for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 07:51:50 -0600
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id GnTUF5COKuZoLxFt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 28 Nov 2012 05:54:06 -0800 (PST)
Subject: Bug#694624: /usr/sbin/xfs_freeze: freezes under lying (root)
	filesystem if mountpoint is not currently mounted
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.694624.B.13541106404199@bugs.debian.org>
MIME-Version: 1.0
From: Patrick Emblen <support@talbragar.com.au>
Message-ID: <20121128134342.4359.51203.reportbug@t5>
Date: Thu, 29 Nov 2012 00:43:42 +1100
Reply-To: Patrick Emblen <support@talbragar.com.au>, 694624@bugs.debian.org
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
To: Debian Bug Tracking System <submit@bugs.debian.org>

Package: xfsprogs
Version: 3.1.7+b1
Severity: important
File: /usr/sbin/xfs_freeze

Dear Maintainer,
When xfs_freeze -f /some/path is executed and /some/path does not contain a
mounted file system the under lying (in my case root) file system was frozen, 
this then required travelling to the site to power cycle the machine. The
mount point normally hosted a removable drive, but it had been ejected.
 
Please have xfs_freeze return an error if the mountpoint argument does not
contain a mounted file system.
The documentation implies that the argument must be a mount point, but _any_
path provided as an argument will freeze the parent file system.



-- System Information:
Debian Release: wheezy/sid
  APT prefers testing
  APT policy: (500, 'testing')
Architecture: i386 (i686)

Kernel: Linux 3.2.0-3-686-pae (SMP w/2 CPU cores)
Locale: LANG=en_AU.UTF-8, LC_CTYPE=en_AU.UTF-8 (charmap=UTF-8)
Shell: /bin/sh linked to /bin/dash

Versions of packages xfsprogs depends on:
ii  libblkid1     2.20.1-5.1
ii  libc6         2.13-33
ii  libreadline5  5.2-11
ii  libuuid1      2.20.1-5.1

xfsprogs recommends no packages.

Versions of packages xfsprogs suggests:
ii  acl      2.2.51-8
pn  attr     <none>
pn  quota    <none>
pn  xfsdump  <none>

-- no debconf information

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
