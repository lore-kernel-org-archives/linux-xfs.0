Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 08 Jul 2007 22:44:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l695i6tL023415
	for <xfs@oss.sgi.com>; Sun, 8 Jul 2007 22:44:08 -0700
Subject: TAKE 967353 - cleanup function name handling for debug code
Message-Id: <20070709054402.8FD1558C38F1@chook.melbourne.sgi.com>
Date: Mon,  9 Jul 2007 15:44:02 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Clean up function name handling in tracing code

Remove the hardcoded "fnames" for tracing, and just embed
them in tracing macros via __FUNCTION__.  Kills a lot of #ifdefs
too.

Signed-Off-By: Eric Sandeen <sandeen@sandeen.net>


Date:  Mon Jul  9 15:43:22 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29099a
fs/xfs/xfs_bmap_btree.c - 1.161 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.161&r2=text&tr2=1.160&f=h
	- Use __FUNCTION__ rather than hardcoded fnames for tracing.

fs/xfs/xfs_inode.c - 1.467 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.467&r2=text&tr2=1.466&f=h
	- Use __FUNCTION__ rather than hardcoded fnames for tracing.

fs/xfs/xfs_alloc.c - 1.187 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.187&r2=text&tr2=1.186&f=h
	- Use __FUNCTION__ rather than hardcoded fnames for tracing.

fs/xfs/xfs_bmap.h - 1.99 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.h.diff?r1=text&tr1=1.99&r2=text&tr2=1.98&f=h
	- Use __FUNCTION__ rather than hardcoded fnames for tracing.

fs/xfs/xfs_bmap.c - 1.372 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.372&r2=text&tr2=1.371&f=h
	- Use __FUNCTION__ rather than hardcoded fnames for tracing.
