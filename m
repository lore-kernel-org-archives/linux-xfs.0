Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jun 2008 20:41:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5I3fO1R030083
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 20:41:25 -0700
Subject: TAKE 983394 - factor out has_attrs function
Message-Id: <20080618034216.7663558C4C3F@chook.melbourne.sgi.com>
Date: Wed, 18 Jun 2008 13:42:16 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Factor out code for whether inode has attributes or not.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Wed Jun 18 13:41:05 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31323a
fs/xfs/xfs_attr.c - 1.153 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.c.diff?r1=text&tr1=1.153&r2=text&tr2=1.152&f=h
	- Factor out xfs_inode_hasattr.
