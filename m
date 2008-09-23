Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Sep 2008 20:27:23 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8N3QqZp001076
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 20:26:52 -0700
Subject: PARTIAL TAKE 987159 - Fix extent list corruption in xfs_iext_irec_compact_full().
Message-Id: <20080923032821.A91D758C52AE@chook.melbourne.sgi.com>
Date: Tue, 23 Sep 2008 13:28:21 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Fix extent list corruption in xfs_iext_irec_compact_full().

If we don't move all the records from the next buffer into the current buffer
then we need to update the er_extoff field of the next buffer as we shift the
remaining records to the start of the buffer.

Date:  Tue Sep 23 13:20:30 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  
sandeen@sandeen.net
cattelan@thebarn.com
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32165a
fs/xfs/xfs_inode.c - 1.521 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.521&r2=text&tr2=1.520&f=h
	- Fix extent list corruption in xfs_iext_irec_compact_full().
