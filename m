Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Apr 2008 22:03:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3E52l4A017629
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 22:02:50 -0700
Subject: PARTIAL TAKE 979606 - xfs bug in going from attr2 back to attr1
Message-Id: <20080414050321.CF17858C4C15@chook.melbourne.sgi.com>
Date: Mon, 14 Apr 2008 15:03:21 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Always use di_forkoff when checking for attr space.

In the case where we mount a filesystem which was previously
using the attr2 format as attr1, returning the default
mp->m_attroffset instead of the per-inode di_forkoff for
inline attribute fit calculations, may result in corruption.
For example, if the data fork is already taking more space
than the default fork offset and we try to add an extended attribute.
An example of this is tested by xfstests/186.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Mon Apr 14 14:59:41 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30861a
fs/xfs/xfs_attr_leaf.c - 1.110 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr_leaf.c.diff?r1=text&tr1=1.110&r2=text&tr2=1.109&f=h
	- Fix up xfs_attr_shortform_bytesfit() to return di_forkoff for attr1 instead
	  of m_attroffset, when we have a fit in the inode.
	  Fix tested by xfstests/186.
