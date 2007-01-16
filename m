Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Jan 2007 22:13:14 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0G6D0r2015798
	for <xfs@oss.sgi.com>; Mon, 15 Jan 2007 22:13:08 -0800
Subject: PARTIAL TAKE 957103 - Merge 2.6.x-xfs up to more recent kernels and new kdb versions
Message-Id: <20070116060314.1E6BB58F92CD@chook.melbourne.sgi.com>
Date: Tue, 16 Jan 2007 17:03:14 +1100 (EST)
From: vapo@sgi.com (Vlad Apostolov)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Date:  Tue Jan 16 17:02:31 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/vapo/isms/linux-xfs
Inspected by:  chatz

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  2.6.x-xfs-melb:linux:27935a
mainline-patches/linux-2.6/xfs_sysctl.c - 1.3 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/mainline-patches/linux-2.6/xfs_sysctl.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
mainline-patches/linux-2.6/xfs_vfs.c - 1.3 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/mainline-patches/linux-2.6/xfs_vfs.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
mainline-patches/xfs_vfsops.c - 1.3 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/mainline-patches/xfs_vfsops.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
mainline-patches/xfs_iget.c - 1.3 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/mainline-patches/xfs_iget.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
mainline-patches/linux-2.6/xfs_vfs.h - 1.3 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/mainline-patches/linux-2.6/xfs_vfs.h.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
mainline-patches/Makefile-linux-2.6 - 1.3 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/mainline-patches/Makefile-linux-2.6.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
mainline-patches/linux-2.6/xfs_globals.c - 1.3 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/mainline-patches/linux-2.6/xfs_globals.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
mainline-patches/linux-2.6/xfs_linux.h - 1.3 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/mainline-patches/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
mainline-patches/linux-2.6/xfs_sysctl.h - 1.3 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/mainline-patches/linux-2.6/xfs_sysctl.h.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
mainline-patches/linux-2.6/xfs_super.c - 1.3 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/mainline-patches/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
mainline-patches/linux-2.6/xfs_super.h - 1.3 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/mainline-patches/linux-2.6/xfs_super.h.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
mainline-patches/xfs_acl.c - 1.3 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/mainline-patches/xfs_acl.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
mainline-patches/xfs.h - 1.3 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/mainline-patches/xfs.h.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
mainline-patches/linux-2.6/xfs_vnode.h - 1.3 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/mainline-patches/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
mainline-patches/quota/xfs_qm_bhv.c - 1.3 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/mainline-patches/quota/xfs_qm_bhv.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
mainline-patches/xfs_behavior.h - 1.3 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/mainline-patches/xfs_behavior.h.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
	- Reinstate delete file.
