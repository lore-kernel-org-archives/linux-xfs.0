Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Oct 2008 23:34:24 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9D6YIDl032627
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 23:34:19 -0700
Subject: TAKE 988140 - xfssyncd: don't call xfs_sync
Message-Id: <20081013063558.8693F58C38F4@chook.melbourne.sgi.com>
Date: Mon, 13 Oct 2008 17:35:58 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

xfssyncd: don't call xfs_sync

Start de-multiplexing xfs_sync() by making xfs_sync_worker()
call the specific sync functions it needs. This is only a small,
unique subset of the entire xfs_sync() code so is easier to
follow.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Mon Oct 13 17:35:40 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-sync
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32307a
fs/xfs/linux-2.6/xfs_sync.c - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
	- xfssyncd: don't call xfs_sync
