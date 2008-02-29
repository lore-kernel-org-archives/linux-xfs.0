Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Feb 2008 22:13:59 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1T6DnDM004436
	for <xfs@oss.sgi.com>; Thu, 28 Feb 2008 22:13:51 -0800
Subject: TAKE 978077 - mkfs.xfs - inconsistant AG count for <128MB filesystems
Message-Id: <20080229061413.75BC558C4C0F@chook.melbourne.sgi.com>
Date: Fri, 29 Feb 2008 17:14:13 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Scale AG count and AG size appropriately below 128MB


Date:  Fri Feb 29 17:13:10 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  jeffpc@josefsipek.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30601a
xfsprogs/mkfs/xfs_mkfs.c - 1.86 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c.diff?r1=text&tr1=1.86&r2=text&tr2=1.85&f=h
	- Scale AG count and AG size appropriately below 128MB
