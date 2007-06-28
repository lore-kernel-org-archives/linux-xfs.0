Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Jun 2007 21:29:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5S4SvtL022301
	for <xfs@oss.sgi.com>; Wed, 27 Jun 2007 21:29:00 -0700
Subject: TAKE fix rtx warning msg
Message-Id: <20070628042853.2F78D58C38F1@chook.melbourne.sgi.com>
Date: Thu, 28 Jun 2007 14:28:53 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-bugs-internal@sgi.com, xfs@oss.sgi.com, akpm@linux-foundation.org

Appease gcc in regards to "warning: 'rtx' is used uninitialized in this function".
Use the uninitialized_var() macro in xfs_bmap_rtalloc for this.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Patch provided by Andrew Morton.

--Tim

Date:  Thu Jun 28 14:25:55 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs
Inspected by:  akpm@linux-foundation.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29007a
fs/xfs/xfs_bmap.c - 1.370 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.370&r2=text&tr2=1.369&f=h
	- Appease gcc in regards to "warning: 'rtx' is used uninitialized in this function".
	  Use the uninitialized_var() macro in xfs_bmap_rtalloc for this.
	  Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
