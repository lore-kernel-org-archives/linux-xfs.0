Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 27 Jul 2006 21:37:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6S4awDW001386
	for <linux-xfs@oss.sgi.com>; Thu, 27 Jul 2006 21:37:10 -0700
Subject: TAKE 912426 - quota vs barriers
Message-Id: <20060728043618.7ED2A58C38C1@chook.melbourne.sgi.com>
Date: Fri, 28 Jul 2006 14:36:18 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix a barrier related forced shutdown on mounts with quota enabled.

Date:  Fri Jul 28 14:35:57 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  Stefan Priebe <s.priebe@profihost.com>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26622a
xfs_vfsops.c - 1.509 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.509&r2=text&tr2=1.508&f=h
linux-2.6/xfs_super.c - 1.369 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.369&r2=text&tr2=1.368&f=h
