Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 23:51:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m396p6Vf003104
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 23:51:08 -0700
Subject: PARTIAL TAKE 980084 - Check for dquot flush errors
Message-Id: <20080409065141.5957058C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 16:51:41 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Check for dquot flush errors

xfs_qm_dqflush() can fail, but the return is not checked anywhere.
Hence we never know if we've failed to flush a dquot to disk.
Propagate the error and warn to the syslog if a flush ever fails.


Date:  Wed Apr  9 16:51:12 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30787a
fs/xfs/quota/xfs_dquot_item.c - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot_item.c.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
	- Propagate xfs_qm_dqflush() errors.

fs/xfs/quota/xfs_dquot.c - 1.31 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.c.diff?r1=text&tr1=1.31&r2=text&tr2=1.30&f=h
	- Propagate xfs_qm_dqflush() errors.

fs/xfs/quota/xfs_qm.c - 1.63 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.63&r2=text&tr2=1.62&f=h
	- Propagate xfs_qm_dqflush() errors.
