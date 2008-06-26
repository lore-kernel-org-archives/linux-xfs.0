Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Jun 2008 20:37:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5Q3bf9Z002610
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 20:37:42 -0700
Subject: TAKE 983734 - Don't assert if trying to mount with blocksize > pagesize
Message-Id: <20080626033837.3B48258C4C3F@chook.melbourne.sgi.com>
Date: Thu, 26 Jun 2008 13:38:37 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Don't assert if trying to mount with blocksize > pagesize

If we don't do the blocksize/PAGESIZE check before
calling xfs_sb_validate_fsb_count() we can assert
if we try to mount with a blocksize > pagesize.
The assert is valid so leave it and just move the
blocksize/pagesize check earlier. 

Date:  Thu Jun 26 13:37:19 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-alloc
Inspected by:  dgc
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31365a
fs/xfs/xfs_mount.c - 1.437 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.437&r2=text&tr2=1.436&f=h
	- Don't assert if trying to mount with blocksize > pagesize
