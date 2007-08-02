Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 04:04:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l72B4Lbm024274
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 04:04:24 -0700
Subject: PARTIAL TAKE 968563 - fix sparse endianess warnings in xfsidbg
Message-Id: <20070802110421.3AE9458F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 21:04:21 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

fix sparse endianess warnings in xfsidbg

xfsidbg was missed in a a few of the previous endianess conversions, and
this patch brings it up to the proper state.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Thu Aug  2 21:04:00 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29316a
fs/xfs/xfsidbg.c - 1.318 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.318&r2=text&tr2=1.317&f=h
	- fix sparse endianess warnings.
