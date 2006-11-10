Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Dec 2006 14:36:52 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBLMajqw019072
	for <xfs@oss.sgi.com>; Thu, 21 Dec 2006 14:36:47 -0800
Subject: TAKE 957005 - fs/xfs/xfs_dmapi.h Removal of old code
Message-Id: <20061110020305.5809258FA286@chook.melbourne.sgi.com>
Date: Fri, 10 Nov 2006 13:03:05 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Remove KERNEL_VERSION macros from xfs_dmapi.h

Date:  Fri Nov 10 13:01:22 AEDT 2006
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  tes,michal.k.k.piotrowski@gmail.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27398a
fs/xfs/linux-2.4/xfs_dmapi_priv.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_dmapi_priv.h
	- Move 2.4 specific dmapi macros here.

fs/xfs/linux-2.6/xfs_dmapi_priv.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_dmapi_priv.h
	- Move 2.6 specific dmapi macros here.

fs/xfs/xfs_dmapi.h - 1.58 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dmapi.h.diff?r1=text&tr1=1.58&r2=text&tr2=1.57&f=h
	- Split platform specific macros out into platform specifc headers.
