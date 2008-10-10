Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 22:17:10 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9A5H7YL002729
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 22:17:07 -0700
Subject: PARTIAL TAKE 988146 - Always use struct xfs_btree_block instead of short / longform structures.
Message-Id: <20081010051846.1E5421EE4D1@chapter11.melbourne.sgi.com>
Date: Fri, 10 Oct 2008 16:18:46 +1100 (EST)
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


Date:  Fri Oct 10 16:18:20 EST 2008
Workarea:  chapter11.melbourne.sgi.com:/scratch/donaldd/isms/2.6.x-xfs
Inspected by:  hch,david@fromorbit.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32297a
fs/xfs/xfs_bmap_btree.h - 1.94 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.94&r2=text&tr2=1.93&f=h
	- Always use struct xfs_btree_block instead of short / longform structures.

fs/xfs/xfs_bmap.c - 1.414 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.414&r2=text&tr2=1.413&f=h
	- Always use struct xfs_btree_block instead of short / longform structures.
