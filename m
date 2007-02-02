Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Feb 2007 21:33:56 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l125Xmqw007348
	for <xfs@oss.sgi.com>; Thu, 1 Feb 2007 21:33:50 -0800
Subject: TAKE 960408 - dmapi bulkstat returns incorrect number of blocks used
Message-Id: <20070202053248.94D5658FF653@chook.melbourne.sgi.com>
Date: Fri,  2 Feb 2007 16:32:48 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

DMAPI bulkstat block count units incorrect.

Return dt_blocks in units of 512 byte blocks instead of
filesystem blocks.

Date:  Fri Feb  2 16:32:12 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28011a
fs/xfs/dmapi/xfs_dm.c - 1.32 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
	- Return dt_blocks in units of 512 byte blocks instead of
	  filesystem blocks.
