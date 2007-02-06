Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Feb 2007 15:56:52 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l16Nui3c009855
	for <xfs@oss.sgi.com>; Tue, 6 Feb 2007 15:56:46 -0800
Subject: TAKE 959267 - bad clientid during log replay of snapshot image
Message-Id: <20070206235638.4300558C4C27@chook.melbourne.sgi.com>
Date: Wed,  7 Feb 2007 10:56:38 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Make freeze code a little cleaner.

Fixes a few small issues (mostly cosmetic) that were picked up during
the review cycle for the last set of freeze path changes.

Date:  Wed Feb  7 10:56:10 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28035a
fs/xfs/xfs_vfsops.c - 1.515 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.515&r2=text&tr2=1.514&f=h
	- Convert SYNC_DIO_WAIT to SYNC_IOWAIT as it really waits for
	  all I/O, not just direct I/O.

fs/xfs/linux-2.6/xfs_vfs.h - 1.69 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.h.diff?r1=text&tr1=1.69&r2=text&tr2=1.68&f=h
	- Convert SYNC_DIO_WAIT to SYNC_IOWAIT as it really waits for
	  all I/O, not just direct I/O.

fs/xfs/linux-2.6/xfs_super.c - 1.378 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.378&r2=text&tr2=1.377&f=h
	- Convert SYNC_DIO_WAIT to SYNC_IOWAIT as it really waits for
	  all I/O, not just direct I/O.

fs/xfs/linux-2.4/xfs_vfs.h - 1.65 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_vfs.h.diff?r1=text&tr1=1.65&r2=text&tr2=1.64&f=h
	- add/remove SYNC_* flags for freeze path changes.

fs/xfs/linux-2.4/xfs_super.c - 1.334 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_super.c.diff?r1=text&tr1=1.334&r2=text&tr2=1.333&f=h
	- Use new flush ordering and semantics in the freeze path.
