Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 08 Jul 2007 22:13:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l695DDtL015366
	for <xfs@oss.sgi.com>; Sun, 8 Jul 2007 22:13:15 -0700
Subject: PARTIAL TAKE 964469 - XFS Concurrent Multi-File Data Streams
Message-Id: <20070709051311.44DE058C38F1@chook.melbourne.sgi.com>
Date: Mon,  9 Jul 2007 15:13:11 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Export radix_tree_preload()

Date:  Mon Jul  9 15:11:56 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  tes@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  2.6.x-xfs-melb:linux:29097a
lib/radix-tree.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/lib/radix-tree.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
	- Export radix_tree_preload() so it is available to modules.
