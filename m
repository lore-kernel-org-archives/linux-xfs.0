Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Apr 2008 22:16:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3L5FnQJ002475
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2008 22:15:53 -0700
Subject: PARTIAL TAKE 976035 - shrink mrlock_t
Message-Id: <20080421051627.40AEB58C4C15@chook.melbourne.sgi.com>
Date: Mon, 21 Apr 2008 15:16:27 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

shrink mrlock_t

The writer field is not needed for non_DEBU builds so remove it.  While
we're at i also clean up the interface for is locked asserts to go
through and xfs_iget.c helper with an interface like the xfs_ilock
routines to isolated the XFS codebase from mrlock internals.  That way
we can kill mrlock_t entirely once rw_semaphores grow an islocked
facility.  Also remove unused flags to the ilock family of functions.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Mon Apr 21 15:15:57 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30902a
fs/xfs/xfs_trans_inode.c - 1.54 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_inode.c.diff?r1=text&tr1=1.54&r2=text&tr2=1.53&f=h
fs/xfs/xfs_vnodeops.c - 1.754 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.754&r2=text&tr2=1.753&f=h
fs/xfs/xfs_inode_item.c - 1.135 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode_item.c.diff?r1=text&tr1=1.135&r2=text&tr2=1.134&f=h
fs/xfs/xfs_iget.c - 1.241 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.241&r2=text&tr2=1.240&f=h
fs/xfs/xfs_inode.c - 1.500 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.500&r2=text&tr2=1.499&f=h
fs/xfs/xfs_inode.h - 1.244 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.244&r2=text&tr2=1.243&f=h
fs/xfs/xfs_utils.c - 1.83 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_utils.c.diff?r1=text&tr1=1.83&r2=text&tr2=1.82&f=h
fs/xfs/xfs_bmap.c - 1.391 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.391&r2=text&tr2=1.390&f=h
fs/xfs/quota/xfs_trans_dquot.c - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_trans_dquot.c.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
fs/xfs/quota/xfs_quota_priv.h - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_quota_priv.h.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
fs/xfs/quota/xfs_dquot.c - 1.33 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.c.diff?r1=text&tr1=1.33&r2=text&tr2=1.32&f=h
fs/xfs/quota/xfs_qm.c - 1.68 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.68&r2=text&tr2=1.67&f=h
fs/xfs/xfs_iomap.c - 1.63 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.c.diff?r1=text&tr1=1.63&r2=text&tr2=1.62&f=h
fs/xfs/linux-2.6/xfs_lrw.c - 1.280 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.280&r2=text&tr2=1.279&f=h
fs/xfs/linux-2.6/xfs_ksyms.c - 1.83 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.83&r2=text&tr2=1.82&f=h
fs/xfs/linux-2.6/mrlock.h - 1.23 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/mrlock.h.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
	- shrink mrlock_t
