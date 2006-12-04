Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Dec 2006 16:06:44 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kB406UaG002209
	for <xfs@oss.sgi.com>; Sun, 3 Dec 2006 16:06:34 -0800
Subject: TAKE 958790 - Fix xfsidbg.c compiler warnings on ia64
Message-Id: <20061204000536.DC19858FF58C@chook.melbourne.sgi.com>
Date: Mon,  4 Dec 2006 11:05:36 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Fix xfsidbg.c compiler warnings on ia64

Date:  Mon Dec  4 11:04:57 AEDT 2006
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  tes

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27611a
fs/xfs/xfsidbg.c - 1.310 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.310&r2=text&tr2=1.309&f=h
	- Cast variables with different definitions on 32/64 bit
	  platforms to remove compiler warnings on 64 bit platforms.
