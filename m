Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Sep 2008 20:59:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m833xF2i001903
	for <xfs@oss.sgi.com>; Tue, 2 Sep 2008 20:59:15 -0700
Subject: TAKE 985757 - Fix use-after-free with buffers
Message-Id: <20080903040038.E2F7E58C52AB@chook.melbourne.sgi.com>
Date: Wed,  3 Sep 2008 14:00:38 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Fix use-after-free with buffers

We have a use-after-free issue where log completions access buffers via the
buffer log item and the buffer has already been freed.  Fix this by taking
a reference on the buffer when attaching the buffer log item and release
the hold when the buffer log item is detached and we no longer need the
buffer.  Also create a new function xfs_buf_item_free() to combine some
common code and move an ASSERT in xfs_buf_rele() so that we can catch more
cases.

Date:  Wed Sep  3 13:59:35 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-tot
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32025a
fs/xfs/xfs_buf_item.c - 1.169 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_buf_item.c.diff?r1=text&tr1=1.169&r2=text&tr2=1.168&f=h
	- Fix use-after-free with buffers
