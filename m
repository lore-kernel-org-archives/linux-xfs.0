Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 22:39:26 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1M6dAIT021834
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 22:39:13 -0800
Subject: TAKE 977636 - Fix superblock features2 field alignment problem
Message-Id: <20080222063931.8DF0A58C4C0F@chook.melbourne.sgi.com>
Date: Fri, 22 Feb 2008 17:39:31 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix superblock features2 field alignment problem

Due to the xfs_dsb_t structure not being 64 bit aligned,
the last field of the on-disk superblock can vary in location
This causes problems when the filesystem gets moved to a
different platform, or there is a 32 bit userspace and 64 bit
kernel.

This patch detects the defect at mount time, logs a warning
such as:

XFS: correcting sb_features alignment problem

in dmesg and corrects the problem so that everything is OK.
it also blacklists the bad field in the superblock so it does
not get used for something else later on.


Date:  Fri Feb 22 17:39:13 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net,hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30539a
fs/xfs/xfs_sb.h - 1.71 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_sb.h.diff?r1=text&tr1=1.71&r2=text&tr2=1.70&f=h
	- Detect and correct the features2 field of the superblock
	  being misaligned. Blacklist the misaligned field so it
	  does not get reused in future.

fs/xfs/xfs_mount.c - 1.419 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.419&r2=text&tr2=1.418&f=h
	- Detect and correct the features2 field of the superblock
	  being misaligned. Blacklist the misaligned field so it
	  does not get reused in future.
