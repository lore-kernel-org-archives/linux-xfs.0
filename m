Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 06:40:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7ODdv4p032595
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 06:40:00 -0700
Subject: PARTIAL TAKE 968563 - replace some large xfs_log_priv.h macros by proper functions
Message-Id: <20070824133952.D494158C38F1@chook.melbourne.sgi.com>
Date: Fri, 24 Aug 2007 23:39:52 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

replace some large xfs_log_priv.h macros by proper functions

... or in the case of XLOG_TIC_ADD_OPHDR remove a useless macro
entirely.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Aug 24 23:39:27 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29511a
fs/xfs/xfs_log.c - 1.336 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.336&r2=text&tr2=1.335&f=h
	- convert some large macros to functions.

fs/xfs/xfs_log_priv.h - 1.120 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_priv.h.diff?r1=text&tr1=1.120&r2=text&tr2=1.119&f=h
	- convert some large macros to functions.
