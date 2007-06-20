Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 21:21:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5K4Lhdo007997
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 21:21:45 -0700
Subject: TAKE 964547 - simplify XFS min/max macros
Message-Id: <20070620042139.0205858C38F1@chook.melbourne.sgi.com>
Date: Wed, 20 Jun 2007 14:21:38 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Simplify XFS min/max macros.

Date:  Wed Jun 20 14:21:16 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  nscott@aconex.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28945a
fs/xfs/xfs_btree.h - 1.66 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.66&r2=text&tr2=1.65&f=h
	- Use min_t/max_t instead of open coding min/max comparisons.
