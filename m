Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 05:12:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l72CC2bm021988
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 05:12:04 -0700
Subject: PARTIAL TAKE 968563 - Fix a potential NULL pointer deref in XFS on failed mount.
Message-Id: <20070802121200.F402E58F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 22:12:00 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix a potential NULL pointer deref in XFS on failed mount.

If we fail to open the the log device buftarg, we can fall through
to error handling code that fails to check for a NULL log device
buftarg before calling xfs_free_buftarg().

This patch fixes the issue by checking mp->m_logdev_targp against
NULL in xfs_unmountfs_close() and doing the proper
xfs_blkdev_put(logdev); and xfs_blkdev_put(rtdev); on
(!mp->m_rtdev_targp) in xfs_mount().

Discovered by the Coverity checker.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Date:  Thu Aug  2 22:11:36 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  jesper.juhl@gmail.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29328a
fs/xfs/xfs_vfsops.c - 1.524 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.524&r2=text&tr2=1.523&f=h
	- Ensure we only ever attempt to free a log device buftarg if
	  we allocated one in teh first place.

fs/xfs/xfs_mount.c - 1.401 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.401&r2=text&tr2=1.400&f=h
	- Ensure we only ever attempt to free a log device buftarg if
	  we allocated one in teh first place.
