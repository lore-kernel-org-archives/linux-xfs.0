Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7BEC87F4E
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 12:37:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0C1EBAC001
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 10:37:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id iuYADwJBSNbHACSa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Aug 2014 10:37:34 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s7PHbWnR006151
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 13:37:32 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s7PHbWjH013986
	for <xfs@oss.sgi.com>; Mon, 25 Aug 2014 13:37:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: trim eofblocks before collapse range
Date: Mon, 25 Aug 2014 13:37:30 -0400
Message-Id: <1408988250-17772-1-git-send-email-bfoster@redhat.com>
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
---

Hi all,

This addresses the other fsx failure I've observed related to collapse
range. It should also be addressed by reworking the algorithm as
discussed in Dave's full file writeback patch. This patch applies on top
of that and I think this is more suitable for a near-term -rc drop.

Brian

 fs/xfs/xfs_bmap_util.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 76b6a29..1707980 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1471,8 +1471,10 @@ xfs_collapse_file_space(
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
@@ -1482,6 +1484,11 @@ xfs_collapse_file_space(
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
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
