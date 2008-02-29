Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Feb 2008 22:36:02 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1T6Zp9O006373
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 22:35:53 -0800
Subject: TAKE 970175 - overhaul default XFS mkfs options
Message-Id: <20080229063615.4F23858C4C0F@chook.melbourne.sgi.com>
Date: Fri, 29 Feb 2008 17:36:15 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Undo making lazy counters defaulting to on


Date:  Fri Feb 29 17:35:45 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xcmds-clean
Inspected by:  nathans@aconex.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30602a
xfsprogs/mkfs/xfs_mkfs.c - 1.87 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c.diff?r1=text&tr1=1.87&r2=text&tr2=1.86&f=h
	- Don't enable lazy counters by default
