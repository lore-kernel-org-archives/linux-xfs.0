Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 01:26:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l8Q8QKSU032022
	for <xfs@oss.sgi.com>; Wed, 26 Sep 2007 01:26:23 -0700
From: donaldd@sgi.com
Subject: PARTIAL TAKE 971050 - Remove linux-2.4 build support
Message-Id: <20070926082614.D92CE300F406@linuxbuild.melbourne.sgi.com>
Date: Wed, 26 Sep 2007 18:26:14 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Remove fs/xfs/linux-2.4 as building for 2.4 kernels is no longer supported from this tree

Date:  Wed Sep 26 18:24:41 AEST 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  tes

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29785a
fs/xfs/linux-2.4/xfs_lrw.h - 1.51 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_lrw.h.diff?r1=text&tr1=1.51&r2=text&tr2=1.50&f=h
fs/xfs/linux-2.4/xfs_lrw.c - 1.240 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_lrw.c.diff?r1=text&tr1=1.240&r2=text&tr2=1.239&f=h
fs/xfs/linux-2.4/xfs_version.h - 1.173 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_version.h.diff?r1=text&tr1=1.173&r2=text&tr2=1.172&f=h
fs/xfs/linux-2.4/xfs_ioctl.c - 1.136 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_ioctl.c.diff?r1=text&tr1=1.136&r2=text&tr2=1.135&f=h
fs/xfs/linux-2.4/xfs_vfs.h - 1.67 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_vfs.h.diff?r1=text&tr1=1.67&r2=text&tr2=1.66&f=h
fs/xfs/linux-2.4/xfs_vfs.c - 1.68 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_vfs.c.diff?r1=text&tr1=1.68&r2=text&tr2=1.67&f=h
fs/xfs/linux-2.4/xfs_globals.h - 1.25 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_globals.h.diff?r1=text&tr1=1.25&r2=text&tr2=1.24&f=h
fs/xfs/linux-2.4/xfs_globals.c - 1.79 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_globals.c.diff?r1=text&tr1=1.79&r2=text&tr2=1.78&f=h
fs/xfs/linux-2.4/xfs_linux.h - 1.164 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_linux.h.diff?r1=text&tr1=1.164&r2=text&tr2=1.163&f=h
fs/xfs/linux-2.4/Makefile - 1.211 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/Makefile.diff?r1=text&tr1=1.211&r2=text&tr2=1.210&f=h
fs/xfs/linux-2.4/xfs_file.c - 1.131 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_file.c.diff?r1=text&tr1=1.131&r2=text&tr2=1.130&f=h
fs/xfs/linux-2.4/xfs_cred.h - 1.28 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_cred.h.diff?r1=text&tr1=1.28&r2=text&tr2=1.27&f=h
fs/xfs/linux-2.4/xfs_vnode.c - 1.140 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_vnode.c.diff?r1=text&tr1=1.140&r2=text&tr2=1.139&f=h
fs/xfs/linux-2.4/xfs_vnode.h - 1.116 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_vnode.h.diff?r1=text&tr1=1.116&r2=text&tr2=1.115&f=h
fs/xfs/linux-2.4/xfs_stats.c - 1.23 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_stats.c.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
fs/xfs/linux-2.4/xfs_stats.h - 1.16 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_stats.h.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
fs/xfs/linux-2.4/xfs_fs_subr.c - 1.50 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_fs_subr.c.diff?r1=text&tr1=1.50&r2=text&tr2=1.49&f=h
fs/xfs/linux-2.4/xfs_fs_subr.h - 1.19 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_fs_subr.h.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
fs/xfs/linux-2.4/xfs_super.h - 1.74 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_super.h.diff?r1=text&tr1=1.74&r2=text&tr2=1.73&f=h
fs/xfs/linux-2.4/xfs_super.c - 1.338 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_super.c.diff?r1=text&tr1=1.338&r2=text&tr2=1.337&f=h
fs/xfs/linux-2.4/xfs_iops.c - 1.230 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_iops.c.diff?r1=text&tr1=1.230&r2=text&tr2=1.229&f=h
fs/xfs/linux-2.4/xfs_iops.h - 1.33 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_iops.h.diff?r1=text&tr1=1.33&r2=text&tr2=1.32&f=h
fs/xfs/linux-2.4/xfs_aops.c - 1.106 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_aops.c.diff?r1=text&tr1=1.106&r2=text&tr2=1.105&f=h
fs/xfs/linux-2.4/xfs_sysctl.c - 1.42 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_sysctl.c.diff?r1=text&tr1=1.42&r2=text&tr2=1.41&f=h
fs/xfs/linux-2.4/xfs_sysctl.h - 1.32 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_sysctl.h.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
fs/xfs/linux-2.4/xfs_buf.h - 1.119 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_buf.h.diff?r1=text&tr1=1.119&r2=text&tr2=1.118&f=h
fs/xfs/linux-2.4/xfs_buf.c - 1.220 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_buf.c.diff?r1=text&tr1=1.220&r2=text&tr2=1.219&f=h
fs/xfs/linux-2.4/kmem.h - 1.35 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/kmem.h.diff?r1=text&tr1=1.35&r2=text&tr2=1.34&f=h
fs/xfs/linux-2.4/kmem.c - 1.39 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/kmem.c.diff?r1=text&tr1=1.39&r2=text&tr2=1.38&f=h
fs/xfs/linux-2.4/xfs_ksyms.c - 1.50 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_ksyms.c.diff?r1=text&tr1=1.50&r2=text&tr2=1.49&f=h
fs/xfs/linux-2.4/sema.h - 1.17 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/sema.h.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
fs/xfs/linux-2.4/mrlock.c - 1.24 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/mrlock.c.diff?r1=text&tr1=1.24&r2=text&tr2=1.23&f=h
fs/xfs/linux-2.4/mrlock.h - 1.17 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/mrlock.h.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
fs/xfs/linux-2.4/time.h - 1.19 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/time.h.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
fs/xfs/linux-2.4/sv.h - 1.20 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/sv.h.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
fs/xfs/linux-2.4/spin.h - 1.24 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/spin.h.diff?r1=text&tr1=1.24&r2=text&tr2=1.23&f=h
fs/xfs/linux-2.4/mutex.h - 1.19 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/mutex.h.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
fs/xfs/linux-2.4/mrlock_rwsem.h - 1.5 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/mrlock_rwsem.h.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
fs/xfs/linux-2.4/xfs_export.h - 1.3 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_export.h.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
fs/xfs/linux-2.4/xfs_ioctl32.h - 1.3 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_ioctl32.h.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
fs/xfs/linux-2.4/xfs_ioctl32.c - 1.3 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_ioctl32.c.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
fs/xfs/linux-2.4/xfs_dmapi_priv.h - 1.2 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_dmapi_priv.h.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
