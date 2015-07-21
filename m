Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 57DB67F82
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 20:17:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B9CA0AC007
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 18:17:22 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	2KXvkyvHkzNiHKLT for <xfs@oss.sgi.com>;
	Mon, 20 Jul 2015 18:17:19 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] xfs: remote attributes need to be considered data
Date: Tue, 21 Jul 2015 11:09:04 +1000
Message-Id: <1437440945-23457-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1437440945-23457-1-git-send-email-david@fromorbit.com>
References: <1437440945-23457-1-git-send-email-david@fromorbit.com>
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
Cc: willy@linux.intel.com

From: Dave Chinner <dchinner@redhat.com>

We don't log remote attribute contents, and instead write them
synchronously before we commit the block allocation and attribute
tree update transaction. As a result we are writing to the allocated
space before the allcoation has been made permanent.

As a result, we cannot consider this allocation to be a metadata
allocation. Metadata allocation can take blocks from the free list
and so reuse them before the transaction that freed the block is
committed to disk. This behaviour is perfectly fine for journalled
metadata changes as log recovery will ensure the free operation is
replayed before the overwrite, but for remote attribute writes this
is not the case.

Hence we have to consider the remote attribute blocks to contain
data and allocate accordingly. We do this by dropping the
XFS_BMAPI_METADATA flag from the block allocation. This means the
allocation will not use blocks that are on the busy list without
first ensuring that the freeing transaction has been committed to
disk and the blocks removed from the busy list. This ensures we will
never overwrite a freed block without first ensuring that it is
really free.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 2faec26..dd71403 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -451,14 +451,21 @@ xfs_attr_rmtval_set(
 
 		/*
 		 * Allocate a single extent, up to the size of the value.
+		 *
+		 * Note that we have to consider this a data allocation as we
+		 * write the remote attribute without logging the contents.
+		 * Hence we must ensure that we aren't using blocks that are on
+		 * the busy list so that we don't overwrite blocks which have
+		 * recently been freed but their transactions are not yet
+		 * committed to disk. If we overwrite the contents of a busy
+		 * extent and then crash then the block may not contain the
+		 * correct metadata after log recovery occurs.
 		 */
 		xfs_bmap_init(args->flist, args->firstblock);
 		nmap = 1;
 		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
-				  blkcnt,
-				  XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
-				  args->firstblock, args->total, &map, &nmap,
-				  args->flist);
+				  blkcnt, XFS_BMAPI_ATTRFORK, args->firstblock,
+				  args->total, &map, &nmap, args->flist);
 		if (!error) {
 			error = xfs_bmap_finish(&args->trans, args->flist,
 						&committed);
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
