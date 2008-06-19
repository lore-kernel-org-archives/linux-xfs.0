Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 22:34:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5J5XwMa009941
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 22:34:00 -0700
Subject: TAKE 983395 - fix warning for: simplify xfs_vn_listxattr
Message-Id: <20080619053450.5F57058C4C3F@chook.melbourne.sgi.com>
Date: Thu, 19 Jun 2008 15:34:50 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix up 64bit warning for xfs_vn_listxattr's call of list_one_attr() with context count
of ssize_t versus int. Change context count to be ssize_t.
As suggested by hch.

--Tim

Date:  Thu Jun 19 15:33:13 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31333a
fs/xfs/xfs_attr.h - 1.43 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.h.diff?r1=text&tr1=1.43&r2=text&tr2=1.42&f=h
	- Fix up warning for xfs_vn_listxattr's call of list_one_attr() with context count
	  of ssize_t versus int. Change context count to be ssize_t.
