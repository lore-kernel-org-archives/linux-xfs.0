Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 00:20:34 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m757KR9m003760
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 00:20:27 -0700
Subject: TAKE 981498 - clean up stale references to semaphores
Message-Id: <20080805072139.EBE0D58C52A4@chook.melbourne.sgi.com>
Date: Tue,  5 Aug 2008 17:21:39 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

clean up stale references to semaphores

A lot of code has been converted away from semaphores, but there are still
comments that reference semaphore behaviour.  The log code is the worst
offender.  Update the comments to reflect what the code really does now.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Tue Aug  5 17:20:54 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-mm
Inspected by:  
david@fromorbit.com
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31814a
fs/xfs/xfs_log.c - 1.360 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.360&r2=text&tr2=1.359&f=h
fs/xfs/xfs_log_priv.h - 1.132 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_priv.h.diff?r1=text&tr1=1.132&r2=text&tr2=1.131&f=h
fs/xfs/linux-2.6/xfs_vnode.c - 1.162 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.162&r2=text&tr2=1.161&f=h
	- clean up stale references to semaphores
