Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 00:46:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l727kVbm021238
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 00:46:36 -0700
Subject: PARTIAL TAKE 968555 - sparse fixes for 2.6.23
Message-Id: <20070802074625.F0D0458F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 17:46:25 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix sparse warning in kmem_shake_allow

We can't return a masked result of a __bitwise type.  Compare it to
0 first to keep the behaviour without the warning.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Thu Aug  2 17:45:47 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29309a
fs/xfs/linux-2.6/kmem.h - 1.43 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/kmem.h.diff?r1=text&tr1=1.43&r2=text&tr2=1.42&f=h
	- Sparse warns if we return a masked result of a __bitwise type.
