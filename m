Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 23:22:48 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9A6Mkr1008420
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 23:22:46 -0700
Subject: TAKE 988146 - Move XFS_BMAP_SANITY_CHECK out of line.
Message-Id: <20081010062422.88DD91F08E9@chapter11.melbourne.sgi.com>
Date: Fri, 10 Oct 2008 17:24:22 +1100 (EST)
From: donaldd@sgi.com (Donald Douwsma)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Move XFS_BMAP_SANITY_CHECK out of line.

Move the XFS_BMAP_SANITY_CHECK macro out of line and make it a properly typed
function.  Also pass the xfs_buf for the btree block instead of just the btree
block header, as we will need some additional information for it to implement
CRC checking of btree blocks.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Oct 10 17:23:56 EST 2008
Workarea:  chapter11.melbourne.sgi.com:/scratch/donaldd/isms/2.6.x-xfs
Inspected by:  hch,david@fromorbit.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32301a
fs/xfs/xfs_bmap_btree.h - 1.97 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.97&r2=text&tr2=1.96&f=h
	- Move XFS_BMAP_SANITY_CHECK out of line.

fs/xfs/xfs_bmap.c - 1.417 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.417&r2=text&tr2=1.416&f=h
	- Move XFS_BMAP_SANITY_CHECK out of line.
