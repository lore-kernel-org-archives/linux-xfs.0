Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 May 2007 01:04:42 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4M84VWt015922
	for <xfs@oss.sgi.com>; Tue, 22 May 2007 01:04:33 -0700
Subject: PARTIAL TAKE 964999 - lazy superblock counters for XFS
Message-Id: <20070522080428.1C4F858CA531@chook.melbourne.sgi.com>
Date: Tue, 22 May 2007 18:04:28 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Fix the transaction flags to make lazy superblock counters work.


Date:  Tue May 22 18:03:50 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28653a
fs/xfs/xfs_trans.c - 1.180 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.c.diff?r1=text&tr1=1.180&r2=text&tr2=1.179&f=h
	- Only conditionally dirty the superblock in the transaction is
	  lazy superblock counters are being used.
