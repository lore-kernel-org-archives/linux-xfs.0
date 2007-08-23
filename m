Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 04:53:44 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7NBrd4p018792
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 04:53:41 -0700
Subject: PARTIAL TAKE 968563 - dinode endianess annotations
Message-Id: <20070823115334.5164858C38F1@chook.melbourne.sgi.com>
Date: Thu, 23 Aug 2007 21:53:34 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

dinode endianess annotations

Biggest bit is duplicating the dinode structure so we have one annoted
for native endianess and one for disk endianess.  The other significant
change is that xfs_xlate_dinode_core is split into one helper per
direction to allow for proper annotations, everything else is trivial.

As a sidenode splitting out the incore dinode means we can move it into
xfs_inode.h in a later patch and severly improving on the include hell
in xfs.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Thu Aug 23 21:53:01 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29476a
fs/xfs/xfsidbg.c - 1.321 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.321&r2=text&tr2=1.320&f=h
	- add endian notations for the dinode.

fs/xfs/xfs_ialloc.c - 1.195 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.c.diff?r1=text&tr1=1.195&r2=text&tr2=1.194&f=h
	- add endian notations for the dinode.

fs/xfs/xfs_itable.c - 1.153 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.153&r2=text&tr2=1.152&f=h
	- add endian notations for the dinode.

fs/xfs/xfs_log_recover.c - 1.321 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.321&r2=text&tr2=1.320&f=h
	- add endian notations for the dinode.

fs/xfs/xfs_inode.c - 1.471 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.471&r2=text&tr2=1.470&f=h
	- add endian notations for the dinode.

fs/xfs/xfs_inode.h - 1.224 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.224&r2=text&tr2=1.223&f=h
	- add endian notations for the dinode.

fs/xfs/xfs_dinode.h - 1.82 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dinode.h.diff?r1=text&tr1=1.82&r2=text&tr2=1.81&f=h
	- add endian notations for the dinode.

fs/xfs/linux-2.6/xfs_ksyms.c - 1.61 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.61&r2=text&tr2=1.60&f=h
	- add endian notations for the dinode.

fs/xfs/dmapi/xfs_dm.c - 1.42 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.42&r2=text&tr2=1.41&f=h
	- add endian notations for the dinode.
