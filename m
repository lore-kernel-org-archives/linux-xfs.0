Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jun 2008 18:08:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5K17s2i007867
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 18:07:55 -0700
Subject: TAKE 981498 - Merge xfs_rmdir into xfs_remove
Message-Id: <20080620010848.8977858C4C3F@chook.melbourne.sgi.com>
Date: Fri, 20 Jun 2008 11:08:48 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Merge xfs_rmdir into xfs_remove

xfs_remove and xfs_rmdir are almost the same with a little more work
performed in xfs_rmdir due to the . and .. entries.  This patch merges
xfs_rmdir into xfs_remove and performs these actions conditionally.

Also clean up the error handling which was a nightmare in both versions
before.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Jun 20 11:07:57 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31335a
fs/xfs/xfs_vnodeops.c - 1.762 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.762&r2=text&tr2=1.761&f=h
	- Merge xfs_remove and xfs_rmdir

fs/xfs/linux-2.6/xfs_iops.c - 1.290 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.290&r2=text&tr2=1.289&f=h
	- Merge xfs_vn_rmdir and xfs_vn_unlink

fs/xfs/xfs_vnodeops.h - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.h.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
	- Merge xfs_remove and xfs_rmdir
