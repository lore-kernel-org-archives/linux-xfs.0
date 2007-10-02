Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Oct 2007 20:23:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l923NS9e005662
	for <xfs@oss.sgi.com>; Mon, 1 Oct 2007 20:23:32 -0700
From: donaldd@sgi.com
Subject: PARTIAL TAKE 971186 - kill xfs_freeze
Message-Id: <20071002032323.D90EC30B55CE@linuxbuild.melbourne.sgi.com>
Date: Tue,  2 Oct 2007 13:23:23 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

kill xfs_freeze.

No need to have a wrapper just two call two more functions.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Tue Oct  2 13:22:40 AEST 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29816a
fs/xfs/xfs_vfsops.c - 1.545 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.545&r2=text&tr2=1.544&f=h
	- kill xfs_freeze.

fs/xfs/linux-2.6/xfs_super.c - 1.400 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.400&r2=text&tr2=1.399&f=h
	- kill xfs_freeze.

fs/xfs/xfs_vfsops.h - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.h.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
	- kill xfs_freeze.
