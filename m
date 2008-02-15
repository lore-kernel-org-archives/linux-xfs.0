Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Feb 2008 23:37:29 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1F7bMQr018461
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 23:37:25 -0800
Subject: TAKE 977461 - Use xfs_inode_clean() in more places
Message-Id: <20080215073743.B336358C4C11@chook.melbourne.sgi.com>
Date: Fri, 15 Feb 2008 18:37:43 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Use xfs_inode_clean() in more places

Remove open coded checks for the whether the inode is
clean and replace them with an inlined function.

Date:  Fri Feb 15 18:37:27 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30503a
fs/xfs/xfs_vnodeops.c - 1.735 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.735&r2=text&tr2=1.734&f=h
	- Use xfs_inode_clean() rather than open coding the check.

fs/xfs/xfs_inode_item.h - 1.50 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode_item.h.diff?r1=text&tr1=1.50&r2=text&tr2=1.49&f=h
	- Use xfs_inode_clean() rather than open coding the check.

fs/xfs/xfs_inode.c - 1.494 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.494&r2=text&tr2=1.493&f=h
	- Use xfs_inode_clean() rather than open coding the check.
