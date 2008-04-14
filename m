Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Apr 2008 22:12:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3E5C88x019257
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 22:12:10 -0700
Subject: PARTIAL TAKE 979606 - xfs bug in going from attr2 back to attr1
Message-Id: <20080414051243.6F9B658C4C15@chook.melbourne.sgi.com>
Date: Mon, 14 Apr 2008 15:12:43 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

xfs_bmap_compute_maxlevels should be based on di_forkoff instead of m_attr_offset

Fix up xfs_bmap_compute_maxlevels() to account for the case when we go
from using attr2 to using attr1. In that case attr1 will no longer necessarily
be at m_attr_offset>>3, but could be at a different value for di_forkoff.
Therefore, we return the worst case scenario using MINDBTPTRS and MINABTPTRS,
as this function is used for determining the maximum log space.

Date:  Mon Apr 14 15:10:39 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30862a
fs/xfs/xfs_bmap.c - 1.390 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.390&r2=text&tr2=1.389&f=h
	- Fix up xfs_bmap_compute_maxlevels() to account for the case when we go
	  from using attr2 to using attr1. In that case attr1 will no longer necessarily
	  be at m_attr_offset>>3, but could be at a different value for di_forkoff.
	  Therefore, we return the worst case scenario using MINDBTPTRS and MINABTPTRS,
	  as this function is used for determining the maximum log space.
