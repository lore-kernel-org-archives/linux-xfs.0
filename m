Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Oct 2008 23:28:14 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9D6SALx031384
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 23:28:11 -0700
Subject: TAKE 988140 - split out two helpers from xfs_syncsub
Message-Id: <20081013062943.C434358C38F4@chook.melbourne.sgi.com>
Date: Mon, 13 Oct 2008 17:29:43 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

split out two helpers from xfs_syncsub

Split out two helpers from xfs_syncsub for the dummy log commit
and the superblock writeout.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Mon Oct 13 17:29:16 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-sync
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32303a
fs/xfs/linux-2.6/xfs_sync.c - 1.8 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c.diff?r1=text&tr1=1.8&r2=text&tr2=1.7&f=h
	- split out two helpers from xfs_syncsub
