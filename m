Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jun 2008 18:11:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5K1B8i9008519
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 18:11:09 -0700
Subject: TAKE 981498 - Don't update i_size for directories and special files
Message-Id: <20080620011203.2D3C758C4C3F@chook.melbourne.sgi.com>
Date: Fri, 20 Jun 2008 11:12:03 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Don't update i_size for directories and special files

The core kernel uses vfs_getattr to look at the inode size and similar
attributes, so there is no need to keep i_size uptodate for directories
or special files.  This means we can remove xfs_validate_fields because
the I/O path already keeps i_size uptodate for regular files.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Jun 20 11:11:11 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/2.6.x-xfs
Inspected by:  bnaujok

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31336a
fs/xfs/linux-2.6/xfs_iops.c - 1.291 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.291&r2=text&tr2=1.290&f=h
	- Don't update i_size for directories and special files
