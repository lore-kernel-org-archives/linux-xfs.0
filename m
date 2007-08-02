Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 00:53:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l727rObm024225
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 00:53:26 -0700
Subject: PARTIAL TAKE 968555 - sparse fixes for 2.6.23
Message-Id: <20070802075324.9F3AF58F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 17:53:24 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

fix ASSERT and ASSERT_ALWAYS

 - remove the != 0 inside the unlikely in ASSERT_ALWAYS because sparse now
   complains about comparisons between pointers and 0
 - add a standalone ASSERT implementation because defining it to
   ASSERT_ALWAYS means the string is expanded before the token passing
   stringification.  This way we get the actual content of the
   assertation in the assfail message and don't overflow sparse's
   stringification buffer leading to sparse error messages.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Thu Aug  2 17:52:47 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29310a
fs/xfs/support/debug.h - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/support/debug.h.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
	- Clean up sparse warnings fo ASSERT_ALWAYS and make ASSERT always
	  stringify the failure correctly.
