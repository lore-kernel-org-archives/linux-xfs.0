Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 21:44:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m394hur0016852
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 21:43:57 -0700
Subject: TAKE 980080 - Don't validate symlink target component length
Message-Id: <20080409044430.1361758C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 14:44:29 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Don't validate symlink target component length

This target component validation is not POSIX conformant and it is not
done by any other Linux filesystem so remove it from XFS.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Apr  9 14:44:06 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30776a
fs/xfs/xfs_vnodeops.c - 1.745 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.745&r2=text&tr2=1.744&f=h
	- Remove non-POSIX symlink target component validation.
