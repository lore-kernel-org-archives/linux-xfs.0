Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 18:46:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4K1kOXK001635
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 18:46:26 -0700
Subject: PARTIAL TAKE 981951 - kill calls to xfs_binval in the mount error path
Message-Id: <20080520014709.D7AE058C4C29@chook.melbourne.sgi.com>
Date: Tue, 20 May 2008 11:47:09 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

kill calls to xfs_binval in the mount error path

xfs_binval aka xfs_flush_buftarg is the first thing done in
xfs_free_buftarg, so there is no need to have duplicated calls just
before xfs_free_buftarg in the mount failure path.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Tue May 20 11:46:53 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31197a
fs/xfs/linux-2.6/xfs_super.c - 1.425 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.425&r2=text&tr2=1.424&f=h
	- kill calls to xfs_binval in the mount error path
