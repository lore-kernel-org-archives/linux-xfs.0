Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 17:41:26 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1M1fBHU018831
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 17:41:18 -0800
From: donaldd@sgi.com
Subject: TAKE 976035 - remove shouting-indirection macros from xfs_sb.h
Message-Id: <20080222014133.7AF36323B4D0@linuxbuild.melbourne.sgi.com>
Date: Fri, 22 Feb 2008 12:41:33 +1100 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

remove shouting-indirection macros from xfs_sb.h

Remove macro-to-small-function indirection from xfs_sb.h,
and remove some which are completely unused.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Fri Feb 22 12:40:40 AEDT 2008
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  donaldd

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30528a
fs/xfs/xfs_log.c - 1.349 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.349&r2=text&tr2=1.348&f=h
	- remove shouting-indirection macros from xfs_sb.h

fs/xfs/xfs_ialloc.c - 1.196 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.c.diff?r1=text&tr1=1.196&r2=text&tr2=1.195&f=h
	- remove shouting-indirection macros from xfs_sb.h

fs/xfs/xfs_log_priv.h - 1.127 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_priv.h.diff?r1=text&tr1=1.127&r2=text&tr2=1.126&f=h
	- remove shouting-indirection macros from xfs_sb.h

fs/xfs/xfs_sb.h - 1.70 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_sb.h.diff?r1=text&tr1=1.70&r2=text&tr2=1.69&f=h
	- remove shouting-indirection macros from xfs_sb.h

fs/xfs/xfs_vnodeops.c - 1.736 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.736&r2=text&tr2=1.735&f=h
	- remove shouting-indirection macros from xfs_sb.h

fs/xfs/xfs_itable.c - 1.162 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.162&r2=text&tr2=1.161&f=h
	- remove shouting-indirection macros from xfs_sb.h

fs/xfs/xfs_inode_item.c - 1.133 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode_item.c.diff?r1=text&tr1=1.133&r2=text&tr2=1.132&f=h
	- remove shouting-indirection macros from xfs_sb.h

fs/xfs/xfs_log_recover.c - 1.335 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.335&r2=text&tr2=1.334&f=h
	- remove shouting-indirection macros from xfs_sb.h

fs/xfs/xfs_vfsops.c - 1.554 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.554&r2=text&tr2=1.553&f=h
	- remove shouting-indirection macros from xfs_sb.h

fs/xfs/xfs_bmap_btree.h - 1.80 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.80&r2=text&tr2=1.79&f=h
	- remove shouting-indirection macros from xfs_sb.h

fs/xfs/xfs_mount.c - 1.418 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.418&r2=text&tr2=1.417&f=h
	- remove shouting-indirection macros from xfs_sb.h

fs/xfs/xfs_inode.c - 1.495 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.495&r2=text&tr2=1.494&f=h
	- remove shouting-indirection macros from xfs_sb.h

fs/xfs/xfs_attr_leaf.c - 1.109 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr_leaf.c.diff?r1=text&tr1=1.109&r2=text&tr2=1.108&f=h
	- remove shouting-indirection macros from xfs_sb.h

fs/xfs/xfs_utils.c - 1.80 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_utils.c.diff?r1=text&tr1=1.80&r2=text&tr2=1.79&f=h
	- remove shouting-indirection macros from xfs_sb.h

fs/xfs/xfs_fsops.c - 1.132 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c.diff?r1=text&tr1=1.132&r2=text&tr2=1.131&f=h
	- remove shouting-indirection macros from xfs_sb.h

fs/xfs/xfs_bmap.c - 1.384 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.384&r2=text&tr2=1.383&f=h
	- remove shouting-indirection macros from xfs_sb.h

fs/xfs/xfs_dir2.c - 1.62 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2.c.diff?r1=text&tr1=1.62&r2=text&tr2=1.61&f=h
	- remove shouting-indirection macros from xfs_sb.h

fs/xfs/quota/xfs_qm_bhv.c - 1.28 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_bhv.c.diff?r1=text&tr1=1.28&r2=text&tr2=1.27&f=h
	- remove shouting-indirection macros from xfs_sb.h

fs/xfs/quota/xfs_qm_syscalls.c - 1.37 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_syscalls.c.diff?r1=text&tr1=1.37&r2=text&tr2=1.36&f=h
	- remove shouting-indirection macros from xfs_sb.h

fs/xfs/quota/xfs_qm.c - 1.59 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.59&r2=text&tr2=1.58&f=h
	- remove shouting-indirection macros from xfs_sb.h

fs/xfs/linux-2.6/xfs_ioctl.c - 1.160 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.160&r2=text&tr2=1.159&f=h
	- remove shouting-indirection macros from xfs_sb.h
