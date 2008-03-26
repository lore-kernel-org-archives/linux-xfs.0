Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Mar 2008 23:53:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2Q6rVKP020968
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 23:53:33 -0700
Subject: PARTIAL TAKE 976035 - Prevent xfs_bmap_check_leaf_extents() from referencing unmapped memory.
Message-Id: <20080326065400.CD6F158C4C0F@chook.melbourne.sgi.com>
Date: Wed, 26 Mar 2008 17:54:00 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Prevent xfs_bmap_check_leaf_extents() from referencing unmapped memory.

While investigating the extent corruption bug I ran into this bug in
debug only code.  xfs_bmap_check_leaf_extents() loops through the leaf
blocks of the extent btree checking that every extent is entirely
before the next extent.  It also compares the last extent in the previous
block to the first extent in the current block when the previous block
has been released and potentially unmapped.  So take a copy of the last
extent instead of a pointer.  Also move the last extent check out of the
loop because we only need to do it once.

Date:  Wed Mar 26 17:53:07 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30718a
fs/xfs/xfs_bmap.c - 1.387 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.387&r2=text&tr2=1.386&f=h
	- Prevent xfs_bmap_check_leaf_extents() from referencing unmapped memory.
