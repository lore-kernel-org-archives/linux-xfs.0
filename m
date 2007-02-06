Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Feb 2007 22:58:21 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l166wE3c023102
	for <xfs@oss.sgi.com>; Mon, 5 Feb 2007 22:58:17 -0800
Subject: TAKE 960867 - Remove useless wmb() from vfs_sync_worker()
Message-Id: <20070206065809.EE16258FF657@chook.melbourne.sgi.com>
Date: Tue,  6 Feb 2007 17:58:09 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Remove useless memory barrier

wake_up's implementation does an implicit memory barrier so the
explicit memory barrier is not needed in vfs_sync_worker.

Patch provided by Ralf Baechle.
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

Date:  Tue Feb  6 17:57:03 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  dgc,ralf@linux-mips.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28032a
fs/xfs/linux-2.6/xfs_super.c - 1.377 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.377&r2=text&tr2=1.376&f=h
	- wake_up() provides a memory barrier so we don't need an
	  explicit one in vfs_sync_worker.
	  Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
