Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Apr 2008 20:48:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3F3mNIr028756
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2008 20:48:25 -0700
Subject: TAKE 980310 - remove CONFIG_XFS_SECURITY
Message-Id: <20080415034858.C1DAB58C4C15@chook.melbourne.sgi.com>
Date: Tue, 15 Apr 2008 13:48:58 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Remove CONFIG_XFS_SECURITY.

There is no point to the CONFIG_XFS_SECURITY option; it
disables the ability to set security attributes at runtime,
but it does not actually slim down or remove any code for
runtime.  Just remove it and always allow security attributes
to be set.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Tue Apr 15 13:47:37 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30877a
fs/xfs/xfs_attr.c - 1.147 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.c.diff?r1=text&tr1=1.147&r2=text&tr2=1.146&f=h
	- remove CONFIG_XFS_SECURITY

fs/xfs/linux-2.6/xfs_super.h - 1.77 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.h.diff?r1=text&tr1=1.77&r2=text&tr2=1.76&f=h
	- remove CONFIG_XFS_SECURITY

fs/xfs/Kconfig - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/Kconfig.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
	- remove CONFIG_XFS_SECURITY
