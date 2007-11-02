Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Nov 2007 18:51:58 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA21pns7011676
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 18:51:53 -0700
Subject: PARTIAL TAKE 971186 - Show all mount args in /proc/mounts
Message-Id: <20071102015150.22C5658C38F7@chook.melbourne.sgi.com>
Date: Fri,  2 Nov 2007 12:51:50 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Show all mount args in /proc/mounts

There are several mount options that don't show up in /proc/mounts.
Add them in and clean up the showargs code at the same time.


Date:  Fri Nov  2 12:51:17 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30004a
fs/xfs/xfs_vfsops.c - 1.547 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.547&r2=text&tr2=1.546&f=h
	- Show all mount args in /proc/mounts.
