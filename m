Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 17:39:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A0cnQ8028146
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 17:38:51 -0700
Subject: PARTIAL TAKE 980084 - Ensure xfs_bawrite() errors are checked.
Message-Id: <20080410003927.538A758C4C15@chook.melbourne.sgi.com>
Date: Thu, 10 Apr 2008 10:39:27 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Ensure xfs_bawrite() errors are checked.

xfs_bawrite() can return immediate error status on async writes.
Unlike xfsbdstrat() we don't ever check the error on the buffer
after the call, so we currently do not catch errors at all here.
Ensure we catch and propagate or warn to the syslog about
up-front async write errors.


Date:  Thu Apr 10 10:39:03 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30824a
fs/xfs/xfs_buf_item.c - 1.165 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_buf_item.c.diff?r1=text&tr1=1.165&r2=text&tr2=1.164&f=h
	- Ensure xfs_bawrite() errors are checked.

fs/xfs/xfs_inode_item.c - 1.134 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode_item.c.diff?r1=text&tr1=1.134&r2=text&tr2=1.133&f=h
	- Ensure xfs_bawrite() errors are checked.

fs/xfs/xfs_inode.c - 1.497 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.497&r2=text&tr2=1.496&f=h
	- Ensure xfs_bawrite() errors are checked.

fs/xfs/quota/xfs_dquot_item.c - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot_item.c.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
	- Ensure xfs_bawrite() errors are checked.

fs/xfs/quota/xfs_dquot.c - 1.32 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.c.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
	- Ensure xfs_bawrite() errors are checked.
