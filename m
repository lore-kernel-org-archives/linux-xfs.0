Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 04:50:04 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l72Bnvbm012906
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 04:50:00 -0700
Subject: PARTIAL TAKE 968563 - move linux/log2.h header to xfs_linux.h
Message-Id: <20070802114956.2AF9858F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 21:49:56 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

move linux/log2.h header to xfs_linux.h

Generally we try not to directly include linux header files
in core xfs code; xfs_linux.h is the spot for that.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Thu Aug  2 21:49:33 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29326a
fs/xfs/xfs_inode.c - 1.470 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.470&r2=text&tr2=1.469&f=h
	- move linux/log2.h header to xfs_linux.h

fs/xfs/linux-2.6/xfs_linux.h - 1.155 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.155&r2=text&tr2=1.154&f=h
	- move linux/log2.h header to xfs_linux.h

fs/xfs/linux-2.4/xfs_linux.h - 1.163 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_linux.h.diff?r1=text&tr1=1.163&r2=text&tr2=1.162&f=h
	- move linux/log2.h header to xfs_linux.h
