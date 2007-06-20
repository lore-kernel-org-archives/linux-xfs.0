Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 22:23:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5K5Mudo028223
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 22:22:58 -0700
Subject: TAKE 966576 - use is_power_of_2() instead of open coding checks
Message-Id: <20070620052252.BAC9058C38F1@chook.melbourne.sgi.com>
Date: Wed, 20 Jun 2007 15:22:52 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Use is_power_of_2 instead of open coding checks

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>


Date:  Wed Jun 20 15:22:20 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  vignesh.babu@wipro.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28950a
fs/xfs/xfs_inode.c - 1.464 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.464&r2=text&tr2=1.463&f=h
	- Use is_power_of_2 instead of open coding checks
