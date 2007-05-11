Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 May 2007 22:25:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4B5POfB018617
	for <xfs@oss.sgi.com>; Thu, 10 May 2007 22:25:26 -0700
Subject: TAKE 964545 - use-after-free of xfs_buf_t during log unmount
Message-Id: <20070511052520.2957D58CA530@chook.melbourne.sgi.com>
Date: Fri, 11 May 2007 15:25:20 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix use-after-free during log unmount.

Don't reference the log buffer after running the callbacks as
the callback can trigger the log buffers to be freed during
unmount.


Date:  Fri May 11 15:24:46 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28567a
fs/xfs/xfs_log.c - 1.329 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.329&r2=text&tr2=1.328&f=h
	- Don't reference the log buffer after running the callbacks
	  as it may have been freed during the unmount.
