Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 17:41:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3T0f5vN027179
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 17:41:07 -0700
Subject: TAKE 979416 - Don't initialise new inode generation numbers to zero
Message-Id: <20080429004144.757D658C4C15@chook.melbourne.sgi.com>
Date: Tue, 29 Apr 2008 10:41:44 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Don't initialise new inode generation numbers to zero

When we allocation new inode chunks, we initialise the generation
numbers to zero. This works fine until we delete a chunk and then
reallocate it, resulting in the same inode numbers but with a
reset generation count. This can result in inode/generation
pairs of different inodes occurring relatively close together.

Given that the inode/gen pair makes up the "unique" portion of
an NFS filehandle on XFS, this can result in file handles cached
on clients being seen on the wire from the server but refer to
a different file. This causes .... issues for NFS clients.

Hence we need a unique generation number initialisation for
each inode to prevent reuse of a small portion of the generation
number space. Use a random number to initialise the generation
number so we don't need to keep any new state on disk whilst
making the new number difficult to guess from previous allocations.

Date:  Tue Apr 29 10:41:26 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31001a
fs/xfs/xfs_ialloc.c - 1.199 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.c.diff?r1=text&tr1=1.199&r2=text&tr2=1.198&f=h
	- use random32() to initialise the generation in newly allocated
	  inodes to prevent short term reuse of inode,gen pairs which
	  can cause ESTALE problems for NFS clients.
