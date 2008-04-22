Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 18:53:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3M1rFJ3017668
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 18:53:17 -0700
Subject: PARTIAL TAKE 976035 - kill XFS_ICSB_SB_LOCKED
Message-Id: <20080422015353.0053558C4C15@chook.melbourne.sgi.com>
Date: Tue, 22 Apr 2008 11:53:52 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

kill XFS_ICSB_SB_LOCKED

With the last two patches XFS_ICSB_SB_LOCKED is never checked and
only superflously passed to xfs_icsb_count, so kill it.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Tue Apr 22 11:53:31 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30920a
fs/xfs/xfs_mount.h - 1.263 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.263&r2=text&tr2=1.262&f=h
	- kill XFS_ICSB_SB_LOCKED.

fs/xfs/xfs_mount.c - 1.429 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.429&r2=text&tr2=1.428&f=h
	- kill XFS_ICSB_SB_LOCKED.
