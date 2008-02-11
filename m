Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 10 Feb 2008 23:44:50 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1B7iOJt003541
	for <xfs@oss.sgi.com>; Sun, 10 Feb 2008 23:44:32 -0800
From: donaldd@sgi.com
Subject: PARTIAL TAKE 971186 - 
Message-Id: <20080211074442.604F8334AB1F@linuxbuild.melbourne.sgi.com>
Date: Mon, 11 Feb 2008 18:44:42 +1100 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Remove the xfs_refcache, it was only needed while we were still building for
2.4 kernels.


Date:  Mon Feb 11 18:43:07 AEDT 2008
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  lachlan,hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30472a
fs/xfs/xfs_vnodeops.c - 1.732 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.732&r2=text&tr2=1.731&f=h
	- Remove xfs_refcache.

fs/xfs/xfs_vfsops.c - 1.552 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.552&r2=text&tr2=1.551&f=h
	- Remove xfs_refcache.

fs/xfs/xfs_inode.h - 1.241 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.241&r2=text&tr2=1.240&f=h
	- Remove xfs_refcache.

fs/xfs/xfs_rename.c - 1.78 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rename.c.diff?r1=text&tr1=1.78&r2=text&tr2=1.77&f=h
	- Remove xfs_refcache.

fs/xfs/xfs_refcache.c - 1.8 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_refcache.c.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
	- Remove xfs_refcache.

fs/xfs/xfs_refcache.h - 1.3 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_refcache.h.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
	- Remove xfs_refcache.

fs/xfs/linux-2.6/xfs_linux.h - 1.163 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.163&r2=text&tr2=1.162&f=h
	- Remove xfs_refcache.

fs/xfs/linux-2.6/xfs_ksyms.c - 1.79 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.79&r2=text&tr2=1.78&f=h
	- Remove xfs_refcache.
