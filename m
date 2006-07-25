Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Jul 2006 21:15:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6P4EbDW017486
	for <linux-xfs@oss.sgi.com>; Mon, 24 Jul 2006 21:14:46 -0700
Subject: TAKE 954772 - remount vs nobarrier/barrier
Message-Id: <20060725041358.B966F58C38C1@chook.melbourne.sgi.com>
Date: Tue, 25 Jul 2006 14:13:58 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix remount vs no/barrier options by ensuring we clear unwanted flags from iclog buffers before submitting them for writing.

Date:  Tue Jul 25 14:13:32 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  tes,hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26605a
xfs_log.c - 1.324 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.324&r2=text&tr2=1.323&f=h
linux-2.6/xfs_buf.h - 1.114 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.h.diff?r1=text&tr1=1.114&r2=text&tr2=1.113&f=h
