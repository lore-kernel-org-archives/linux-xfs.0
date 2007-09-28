Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Sep 2007 01:07:58 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l8S86fAT020026
	for <xfs@oss.sgi.com>; Fri, 28 Sep 2007 01:06:45 -0700
Subject: PARTIAL TAKE 971186 - kill xfs_statvfs
Message-Id: <20070928080634.E8CD958C4C0A@chook.melbourne.sgi.com>
Date: Fri, 28 Sep 2007 18:06:34 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Kill off xfs_statvfs.

We were already filling the Linux struct statfs anyway, and doing this
trivial task directly in xfs_fs_statfs makes the code quite a bit cleaner.
While I was at it I also moved copying attributes that don't change over
the lifetime of the filesystem outside the superblock lock.

xfs_fs_fill_super used to get the magic number and blocksize through
xfs_statvfs, but assigning them directly is a lot cleaner and will save
some stack space during mount.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Sep 28 18:05:12 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29802a
fs/xfs/xfs_vfsops.c - 1.544 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.544&r2=text&tr2=1.543&f=h
fs/xfs/linux-2.6/xfs_linux.h - 1.160 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.160&r2=text&tr2=1.159&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.399 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.399&r2=text&tr2=1.398&f=h
fs/xfs/xfs_vfsops.h - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.h.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
	- Kill off xfs_statvfs.
