Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 17:51:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A0pijl031213
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 17:51:46 -0700
Subject: PARTIAL TAKE 980084 - Don't allow silent errors in xfs_inactive().
Message-Id: <20080410005222.6ACB158C4C15@chook.melbourne.sgi.com>
Date: Thu, 10 Apr 2008 10:52:22 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Don't allow silent errors in xfs_inactive().

xfs_inactive() fails to report errors when committing the inactive
transaction. Hence we can get silent failures either finishing off
the truncation or committing the transaction. Even if we get errors,
we need to continue, so simply warn loudly to the system if we get
errors here.


Date:  Thu Apr 10 10:52:04 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30830a
fs/xfs/xfs_vnodeops.c - 1.749 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.749&r2=text&tr2=1.748&f=h
	- Don't allow silent errors in xfs_inactive().
