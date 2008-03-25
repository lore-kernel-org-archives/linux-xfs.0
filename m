Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Mar 2008 23:55:42 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2P6tVwA011171
	for <xfs@oss.sgi.com>; Mon, 24 Mar 2008 23:55:33 -0700
Subject: PARTIAL TAKE 976035 - remove most calls to VN_RELE
Message-Id: <20080325065601.5CD2D58C4C0F@chook.melbourne.sgi.com>
Date: Tue, 25 Mar 2008 17:56:01 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

remove most calls to VN_RELE

Most VN_RELE calls either directly contain a XFS_ITOV or have the
corresponding xfs_inode already in scope.  Use the IRELE helper instead
of VN_RELE to clarify the code.  With a little more work we can kill
VN_RELE altogether and define IRELE in terms of iput directly.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Tue Mar 25 17:54:50 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30710a
fs/xfs/xfs_rtalloc.c - 1.110 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rtalloc.c.diff?r1=text&tr1=1.110&r2=text&tr2=1.109&f=h
fs/xfs/xfs_log_recover.c - 1.336 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.336&r2=text&tr2=1.335&f=h
fs/xfs/xfs_vfsops.c - 1.557 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.557&r2=text&tr2=1.556&f=h
fs/xfs/xfs_mount.c - 1.421 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.421&r2=text&tr2=1.420&f=h
fs/xfs/quota/xfs_qm_syscalls.c - 1.38 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_syscalls.c.diff?r1=text&tr1=1.38&r2=text&tr2=1.37&f=h
fs/xfs/quota/xfs_qm.c - 1.60 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.60&r2=text&tr2=1.59&f=h
	- remove most calls to VN_RELE
