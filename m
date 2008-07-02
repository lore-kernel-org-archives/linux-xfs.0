Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Jul 2008 20:42:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m623fxr3008701
	for <xfs@oss.sgi.com>; Tue, 1 Jul 2008 20:42:00 -0700
Subject: TAKE 983964 - fix mount option parsing in remount
Message-Id: <20080702034258.0250058C4C29@chook.melbourne.sgi.com>
Date: Wed,  2 Jul 2008 13:42:57 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix mount option parsing in remount.

Remount currently happily accept any option thrown at it, although the
only filesystem specific option it actually handles is barrier/nobarrier.
And it actually doesn't handle these correctly either because it only
uses the value it parsed when we're doing a ro->rw transition.  In
addition to that there's also a bad bug in xfs_parseargs which doesn't
touch the actual option in the mount point except for a single one,
XFS_MOUNT_SMALL_INUMS and thus forced any filesystem that's every
remounted in some way to not support 64bit inodes with no way to recover
unless unmounted.

This patch changes xfs_fs_remount to use it's own linux/parser.h based
options parse instead of xfs_parseargs and reject all options except
for barrier/nobarrier and to the right thing in general.  Eventually
I'd like to have a single big option table used for mount aswell but
that can wait for a while.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Wed Jul  2 13:41:58 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31382a
fs/xfs/linux-2.6/xfs_super.c - 1.434 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.434&r2=text&tr2=1.433&f=h
	- fix mount option parsing in remount
