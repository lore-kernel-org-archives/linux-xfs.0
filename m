Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 17:53:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A0rjnp031714
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 17:53:46 -0700
Subject: PARTIAL TAKE 980084 - Check for errors when changing buffer pointers.
Message-Id: <20080410005423.0AA5C58C4C15@chook.melbourne.sgi.com>
Date: Thu, 10 Apr 2008 10:54:23 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Check for errors when changing buffer pointers.

xfs_buf_associate_memory() can fail, but the return is never
checked. Propagate the error through XFS_BUF_SET_PTR() so that
failures are detected.


Date:  Thu Apr 10 10:54:04 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30831a
fs/xfs/xfs_log_recover.c - 1.343 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.343&r2=text&tr2=1.342&f=h
	- Check for errors when changing buffer pointers.
