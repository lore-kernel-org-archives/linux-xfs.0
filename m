Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Mar 2008 16:57:44 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m230fbhJ031823
	for <xfs@oss.sgi.com>; Sun, 2 Mar 2008 16:41:41 -0800
From: donaldd@sgi.com
Subject: TAKE 976035 - Remove superflous xfs_readsb call in xfs_mountfs.
Message-Id: <20080303004201.C3753323900C@linuxbuild.melbourne.sgi.com>
Date: Mon,  3 Mar 2008 11:42:01 +1100 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Remove superflous xfs_readsb call in xfs_mountfs.

When xfs_mountfs is called by xfs_mount xfs_readsb was called 35 lines
above unconditionally, so there is no need to try to read the superblock
if it's not present.  If any other port doesn't have the superblock
read at this point it should just call it directly from it's xfs_mount
equivalent.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Mon Mar  3 11:41:13 AEDT 2008
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  donaldd

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30603a
fs/xfs/xfs_mount.c - 1.420 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.420&r2=text&tr2=1.419&f=h
	- Remove superflous xfs_readsb call in xfs_mountfs.
