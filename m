Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 20:54:28 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9A3sNVd027102
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 20:54:24 -0700
Subject: TAKE 988139 - move xfssyncd code to xfs_sync.c
Message-Id: <20081010035555.86BA958C52B5@chook.melbourne.sgi.com>
Date: Fri, 10 Oct 2008 14:55:55 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

move xfssyncd code to xfs_sync.c

Move all the xfssyncd code to the new xfs_sync.c file.
This places it closer to the actual code that it interacts
with, rather than just being associated with high level
VFS code.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Fri Oct 10 14:54:49 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-radix
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32283a
fs/xfs/xfs_mount.h - 1.277 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.277&r2=text&tr2=1.276&f=h
fs/xfs/linux-2.6/xfs_vfs.h - 1.82 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.h.diff?r1=text&tr1=1.82&r2=text&tr2=1.81&f=h
fs/xfs/linux-2.6/xfs_super.h - 1.82 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.h.diff?r1=text&tr1=1.82&r2=text&tr2=1.81&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.452 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.452&r2=text&tr2=1.451&f=h
fs/xfs/linux-2.6/xfs_sync.h - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.h.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
fs/xfs/linux-2.6/xfs_sync.c - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- move xfssyncd code to xfs_sync.c
