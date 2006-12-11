Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 10 Dec 2006 21:56:05 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBB5tqqw008239
	for <xfs@oss.sgi.com>; Sun, 10 Dec 2006 21:55:56 -0800
Subject: TAKE 952227 - Severe lock contention in xfs_icsb_xxxx running
Message-Id: <20061211055456.DC2F158C4C00@chook.melbourne.sgi.com>
Date: Mon, 11 Dec 2006 16:54:56 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix UP build breakage due to undefined m_icsb_mutex.

Date:  Mon Dec 11 16:54:27 AEDT 2006
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27692a
fs/xfs/xfs_mount.h - 1.229 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.229&r2=text&tr2=1.228&f=h
	- Abstract m_icsb_mutex references into HAVE_PERCPU_SB dependent functions.

fs/xfs/xfs_mount.c - 1.389 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.389&r2=text&tr2=1.388&f=h
	- Abstract m_icsb_mutex references into HAVE_PERCPU_SB dependent functions.
