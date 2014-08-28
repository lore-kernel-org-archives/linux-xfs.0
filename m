Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 666C37F51
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 06:49:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 44CA58F8050
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 04:49:22 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	MKwUGLsGcnZjNLRt for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 04:49:20 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XMyCX-0000FR-Iv
	for xfs@oss.sgi.com; Thu, 28 Aug 2014 21:49:13 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XMyCX-0004L5-He
	for xfs@oss.sgi.com; Thu, 28 Aug 2014 21:49:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/7] xfs: trim eofblocks before collapse range
Date: Thu, 28 Aug 2014 21:49:11 +1000
Message-Id: <1409226551-16570-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1409226551-16570-1-git-send-email-david@fromorbit.com>
References: <1409226551-16570-1-git-send-email-david@fromorbit.com>
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

From: Brian Foster <bfoster@redhat.com>

xfs_collapse_file_space() currently writes back the entire file
undergoing collapse range to settle things down for the extent shift
algorithm. While this prevents changes to the extent list during the
collapse operation, the writeback itself is not enough to prevent
unnecessary collapse failures.

The current shift algorithm uses the extent index to iterate the in-core
extent list. If a post-eof delalloc extent persists after the writeback
(e.g., a prior zero range op where the end of the range aligns with eof
can separate the post-eof blocks such that they are not written back and
converted), xfs_bmap_shift_extents() becomes confused over the encoded
br_startblock value and fails the collapse.

As with the full writeback, this is a temporary fix until the algorithm
is improved to cope with a volatile extent list and avoid attempts to
shift post-eof extents.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 283e20c..c692260 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1445,8 +1445,10 @@ xfs_collapse_file_space(
 	shift_fsb = XFS_B_TO_FSB(mp, len);
 
 	/*
-	 * writeback the entire file to prevent concurrent writeback of ranges
-	 * outside the collapsing region from changing the extent list.
+	 * Writeback the entire file and force remove any post-eof blocks. The
+	 * writeback prevents changes to the extent list via concurrent
+	 * writeback and the eofblocks trim prevents the extent shift algorithm
+	 * from running into a post-eof delalloc extent.
 	 *
 	 * XXX: This is a temporary fix until the extent shift loop below is
 	 * converted to use offsets and lookups within the ILOCK rather than
@@ -1456,6 +1458,11 @@ xfs_collapse_file_space(
 	error = filemap_write_and_wait(VFS_I(ip)->i_mapping);
 	if (error)
 		return error;
+	if (xfs_can_free_eofblocks(ip, true)) {
+		error = xfs_free_eofblocks(mp, ip, false);
+		if (error)
+			return error;
+	}
 
 	error = xfs_free_file_space(ip, offset, len);
 	if (error)
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
