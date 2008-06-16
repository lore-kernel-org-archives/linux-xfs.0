Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jun 2008 19:04:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5G2431g026509
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 19:04:05 -0700
Subject: TAKE 983102 - XFS case-insensitive: Assertion Failed: xfs_dir2_sf_lookup(args) == ENOENT
Message-Id: <20080616020450.0068258C4C3F@chook.melbourne.sgi.com>
Date: Mon, 16 Jun 2008 12:04:49 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

The vfs_unlink/d_delete functionality in the Linux VFS make the dentry
negative if it is the only inode being referenced. Case-insensitive mode
doesn't work with negative dentries, so if using CI-mode, invalidate the
dentry on unlink/rmdir.


Date:  Mon Jun 16 12:04:04 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/2.6.x-xfs
Inspected by:  hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31308a
fs/xfs/linux-2.6/xfs_iops.c - 1.289 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.289&r2=text&tr2=1.288&f=h
	- Invalidate dentry in unlink/rmdir if in CI mode
