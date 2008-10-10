Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 23:17:58 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9A6HssL007751
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 23:17:55 -0700
Subject: PARTIAL TAKE 988146 - Always use struct xfs_btree_block instead of short / longform structures.
Message-Id: <20081010061927.168901F08E9@chapter11.melbourne.sgi.com>
Date: Fri, 10 Oct 2008 17:19:27 +1100 (EST)
From: donaldd@sgi.com (Donald Douwsma)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Always use struct xfs_btree_block instead of short / longform structures.

Always use the generic xfs_btree_block type instead of the short / long
structures.  Add XFS_BTREE_SBLOCK_LEN / XFS_BTREE_LBLOCK_LEN defines for
the length of a short / long form block.  The rationale for this is that
we will grow more btree block header variants to support CRCs and other
RAS information, and always accessing them through the same datatype
with unions for the short / long form pointers makes implementing this
much easier.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Oct 10 17:18:54 EST 2008
Workarea:  chapter11.melbourne.sgi.com:/scratch/donaldd/isms/2.6.x-xfs
Inspected by:  hch,david@fromorbit.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32300a
fs/xfs/xfsidbg.c - 1.370 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.370&r2=text&tr2=1.369&f=h
	- Always use struct xfs_btree_block instead of short / longform structures.

fs/xfs/xfs_ialloc_btree.h - 1.44 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.h.diff?r1=text&tr1=1.44&r2=text&tr2=1.43&f=h
	- Always use struct xfs_btree_block instead of short / longform structures.

fs/xfs/xfs_ialloc_btree.c - 1.108 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.108&r2=text&tr2=1.107&f=h
	- Always use struct xfs_btree_block instead of short / longform structures.

fs/xfs/xfs_log_recover.c - 1.349 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.349&r2=text&tr2=1.348&f=h
	- Always use struct xfs_btree_block instead of short / longform structures.

fs/xfs/xfs_bmap_btree.h - 1.96 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.96&r2=text&tr2=1.95&f=h
	- Always use struct xfs_btree_block instead of short / longform structures.

fs/xfs/xfs_bmap_btree.c - 1.198 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.198&r2=text&tr2=1.197&f=h
	- Always use struct xfs_btree_block instead of short / longform structures.

fs/xfs/xfs_btree.c - 1.145 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.145&r2=text&tr2=1.144&f=h
	- Always use struct xfs_btree_block instead of short / longform structures.

fs/xfs/xfs_btree.h - 1.100 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.100&r2=text&tr2=1.99&f=h
	- Always use struct xfs_btree_block instead of short / longform structures.

fs/xfs/xfs_inode.c - 1.529 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.529&r2=text&tr2=1.528&f=h
	- Always use struct xfs_btree_block instead of short / longform structures.

fs/xfs/xfs_inode.h - 1.262 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.262&r2=text&tr2=1.261&f=h
	- Always use struct xfs_btree_block instead of short / longform structures.

fs/xfs/xfs_alloc.c - 1.204 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.204&r2=text&tr2=1.203&f=h
	- Always use struct xfs_btree_block instead of short / longform structures.

fs/xfs/xfs_fsops.c - 1.138 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c.diff?r1=text&tr1=1.138&r2=text&tr2=1.137&f=h
	- Always use struct xfs_btree_block instead of short / longform structures.

fs/xfs/xfs_bmap.c - 1.416 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.416&r2=text&tr2=1.415&f=h
	- Always use struct xfs_btree_block instead of short / longform structures.

fs/xfs/xfs_alloc_btree.h - 1.41 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.h.diff?r1=text&tr1=1.41&r2=text&tr2=1.40&f=h
	- Always use struct xfs_btree_block instead of short / longform structures.

fs/xfs/xfs_alloc_btree.c - 1.113 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.113&r2=text&tr2=1.112&f=h
	- Always use struct xfs_btree_block instead of short / longform structures.

fs/xfs/xfs_dinode.h - 1.88 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dinode.h.diff?r1=text&tr1=1.88&r2=text&tr2=1.87&f=h
	- Always use struct xfs_btree_block instead of short / longform structures.
