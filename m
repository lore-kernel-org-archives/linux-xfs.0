Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 06:02:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7ND264p030174
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 06:02:10 -0700
Subject: TAKE 969561 - Radix tree based inode caching
Message-Id: <20070823130200.7A4CD58C38F1@chook.melbourne.sgi.com>
Date: Thu, 23 Aug 2007 23:02:00 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Radix tree based inode caching

One of the perpetual scaling problems XFS has is indexing
it's incore inodes. We currently uses hashes and the default
hash sizes chosen can only ever be a tradeoff between memory
consumption and the maximum realistic size of the cache.

As a result, anyone who has millions of inodes cached on a
filesystem needs to tunes the size of the cache via the ihashsize
mount option to allow decent scalability with inode cache
operations.

A further problem is the separate inode cluster hash, whose size is
based on the ihashsize but is smaller, and so under certain
conditions (sparse cluster cache population) this can become
a limitation long before the inode hash is causing issues.

The following patchset removes the inode hash and cluster hash
and replaces them with radix trees to avoid the scalability
limitations of the hashes. It also reduces the size of the
inodes by 3 pointers....


Date:  Thu Aug 23 23:01:35 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29481a
fs/xfs/xfsidbg.c - 1.323 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.323&r2=text&tr2=1.322&f=h
	- Convert xfs inode caches from hashes to radix trees.

fs/xfs/xfs_ag.h - 1.61 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ag.h.diff?r1=text&tr1=1.61&r2=text&tr2=1.60&f=h
	- Convert xfs inode caches from hashes to radix trees.

fs/xfs/xfs_extfree_item.c - 1.67 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_extfree_item.c.diff?r1=text&tr1=1.67&r2=text&tr2=1.66&f=h
	- Convert xfs inode caches from hashes to radix trees.

fs/xfs/xfs_buf_item.c - 1.163 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_buf_item.c.diff?r1=text&tr1=1.163&r2=text&tr2=1.162&f=h
	- Convert xfs inode caches from hashes to radix trees.

fs/xfs/xfs_trans_ail.c - 1.81 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_ail.c.diff?r1=text&tr1=1.81&r2=text&tr2=1.80&f=h
	- Convert xfs inode caches from hashes to radix trees.

fs/xfs/xfs_vnodeops.c - 1.708 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.708&r2=text&tr2=1.707&f=h
	- Convert xfs inode caches from hashes to radix trees.

fs/xfs/xfs_dir2_block.c - 1.57 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_block.c.diff?r1=text&tr1=1.57&r2=text&tr2=1.56&f=h
	- Convert xfs inode caches from hashes to radix trees.

fs/xfs/xfs_vfsops.c - 1.526 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.526&r2=text&tr2=1.525&f=h
	- Convert xfs inode caches from hashes to radix trees.

fs/xfs/xfs_iget.c - 1.226 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.226&r2=text&tr2=1.225&f=h
	- Convert xfs inode caches from hashes to radix trees.

fs/xfs/xfs_clnt.h - 1.56 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_clnt.h.diff?r1=text&tr1=1.56&r2=text&tr2=1.55&f=h
	- Convert xfs inode caches from hashes to radix trees.

fs/xfs/xfs_dir2_sf.c - 1.49 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_sf.c.diff?r1=text&tr1=1.49&r2=text&tr2=1.48&f=h
	- Convert xfs inode caches from hashes to radix trees.

fs/xfs/xfs_mount.h - 1.240 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.240&r2=text&tr2=1.239&f=h
	- Convert xfs inode caches from hashes to radix trees.

fs/xfs/xfs_mount.c - 1.403 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.403&r2=text&tr2=1.402&f=h
	- Convert xfs inode caches from hashes to radix trees.

fs/xfs/xfs_dir2_data.c - 1.39 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_data.c.diff?r1=text&tr1=1.39&r2=text&tr2=1.38&f=h
	- Convert xfs inode caches from hashes to radix trees.

fs/xfs/xfs_trans_extfree.c - 1.28 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_extfree.c.diff?r1=text&tr1=1.28&r2=text&tr2=1.27&f=h
	- Convert xfs inode caches from hashes to radix trees.

fs/xfs/xfs_inode.c - 1.472 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.472&r2=text&tr2=1.471&f=h
	- Convert xfs inode caches from hashes to radix trees.

fs/xfs/xfs_inode.h - 1.225 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.225&r2=text&tr2=1.224&f=h
	- Convert xfs inode caches from hashes to radix trees.

fs/xfs/xfs_error.c - 1.57 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_error.c.diff?r1=text&tr1=1.57&r2=text&tr2=1.56&f=h
	- Convert xfs inode caches from hashes to radix trees.

fs/xfs/xfs_dir2_node.c - 1.60 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2_node.c.diff?r1=text&tr1=1.60&r2=text&tr2=1.59&f=h
	- Convert xfs inode caches from hashes to radix trees.

fs/xfs/xfs_rename.c - 1.72 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rename.c.diff?r1=text&tr1=1.72&r2=text&tr2=1.71&f=h
	- Convert xfs inode caches from hashes to radix trees.

fs/xfs/linux-2.6/xfs_ksyms.c - 1.64 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.64&r2=text&tr2=1.63&f=h
	- Convert xfs inode caches from hashes to radix trees.

fs/xfs/linux-2.6/xfs_export.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_export.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
	- Convert xfs inode caches from hashes to radix trees.




Modid:  2.6.x-xfs-melb:linux:29481b
Documentation/filesystems/xfs.txt - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/Documentation/filesystems/xfs.txt.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
	- Update ihashsize mount option as deprecated.
