Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 23:14:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m766EfZ4016659
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 23:14:42 -0700
Subject: TAKE 981498 - Use KM_NOFS for debug trace buffers
Message-Id: <20080806061553.A8D8958C52A4@chook.melbourne.sgi.com>
Date: Wed,  6 Aug 2008 16:15:53 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Use KM_NOFS for debug trace buffers

Use KM_NOFS to prevent recursion back into the filesystem which can
cause deadlocks.

In the case of xfs_iread() we hold the lock on the inode cluster buffer
while allocating memory for the trace buffers.  If we recurse back into
XFS to flush data that may require a transaction to allocate extents
which needs log space.  This can deadlock with the xfsaild thread which
can't push the tail of the log because it is trying to get the inode
cluster buffer lock.

Date:  Wed Aug  6 16:15:14 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-mm
Inspected by:  david@fromorbit.com
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31838a
fs/xfs/xfs_log.c - 1.362 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.362&r2=text&tr2=1.361&f=h
fs/xfs/xfs_buf_item.c - 1.168 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_buf_item.c.diff?r1=text&tr1=1.168&r2=text&tr2=1.167&f=h
fs/xfs/xfs_inode.c - 1.518 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.518&r2=text&tr2=1.517&f=h
fs/xfs/quota/xfs_dquot.c - 1.38 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.c.diff?r1=text&tr1=1.38&r2=text&tr2=1.37&f=h
fs/xfs/linux-2.6/xfs_buf.c - 1.262 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.262&r2=text&tr2=1.261&f=h
fs/xfs/xfs_filestream.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_filestream.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
	- Use KM_NOFS for debug trace buffers
