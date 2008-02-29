Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Feb 2008 21:41:05 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1T5epjI000893
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 21:40:57 -0800
Subject: TAKE 977827 - mkfs.xfs fails with non-sector aligned block devices
Message-Id: <20080229054114.C1B5C58C4C0F@chook.melbourne.sgi.com>
Date: Fri, 29 Feb 2008 16:41:14 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Make sure device size is aligned to the specified sector size


Date:  Fri Feb 29 16:40:38 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  esandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30600a
xfsprogs/mkfs/xfs_mkfs.c - 1.85 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c.diff?r1=text&tr1=1.85&r2=text&tr2=1.84&f=h
	- Make sure the device size is aligned to the specified sector size
