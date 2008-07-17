Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Jul 2008 22:43:45 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6H5hH8l023844
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2008 22:43:18 -0700
Subject: PARTIAL TAKE 983806 - fix use after free with external logs or real-time devices
Message-Id: <20080717054419.C4B1358C4C3F@chook.melbourne.sgi.com>
Date: Thu, 17 Jul 2008 15:44:19 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

fix use after free with external logs or real-time devices


Date:  Thu Jul 17 15:43:06 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-alloc
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31666a
fs/xfs/linux-2.6/xfs_super.c - 1.435 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.435&r2=text&tr2=1.434&f=h
	- fix use after free with external logs or real-time devices
