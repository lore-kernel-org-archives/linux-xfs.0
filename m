Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 00:25:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m397PMOB019291
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 00:25:27 -0700
Subject: PARTIAL TAKE 980084 - Check for xfs_free_extent() failing.
Message-Id: <20080409072556.882F058C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 17:25:56 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Check for xfs_free_extent() failing.

xfs_free_extent() can fail, but log recovery never bothers to check
if it successfully free the extent it was supposed to. This could
lead to silent corruption during log recovery. Abort log recovery
if we fail to free an extent.


Date:  Wed Apr  9 17:25:38 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30801a
fs/xfs/xfs_log_recover.c - 1.340 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.340&r2=text&tr2=1.339&f=h
	- Check for xfs_free_extent() failing.
