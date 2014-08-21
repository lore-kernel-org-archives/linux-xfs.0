Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4729A7F4E
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 00:09:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 27556304066
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 22:09:37 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	vHD65xntNc1jUSBH for <xfs@oss.sgi.com>;
	Wed, 20 Aug 2014 22:09:36 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] xfs: xfs_file_collapse_range is delalloc challenged
Date: Thu, 21 Aug 2014 15:09:14 +1000
Message-Id: <1408597754-13526-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1408597754-13526-1-git-send-email-david@fromorbit.com>
References: <1408597754-13526-1-git-send-email-david@fromorbit.com>
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
Cc: clm@fb.com

From: Dave Chinner <dchinner@redhat.com>

If we have delalloc extents on a file before we run a collapse range
opertaion, we sync the range that we are going to collapse to
convert delalloc extents in that region to real extents to simplify
the shift operation.

However, the shift operation then assumes that the extent list is
not going to change as it iterates over the extent list moving
things about. Unfortunately, this isn't true because we can't hold
the ILOCK over all the operations. We can prevent new IO from
modifying the extent list by holding the IOLOCK, but that doesn't
prevent writeback from running....

And when writeback runs, it can convert delalloc extents is the
range of the file prior to the region being collapsed, and this
changes the indexes of all the extents in the file. That causes the
collapse range operation to Go Bad.

The right fix is to rewrite the extent shift operation not to be
dependent on the extent list not changing across the entire
operation, but this is a fairly significant piece of work to do.
Hence, as a short-term workaround for the problem, sync the entire
file before starting a collapse operation to remove all delalloc
ranges from the file and so avoid the problem of concurrent
writeback changing the extent list.

Diagnosed-and-Reported-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index c53cc03..035041d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1460,6 +1460,19 @@ xfs_collapse_file_space(
 	start_fsb = XFS_B_TO_FSB(mp, offset + len);
 	shift_fsb = XFS_B_TO_FSB(mp, len);
 
+	/*
+	 * writeback the entire file to prevent concurrent writeback of ranges
+	 * outside the collapsing region from changing the extent list.
+	 *
+	 * XXX: This is a temporary fix until the extent shift loop below is
+	 * converted to use offsets and lookups within the ILOCK rather than
+	 * carrying around the index into the extent list for the next
+	 * iteration.
+	 */
+	error = filemap_write_and_wait(VFS_I(ip)->i_mapping);
+	if (error)
+		return error;
+
 	error = xfs_free_file_space(ip, offset, len);
 	if (error)
 		return error;
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
