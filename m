Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 20:48:15 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9A3m74L026551
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 20:48:07 -0700
Subject: TAKE 988139 - move sync code to its own file
Message-Id: <20081010034939.A064858C52B5@chook.melbourne.sgi.com>
Date: Fri, 10 Oct 2008 14:49:39 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

move sync code to its own file

The sync code in XFS is spread around several files.
While it used to make sense to have such a distribution,
the code is about to be cleaned up and so centralising it
in one spot as the first step makes sense.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Fri Oct 10 14:48:57 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-radix
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32282a
fs/xfs/linux-2.6/xfs_sync.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.h
fs/xfs/linux-2.6/xfs_sync.c - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c
fs/xfs/Makefile - 1.66 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/Makefile.diff?r1=text&tr1=1.66&r2=text&tr2=1.65&f=h
fs/xfs/xfs_vfsops.c - 1.575 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.575&r2=text&tr2=1.574&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.451 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.451&r2=text&tr2=1.450&f=h
fs/xfs/xfs_vfsops.h - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.h.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
	- move sync code to its own file
