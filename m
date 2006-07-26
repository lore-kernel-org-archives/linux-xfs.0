Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Jul 2006 18:41:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6Q1ehDW022295
	for <linux-xfs@oss.sgi.com>; Tue, 25 Jul 2006 18:40:56 -0700
Subject: TAKE 944409 - bulkstat
Message-Id: <20060726014004.DD81858C38C1@chook.melbourne.sgi.com>
Date: Wed, 26 Jul 2006 11:40:04 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Increase the size of the buffer holding the local inode cluster list,
to increase our potential readahead window and in turn improve bulkstat
performance.

Date:  Wed Jul 26 11:39:37 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  hch,cw

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26607a
xfs_itable.c - 1.143 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.143&r2=text&tr2=1.142&f=h
