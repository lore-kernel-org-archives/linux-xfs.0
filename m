Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 Nov 2007 20:16:11 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA54FjhE026281
	for <xfs@oss.sgi.com>; Sun, 4 Nov 2007 20:15:48 -0800
Subject: PARTIAL TAKE 971186 - Move platform specific mount option parsing out of core XFS code
Message-Id: <20071105041544.C86DB58C38F7@chook.melbourne.sgi.com>
Date: Mon,  5 Nov 2007 15:15:44 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Move platform specific mount option parsing out of core XFS code

Mount option parsing is platform specific. Move it out of core code into
the platform specific superblock operation file.


Date:  Mon Nov  5 15:14:58 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30012a
fs/xfs/xfs_vfsops.c - 1.548 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.548&r2=text&tr2=1.547&f=h
	- move linux specific mount option parsing into linux specific code.

fs/xfs/linux-2.6/xfs_super.c - 1.403 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.403&r2=text&tr2=1.402&f=h
	- move linux specific mount option parsing into linux specific code.

fs/xfs/xfs_vfsops.h - 1.6 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.h.diff?r1=text&tr1=1.6&r2=text&tr2=1.5&f=h
	- move linux specific mount option parsing into linux specific code.
