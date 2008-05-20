Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 19 May 2008 17:47:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4K0lKv1028238
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 17:47:21 -0700
Subject: PARTIAL TAKE 981951 - merge xfs_mount into xfs_fs_fill_super
Message-Id: <20080520004805.C069758C4C29@chook.melbourne.sgi.com>
Date: Tue, 20 May 2008 10:48:05 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

merge xfs_mount into xfs_fs_fill_super

xfs_mount is already pretty linux-specific so merge it into
xfs_fs_fill_super to allow for a more structured mount code in the next
patches. xfs_start_flags and xfs_finish_flags also move to xfs_super.c.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Tue May 20 10:46:35 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31189a
fs/xfs/xfs_vfsops.c - 1.567 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.567&r2=text&tr2=1.566&f=h
	- merge xfs_mount into xfs_fs_fill_super.

fs/xfs/linux-2.6/xfs_super.c - 1.420 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.420&r2=text&tr2=1.419&f=h
	- merge xfs_mount into xfs_fs_fill_super.

fs/xfs/xfs_vfsops.h - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.h.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
	- merge xfs_mount into xfs_fs_fill_super.
