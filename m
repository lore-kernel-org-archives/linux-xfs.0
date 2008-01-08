Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Jan 2008 20:34:56 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m084YPqb012563
	for <xfs@oss.sgi.com>; Mon, 7 Jan 2008 20:34:29 -0800
Subject: TAKE 975411 - fix unaligned access in readdir
Message-Id: <20080108043436.8676858C4C0F@chook.melbourne.sgi.com>
Date: Tue,  8 Jan 2008 15:34:36 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

fix unaligned access in readdir

This patch should fix the issue seen on Alpha with unaligned accesses
in the new readdir code.   By aligning each dirent to sizeof(u64) we'll
avoid unaligned accesses.  To make doubly sure we're not hitting
problems also rearrange struct hack_dirent to avoid holes.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Tue Jan  8 15:33:20 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-readdir
Inspected by:  Christoph Hellwig <hch@lst.de>
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30302a
fs/xfs/linux-2.6/xfs_file.c - 1.162 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_file.c.diff?r1=text&tr1=1.162&r2=text&tr2=1.161&f=h
	- fix unaligned access in readdir
