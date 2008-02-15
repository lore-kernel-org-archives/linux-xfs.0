Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Feb 2008 23:30:24 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1F7UFHA017846
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 23:30:18 -0800
Subject: TAKE 977460 - Remove the xfs_icluster structure
Message-Id: <20080215073036.0EE4B58C4C11@chook.melbourne.sgi.com>
Date: Fri, 15 Feb 2008 18:30:36 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Remove the xfs_icluster structure and replace with a radix tree lookup.

We don't need to keep a list of inodes in each cluster around anymore
as we can look them up quickly when we need to. The only time we need
to do this now is during inode writeback.

Factor the inode cluster writeback code out of xfs_iflush and convert
it to use radix_tree_gang_lookup() instead of walking a list of
inodes built when we first read in the inodes.

This remove 3 pointers from each xfs_inode structure and the xfs_icluster
structure per inode cluster. Hence we reduce the cache footprint of the
xfs_inodes by between 5-10% depending on cluster sparseness.

To be truly efficient we need a radix_tree_gang_lookup_range() call
to stop searching once we are past the end of the cluster instead
of trying to find a full cluster's worth of inodes.

Before (ia64):

$ cat /sys/slab/xfs_inode/object_size
536

After:

$ cat /sys/slab/xfs_inode/object_size
512


Date:  Fri Feb 15 18:29:55 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30502a
fs/xfs/xfsidbg.c - 1.343 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.343&r2=text&tr2=1.342&f=h
	- remove the cluster structures from the inode cache
	  and use the radix trees for lookups instead.

fs/xfs/xfs_vfsops.c - 1.553 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.553&r2=text&tr2=1.552&f=h
	- remove the cluster structures from the inode cache
	  and use the radix trees for lookups instead.

fs/xfs/xfs_iget.c - 1.239 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.239&r2=text&tr2=1.238&f=h
	- remove the cluster structures from the inode cache
	  and use the radix trees for lookups instead.

fs/xfs/xfs_inode.c - 1.493 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.493&r2=text&tr2=1.492&f=h
	- remove the cluster structures from the inode cache
	  and use the radix trees for lookups instead.

fs/xfs/xfs_inode.h - 1.243 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.243&r2=text&tr2=1.242&f=h
	- remove the cluster structures from the inode cache
	  and use the radix trees for lookups instead.

fs/xfs/linux-2.6/xfs_ksyms.c - 1.80 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.80&r2=text&tr2=1.79&f=h
	- the xfs_icluster_zone is no longer...
