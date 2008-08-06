Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 21:30:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m764UPv4019947
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 21:30:26 -0700
Subject: TAKE 981498 - remove the sema_t from XFS.
Message-Id: <20080806043138.1E66D58C52A4@chook.melbourne.sgi.com>
Date: Wed,  6 Aug 2008 14:31:38 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

remove the sema_t from XFS.

Now that all users of the sema_t are gone from XFS we can finally kill it.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Wed Aug  6 14:30:56 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-mm
Inspected by:  
david@fromorbit.com
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31823a
fs/xfs/linux-2.6/xfs_linux.h - 1.170 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.170&r2=text&tr2=1.169&f=h
fs/xfs/linux-2.6/sema.h - 1.16 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/sema.h.diff?r1=text&tr1=1.16&r2=text&tr2=1.15&f=h
	- remove the sema_t from XFS.
