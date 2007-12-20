Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Dec 2007 21:33:18 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBK5X6w1031849
	for <xfs@oss.sgi.com>; Wed, 19 Dec 2007 21:33:12 -0800
Subject: TAKE 974905 - Initialise current offset in xfs_file_readdir correctly
Message-Id: <20071220053315.8F50C58C4C0F@chook.melbourne.sgi.com>
Date: Thu, 20 Dec 2007 16:33:15 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Initialise current offset in xfs_file_readdir correctly

After reading the directory contents into the temporary buffer, we
grab each dirent and pass it to filldir witht eh current offset of
the dirent. The current offset was not being set for the first
dirent in the temporary buffer, which coul dresult in bad offsets
being set in the f_pos field result in looping and duplicate entries
being returned from readdir.

Date:  Thu Dec 20 16:32:49 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  tes@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30282a
fs/xfs/linux-2.6/xfs_file.c - 1.161 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_file.c.diff?r1=text&tr1=1.161&r2=text&tr2=1.160&f=h
	- Initialise the curr_offset correctly for the first dirent in each temp
	  buffer during readdir.
