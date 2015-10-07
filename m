Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AAC9F7F37
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 10:59:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2B349AC009
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 08:59:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id J3mf0QVQfTWofUFB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 07 Oct 2015 08:59:00 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: pass total block res. as total xfs_bmapi_write()
	parameter
Date: Wed,  7 Oct 2015 11:58:58 -0400
Message-Id: <1444233538-52658-1-git-send-email-bfoster@redhat.com>
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
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>

The total field from struct xfs_alloc_arg is a bit of an unknown
commodity. It is documented as the total block requirement for the
transaction and is used in this manner from most call sites by virtue of
passing the total block reservation of the transaction associated with
an allocation. Several xfs_bmapi_write() callers pass hardcoded values
of 0 or 1 for the total block requirement, which is a historical oddity
without any clear reasoning.

The xfs_iomap_write_direct() caller, for example, passes 0 for the total
block requirement. This has been determined to cause problems in the
form of ABBA deadlocks of AGF buffers due to incorrect AG selection in
the block allocator. Specifically, the xfs_alloc_space_available()
function incorrectly selects an AG that doesn't actually have sufficient
space for the allocation. This occurs because the args.total field is 0
and thus the remaining free space check on the AG doesn't actually
consider the size of the allocation request. This locks the AGF buffer,
the allocation attempt proceeds and ultimately fails (in
xfs_alloc_fix_minleft()), and xfs_alloc_vexent() moves on to the next
AG. In turn, this can lead to incorrect AG locking order (if the
allocator wraps around, attempting to lock AG 0 after acquiring AG N)
and thus deadlock if racing with another operation. This problem has
been reproduced via generic/299 on smallish (1GB) ramdisk test devices.

To avoid this problem, replace the undocumented hardcoded total
parameters from the iomap and utility callers to pass the block
reservation used for the associated transaction. This is consistent with
other xfs_bmapi_write() callers throughout XFS. The assumption is that
the total field allows the selection of an AG that can handle the entire
operation rather than simply the allocation/range being requested (e.g.,
resulting btree splits, etc.). This addresses the aforementioned
generic/299 hang by ensuring AG selection only occurs when the
allocation can be satisfied by the AG.

Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_util.c |  2 +-
 fs/xfs/xfs_iomap.c     | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 3bf4ad0..eca325e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1027,7 +1027,7 @@ xfs_alloc_file_space(
 		xfs_bmap_init(&free_list, &firstfsb);
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
 					allocatesize_fsb, alloc_type, &firstfsb,
-					0, imapp, &nimaps, &free_list);
+					resblks, imapp, &nimaps, &free_list);
 		if (error) {
 			goto error0;
 		}
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 1f86033..3d9fa36 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -202,8 +202,8 @@ xfs_iomap_write_direct(
 	xfs_bmap_init(&free_list, &firstfsb);
 	nimaps = 1;
 	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
-				XFS_BMAPI_PREALLOC, &firstfsb, 0,
-				imap, &nimaps, &free_list);
+				XFS_BMAPI_PREALLOC, &firstfsb, resblks, imap,
+				&nimaps, &free_list);
 	if (error)
 		goto out_bmap_cancel;
 
@@ -750,9 +750,9 @@ xfs_iomap_write_allocate(
 			 * pointer that the caller gave to us.
 			 */
 			error = xfs_bmapi_write(tp, ip, map_start_fsb,
-						count_fsb, 0,
-						&first_block, 1,
-						imap, &nimaps, &free_list);
+						count_fsb, 0, &first_block,
+						nres, imap, &nimaps,
+						&free_list);
 			if (error)
 				goto trans_cancel;
 
@@ -866,8 +866,8 @@ xfs_iomap_write_unwritten(
 		xfs_bmap_init(&free_list, &firstfsb);
 		nimaps = 1;
 		error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
-				  XFS_BMAPI_CONVERT, &firstfsb,
-				  1, &imap, &nimaps, &free_list);
+					XFS_BMAPI_CONVERT, &firstfsb, resblks,
+					&imap, &nimaps, &free_list);
 		if (error)
 			goto error_on_bmapi_transaction;
 
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
