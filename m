Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 22:01:44 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A51VBI002580
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 22:01:34 -0700
Subject: TAKE 980084 - fix logic error in xfs_alloc_ag_vextent_near()
Message-Id: <20080410050206.3EC8558C4C15@chook.melbourne.sgi.com>
Date: Thu, 10 Apr 2008 15:02:06 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

fix logic error in xfs_alloc_ag_vextent_near()

Fix a logic error in xfs_alloc_ag_vextent_near(). This is
a regression introduced by the error handling changes.


Date:  Thu Apr 10 15:01:27 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  bnaujok@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30838a
fs/xfs/xfs_alloc.c - 1.193 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.193&r2=text&tr2=1.192&f=h
	- Fix a logic error introduced by the error handling changes.
