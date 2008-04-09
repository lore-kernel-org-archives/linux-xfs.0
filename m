Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 00:03:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m39736Rk008517
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 00:03:07 -0700
Subject: PARTIAL TAKE 980084 - Catch errors from xfs_acl_setmode()
Message-Id: <20080409070340.87DD858C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 17:03:40 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Catch errors from xfs_acl_setmode().

Propagate the error status from xfs_acl_setmode() so that callers
know if the ACl was set correctly or not.


Date:  Wed Apr  9 17:03:20 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30792a
fs/xfs/xfs_acl.c - 1.69 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_acl.c.diff?r1=text&tr1=1.69&r2=text&tr2=1.68&f=h
	- Catch errors from xfs_acl_setmode().
