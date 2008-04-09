Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 23:54:18 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m396s8XE003798
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 23:54:10 -0700
Subject: PARTIAL TAKE 980084 - Clean up quotamount error handling.
Message-Id: <20080409065442.4EB1358C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 16:54:42 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Clean up quotamount error handling.

xfs_qm_mount_quotas() returns an error status that is ignored.
If we fail to mount quotas, we continue with quota's turned
off, which is all handled inside xfs_qm_mount_quotas(). Mark
it as void to indicate that errors need not be returned to the
callers.


Date:  Wed Apr  9 16:54:21 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30788a
fs/xfs/quota/xfs_qm.h - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.h.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
	- Clean up quotamount error handling.

fs/xfs/quota/xfs_qm.c - 1.64 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.64&r2=text&tr2=1.63&f=h
	- Clean up quotamount error handling.
