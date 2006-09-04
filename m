Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Sep 2006 18:33:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k841WkDW011352
	for <linux-xfs@oss.sgi.com>; Sun, 3 Sep 2006 18:32:57 -0700
Subject: TAKE 955302 - fix warnings
Message-Id: <20060904013157.3ED5158CF851@chook.melbourne.sgi.com>
Date: Mon,  4 Sep 2006 11:31:56 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix kmem_zalloc_greedy warnings on 64 bit platforms.

Date:  Mon Sep  4 11:31:03 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  lachlan,vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26907a
xfs_itable.c - 1.148 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.148&r2=text&tr2=1.147&f=h
xfs_vfsops.c - 1.511 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.511&r2=text&tr2=1.510&f=h
xfs_mount.h - 1.227 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.227&r2=text&tr2=1.226&f=h
quota/xfs_qm.c - 1.44 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.44&r2=text&tr2=1.43&f=h
linux-2.6/xfs_ksyms.c - 1.51 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.51&r2=text&tr2=1.50&f=h
linux-2.4/xfs_ksyms.c - 1.46 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_ksyms.c.diff?r1=text&tr1=1.46&r2=text&tr2=1.45&f=h
