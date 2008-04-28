Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 22:52:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3S5q6A5004628
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 22:52:08 -0700
Subject: TAKE 980887 - remove xfs_log_ticket_zone on rmmod
Message-Id: <20080428055237.1BD0358C4C15@chook.melbourne.sgi.com>
Date: Mon, 28 Apr 2008 15:52:37 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

remove xfs_log_ticket_zone on rmmod

Fix bug introduced in commit eb01c9cd87c7a9998c2edf209721ea069e3e3652
aka "[XFS] Remove the xlog_ticket allocator"

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Date:  Mon Apr 28 15:52:22 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  adobriyan@gmail.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30995a
fs/xfs/xfs_vfsops.c - 1.562 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.562&r2=text&tr2=1.561&f=h
	- remove xfs_log_ticket_zone on rmmod
