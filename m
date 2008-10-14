Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Oct 2008 21:46:10 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9E4k7Os025157
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 21:46:07 -0700
Subject: TAKE 988141 - factor xfs_iget_core() into hit and miss cases
Message-Id: <20081014044741.7DC1C58FA1E9@chook.melbourne.sgi.com>
Date: Tue, 14 Oct 2008 15:47:41 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

factor xfs_iget_core() into hit and miss cases

There are really two cases in xfs_iget_core(). The first is the
cache hit case, the second is the miss case. They share very little
code, and hence can easily be factored out into separate functions.
This makes the code much easier to understand and subsequently
modify.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Tue Oct 14 15:46:57 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-inode
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32317a
fs/xfs/xfs_iget.c - 1.249 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.249&r2=text&tr2=1.248&f=h
	- factor xfs_iget_core() into hit and miss cases
