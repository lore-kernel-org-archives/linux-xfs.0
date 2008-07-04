Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Jul 2008 23:44:58 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m646iquR026566
	for <xfs@oss.sgi.com>; Thu, 3 Jul 2008 23:44:53 -0700
Subject: TAKE 981498 - kill XFS_PURGE_INODE
Message-Id: <20080704064551.8798E58C4C29@chook.melbourne.sgi.com>
Date: Fri,  4 Jul 2008 16:45:51 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

s/XFS_PURGE_INODE/IRELE/g
s/VN_HOLD(XFS_ITOV())/IHOLD()/

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Jul  4 16:44:37 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  hch@lst.de,dchinner@agami.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31405a
fs/xfs/quota/xfs_quota_priv.h - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_quota_priv.h.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
	- s/XFS_PURGE_INODE/IRELE/g

fs/xfs/quota/xfs_qm_syscalls.c - 1.44 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_syscalls.c.diff?r1=text&tr1=1.44&r2=text&tr2=1.43&f=h
	- s/XFS_PURGE_INODE/IRELE/g

fs/xfs/quota/xfs_qm.c - 1.71 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.71&r2=text&tr2=1.70&f=h
	- s/XFS_PURGE_INODE/IRELE/g
