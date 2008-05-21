Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 May 2008 20:48:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4L3m4Ds018210
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 20:48:05 -0700
Subject: TAKE 981516 - ASCII case-insensitive support
Message-Id: <20080521034851.1708D58C4C29@chook.melbourne.sgi.com>
Date: Wed, 21 May 2008 13:48:51 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

XFS: ASCII case-insensitive support

Implement ASCII case-insensitive support. It's primary purpose
is for supporting existing filesystems that already use this
case-insensitive mode migrated from IRIX. But, if you only need
ASCII-only case-insensitive support (ie. English only) and will
never use another language, then this mode is perfectly adequate.

ASCII-CI is implemented by generating hashes based on lower-case
letters and doing lower-case compares. It implements a new
xfs_nameops vector for doing the hashes and comparisons for
all filename operations.

To create a filesystem with this CI mode, use:
# mkfs.xfs -n version=ci <device>

Signed-off-by: Barry Naujok <bnaujok@sgi.com>


Date:  Wed May 21 13:48:31 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31209a
fs/xfs/xfs_sb.h - 1.74 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_sb.h.diff?r1=text&tr1=1.74&r2=text&tr2=1.73&f=h
	- Add ASCII CI flag and support to superblock

fs/xfs/xfs_fs.h - 1.37 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fs.h.diff?r1=text&tr1=1.37&r2=text&tr2=1.36&f=h
	- Add geometry flag for ASCII CI

fs/xfs/xfs_fsops.c - 1.135 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c.diff?r1=text&tr1=1.135&r2=text&tr2=1.134&f=h
	- Update fs_geometry ioctl implementation for ASCII CI flag

fs/xfs/xfs_dir2.c - 1.68 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2.c.diff?r1=text&tr1=1.68&r2=text&tr2=1.67&f=h
	- Add ASCII CI nameops routines

fs/xfs/linux-2.6/xfs_linux.h - 1.166 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.166&r2=text&tr2=1.165&f=h
	- Include ctype.h for tolower function

fs/xfs/linux-2.6/xfs_super.c - 1.428 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.428&r2=text&tr2=1.427&f=h
	- Setup inode ops based on CI mode
