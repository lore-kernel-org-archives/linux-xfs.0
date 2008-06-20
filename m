Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jun 2008 18:57:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5K1vgcB014938
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 18:57:43 -0700
Subject: TAKE 983500 - Convert ASSERTs to XFS_WANT_CORRUPTED_GOTOs
Message-Id: <20080620015836.509CE58C4C3F@chook.melbourne.sgi.com>
Date: Fri, 20 Jun 2008 11:58:36 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Convert ASSERTs to XFS_WANT_CORRUPTED_GOTOs

ASSERTs are no good to us on a non-debug build so use XFS_WANT_CORRUPTED_GOTOs
to report extent btree corruption ASAP.

Date:  Fri Jun 20 11:57:41 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-agno2
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31338a
fs/xfs/xfs_bmap.c - 1.393 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.393&r2=text&tr2=1.392&f=h
	- Convert ASSERTs to XFS_WANT_CORRUPTED_GOTOs
