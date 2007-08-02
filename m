Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 04:42:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l72Bggbm010240
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 04:42:44 -0700
Subject: PARTIAL TAKE 968563 - Pick a single default inode cluster size.
Message-Id: <20070802114242.5FBCF58F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 21:42:42 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Pick a single default inode cluster size.

Remove scaling of inode "clusters" based on machine memory;
small cluster cut-point was an unrealistic 32MB and was
probably never tested.

Removes another user of xfs_physmem.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Thu Aug  2 21:42:18 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29324a
fs/xfs/xfs_ialloc.h - 1.48 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.h.diff?r1=text&tr1=1.48&r2=text&tr2=1.47&f=h
	- Don't scale inode cluster size based on physical memory.

fs/xfs/xfs_mount.c - 1.400 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.400&r2=text&tr2=1.399&f=h
	- Don't scale inode cluster size based on physical memory.
