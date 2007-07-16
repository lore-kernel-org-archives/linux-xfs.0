Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 00:39:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6G7dSbm017670
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2007 00:39:30 -0700
Subject: TAKE 940392 - unwritten extents aren't converted when modified through mmap
Message-Id: <20070716073927.02D2858C38F1@chook.melbourne.sgi.com>
Date: Mon, 16 Jul 2007 17:39:26 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Implement ->page_mkwrite in XFS.

Hook XFS up to ->page_mkwrite to ensure that we know about
mmap pages being written to. This allows use to do correct
delayed allocation and ENOSPC checking as well as remap unwritten
extents so that they get converted correctly during writeback.
This is done via the generic block_page_mkwrite code.

Date:  Mon Jul 16 17:38:51 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29149a
fs/xfs/linux-2.6/xfs_file.c - 1.150 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_file.c.diff?r1=text&tr1=1.150&r2=text&tr2=1.149&f=h
	- Connect ->page_mkwrite to the generic block_page_mkwrite
	  implementation.
