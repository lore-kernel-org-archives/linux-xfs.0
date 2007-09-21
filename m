Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Sep 2007 23:27:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8L6Rfgf012541
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2007 23:27:46 -0700
From: donaldd@sgi.com
Subject: TAKE 970382 - untangle spinlock macros
Message-Id: <20070921062740.1A03B2F59F9B@linuxbuild.melbourne.sgi.com>
Date: Fri, 21 Sep 2007 16:27:40 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Remove spin.h

remove spinlock init abstraction macro in spin.h, remove the callers, 
and  remove the file.  Move no-op spinlock_destroy to xfs_linux.h
Cleanup spinlock locals in xfs_mount.c

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Fri Sep 21 16:26:30 AEST 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net,lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29751a
fs/xfs/xfs_log.c - 1.339 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.339&r2=text&tr2=1.338&f=h
	- Remove spin.h

fs/xfs/xfs_vfsops.c - 1.543 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.543&r2=text&tr2=1.542&f=h
	- Remove spin.h

fs/xfs/xfs_mount.c - 1.414 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.414&r2=text&tr2=1.413&f=h
	- Remove spin.h, cleanup local spinlock variables. 

fs/xfs/xfs_alloc.c - 1.189 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.189&r2=text&tr2=1.188&f=h
	- Remove spin.h

fs/xfs/support/debug.c - 1.38 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/debug.c.diff?r1=text&tr1=1.38&r2=text&tr2=1.37&f=h
	- Remove spin.h

fs/xfs/support/ktrace.h - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/ktrace.h.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
	- Remove spin.h

fs/xfs/quota/xfs_qm.c - 1.57 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.57&r2=text&tr2=1.56&f=h
	- Remove spin.h

fs/xfs/linux-2.6/xfs_linux.h - 1.159 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.159&r2=text&tr2=1.158&f=h
	- Remove spin.h

fs/xfs/linux-2.6/xfs_buf.c - 1.244 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.244&r2=text&tr2=1.243&f=h
	- Remove spin.h

fs/xfs/linux-2.6/spin.h - 1.22 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/spin.h.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
	- Remove spin.h

fs/xfs/xfs_mru_cache.c - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mru_cache.c.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
	- Remove spin.h
