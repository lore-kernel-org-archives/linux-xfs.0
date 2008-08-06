Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 22:18:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m765Ij91008237
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 22:18:46 -0700
Subject: TAKE 981498 - cleanup xfs_mountfs
Message-Id: <20080806051957.3F05758C52A4@chook.melbourne.sgi.com>
Date: Wed,  6 Aug 2008 15:19:57 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

cleanup xfs_mountfs

Remove all the useless flags and code keyed off it in xfs_mountfs.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Aug  6 15:19:16 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-mm
Inspected by:  
hch
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31831a
fs/xfs/xfs_log.h - 1.82 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.h.diff?r1=text&tr1=1.82&r2=text&tr2=1.81&f=h
fs/xfs/xfs_log.c - 1.361 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.361&r2=text&tr2=1.360&f=h
fs/xfs/xfs_log_priv.h - 1.133 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_priv.h.diff?r1=text&tr1=1.133&r2=text&tr2=1.132&f=h
fs/xfs/xfs_log_recover.c - 1.347 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.347&r2=text&tr2=1.346&f=h
fs/xfs/xfs_mount.h - 1.273 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.273&r2=text&tr2=1.272&f=h
fs/xfs/xfs_mount.c - 1.441 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.441&r2=text&tr2=1.440&f=h
fs/xfs/quota/xfs_qm_bhv.c - 1.29 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_bhv.c.diff?r1=text&tr1=1.29&r2=text&tr2=1.28&f=h
fs/xfs/quota/xfs_qm.h - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.h.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
fs/xfs/quota/xfs_qm.c - 1.73 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.73&r2=text&tr2=1.72&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.445 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.445&r2=text&tr2=1.444&f=h
	- cleanup xfs_mountfs
