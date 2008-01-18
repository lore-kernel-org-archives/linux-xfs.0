Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jan 2008 22:59:45 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0I6xZup002655
	for <xfs@oss.sgi.com>; Thu, 17 Jan 2008 22:59:39 -0800
Subject: TAKE 972759 - Make xfs_ail_check check less by default
Message-Id: <20080118065950.0435658C4C0F@chook.melbourne.sgi.com>
Date: Fri, 18 Jan 2008 17:59:49 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Make xfs_ail_check check less by default

Checking the entire AIL on every insert and remove is
prohibitively expensive - the sustained sequntial create rate
on a single disk drops from about 1800/s to 60/s because of
this checking resulting in the xfslogd becoming cpu bound.

By default on debug builds, only check the next and previous
entries in the list to ensure they are ordered correctly.
If you really want, define XFS_TRANS_DEBUG to use the old
behaviour.


Date:  Fri Jan 18 17:59:29 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30372a
fs/xfs/xfs_trans_ail.c - 1.84 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_ail.c.diff?r1=text&tr1=1.84&r2=text&tr2=1.83&f=h
	- Make exhaustive AIL checking only occur when XFS_TRANS_DEBUG
	  is defined to prevent excessive performance loss on normal
	  debug kernels.
