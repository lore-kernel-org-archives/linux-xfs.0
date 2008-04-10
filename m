Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 17:42:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A0gEJU029094
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 17:42:17 -0700
Subject: PARTIAL TAKE 980084 - Catch unwritten extent conversion errors.
Message-Id: <20080410004252.100DB58C4C15@chook.melbourne.sgi.com>
Date: Thu, 10 Apr 2008 10:42:52 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Catch unwritten extent conversion errors.

On unwritten I/O completion, we fail to propagate an error
when converting the extent to a written extent. This means that
the I/O silently fails. propagate the error onto the ioend so that
the inode is marked with an error appropriately.


Date:  Thu Apr 10 10:42:31 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30826a
fs/xfs/linux-2.6/xfs_aops.c - 1.161 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.161&r2=text&tr2=1.160&f=h
	- Catch unwritten extent conversion errors.
