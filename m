Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Jul 2006 20:40:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6P3e2DW012992
	for <linux-xfs@oss.sgi.com>; Mon, 24 Jul 2006 20:40:13 -0700
Subject: PARTIAL TAKE 944409 - readahead
Message-Id: <20060725033923.75F0558C38C1@chook.melbourne.sgi.com>
Date: Tue, 25 Jul 2006 13:39:23 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

When issuing metadata readahead, submit bio with READA not READ.

Date:  Tue Jul 25 13:39:04 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  dgc

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26603a
linux-2.6/xfs_buf.c - 1.224 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.224&r2=text&tr2=1.223&f=h
