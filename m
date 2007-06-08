Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Jun 2007 02:43:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l589hNWt031969
	for <xfs@oss.sgi.com>; Fri, 8 Jun 2007 02:43:25 -0700
Subject: TAKE 965784 -  i386 linker error: xfs_dm_punch_hole - undefined ref to `__divdi3'
Message-Id: <20070608094319.924C058C38C1@chook.melbourne.sgi.com>
Date: Fri,  8 Jun 2007 19:43:19 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix i386 dmapi build - use roundup_64 for 64 bit types.

Date:  Fri Jun  8 19:42:38 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  donaldd@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28870a
fs/xfs/dmapi/xfs_dm.c - 1.37 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.37&r2=text&tr2=1.36&f=h
	- Use roundup_64() instead of roundup() which cannot handle 64
	  bit types on 32bit platforms.
