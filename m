Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Dec 2007 21:29:51 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lB65Tdix016568
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2007 21:29:46 -0800
Subject: TAKE 974005 - xfs_lowbit64 broken on 32bit platforms
Message-Id: <20071206052946.0F59358FA249@chook.melbourne.sgi.com>
Date: Thu,  6 Dec 2007 16:29:46 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix xfs_lowbit64

xfs_lowbit64 was broken on 32 bit platforms in a recent cleanup of
the xfs bitops. Fix it back up again.


Date:  Thu Dec  6 16:28:59 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30202a
fs/xfs/xfs_bit.h - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bit.h.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
	- make the temporary variable in xfs_lowbit64 the correct type
	  so that 32bit platforms work as well.
