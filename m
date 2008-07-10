Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 00:25:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6A7P5Cu016229
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 00:25:07 -0700
Subject: PARTIAL TAKE 981498 - Use the generic bitops rather than implementing them ourselves
Message-Id: <20080710072604.7F28732F6987@linuxbuild.melbourne.sgi.com>
Date: Thu, 10 Jul 2008 17:26:04 +1000 (EST)
From: donaldd@sgi.com (Donald Douwsma)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Use the generic bitops rather than implementing them ourselves.

This keeps xfs_lowbit64 as it was since there aren't good generic
helpers there ...
Patch inspired by Andi Kleen.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Thu Jul 10 17:25:02 AEST 2008
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  david@fromorbit.com,sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31472a
fs/xfs/xfs_bit.h - 1.25 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bit.h.diff?r1=text&tr1=1.25&r2=text&tr2=1.24&f=h
	- Use the generic bitops rather than implementing them ourselves.

fs/xfs/xfs_bit.c - 1.34 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bit.c.diff?r1=text&tr1=1.34&r2=text&tr2=1.33&f=h
	- Use the generic bitops rather than implementing them ourselves.

fs/xfs/xfs_rtalloc.c - 1.113 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rtalloc.c.diff?r1=text&tr1=1.113&r2=text&tr2=1.112&f=h
	- Use the generic bitops rather than implementing them ourselves.
