Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 21:12:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m764Bk1J018098
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 21:11:48 -0700
Subject: TAKE 981498 - replace dquot flush semaphore with a completion
Message-Id: <20080806041257.B9C6758C52A4@chook.melbourne.sgi.com>
Date: Wed,  6 Aug 2008 14:12:57 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

replace dquot flush semaphore with a completion

Use the new completion flush code to implement the dquot flush lock.  Removes
one of the final users of semaphores in the XFS code base.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Wed Aug  6 14:12:02 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-mm
Inspected by:  
david@fromorbit.com
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31822a
fs/xfs/quota/xfs_dquot_item.c - 1.23 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot_item.c.diff?r1=text&tr1=1.23&r2=text&tr2=1.22&f=h
fs/xfs/quota/xfs_dquot.h - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.h.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
fs/xfs/quota/xfs_dquot.c - 1.37 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.c.diff?r1=text&tr1=1.37&r2=text&tr2=1.36&f=h
fs/xfs/quota/xfs_qm.c - 1.72 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.72&r2=text&tr2=1.71&f=h
	- replace dquot flush semaphore with a completion
