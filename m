Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6N1euBD021265 for <xfs@oss.sgi.com>; Wed, 22 Jul 2009 20:40:56 -0500
Received: from radon.netxsys.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5409AC8AA2
	for <xfs@oss.sgi.com>; Wed, 22 Jul 2009 18:49:54 -0700 (PDT)
Received: from radon.netxsys.com (radon.netxsys.com [204.16.202.162]) by
	cuda.sgi.com with ESMTP id REjU1SmGj15bFHST for
	<xfs@oss.sgi.com>; Wed, 22 Jul 2009 18:49:54 -0700 (PDT)
Received: from [205.233.151.7] (Oxygen.NetXSys.Com [205.233.151.7])
	by radon.netxsys.com (Postfix) with ESMTP id 6E0A9C0000A5
	for <xfs@oss.sgi.com>; Wed, 22 Jul 2009 21:41:36 -0400 (EDT)
Subject: XFS: file system too large to be mounted on this system. 2.6.30.1
From: Krzysztof Adamski <k@adamski.org>
Date: Wed, 22 Jul 2009 21:41:35 -0400
Message-Id: <1248313295.4730.2.camel@oxygen.netxsys.com>
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

I got "XFS: file system too large to be mounted on this system." when
mounting my not to large file system.

I'm running Debian lenny with a self compiled kernel, 32 bit userland
distribution.

I have both 32 and 64 bit kernels of the 2.6.30.1 installed. I was
running the 64bit kernel for a while, I needed to switch to the 32 bit
version to run VBox. After reboot to 32bit kernel, one filesystem would
not mount. The xfs_repair did not find any good superblocks.
Fortunately booting the 64bit kernel allowed mounting of this
filesystem.
This is a df while running 64bit kernel:
/dev/mapper/big--raid-file--store
               xfs   2558652416 2540114040  18538376 100% /file-store
/dev/sda1      xfs   195263012 194723636    539376 100% /disks/a1

The interesting part is that /disks/a1 did not have problem with
mounting on the 32bit kernel, just the /file-store.

When running 2.6.28.4 32bit kernel I have no problem with mounting this
filesystem. So something broke between 2.6.28.4 and 2.6.30.1

I can provide any other info.

K


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
