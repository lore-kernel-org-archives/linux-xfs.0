Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 00:25:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m757PBlb007810
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 00:25:12 -0700
Subject: TAKE 981498 - replace the XFS buf iodone semaphore with a completion
Message-Id: <20080805072624.9FFAA58C52A4@chook.melbourne.sgi.com>
Date: Tue,  5 Aug 2008 17:26:24 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

replace the XFS buf iodone semaphore with a completion

The xfs_buf_t b_iodonesema is really just a semaphore that wants to be a
completion.  Change it to a completion and remove the last user of the sema_t
from XFS.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Tue Aug  5 17:25:44 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-mm
Inspected by:  
david@fromorbit.com
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31815a
fs/xfs/xfs_rw.c - 1.401 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rw.c.diff?r1=text&tr1=1.401&r2=text&tr2=1.400&f=h
fs/xfs/xfs_buf_item.c - 1.167 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_buf_item.c.diff?r1=text&tr1=1.167&r2=text&tr2=1.166&f=h
fs/xfs/linux-2.6/xfs_buf.h - 1.127 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.h.diff?r1=text&tr1=1.127&r2=text&tr2=1.126&f=h
fs/xfs/linux-2.6/xfs_buf.c - 1.261 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.261&r2=text&tr2=1.260&f=h
	- replace the XFS buf iodone semaphore with a completion
