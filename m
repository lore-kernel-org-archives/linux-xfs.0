Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Oct 2008 21:37:17 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9G4bD9r012812
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 21:37:13 -0700
Subject: TAKE 988143 - Given the log a pointer to the AIL
Message-Id: <20081016043855.1C7F958FA22B@chook.melbourne.sgi.com>
Date: Thu, 16 Oct 2008 15:38:55 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Given the log a pointer to the AIL

When we need to go from the log to the AIL, we have
to go via the xfs_mount. Add a xfs_ail pointer to the log
so we can go directly to the AIL associated with the log.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Thu Oct 16 15:38:35 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-ail
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32351a
fs/xfs/xfs_log.c - 1.372 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.372&r2=text&tr2=1.371&f=h
fs/xfs/xfs_log_priv.h - 1.135 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_priv.h.diff?r1=text&tr1=1.135&r2=text&tr2=1.134&f=h
fs/xfs/xfs_log_recover.c - 1.353 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.353&r2=text&tr2=1.352&f=h
	- Given the log a pointer to the AIL
