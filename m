Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Aug 2006 16:09:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7TN8sDW010310
	for <linux-xfs@oss.sgi.com>; Tue, 29 Aug 2006 16:09:06 -0700
Subject: TAKE 947312 - fix bma.conv assignment
Message-Id: <20060829230805.864C458CF7C2@chook.melbourne.sgi.com>
Date: Wed, 30 Aug 2006 09:08:05 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix char size overflow in bmap_alloc call for unwritten extent conversion.

Since bma.conv is a char and XFS_BMAPI_CONVERT is 0x1000, bma.conv was
always assigned zero.  Spotted by the GNU C compiler (SVN version).

Signed-off-by: Adrian Bunk <bunk@stusta.de>


Date:  Wed Aug 30 09:06:53 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  Adrian Bunk <bunk@stusta.de>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26887a
xfs_bmap.c - 1.358 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.358&r2=text&tr2=1.357&f=h
	- Since bma.conv is a char and XFS_BMAPI_CONVERT is 0x1000, bma.conv was
	  always assigned zero.  Spotted by the GNU C compiler (SVN version).
