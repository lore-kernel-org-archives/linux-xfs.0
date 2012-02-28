Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1S7p9oF167928 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 01:51:09 -0600
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id xXKEvIOpRfOQqRNS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 27 Feb 2012 23:51:07 -0800 (PST)
Subject: Bug#661580: mkfs.xfs fails to detect correct sector size
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.661580.B.13304153657588@bugs.debian.org>
MIME-Version: 1.0
From: Goswin von Brederlow <goswin-v-b@web.de>
Message-ID: <20120228074914.31280.78231.reportbug@frosties.localnet>
Date: Tue, 28 Feb 2012 08:49:14 +0100
Reply-To: Goswin von Brederlow <goswin-v-b@web.de>, 661580@bugs.debian.org
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
Version: 3.1.7
Severity: important
File: /sbin/mkfs.xfs

Hi,

since I recently bought a harddisk with 4K sector size I've been
checking for correct alignment and blocksizes in various things. One
of them being xfs.

When I partition the disk in parted it shows correctly to have a
logical blocksize of 512 byte and physical blocksize of 4096 byte.
But mkfs.xfs does not detect that the physical blocksize is 4096 byte
and creates a filesystem with:

meta-data=/dev/sde1              isize=256    agcount=32, agsize=22892696 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=732566272, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=357698, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


This often results in access to the disk that is not aligned to the
blocksize with the resulting degradation in performance.

Further, manually selecting the right sector size of 4096 still causes
lots of unaligned access while formating and while mounting the
filesystem. It does seem to fix the problem for actual use though.

MfG
	Goswin

-- System Information:
Debian Release: wheezy/sid
  APT prefers unstable
  APT policy: (500, 'unstable')
Architecture: amd64 (x86_64)

Kernel: Linux 3.1.0-1-amd64 (SMP w/4 CPU cores)
Locale: LANG=C, LC_CTYPE=de_DE (charmap=ISO-8859-1)
Shell: /bin/sh linked to /bin/dash

Versions of packages xfsprogs depends on:
ii  libblkid1     2.20.1-1
ii  libc6         2.13-21 
ii  libreadline5  5.2-11  
ii  libuuid1      2.19.1-5

xfsprogs recommends no packages.

Versions of packages xfsprogs suggests:
pn  acl      2.2.51-4  
pn  attr     1:2.4.46-3
pn  quota    <none>    
pn  xfsdump  <none>    

-- no debconf information


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
