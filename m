Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 01:28:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l548SHWt021598
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 01:28:18 -0700
Subject: TAKE 965636 - xfs_setfilesize panics on null xfs_inode
Message-Id: <20070604082812.49AF658C38C1@chook.melbourne.sgi.com>
Date: Mon,  4 Jun 2007 18:28:12 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Handle null returned from xfs_vtoi() in xfs_setfilesize().


Date:  Mon Jun  4 18:27:21 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  tes@sgi.com, olaf@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28777a
fs/xfs/linux-2.6/xfs_aops.c - 1.145 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.145&r2=text&tr2=1.144&f=h
	- If we get a null xfs_inode in xfs_setfilesize(), we can't update
	  the file size. Don't even bother trying.
