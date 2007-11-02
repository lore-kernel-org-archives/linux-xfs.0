Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Nov 2007 17:30:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA20UI7e001094
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 17:30:21 -0700
Subject: PARTIAL TAKE 971186 - Clean up bitops
Message-Id: <20071102003017.6D3EE58C38F7@chook.melbourne.sgi.com>
Date: Fri,  2 Nov 2007 11:30:17 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Use the generic bitops rather than implementing them ourselves.
Patch inspired by Andi Kleen.


Date:  Fri Nov  2 11:29:35 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30000a
fs/xfs/xfs_bit.h - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bit.h.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
	- wrap xfs bitop functions around generic implementations.

fs/xfs/xfs_bit.c - 1.32 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bit.c.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
	- Remove implementation of generic bitops.

fs/xfs/xfs_rtalloc.c - 1.108 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rtalloc.c.diff?r1=text&tr1=1.108&r2=text&tr2=1.107&f=h
	- remove implementation of generic bitops.
