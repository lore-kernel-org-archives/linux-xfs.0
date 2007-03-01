Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Mar 2007 11:04:09 -0800 (PST)
Received: from lab41.emea.sgi.com (lab41.emea.sgi.com [144.253.75.41])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l21J446p020323
	for <xfs@oss.sgi.com>; Thu, 1 Mar 2007 11:04:05 -0800
Subject: TAKE 961693 - The last argument "lsn" of xfs_trans_commit() is always called with NULL.
Message-Id: <20070301185655.E9CE752AC0@lab41.emea.sgi.com>
Date: Thu,  1 Mar 2007 18:56:55 +0000 (GMT)
From: lachlan@lab41.emea.sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The last argument "lsn" of xfs_trans_commit() is always called with NULL.

Patch provided by Eric Sandeen.
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Fri Mar  2 05:02:20 AEDT 2007
Workarea:  vpn-emea-sw-emea-160-20.emea.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  
tes
sandeen@sandeen.net
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28199a
fs/xfs/xfs_rw.c - 1.398 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rw.c.diff?r1=text&tr1=1.398&r2=text&tr2=1.397&f=h
fs/xfs/xfs_vnodeops.c - 1.690 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.690&r2=text&tr2=1.689&f=h
fs/xfs/xfs_rtalloc.c - 1.106 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rtalloc.c.diff?r1=text&tr1=1.106&r2=text&tr2=1.105&f=h
fs/xfs/xfs_log_recover.c - 1.316 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.316&r2=text&tr2=1.315&f=h
fs/xfs/xfs_vfsops.c - 1.516 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.516&r2=text&tr2=1.515&f=h
fs/xfs/xfs_dfrag.c - 1.58 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dfrag.c.diff?r1=text&tr1=1.58&r2=text&tr2=1.57&f=h
fs/xfs/xfs_mount.c - 1.393 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.393&r2=text&tr2=1.392&f=h
fs/xfs/xfs_inode.c - 1.461 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.461&r2=text&tr2=1.460&f=h
fs/xfs/xfs_qmops.c - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_qmops.c.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
fs/xfs/xfs_attr_leaf.c - 1.107 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr_leaf.c.diff?r1=text&tr1=1.107&r2=text&tr2=1.106&f=h
fs/xfs/xfs_trans.c - 1.178 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.c.diff?r1=text&tr1=1.178&r2=text&tr2=1.177&f=h
fs/xfs/xfs_trans.h - 1.144 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.h.diff?r1=text&tr1=1.144&r2=text&tr2=1.143&f=h
fs/xfs/xfs_utils.c - 1.73 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_utils.c.diff?r1=text&tr1=1.73&r2=text&tr2=1.72&f=h
fs/xfs/xfs_fsops.c - 1.122 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c.diff?r1=text&tr1=1.122&r2=text&tr2=1.121&f=h
fs/xfs/xfs_bmap.c - 1.365 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.365&r2=text&tr2=1.364&f=h
fs/xfs/xfs_rename.c - 1.70 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rename.c.diff?r1=text&tr1=1.70&r2=text&tr2=1.69&f=h
fs/xfs/xfs_attr.c - 1.143 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.c.diff?r1=text&tr1=1.143&r2=text&tr2=1.142&f=h
fs/xfs/quota/xfs_qm_syscalls.c - 1.31 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_syscalls.c.diff?r1=text&tr1=1.31&r2=text&tr2=1.30&f=h
fs/xfs/quota/xfs_dquot.c - 1.29 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.c.diff?r1=text&tr1=1.29&r2=text&tr2=1.28&f=h
fs/xfs/quota/xfs_qm.c - 1.47 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.47&r2=text&tr2=1.46&f=h
fs/xfs/xfs_iomap.c - 1.51 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.c.diff?r1=text&tr1=1.51&r2=text&tr2=1.50&f=h
fs/xfs/dmapi/xfs_dm.c - 1.33 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.33&r2=text&tr2=1.32&f=h
	- The last argument "lsn" of xfs_trans_commit() is always called with NULL.
	  Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
