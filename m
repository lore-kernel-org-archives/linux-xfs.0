Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 18:44:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3M1i6Kc016644
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 18:44:10 -0700
Subject: PARTIAL TAKE 976035 - split xfs_icsb_sync_counters_flags
Message-Id: <20080422014439.C2FE258C4C15@chook.melbourne.sgi.com>
Date: Tue, 22 Apr 2008 11:44:39 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Add a new xfs_icsb_sync_counters_locked for the case where m_sb_lock
is already taken and add a flags argument to xfs_icsb_sync_counters so
that xfs_icsb_sync_counters_flags is not needed.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Tue Apr 22 11:44:03 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30917a
fs/xfs/xfs_mount.h - 1.262 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.262&r2=text&tr2=1.261&f=h
	- Add xfs_icsb_sync_counters_locked().

fs/xfs/xfs_mount.c - 1.427 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.427&r2=text&tr2=1.426&f=h
	- Add xfs_icsb_sync_counters_locked().

fs/xfs/xfs_fsops.c - 1.133 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c.diff?r1=text&tr1=1.133&r2=text&tr2=1.132&f=h
	- Add xfs_icsb_sync_counters_locked().

fs/xfs/linux-2.6/xfs_super.c - 1.414 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.414&r2=text&tr2=1.413&f=h
	- Add xfs_icsb_sync_counters_locked().
