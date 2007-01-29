Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Jan 2007 00:16:14 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0T8G4qw026729
	for <xfs@oss.sgi.com>; Mon, 29 Jan 2007 00:16:06 -0800
Subject: PARTIAL TAKE 960028 - XFS tripping bug in cancel_dirty_pages in 2.6.20-rc3
Message-Id: <20070129081505.674F558FF492@chook.melbourne.sgi.com>
Date: Mon, 29 Jan 2007 19:15:05 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Revert broken and obsolete change to page invalidation.

The changes checked in under mod xfs-linux-melb:xfs-kern:27909a
are broken. 2.6.20 will release with the troublesome warning
turned off so by reverting this mod we will have the same
behaviour as 2.6.19 w.r.t to fs_tosspages and fs_flushinval_pages.

Date:  Mon Jan 29 19:14:25 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  dgc

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27998a
fs/xfs/linux-2.6/xfs_fs_subr.c - 1.49 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_fs_subr.c.diff?r1=text&tr1=1.49&r2=text&tr2=1.48&f=h
	- Revert broken mod xfs-linux-melb:xfs-kern:27909a.
