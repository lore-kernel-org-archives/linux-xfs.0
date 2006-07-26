Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Jul 2006 18:36:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6Q1ZdDW021262
	for <linux-xfs@oss.sgi.com>; Tue, 25 Jul 2006 18:35:51 -0700
Subject: PARTIAL TAKE 944409 - bulkstat readahead
Message-Id: <20060726013459.655AA58C38C1@chook.melbourne.sgi.com>
Date: Wed, 26 Jul 2006 11:34:59 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Drop unneeded endian conversion in bulkstat and start readahead for
batches of inode cluster buffers at once, before any blocking reads
are issued.

Date:  Wed Jul 26 11:34:38 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26606a
xfs_itable.c - 1.142 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.142&r2=text&tr2=1.141&f=h
