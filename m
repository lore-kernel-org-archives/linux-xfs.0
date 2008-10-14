Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Oct 2008 18:16:21 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9E1GDsC004360
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 18:16:13 -0700
Subject: TAKE 988255 - fix instant oops with tracing enabled
Message-Id: <20081014011747.AC14E58FA1E9@chook.melbourne.sgi.com>
Date: Tue, 14 Oct 2008 12:17:47 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

fix instant oops with tracing enabled

We can only read inode->i_count if the inode is actually there and not
a NULL pointer.  This was introduced in one of the recent sync patches.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Tue Oct 14 12:17:19 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-sync
Inspected by:  lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32315a
fs/xfs/linux-2.6/xfs_vnode.c - 1.164 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.164&r2=text&tr2=1.163&f=h
	- fix instant oops with tracing enabled
