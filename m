Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Dec 2006 16:47:15 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kB70l2aG023174
	for <xfs@oss.sgi.com>; Wed, 6 Dec 2006 16:47:05 -0800
Subject: PARTIAL TAKE 956832 -  xfs_iunpin() sets I_DIRTY_SYNC after clear_inode()
Message-Id: <20061107060143.0CFA558FA27C@chook.melbourne.sgi.com>
Date: Tue,  7 Nov 2006 17:01:42 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Clean up i_flags and i_flags_lock handling.

Date:  Tue Nov  7 17:00:11 AEDT 2006
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  nscott@aconex.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27358a
fs/xfs/xfs_vnodeops.c - 1.686 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.686&r2=text&tr2=1.685&f=h
	- Use prepackaged i_flags handling functions.

fs/xfs/xfs_iget.c - 1.223 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.223&r2=text&tr2=1.222&f=h
	- Use prepackaged i_flags handling functions.

fs/xfs/xfs_inode.c - 1.453 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.453&r2=text&tr2=1.452&f=h
	- Use prepackaged i_flags handling functions.

fs/xfs/xfs_inode.h - 1.217 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.217&r2=text&tr2=1.216&f=h
	- define common i_flags handling functions.

fs/xfs/linux-2.6/xfs_super.c - 1.373 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.373&r2=text&tr2=1.372&f=h
	- Use prepackaged i_flags handling functions.
