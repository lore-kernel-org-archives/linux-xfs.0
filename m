Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Apr 2008 04:19:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3ABJ74Z022427
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2008 04:19:09 -0700
Subject: TAKE 980084 - Ensure the inode is joined in xfs_itruncate_finish
Message-Id: <20080410111939.ECD4058C4C15@chook.melbourne.sgi.com>
Date: Thu, 10 Apr 2008 21:19:39 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Ensure the inode is joined in xfs_itruncate_finish

On success, we still need to join the inode to the current
transaction in xfs_itruncate_finish(). Fixes regression from
error handling changes.

Date:  Thu Apr 10 21:19:22 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30845a
fs/xfs/xfs_inode.c - 1.499 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.499&r2=text&tr2=1.498&f=h
	- Ensure the inode is always joined to the current transaction in
	  xfs_itruncate_finish().
