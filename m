Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Jan 2007 17:30:24 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0V1UFqw002564
	for <xfs@oss.sgi.com>; Tue, 30 Jan 2007 17:30:16 -0800
Date: Wed, 31 Jan 2007 12:29:15 +1100
From: David Chinner <dgc@sgi.com>
Subject: Review: Fix bulkstat block count units
Message-ID: <20070131012915.GO33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com
Cc: xfs@oss.sgi.com


The recent bulkstat improvements introduced a minor
regression - they changed the units of the dt_count field
from 512 byte blocks to filesystem blocks. This changes
the userspace visible fields and can break existing applications
that use bulkstat.

Comments?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/dmapi/xfs_dm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/dmapi/xfs_dm.c	2007-01-16 10:54:14.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/dmapi/xfs_dm.c	2007-01-29 18:09:35.612014885 +1100
@@ -426,7 +426,8 @@ xfs_dip_to_stat(
 	case XFS_DINODE_FMT_BTREE:
 		buf->dt_rdev = 0;
 		buf->dt_blksize = mp->m_sb.sb_blocksize;
-		buf->dt_blocks = INT_GET(dic->di_nblocks, ARCH_CONVERT);
+		buf->dt_blocks = XFS_FSB_TO_BB(mp,
+				INT_GET(dic->di_nblocks, ARCH_CONVERT));
 		break;
 	}
 
@@ -494,7 +495,8 @@ xfs_ip_to_stat(
 	case XFS_DINODE_FMT_BTREE:
 		buf->dt_rdev = 0;
 		buf->dt_blksize = mp->m_sb.sb_blocksize;
-		buf->dt_blocks = dic->di_nblocks + ip->i_delayed_blks;
+		buf->dt_blocks = XFS_FSB_TO_BB(mp,
+				(dic->di_nblocks + ip->i_delayed_blks));
 		break;
 	}
 
