Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 810347F47
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 08:20:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 615BC304051
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 06:20:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MLTUfng196Ptn2Es (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Sep 2014 06:20:33 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s8ADKW1n030574
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 09:20:32 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s8ADKWPr014730
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 09:20:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 4/5] xfs: writeback and inval. file range to be shifted by
	collapse
Date: Wed, 10 Sep 2014 09:20:30 -0400
Message-Id: <1410355231-50495-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1410355231-50495-1-git-send-email-bfoster@redhat.com>
References: <1410355231-50495-1-git-send-email-bfoster@redhat.com>
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

The collapse range operation currently writes the entire file before
starting the collapse to avoid changes in the in-core extent list due to
writeback causing the extent count to change. Now that collapse range is
fsb based rather than extent index based it can sustain changes in the
extent list during the shift sequence without disruption.

Modify xfs_collapse_file_space() to writeback and invalidate pages
associated with the range of the file to be shifted.
xfs_free_file_space() currently has similar behavior, but the space free
need only affect the region of the file that is freed and this could
change in the future.

Also update the comments to reflect the current implementation. We
retain the eofblocks trim permanently as a best option for dealing with
delalloc extents. We don't shift delalloc extents because this scenario
only occurs with post-eof preallocation (since data must be flushed such
that the cache can be invalidated and data can be shifted). That means
said space must also be initialized before being shifted into the
accessible region of the file only to be immediately truncated off as
the last part of the collapse. In other words, the eofblocks trim will
happen anyways, we just run it first to ensure the file remains in a
consistent state throughout the collapse.

Finally, detect and fail explicitly in the event of a delalloc extent
during the extent shift. The implementation does not support delalloc
extents and the caller is expected to prevent this scenario in advance
as is done by collapse.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c |  4 ++++
 fs/xfs/xfs_bmap_util.c   | 32 +++++++++++++++++++-------------
 2 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 69bf8d8..79c9819 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5543,6 +5543,10 @@ xfs_bmse_shift_one(
 	xfs_bmbt_get_all(gotp, &got);
 	startoff = got.br_startoff - offset_shift_fsb;
 
+	/* delalloc extents should be prevented by caller */
+	XFS_WANT_CORRUPTED_GOTO(!isnullstartblock(got.br_startblock),
+				out_error);
+
 	/*
 	 * If this is the first extent in the file, make sure there's enough
 	 * room at the start of the file and jump right to the shift as there's
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 1e96d77..eae763f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1470,27 +1470,33 @@ xfs_collapse_file_space(
 	next_fsb = XFS_B_TO_FSB(mp, offset + len);
 	shift_fsb = XFS_B_TO_FSB(mp, len);
 
-	/*
-	 * Writeback the entire file and force remove any post-eof blocks. The
-	 * writeback prevents changes to the extent list via concurrent
-	 * writeback and the eofblocks trim prevents the extent shift algorithm
-	 * from running into a post-eof delalloc extent.
-	 *
-	 * XXX: This is a temporary fix until the extent shift loop below is
-	 * converted to use offsets and lookups within the ILOCK rather than
-	 * carrying around the index into the extent list for the next
-	 * iteration.
-	 */
-	error = filemap_write_and_wait(VFS_I(ip)->i_mapping);
+	error = xfs_free_file_space(ip, offset, len);
 	if (error)
 		return error;
+
+	/*
+	 * Trim eofblocks to avoid shifting uninitialized post-eof preallocation
+	 * into the accessible region of the file.
+	 */
 	if (xfs_can_free_eofblocks(ip, true)) {
 		error = xfs_free_eofblocks(mp, ip, false);
 		if (error)
 			return error;
 	}
 
-	error = xfs_free_file_space(ip, offset, len);
+	/*
+	 * Writeback and invalidate cache for the remainder of the file as we're
+	 * about to shift down every extent from the collapse range to EOF. The
+	 * free of the collapse range above might have already done some of
+	 * this, but we shouldn't rely on it to do anything outside of the range
+	 * that was freed.
+	 */
+	error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
+					     offset + len, -1);
+	if (error)
+		return error;
+	error = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
+					(offset + len) >> PAGE_CACHE_SHIFT, -1);
 	if (error)
 		return error;
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
