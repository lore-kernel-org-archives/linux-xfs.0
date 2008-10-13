Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Oct 2008 23:41:06 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9D6f4OJ001507
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 23:41:04 -0700
Subject: TAKE 988140 - Kill xfs_sync()
Message-Id: <20081013064244.7C1CF58C38F4@chook.melbourne.sgi.com>
Date: Mon, 13 Oct 2008 17:42:44 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Kill xfs_sync()

There are no more callers to xfs_sync() now, so remove the
function altogther.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Mon Oct 13 17:42:24 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-sync
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32311a
fs/xfs/xfs_iget.c - 1.248 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.248&r2=text&tr2=1.247&f=h
fs/xfs/quota/xfs_qm.c - 1.76 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.76&r2=text&tr2=1.75&f=h
fs/xfs/linux-2.6/xfs_sync.h - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.h.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
fs/xfs/linux-2.6/xfs_sync.c - 1.16 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
	- Kill xfs_sync()
