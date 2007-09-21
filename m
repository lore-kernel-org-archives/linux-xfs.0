Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Sep 2007 21:49:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8L4nkgf030374
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2007 21:49:51 -0700
From: donaldd@sgi.com
Subject: PARTIAL TAKE 970382 - untangle spinlock macros
Message-Id: <20070921044944.24416307A03C@linuxbuild.melbourne.sgi.com>
Date: Fri, 21 Sep 2007 14:49:44 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

ktrace kt_lock is unused, remove it.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Fri Sep 21 14:49:14 AEST 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29747a
fs/xfs/support/ktrace.c - 1.27 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/ktrace.c.diff?r1=text&tr1=1.27&r2=text&tr2=1.26&f=h
	- Remove unused kt_lock

fs/xfs/support/ktrace.h - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/ktrace.h.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
	- Remove unused kt_lock
