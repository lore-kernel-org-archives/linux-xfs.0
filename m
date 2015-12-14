Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3B8B87CBF
	for <xfs@oss.sgi.com>; Sun, 13 Dec 2015 20:00:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C42D1AC003
	for <xfs@oss.sgi.com>; Sun, 13 Dec 2015 18:00:11 -0800 (PST)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id J7TDzgYbuBdfxc1l (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 13 Dec 2015 18:00:08 -0800 (PST)
Subject: Bug#807879: xfsprogs: Cannot mount XFS filesystem formated with
	mkfs.xfs newer than 3.2.1
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.807879.B.145005819820282@bugs.debian.org>
MIME-Version: 1.0
From: Emil <ee@la.mine.nu>
Message-ID: <145005783346.24095.10578707004408280277.reportbug@flop>
Date: Mon, 14 Dec 2015 01:50:33 +0000
Reply-To: Emil <ee@la.mine.nu>, 807879@bugs.debian.org
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
Version: 4.3.0
Severity: normal

For any version of xfsprogs after v3.2.1 formating with default options:

# dpkg -l mount
ii  mount            2.27.1-1      i386          Tools for mounting and manipulating

# mkfs.xfs -f /dev/sde1
meta-data=/dev/sde1              isize=512    agcount=4, agsize=61047598 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=0
data     =                       bsize=4096   blocks=244190390, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=119233, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# mount /dev/sde1 /mnt/e
mount: wrong fs type, bad option, bad superblock on /dev/sde1
# dmesg
[    0.000000] XFS (sde1): bad version
[    0.000000] XFS (sde1): SB validate failed

# dpkg -i xfsprogs_3.2.1_i386.deb
# mkfs.xfs -f /dev/sde1
meta-data=/dev/sde1              isize=256    agcount=4, agsize=61047598 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0
data     =                       bsize=4096   blocks=244190390, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal log           bsize=4096   blocks=119233, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# mount /dev/sde1 /mnt/e
No errors after mount.

-- System Information:
Debian Release: stretch/sid
  APT prefers unstable
  APT policy: (900, 'unstable'), (300, 'stable')
Architecture: i386 (i686)

Kernel: Linux 3.4.110 (SMP w/4 CPU cores)
Locale: LANG=C
Shell: /bin/sh linked to /bin/dash
Init: sysvinit (via /sbin/init)

Versions of packages xfsprogs depends on:
ii  libblkid1     2.27.1-1
ii  libc6         2.21-3
ii  libreadline5  5.2+dfsg-3+b1
ii  libuuid1      2.27.1-1

xfsprogs recommends no packages.

Versions of packages xfsprogs suggests:
ii  acl      2.2.52-2
ii  attr     1:2.4.47-2
pn  quota    <none>
pn  xfsdump  <none>

-- no debconf information

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
