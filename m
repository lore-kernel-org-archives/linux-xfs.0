Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Jun 2007 01:52:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5C8qEWt013580
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2007 01:52:16 -0700
Subject: TAKE 966145 - fix i386 build
Message-Id: <20070612085210.B425458C38C1@chook.melbourne.sgi.com>
Date: Tue, 12 Jun 2007 18:52:10 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Use do_div() on 64 bit types.

Signed-Off-By: Christoph Hellwig <hch@lst.de>


Date:  Tue Jun 12 18:51:47 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28889a
fs/xfs/xfs_mount.c - 1.398 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.398&r2=text&tr2=1.397&f=h
	- Use do_div() on 64 bit types.
