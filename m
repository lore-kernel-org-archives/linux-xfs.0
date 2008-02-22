Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 18:16:26 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1M2GHOI021959
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 18:16:21 -0800
Subject: PARTIAL TAKE 976035 - kill xfs_rwlock/xfs_rwunlock
Message-Id: <20080222021635.F082558C4C0F@chook.melbourne.sgi.com>
Date: Fri, 22 Feb 2008 13:16:35 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

kill xfs_rwlock/xfs_rwunlock

We can just use xfs_ilock/xfs_iunlock instead and get rid of the ugly
bhv_vrwlock_t.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Feb 22 13:15:58 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30533a
fs/xfs/xfs_vnodeops.c - 1.738 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.738&r2=text&tr2=1.737&f=h
fs/xfs/xfs_mount.h - 1.257 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.257&r2=text&tr2=1.256&f=h
fs/xfs/linux-2.6/xfs_lrw.c - 1.274 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.274&r2=text&tr2=1.273&f=h
fs/xfs/linux-2.6/xfs_vnode.h - 1.146 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.146&r2=text&tr2=1.145&f=h
fs/xfs/linux-2.6/xfs_aops.c - 1.160 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.160&r2=text&tr2=1.159&f=h
fs/xfs/linux-2.6/xfs_ksyms.c - 1.81 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.81&r2=text&tr2=1.80&f=h
fs/xfs/dmapi/xfs_dm.c - 1.64 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.64&r2=text&tr2=1.63&f=h
fs/xfs/xfs_vnodeops.h - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.h.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
	- kill xfs_rwlock/xfs_rwunlock
