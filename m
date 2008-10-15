Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 18:46:43 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F1kfgK003384
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 18:46:41 -0700
Subject: TAKE 988141 - Inode: Allow external initialisers
Message-Id: <20081015014815.D53EF58FA1E9@chook.melbourne.sgi.com>
Date: Wed, 15 Oct 2008 12:48:15 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Date:  Wed Oct 15 12:47:17 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-inode
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  2.6.x-xfs-melb:linux:32321a
fs/inode.c - 1.27 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/fs/inode.c.diff?r1=text&tr1=1.27&r2=text&tr2=1.26&f=h
	- Inode: Allow external initialisers
	  To allow XFS to combine the XFS and linux inodes into a single
	  structure, we need to drive inode lookup from the XFS inode cache,
	  not the generic inode cache. This means that we need initialise a
	  struct inode from a context outside alloc_inode() as it is no longer
	  used by XFS.
	  Factor and export the struct inode initialisation code from
	  alloc_inode() to inode_init_always() as a counterpart to
	  inode_init_once().  i.e. we have to call this init function for each
	  inode instantiation (always), as opposed inode_init_once() which is
	  only called on slab object instantiation (once).
	  Signed-off-by: Dave Chinner <david@fromorbit.com>

include/linux/fs.h - 1.40 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/include/linux/fs.h.diff?r1=text&tr1=1.40&r2=text&tr2=1.39&f=h
	- Inode: Allow external initialisers
