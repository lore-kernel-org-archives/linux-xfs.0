Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Apr 2008 18:49:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3M1mFCY016938
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2008 18:48:50 -0700
Subject: PARTIAL TAKE 976035 - split xfs_icsb_balance_counter
Message-Id: <20080422014853.42E3758C4C15@chook.melbourne.sgi.com>
Date: Tue, 22 Apr 2008 11:48:53 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

split xfs_icsb_balance_counter

Add an xfs_icsb_balance_counter_locked for the case where mp->m_sb_lock
is already locked.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Tue Apr 22 11:48:25 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30918a
fs/xfs/xfs_mount.c - 1.428 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.428&r2=text&tr2=1.427&f=h
	- Add xfs_icsb_balance_counter_locked.
