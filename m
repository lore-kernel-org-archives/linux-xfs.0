Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 May 2008 23:58:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4J6wMr4024927
	for <xfs@oss.sgi.com>; Sun, 18 May 2008 23:58:23 -0700
Subject: TAKE 981949 - Fix inode list allocation size in writeback.
Message-Id: <20080519065906.1C9C058C4C29@chook.melbourne.sgi.com>
Date: Mon, 19 May 2008 16:59:06 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix inode list allocation size in writeback.

We only need to allocate space for the number of inodes in
the cluster when writing back inodes, not every byte in the
inode cluster. This reduces the amount of memory needing to
be allocated to 256 bytes instead of 64k.


Date:  Mon May 19 16:58:49 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31182a
fs/xfs/xfs_inode.c - 1.503 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.503&r2=text&tr2=1.502&f=h
	- Only allocate enough memory for the pointer list in inode cluster
	  writeback.
