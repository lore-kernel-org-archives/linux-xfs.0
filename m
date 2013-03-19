Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4E29F7F4C
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 08:21:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C181AAC005
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 06:21:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0CG0K5TGphHyCk5z for
	<xfs@oss.sgi.com>; Tue, 19 Mar 2013 06:21:46 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2JDLjRk001280
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 09:21:46 -0400
Received: from bfoster.bfoster (dhcp-189-135.bos.redhat.com [10.16.189.135])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r2JDLjfX029151
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 09:21:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfsprogs: reduce bb_numrecs in bno/cnt btrees when log
	consumes all agf space
Date: Tue, 19 Mar 2013 09:23:35 -0400
Message-Id: <1363699415-28022-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The mkfs code currently creates a single free space extent record
for each of the bno and cnt btrees in each AG. The start block of
the record is pushed forward on the AG that hosts an internal log.
If the log happens to consume all available space in the AG, the
start block becomes equal to sb->sb_agblocks and thus invalid.
This causes xfs_repair to complain.

For example, the following sequence:

	mkfs.xfs -d file,name=./fs.img,size=50g,agsize=16m
	xfs_repair ./fs.img

... produces the following xfs_repair output:

	Phase 1 - find and verify superblock...
	Phase 2 - using internal log
        	- scan filesystem freespace and inode maps...
	invalid start block 4096 in record 0 of bno btree block 1600/1
	invalid start block 4096 in record 0 of cnt btree block 1600/2
        	- found root inode chunk
	...

xfs_repair appears to correct the numrecs value such that subsequent
checks are successful. The sequence above is pulled from xfstests
test #250, which fails due to this behavior.

Modify mkfs.xfs such that we check the block count value of the
free space record for the log AG after the log is accounted for. If
no space is left for the record, reset the record count to 0.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Drop the byte swap.
- Add a comment.
- Fix up the commit log description.

 mkfs/xfs_mkfs.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index c84448e..c57a855 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2592,8 +2592,17 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 			 */
 			be32_add_cpu(&arec->ar_startblock, logblocks);
 		}
+		/*
+		 * Calculate the record block count and check for the case where
+		 * the log might have consumed all available space in the AG. If
+		 * so, reset the record count to 0 to avoid exposure of an invalid
+		 * record start block.
+		 */
 		arec->ar_blockcount = cpu_to_be32(agsize - 
 					be32_to_cpu(arec->ar_startblock));
+		if (!arec->ar_blockcount)
+			block->bb_numrecs = 0;
+
 		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 
 		/*
@@ -2625,8 +2634,17 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 			}
 			be32_add_cpu(&arec->ar_startblock, logblocks);
 		}
+		/*
+		 * Calculate the record block count and check for the case where
+		 * the log might have consumed all available space in the AG. If
+		 * so, reset the record count to 0 to avoid exposure of an invalid
+		 * record start block.
+		 */
 		arec->ar_blockcount = cpu_to_be32(agsize - 
 					be32_to_cpu(arec->ar_startblock));
+		if (!arec->ar_blockcount)
+			block->bb_numrecs = 0;
+
 		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 
 		/*
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
