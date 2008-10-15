Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 18:57:07 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F1v4XH004667
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 18:57:05 -0700
Subject: TAKE 988141 - Inode: Allow external list initialisation
Message-Id: <20081015015839.ACD5358FA1E9@chook.melbourne.sgi.com>
Date: Wed, 15 Oct 2008 12:58:39 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Date:  Wed Oct 15 12:58:12 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-inode
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  2.6.x-xfs-melb:linux:32322a
fs/inode.c - 1.28 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/fs/inode.c.diff?r1=text&tr1=1.28&r2=text&tr2=1.27&f=h
include/linux/fs.h - 1.41 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/include/linux/fs.h.diff?r1=text&tr1=1.41&r2=text&tr2=1.40&f=h
	- Inode: Allow external list initialisation
	  To allow XFS to combine the XFS and linux inodes into a single
	  structure, we need to drive inode lookup from the XFS inode cache,
	  not the generic inode cache. This means that we need initialise a
	  struct inode from a context outside alloc_inode() as it is no longer
	  used by XFS.
	  After inode allocation and initialisation, we need to add the inode
	  to the superblock list, the in-use list, hash it and do some
	  accounting. This all needs to be done with the inode_lock held and
	  there are already several places in fs/inode.c that do this list
	  manipulation.  Factor out the common code, add a locking wrapper and
	  export the function so ti can be called from XFS.
	  Signed-off-by: Dave Chinner <david@fromorbit.com>
