Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Dec 2007 19:45:07 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBD3ihGq027747
	for <xfs@oss.sgi.com>; Wed, 12 Dec 2007 19:44:46 -0800
Subject: TAKE 973746 - Put the correct offset in dirent d_off
Message-Id: <20071213034445.2DEBC58C4C35@chook.melbourne.sgi.com>
Date: Thu, 13 Dec 2007 14:44:45 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Put the correct offset in dirent d_off

The recent filldir regression fix was not putting the correct
d_off in each dirent. This was resulting in incorrect cookies being
passed to dmapi ioctls and the wrong offset appearing in the dirents.
readdir was unaffected as the filp->f_pos was being updated with the
correct offset and this was being written into the last dirent in
each buffer. Fix the XFS code to do the right thing.

Date:  Thu Dec 13 14:44:12 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30240a
fs/xfs/xfs_dir2_block.c - 1.58 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_block.c.diff?r1=text&tr1=1.58&r2=text&tr2=1.57&f=h
	- pass the current offset to the filldir method rather than the offset
	  of the next object. filldir expects the current offset, not the next one.

fs/xfs/xfs_dir2_sf.c - 1.50 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_sf.c.diff?r1=text&tr1=1.50&r2=text&tr2=1.49&f=h
	- pass the current offset to the filldir method rather than the offset
	  of the next object. filldir expects the current offset, not the next one.

fs/xfs/xfs_dir2_leaf.c - 1.60 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_leaf.c.diff?r1=text&tr1=1.60&r2=text&tr2=1.59&f=h
	- pass the current offset to the filldir method rather than the offset
	  of the next object. filldir expects the current offset, not the next one.

fs/xfs/linux-2.6/xfs_file.c - 1.160 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_file.c.diff?r1=text&tr1=1.160&r2=text&tr2=1.159&f=h
	- Update filp->f_pos correctly now that we pass the current offset with
	  each dirent to filldir.

fs/xfs/dmapi/xfs_dm.c - 1.61 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.61&r2=text&tr2=1.60&f=h
	- Remove special handling of dirent offsets for the cookie betwen
	  ioctl calls.
