Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jun 2008 18:37:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5O1b8q6005255
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 18:37:10 -0700
Subject: TAKE 983564 - 
Message-Id: <20080624013801.4B00458C4C3F@chook.melbourne.sgi.com>
Date: Tue, 24 Jun 2008 11:38:01 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix CI lookup in leaf-form directories

Instead of comparing buffer pointers, compare buffer block numbers
and don't keep buff


Date:  Tue Jun 24 11:37:29 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31346a
fs/xfs/xfs_dir2_leaf.c - 1.65 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_leaf.c.diff?r1=text&tr1=1.65&r2=text&tr2=1.64&f=h
	- Fix CI lookup in leaf-form directories
