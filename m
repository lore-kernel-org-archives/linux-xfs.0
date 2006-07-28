Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 27 Jul 2006 23:43:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6S6g5DW024326
	for <linux-xfs@oss.sgi.com>; Thu, 27 Jul 2006 23:42:17 -0700
Subject: TAKE 954802 - xlog_state_do_callback
Message-Id: <20060728064125.66D3558C38C1@chook.melbourne.sgi.com>
Date: Fri, 28 Jul 2006 16:41:25 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Ensure xlog_state_do_callback does not report spurious warnings on ramdisks.

Date:  Fri Jul 28 16:41:12 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  hch,tes

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26627a
xfs_log.c - 1.325 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.325&r2=text&tr2=1.324&f=h
