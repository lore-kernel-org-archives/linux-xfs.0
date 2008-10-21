Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 23:33:27 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9L6XPKe009581
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 23:33:25 -0700
Subject: TAKE 987246 - fix the noquota mount option
Message-Id: <20081021063502.9DDED1EDD85@chapter11.melbourne.sgi.com>
Date: Tue, 21 Oct 2008 17:35:02 +1100 (EST)
From: donaldd@sgi.com (Donald Douwsma)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Noquota should clear all mount options, and not just user and group
quota.  Probably doesn't matter very much in real life.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Tue Oct 21 17:34:46 EST 2008
Workarea:  chapter11.melbourne.sgi.com:/scratch/donaldd/isms/2.6.x-xfs
Inspected by:  hch,david@fromorbit.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32372a
fs/xfs/linux-2.6/xfs_super.c - 1.465 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.465&r2=text&tr2=1.464&f=h
	- fix the noquota mount option
