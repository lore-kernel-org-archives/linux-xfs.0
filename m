Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 20:21:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3A3Kscc021925
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 20:20:57 -0700
Subject: PARTIAL TAKE 980084 -  Don't error out on good I/Os in xfsbdstrat
Message-Id: <20080410032128.E612358C4C15@chook.melbourne.sgi.com>
Date: Thu, 10 Apr 2008 13:21:28 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Don't error out on good I/Os.

xfsbdstrat() made all I/Os error out, good or bad. Fix it.

Date:  Thu Apr 10 13:21:03 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  donaldd@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30836a
fs/xfs/linux-2.6/xfs_lrw.c - 1.279 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.279&r2=text&tr2=1.278&f=h
	- Don't error out on good I/Os in xfsbdstrat()
