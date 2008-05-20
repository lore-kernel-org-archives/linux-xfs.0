Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 18:14:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4K1ERPP030285
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 18:14:29 -0700
Subject: PARTIAL TAKE 981951 - don't call xfs_freesb from xfs_mountfs failure case
Message-Id: <20080520011512.E515558C4C29@chook.melbourne.sgi.com>
Date: Tue, 20 May 2008 11:15:12 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

don't call xfs_freesb from xfs_mountfs failure case

Freeing of the superblock is already handled in the caller, and that
is more symmetric with the mount path, too.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Tue May 20 11:14:47 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31192a
fs/xfs/xfs_mount.c - 1.434 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.434&r2=text&tr2=1.433&f=h
	- don't call xfs_freesb from xfs_mountfs failure case
