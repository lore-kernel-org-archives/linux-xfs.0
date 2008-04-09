Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 00:18:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m397I23U012593
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 00:18:04 -0700
Subject: PARTIAL TAKE 980084 - Make xfs_alloc_compute_aligned() void.
Message-Id: <20080409071837.0773958C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 17:18:36 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Make xfs_alloc_compute_aligned() void.

xfs_alloc_compute_aligned() returns a value based on a comparison
of the computed extent length and the minimum length allowed. This
is only used by some callers - the other four return parameters
are used more often. Hence move the comparison to the code that
actually needs to do it and make xfs_alloc_compute_aligned() a
void function.


Date:  Wed Apr  9 17:18:17 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  xaiki@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30797a
fs/xfs/xfs_alloc.c - 1.192 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.192&r2=text&tr2=1.191&f=h
	- Make xfs_alloc_compute_aligned() void.
