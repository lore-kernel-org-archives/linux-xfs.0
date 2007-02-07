Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Feb 2007 19:54:11 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l173s53c011421
	for <xfs@oss.sgi.com>; Tue, 6 Feb 2007 19:54:07 -0800
Subject: TAKE 960904 - Remove kmap usage from xfs_iozero()
Message-Id: <20070207035400.B499B58C4C27@chook.melbourne.sgi.com>
Date: Wed,  7 Feb 2007 14:54:00 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Don't use kmap in xfs_iozero.

kmap() is inefficient and does not scale well. kmap_atomic() is a
better choice. Use the generic wrapper function instead of open
coding the kmap-memset-dcache flush-kunmap stuff.

Date:  Wed Feb  7 14:53:32 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28041a
fs/xfs/linux-2.6/xfs_lrw.c - 1.256 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.256&r2=text&tr2=1.255&f=h
	- replace kmap usage in xfs_iozero with more optimal implementation.
