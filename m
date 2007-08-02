Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 00:13:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l727DPbm003782
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 00:13:28 -0700
Subject: PARTIAL TAKE 968554 - Filestreams fixes for 2.6.23
Message-Id: <20070802071323.ACB8A58F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 17:13:23 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Set filestreams object timeout to something sane.


Date:  Thu Aug  2 17:12:33 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29303a
fs/xfs/linux-2.6/xfs_globals.c - 1.71 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_globals.c.diff?r1=text&tr1=1.71&r2=text&tr2=1.70&f=h
	- Set the filestreams default timeout to 30s.
