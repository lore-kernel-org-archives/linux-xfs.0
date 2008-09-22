Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Sep 2008 21:03:30 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8M43Na6009279
	for <xfs@oss.sgi.com>; Sun, 21 Sep 2008 21:03:23 -0700
Subject: TAKE 987246 - xail idbg command doesn't increment count in each loop
Message-Id: <20080922040456.1EA7C58C52AE@chook.melbourne.sgi.com>
Date: Mon, 22 Sep 2008 14:04:56 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

xail idbg command doesn't increment count in each loop

count is never incremented on each log item because it is unreachable code.

Date:  Mon Sep 22 14:04:00 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  tes
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32157a
fs/xfs/xfsidbg.c - 1.365 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.365&r2=text&tr2=1.364&f=h
	- xail idbg command doesn't increment count in each loop
