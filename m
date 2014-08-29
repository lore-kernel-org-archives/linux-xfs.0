Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D9F67FC3
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 15:29:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1C6D1AC001
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 13:29:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SnoHBmKzPzxiBjpR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Aug 2014 13:29:40 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s7TKTeAO027648
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 16:29:40 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s7TKTdUj029026
	for <xfs@oss.sgi.com>; Fri, 29 Aug 2014 16:29:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/4] xfs: allow collapse to handle delalloc extents
Date: Fri, 29 Aug 2014 16:29:37 -0400
Message-Id: <1409344178-44817-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1409344178-44817-1-git-send-email-bfoster@redhat.com>
References: <1409344178-44817-1-git-send-email-bfoster@redhat.com>
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

The xfs_bmap_shift_extents() mechanism currently requires any post-EOF
delalloc blocks to be explicitly trimmed before it can proceed to avoid
hitting delalloc extents during the extent shift sequence. This is
because the implementation doesn't account for delalloc extents and
expects consistency between the in-core extent list and what is on disk
for bmapbt mappings. E.g., it will attempt to look up delalloc extents
on disk and fail.

Since delayed allocation extents have not been written to disk, no
on-disk changes are required to shift such extents. Update
xfs_bmap_shift_extents() to check for delalloc extents. If found, simply
update the start offset of the record and move on. This should only
occur for delalloc blocks that do not have data (e.g., post-eof
preallocation). Such blocks are currently trimmed off by the truncate
that occurs after the extent shift, so we make no attempt to merge
delalloc extents.

This eliminates the need for an eofblocks trim prior to collapse.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 449a016..32598cb 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5417,6 +5417,11 @@ xfs_bmap_shift_extents_can_merge(
 
 	startoff = got->br_startoff - shift;
 
+	/* do not merge if either extent is delalloc */
+	if (isnullstartblock(left->br_startblock) ||
+	    isnullstartblock(got->br_startblock))
+		return false;
+
 	/*
 	 * The extent, once shifted, must be adjacent in-file and on-disk with
 	 * the preceding extent.
@@ -5554,6 +5559,7 @@ xfs_bmap_shift_extents(
 	int				whichfork = XFS_DATA_FORK;
 	int				logflags = 0;
 	int				total_extents;
+	bool				delalloc;
 
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
@@ -5618,6 +5624,7 @@ xfs_bmap_shift_extents(
 	total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
 	while (nexts++ < num_exts && current_ext < total_extents) {
 		startoff = got.br_startoff - offset_shift_fsb;
+		delalloc = isnullstartblock(got.br_startblock);
 
 		/* grab the left extent and check for a potential merge */
 		if (current_ext > 0) {
@@ -5649,9 +5656,14 @@ xfs_bmap_shift_extents(
 
 		/*
 		 * We didn't merge the extent so do the shift. Update the start
-		 * offset in the in-core extent and btree, if necessary.
+		 * offset in the in-core extent. If the extent is delalloc,
+		 * there's nothing else to do. Otherwise, update the extent
+		 * on-disk.
 		 */
 		xfs_bmbt_set_startoff(gotp, startoff);
+		if (delalloc)
+			goto next;
+
 		logflags |= XFS_ILOG_CORE;
 		if (cur) {
 			error = xfs_bmbt_lookup_eq(cur, got.br_startoff,
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
