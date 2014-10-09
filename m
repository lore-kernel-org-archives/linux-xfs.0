Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A3DDF7F3F
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 14:00:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 74DEB304075
	for <xfs@oss.sgi.com>; Thu,  9 Oct 2014 12:00:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id l3PDVkF8Fl1HGSbz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Oct 2014 12:00:44 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s99J0hrV024649
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 9 Oct 2014 15:00:43 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s99J0hJu008029
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2014 15:00:43 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: create zero range helper to convert existing extents to
	unwritten
Date: Thu,  9 Oct 2014 15:00:41 -0400
Message-Id: <1412881241-34838-1-git-send-email-bfoster@redhat.com>
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

The zero range mechanism makes multiple xfs_alloc_file_space() calls to
try convert as much of a range as possible to unwritten in the event of
allocation failure. The problem is that the subsequent conversion call
will progress no further than the first preallocate call if the latter
happened to fail, because we have no ability to do extent conversion
without preallocation.

Create a helper to iterate a range of a bmap and convert all existing,
normal extents to unwritten. Call the helper from xfs_zero_file_space()
to accomplish the goal specified above. This allows zero range to put
off preallocation to the final step and thus ensures the range is zero
valued before any significant preallocation is attemped.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Here's a stab at the kind of helper I was referring to in the review
discussion of the zero range rework. This applies on top of v3:

http://oss.sgi.com/archives/xfs/2014-10/msg00149.html

Lightly tested, but I'm throwing some workloads at it now and so far, so
good. Thoughts appreciated.

Brian

 fs/xfs/xfs_bmap_util.c | 145 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 129 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index a69df91..937528c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -793,6 +793,119 @@ next_block:
 }
 
 /*
+ * Convert all normal extents in a range to unwritten. This function does not
+ * preallocate. Instead, seek out existing extents and convert to unwritten.
+ * This is a helper to zero-value a range of a file. All extents other than
+ * normal, non-delalloc extents are skipped and must be handled separately.
+ */
+static int
+xfs_bmap_convert_unwritten_range(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		start_fsb,
+	xfs_fileoff_t		length)
+{
+	xfs_fileoff_t		cur_fsb;
+	xfs_fileoff_t		end_fsb;
+	int			error = 0;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			committed;
+
+	cur_fsb = start_fsb;
+	end_fsb = start_fsb + length;	/* exclusive end */
+
+	while (cur_fsb < end_fsb) {
+		xfs_bmbt_irec_t	imap;
+		int		nimaps = 1;
+		xfs_fsblock_t	firstblock;
+		xfs_bmap_free_t flist;
+		xfs_fileoff_t	count;
+
+		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
+		/*
+		 * We only convert existing extents. Reserve only what blocks
+		 * might be necessary for an extent split.
+		 */
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
+					  XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
+		if (error) {
+			xfs_trans_cancel(tp, 0);
+			break;
+		}
+
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+		/* loop until we find a normal extent */
+		do {
+			error = xfs_bmapi_read(ip, cur_fsb, end_fsb - cur_fsb,
+					&imap, &nimaps, XFS_BMAPI_ENTIRE);
+			if (error) {
+				/* something screwed, just bail */
+				if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+					xfs_alert(ip->i_mount,
+				"Failed mapping lookup ino %lld fsb %lld.",
+							ip->i_ino, cur_fsb);
+				}
+				break;
+			}
+
+			if (!nimaps) {
+				cur_fsb++;
+				continue;
+			}
+
+			/* look for normal extents */
+			if (imap.br_state == XFS_EXT_NORM &&
+			    imap.br_startblock != DELAYSTARTBLOCK &&
+			    imap.br_startblock != HOLESTARTBLOCK)
+				break;
+
+			cur_fsb = imap.br_startoff + imap.br_blockcount;
+		} while (cur_fsb < end_fsb);
+
+		/* check whether we failed or found nothing to convert */
+		if (error || cur_fsb >= end_fsb) {
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			goto out_cancel;
+		}
+
+		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+		/*
+		 * convert to the end of the extent or the end of the range,
+		 * whichever is shorter
+		 */
+		count = imap.br_blockcount - (cur_fsb - imap.br_startoff);
+		count = min_t(xfs_fileoff_t, count, end_fsb - cur_fsb);
+
+		xfs_bmap_init(&flist, &firstblock);
+
+		error = xfs_bmapi_write(tp, ip, cur_fsb, count,
+					XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT,
+					&firstblock, 0, &imap, &nimaps, &flist);
+		if (error)
+			goto out_cancel;
+
+		error = xfs_bmap_finish(&tp, &flist, &committed);
+		if (error)
+			goto out_cancel;
+
+		error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
+		if (error)
+			break;
+
+		/* set cur fsb to start of next extent */
+		cur_fsb = imap.br_startoff + imap.br_blockcount;
+	}
+
+	return error;
+
+out_cancel:
+	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
+	return error;
+}
+
+/*
  * Test whether it is appropriate to check an inode for and free post EOF
  * blocks. The 'force' parameter determines whether we should also consider
  * regular files that are marked preallocated or append-only.
@@ -1433,28 +1546,28 @@ xfs_zero_file_space(
 	}
 
 	/*
-	 * First, preallocate the unaligned range to ensure the entire range is
-	 * allocated. This does not convert extents because we cannot convert
-	 * partial blocks. Second, convert the block-aligned range to unwritten
-	 * extents. We do this as such because passing the entire range for
-	 * allocation facilitates ideal contiguity from the allocator.
+	 * At this point partial blocks are consistent on-disk and in pagecache
+	 * and delalloc mappings are consistent between pagecache (buffer heads)
+	 * and the in-core extent tree. We can proceed with allocation without
+	 * worry of failure leaving inconsistencies.
 	 *
-	 * Note that we attempt unwritten conversion even if we fail to
-	 * preallocate space. This is an effort to convert as many extents as
-	 * possible before we inevitably return ENOSPC.
-	 *
-	 * XXX: A helper that converts existing extents but does not preallocate
-	 * would help clean all this up. We could convert extents first,
-	 * preallocate second, and thus guarantee a zero-value range on ENOSPC.
+	 * First, convert existing extents in the block aligned range to
+	 * unwritten. Next, preallocate the unaligned range to fill in the gaps
+	 * and cover partial start and end blocks. This sequence means that the
+	 * range has likely been zero-valued even if we run out of space.
 	 */
+	if (end_boundary > start_boundary) {
+		error = xfs_bmap_convert_unwritten_range(ip,
+				XFS_B_TO_FSBT(mp, start_boundary),
+				XFS_B_TO_FSB(mp,
+					     end_boundary - start_boundary));
+		if (error)
+			goto out;
+	}
 	error = xfs_alloc_file_space(ip, round_down(offset, blksize),
 				     round_up(offset + len, blksize) -
 				     round_down(offset, blksize),
 				     XFS_BMAPI_PREALLOC);
-	if (end_boundary > start_boundary)
-		error = xfs_alloc_file_space(ip, start_boundary,
-					end_boundary - start_boundary,
-					XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT);
 
 out:
 	return error;
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
