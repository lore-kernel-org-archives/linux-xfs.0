Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 19:29:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m422Sic5022606
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 19:28:48 -0700
Subject: TAKE 981091 - Don't allow memory reclaim to wait on the filesystem in inode writeback
Message-Id: <20080502022924.0CA8C58C4C15@chook.melbourne.sgi.com>
Date: Fri,  2 May 2008 12:29:23 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Don't allow memory reclaim to wait on the filesystem in inode writeback

If we allow memory reclaim to wait on the pages under writeback in
inode cluster writeback we could deadlock because we are currently
holding the ILOCK on the initial writeback inode which is needed in
data I/O completion to change the file size or do unwritten extent
conversion before the pages are taken out of writeback state.


Date:  Fri May  2 12:29:03 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31015a
fs/xfs/xfs_inode.c - 1.501 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.501&r2=text&tr2=1.500&f=h
	- Allocate the inode cluster list with KM_NOFS to prevent reclaim
	  from recursing into the filesystem.
