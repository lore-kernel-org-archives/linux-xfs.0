Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 05:10:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7OCAL4p015856
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 05:10:23 -0700
Subject: PARTIAL TAKE 969608 - kill the vfs_flags member in struct bhv_vfs
Message-Id: <20070824121017.AA07A58C38F1@chook.melbourne.sgi.com>
Date: Fri, 24 Aug 2007 22:10:17 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

kill the vfs_flags member in struct bhv_vfs

All flags are added to xfs_mount's m_flag instead.  Note that the 32bit
inode flag was duplicated in both of them, but only cleared in the
mount when it was not nessecary due to the filesystem beeing small enough.
Two flags are still required here - one to indicate the mount option
setting, and one to indicate if it applies or not.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Aug 24 22:09:46 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29507a
fs/xfs/xfsidbg.c - 1.330 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.330&r2=text&tr2=1.329&f=h
	- move vfs_flags to xfs_mount.

fs/xfs/xfs_log.c - 1.335 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.335&r2=text&tr2=1.334&f=h
	- move vfs_flags to xfs_mount.

fs/xfs/xfs_vnodeops.c - 1.716 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.716&r2=text&tr2=1.715&f=h
	- move vfs_flags to xfs_mount.

fs/xfs/xfs_dmapi.h - 1.62 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dmapi.h.diff?r1=text&tr1=1.62&r2=text&tr2=1.61&f=h
	- move vfs_flags to xfs_mount.

fs/xfs/xfs_vfsops.c - 1.535 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.535&r2=text&tr2=1.534&f=h
	- move vfs_flags to xfs_mount.

fs/xfs/xfs_mount.h - 1.247 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.247&r2=text&tr2=1.246&f=h
	- move vfs_flags to xfs_mount.

fs/xfs/xfs_mount.c - 1.407 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.407&r2=text&tr2=1.406&f=h
	- move vfs_flags to xfs_mount.

fs/xfs/xfs_inode.c - 1.478 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.478&r2=text&tr2=1.477&f=h
	- move vfs_flags to xfs_mount.

fs/xfs/xfs_inode.h - 1.232 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.232&r2=text&tr2=1.231&f=h
	- move vfs_flags to xfs_mount.

fs/xfs/xfs_qmops.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_qmops.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
	- move vfs_flags to xfs_mount.

fs/xfs/quota/xfs_qm_syscalls.c - 1.35 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_syscalls.c.diff?r1=text&tr1=1.35&r2=text&tr2=1.34&f=h
	- move vfs_flags to xfs_mount.

fs/xfs/quota/xfs_qm.c - 1.54 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.54&r2=text&tr2=1.53&f=h
	- move vfs_flags to xfs_mount.

fs/xfs/linux-2.6/xfs_vfs.h - 1.78 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.h.diff?r1=text&tr1=1.78&r2=text&tr2=1.77&f=h
	- move vfs_flags to xfs_mount.

fs/xfs/linux-2.6/xfs_vfs.c - 1.81 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.c.diff?r1=text&tr1=1.81&r2=text&tr2=1.80&f=h
	- move vfs_flags to xfs_mount.

fs/xfs/linux-2.6/xfs_file.c - 1.156 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_file.c.diff?r1=text&tr1=1.156&r2=text&tr2=1.155&f=h
	- move vfs_flags to xfs_mount.

fs/xfs/linux-2.6/xfs_super.c - 1.393 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.393&r2=text&tr2=1.392&f=h
	- move vfs_flags to xfs_mount.

fs/xfs/linux-2.6/xfs_export.c - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_export.c.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
	- move vfs_flags to xfs_mount.

fs/xfs/dmapi/xfs_dm.c - 1.51 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.51&r2=text&tr2=1.50&f=h
	- move vfs_flags to xfs_mount.
