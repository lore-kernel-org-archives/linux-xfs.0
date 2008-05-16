Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 21:57:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4G4uoX2016469
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 21:56:52 -0700
Subject: TAKE 981875 - xfs_dm_rdwr() needs to pass a vfsmount to dentry_open()
Message-Id: <20080516045732.F12DC58C4C29@chook.melbourne.sgi.com>
Date: Fri, 16 May 2008 14:57:32 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

xfs_dm_rdwr() needs to pass a vfsmount to dentry_open()

We need a vfsmount pointer in xfs_dm_rdwr() but we are not
provided with one and there's no way to get to it.  So add
a m_vfsmount field to the xfs_mount structure and set it
up at mount time.  We can then access it through the xfs
inode.

Date:  Fri May 16 14:56:46 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-bmap
Inspected by:  dgc
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31176a
fs/xfs/xfs_mount.h - 1.266 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.266&r2=text&tr2=1.265&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.417 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.417&r2=text&tr2=1.416&f=h
	- Set up a vfsmount pointer in the xfs mount structure.

fs/xfs/dmapi/xfs_dm.c - 1.73 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.73&r2=text&tr2=1.72&f=h
	- xfs_dm_rdwr() needs to pass a vfsmount to dentry_open()
