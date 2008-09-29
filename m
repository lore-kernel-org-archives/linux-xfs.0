Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 28 Sep 2008 23:06:40 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8T666bC003947
	for <xfs@oss.sgi.com>; Sun, 28 Sep 2008 23:06:06 -0700
Subject: TAKE 985583 - factored XFS btrees
Message-Id: <20080929060733.E9D0958C52AE@chook.melbourne.sgi.com>
Date: Mon, 29 Sep 2008 16:07:33 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Update the shared kernel and userspace code to the latest version with
the generic btree implementation.  Contains one additional patch to move
the __KERNEL__ ifdefs around in xfs_btree.h over the current kernel
version, which is posted and waiting to be commited for the kernel.
 
 
Signed-off-by: Christoph Hellwig <hch@lst.de>



Date:  Mon Sep 29 16:06:47 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/libxfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32222a
xfsprogs/include/xfs_btree_trace.h - 1.1 - new
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_btree_trace.h
xfsprogs/include/xfs_ialloc.h - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_ialloc.h.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
xfsprogs/include/libxfs.h - 1.67 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/libxfs.h.diff?r1=text&tr1=1.67&r2=text&tr2=1.66&f=h
xfsprogs/include/xfs_ialloc_btree.h - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_ialloc_btree.h.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
xfsprogs/include/xfs_bmap_btree.h - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_bmap_btree.h.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
xfsprogs/include/xfs_btree.h - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_btree.h.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsprogs/include/xfs_inode.h - 1.42 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_inode.h.diff?r1=text&tr1=1.42&r2=text&tr2=1.41&f=h
xfsprogs/include/xfs_alloc_btree.h - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/include/xfs_alloc_btree.h.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
xfsprogs/libxfs/xfs_ialloc.c - 1.28 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_ialloc.c.diff?r1=text&tr1=1.28&r2=text&tr2=1.27&f=h
xfsprogs/libxfs/xfs_ialloc_btree.c - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_ialloc_btree.c.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
xfsprogs/libxfs/xfs_bmap_btree.c - 1.24 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_bmap_btree.c.diff?r1=text&tr1=1.24&r2=text&tr2=1.23&f=h
xfsprogs/libxfs/xfs_btree.c - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_btree.c.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h
xfsprogs/libxfs/xfs_inode.c - 1.33 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_inode.c.diff?r1=text&tr1=1.33&r2=text&tr2=1.32&f=h
xfsprogs/libxfs/xfs_alloc.c - 1.30 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_alloc.c.diff?r1=text&tr1=1.30&r2=text&tr2=1.29&f=h
xfsprogs/libxfs/xfs_bmap.c - 1.36 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_bmap.c.diff?r1=text&tr1=1.36&r2=text&tr2=1.35&f=h
xfsprogs/libxfs/xfs_alloc_btree.c - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/libxfs/xfs_alloc_btree.c.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
xfsprogs/db/metadump.c - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/db/metadump.c.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
	- User space update for refactored btrees
