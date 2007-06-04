Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Jun 2007 23:58:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l546whWt008370
	for <xfs@oss.sgi.com>; Sun, 3 Jun 2007 23:58:45 -0700
Subject: TAKE 965630 - xfs should flush the block device on unmount
Message-Id: <20070604065839.7054B58C38C1@chook.melbourne.sgi.com>
Date: Mon,  4 Jun 2007 16:58:39 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Flush the block device before closing it on unmount.


Date:  Mon Jun  4 16:58:12 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28774a
fs/xfs/linux-2.6/xfs_buf.c - 1.242 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.242&r2=text&tr2=1.241&f=h
	- Flush the block device before closing it on unmount.
