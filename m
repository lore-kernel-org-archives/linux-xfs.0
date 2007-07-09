Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 08 Jul 2007 22:21:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l695LBtL018231
	for <xfs@oss.sgi.com>; Sun, 8 Jul 2007 22:21:13 -0700
Subject: TAKE 964469 - XFS Concurrent Multi-File Data Streams
Message-Id: <20070709052108.DD76158C38F1@chook.melbourne.sgi.com>
Date: Mon,  9 Jul 2007 15:21:08 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Quota inode has no parent.

Avoid using a special "zero inode" as the parent of the quota inode
as this can confuse the filestreams code into thinking the quota inode
has a parent. We do not want the quota inode to follow filestreams allocation
rules, so pass a NULL as the parent inode and detect this condition
when doing stream associations.

Date:  Mon Jul  9 15:20:37 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  tes@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29098a
fs/xfs/xfs_inode.c - 1.466 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.466&r2=text&tr2=1.465&f=h
	- Check for inodes without parents and don't try to associate them
	  or inherit from a non-existent parent inode.

fs/xfs/quota/xfs_qm.c - 1.50 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.50&r2=text&tr2=1.49&f=h
	- Do not use a special zero inode as the quota inode parent. This
	  avoids incorrect detection of a parent inode when allocating
	  new inodes.
