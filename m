Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 23:47:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m396lXrO002288
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 23:47:35 -0700
Subject: PARTIAL TAKE 980084 - Propagate xfs_qm_dqflush_all() errors.
Message-Id: <20080409064807.95CE558C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 16:48:07 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Propagate xfs_qm_dqflush_all() errors.

xfs_qm_dqflush_all() can return flush errors. Ensure they are propagated
into the quotacheck code to determine if the quotacheck succeeded or not.

Date:  Wed Apr  9 16:47:44 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30786a
fs/xfs/quota/xfs_qm.c - 1.62 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.62&r2=text&tr2=1.61&f=h
	- Propagate xfs_qm_dqflush_all() errors.
