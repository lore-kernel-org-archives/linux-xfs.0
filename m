Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Sep 2008 21:01:16 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8M41ALO008967
	for <xfs@oss.sgi.com>; Sun, 21 Sep 2008 21:01:10 -0700
Subject: TAKE 987246 - Fix buffer flag definitions for xbp idbg command
Message-Id: <20080922040235.E4BA958C52AE@chook.melbourne.sgi.com>
Date: Mon, 22 Sep 2008 14:02:35 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Fix buffer flag definitions for xbp idbg command

PARTIAL no longer exists
NONE is actually DONE
FS_DATAIOD no longer exists
FORCEIO no longer exists
FLUSH is actually ORDERED
DIRECTIO no longer exists
KMEM_ALLOC is actually PAGES
PRIVATE_BH no longer exists
PAGE_LOCKED is a new flag 

Date:  Mon Sep 22 14:01:44 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  tes
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32156a
fs/xfs/xfsidbg.c - 1.364 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.364&r2=text&tr2=1.363&f=h
	- Fix buffer flag definitions for xbp idbg command
