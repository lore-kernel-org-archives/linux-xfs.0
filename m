Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 00:13:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m397DH4p011043
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 00:13:20 -0700
Subject: PARTIAL TAKE 980084 - Propagate errors from xfs_trans_commit()
Message-Id: <20080409071351.F276B58C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 17:13:51 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Propagate errors from xfs_trans_commit().

xfs_trans_commit() can return errors when there are problems
in the transaction subsystem. They are indicative that the entire
transaction may be incomplete, and hence the error should be
propagated as there is a good possibility that there is something
fatally wrong in the filesystem. Catch and propagate or warn
about commit errors in the places where they are currently ignored.

Date:  Wed Apr  9 17:13:30 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30795a
fs/xfs/xfs_vnodeops.c - 1.746 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.746&r2=text&tr2=1.745&f=h
	- Propagate errors from xfs_trans_commit()

fs/xfs/xfs_rtalloc.c - 1.111 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rtalloc.c.diff?r1=text&tr1=1.111&r2=text&tr2=1.110&f=h
	- Propagate errors from xfs_trans_commit()

fs/xfs/xfs_log_recover.c - 1.339 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.339&r2=text&tr2=1.338&f=h
	- Propagate errors from xfs_trans_commit()

fs/xfs/xfs_vfsops.c - 1.560 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.560&r2=text&tr2=1.559&f=h
	- Propagate errors from xfs_trans_commit()

fs/xfs/xfs_mount.c - 1.425 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.425&r2=text&tr2=1.424&f=h
	- Propagate errors from xfs_trans_commit()

fs/xfs/xfs_inode.c - 1.496 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.496&r2=text&tr2=1.495&f=h
	- Propagate errors from xfs_trans_commit()

fs/xfs/quota/xfs_qm_syscalls.c - 1.41 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_syscalls.c.diff?r1=text&tr1=1.41&r2=text&tr2=1.40&f=h
	- Propagate errors from xfs_trans_commit()

fs/xfs/quota/xfs_qm.c - 1.66 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.66&r2=text&tr2=1.65&f=h
	- Propagate errors from xfs_trans_commit()
