Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Jul 2008 22:21:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6H5LC60022141
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2008 22:21:13 -0700
Subject: PARTIAL 984030 - incorrect delta in xfs_bmap_add_extent_unwritten_real
Message-Id: <20080717052212.AB26958C4C3F@chook.melbourne.sgi.com>
Date: Thu, 17 Jul 2008 15:22:12 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

A bug was found in xfs_bmap_add_extent_unwritten_real().
In a particular case, the delta param which is supposed to describe
the region where extents have changed was not updated appropriately.

Date:  Thu Jul 17 15:20:34 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  olaf@sgi.com,lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31663a
fs/xfs/xfs_bmap.c - 1.395 - changed
	- A bug was found in xfs_bmap_add_extent_unwritten_real().
	  In a particular case, the delta param which is supposed to describe
	  the region where extents have changed was not updated appropriately.
