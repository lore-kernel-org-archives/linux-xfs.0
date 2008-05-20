Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 18:28:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4K1ShDg032067
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 18:28:44 -0700
Subject: PARTIAL TAKE 981951 - allow xfs_args_allocate to fail
Message-Id: <20080520012928.8BFB258C4C29@chook.melbourne.sgi.com>
Date: Tue, 20 May 2008 11:29:28 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

allow xfs_args_allocate to fail

Switch xfs_args_allocate to kzalloc and handle failures.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Tue May 20 11:29:10 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31195a
fs/xfs/linux-2.6/xfs_super.c - 1.423 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.423&r2=text&tr2=1.422&f=h
	- allow xfs_args_allocate to fail.
