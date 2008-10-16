Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 15 Oct 2008 21:34:42 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9G4Ydwp012108
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2008 21:34:40 -0700
Subject: TAKE 988143 - Allow 64 bit machines to avoid the AIL lock during flushes
Message-Id: <20081016043621.7A1A658FA22B@chook.melbourne.sgi.com>
Date: Thu, 16 Oct 2008 15:36:21 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Allow 64 bit machines to avoid the AIL lock during flushes

When copying lsn's from the log item to the inode or dquot
flush lsn, we currently grab the AIL lock. We do this because the
LSN is a 64 bit quantity and it needs to be read atomically.
The lock is used to guarantee atomicity for 32 bit platforms.

Make the LSN copying a small function, and make the function
used conditional on BITS_PER_LONG so that 64 bit machines don't
need to take the AIL lock in these places.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Thu Oct 16 15:36:04 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-ail
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32349a
fs/xfs/xfs_trans_priv.h - 1.34 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_priv.h.diff?r1=text&tr1=1.34&r2=text&tr2=1.33&f=h
fs/xfs/xfs_inode.c - 1.532 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.532&r2=text&tr2=1.531&f=h
fs/xfs/quota/xfs_dquot.c - 1.41 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.c.diff?r1=text&tr1=1.41&r2=text&tr2=1.40&f=h
	- Allow 64 bit machines to avoid the AIL lock during flushes
