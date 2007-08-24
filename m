Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 06:46:11 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7ODk64p001632
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 06:46:08 -0700
Subject: PARTIAL TAKE 968563 - growlock should be a mutex
Message-Id: <20070824134601.AF28D58C38F1@chook.melbourne.sgi.com>
Date: Fri, 24 Aug 2007 23:46:01 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

growlock should be a mutex

m_growlock only needs plain binary mutex semantics, so use a struct
mutex instead of a semaphore for it.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Aug 24 23:45:37 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29512a
fs/xfs/xfs_mount.h - 1.250 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.250&r2=text&tr2=1.249&f=h
	- convert m_growlock to a mutex.

fs/xfs/xfs_mount.c - 1.409 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.409&r2=text&tr2=1.408&f=h
	- convert m_growlock to a mutex.

fs/xfs/xfs_fsops.c - 1.130 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c.diff?r1=text&tr1=1.130&r2=text&tr2=1.129&f=h
	- convert m_growlock to a mutex.
