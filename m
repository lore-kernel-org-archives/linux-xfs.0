Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 17:49:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A0mwbC030668
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 17:49:00 -0700
Subject: PARTIAL TAKE 980084 - Catch errors from xfs_imap()
Message-Id: <20080410004936.8772558C4C15@chook.melbourne.sgi.com>
Date: Thu, 10 Apr 2008 10:49:36 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Catch errors from xfs_imap().

Catch errors from xfs_imap() in log recovery when we might be
trying to map an invalid inode number due to a corrupted log.


Date:  Thu Apr 10 10:49:21 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30829a
fs/xfs/xfs_log_recover.c - 1.342 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.342&r2=text&tr2=1.341&f=h
	- Catch errors from xfs_imap().
