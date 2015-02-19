Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8FFA77F55
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 12:13:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7F9A0304053
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 10:13:47 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mrAYUUAtXMCdPKht (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 10:13:46 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1JIDj8b014615
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 13:13:45 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t1JIDjwg030520
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 13:13:45 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 03/18] xfs: support min/max agbno args in block allocator
Date: Thu, 19 Feb 2015 13:13:28 -0500
Message-Id: <1424369623-5656-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1424369623-5656-1-git-send-email-bfoster@redhat.com>
References: <1424369623-5656-1-git-send-email-bfoster@redhat.com>
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

The block allocator supports various arguments to tweak block allocation
behavior and set allocation requirements. The sparse inode chunk feature
introduces a new requirement not supported by the current arguments.
Sparse inode allocations must convert or merge into an inode record that
describes a fixed length chunk (64 inodes x inodesize). Full inode chunk
allocations by definition always result in valid inode records. Sparse
chunk allocations are smaller and the associated records can refer to
blocks not owned by the inode chunk. This model can result in invalid
inode records in certain cases.

For example, if a sparse allocation occurs near the start of an AG, the
aligned inode record for that chunk might refer to agbno 0. If an
allocation occurs towards the end of the AG and the AG size is not
aligned, the inode record could refer to blocks beyond the end of the
AG. While neither of these scenarios directly result in corruption, they
both insert invalid inode records and at minimum cause repair to
complain, are unlikely to merge into full chunks over time and set land
mines for other areas of code.

To guarantee sparse inode chunk allocation creates valid inode records,
support the ability to specify an agbno range limit for
XFS_ALLOCTYPE_NEAR_BNO block allocations. The min/max agbno's are
specified in the allocation arguments and limit the block allocation
algorithms to that range. The starting 'agbno' hint is clamped to the
range if the specified agbno is out of range. If no sufficient extent is
available within the range, the allocation fails. For backwards
compatibility, the min/max fields can be initialized to 0 to disable
range limiting (e.g., equivalent to min=0,max=agsize).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 42 +++++++++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_alloc.h |  2 ++
 2 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index a6fbf44..0ddf6c9 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -149,13 +149,27 @@ xfs_alloc_compute_aligned(
 {
 	xfs_agblock_t	bno;
 	xfs_extlen_t	len;
+	xfs_extlen_t	diff;
 
 	/* Trim busy sections out of found extent */
 	xfs_extent_busy_trim(args, foundbno, foundlen, &bno, &len);
 
+	/*
+	 * If we have a largish extent that happens to start before min_agbno,
+	 * see if we can shift it into range...
+	 */
+	if (bno < args->min_agbno && bno + len > args->min_agbno) {
+		diff = args->min_agbno - bno;
+		if (len > diff) {
+			bno += diff;
+			len -= diff;
+		}
+	}
+
 	if (args->alignment > 1 && len >= args->minlen) {
 		xfs_agblock_t	aligned_bno = roundup(bno, args->alignment);
-		xfs_extlen_t	diff = aligned_bno - bno;
+
+		diff = aligned_bno - bno;
 
 		*resbno = aligned_bno;
 		*reslen = diff >= len ? 0 : len - diff;
@@ -790,9 +804,13 @@ xfs_alloc_find_best_extent(
 		 * The good extent is closer than this one.
 		 */
 		if (!dir) {
+			if (*sbnoa > args->max_agbno)
+				goto out_use_good;
 			if (*sbnoa >= args->agbno + gdiff)
 				goto out_use_good;
 		} else {
+			if (*sbnoa < args->min_agbno)
+				goto out_use_good;
 			if (*sbnoa <= args->agbno - gdiff)
 				goto out_use_good;
 		}
@@ -879,6 +897,17 @@ xfs_alloc_ag_vextent_near(
 	dofirst = prandom_u32() & 1;
 #endif
 
+	/* handle unitialized agbno range so caller doesn't have to */
+	if (!args->min_agbno && !args->max_agbno)
+		args->max_agbno = args->mp->m_sb.sb_agblocks - 1;
+	ASSERT(args->min_agbno <= args->max_agbno);
+
+	/* clamp agbno to the range if it's outside */
+	if (args->agbno < args->min_agbno)
+		args->agbno = args->min_agbno;
+	if (args->agbno > args->max_agbno)
+		args->agbno = args->max_agbno;
+
 restart:
 	bno_cur_lt = NULL;
 	bno_cur_gt = NULL;
@@ -971,6 +1000,8 @@ restart:
 						  &ltbnoa, &ltlena);
 			if (ltlena < args->minlen)
 				continue;
+			if (ltbnoa < args->min_agbno || ltbnoa > args->max_agbno)
+				continue;
 			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
 			xfs_alloc_fix_len(args);
 			ASSERT(args->len >= args->minlen);
@@ -1091,11 +1122,11 @@ restart:
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 			xfs_alloc_compute_aligned(args, ltbno, ltlen,
 						  &ltbnoa, &ltlena);
-			if (ltlena >= args->minlen)
+			if (ltlena >= args->minlen && ltbnoa >= args->min_agbno)
 				break;
 			if ((error = xfs_btree_decrement(bno_cur_lt, 0, &i)))
 				goto error0;
-			if (!i) {
+			if (!i || ltbnoa < args->min_agbno) {
 				xfs_btree_del_cursor(bno_cur_lt,
 						     XFS_BTREE_NOERROR);
 				bno_cur_lt = NULL;
@@ -1107,11 +1138,11 @@ restart:
 			XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
 			xfs_alloc_compute_aligned(args, gtbno, gtlen,
 						  &gtbnoa, &gtlena);
-			if (gtlena >= args->minlen)
+			if (gtlena >= args->minlen && gtbnoa <= args->max_agbno)
 				break;
 			if ((error = xfs_btree_increment(bno_cur_gt, 0, &i)))
 				goto error0;
-			if (!i) {
+			if (!i || gtbnoa > args->max_agbno) {
 				xfs_btree_del_cursor(bno_cur_gt,
 						     XFS_BTREE_NOERROR);
 				bno_cur_gt = NULL;
@@ -1211,6 +1242,7 @@ restart:
 	ASSERT(ltnew >= ltbno);
 	ASSERT(ltnew + rlen <= ltbnoa + ltlena);
 	ASSERT(ltnew + rlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
+	ASSERT(ltnew >= args->min_agbno && ltnew <= args->max_agbno);
 	args->agbno = ltnew;
 
 	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur_lt, ltbno, ltlen,
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index d1b4b6a..29f27b2 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -112,6 +112,8 @@ typedef struct xfs_alloc_arg {
 	xfs_extlen_t	total;		/* total blocks needed in xaction */
 	xfs_extlen_t	alignment;	/* align answer to multiple of this */
 	xfs_extlen_t	minalignslop;	/* slop for minlen+alignment calcs */
+	xfs_agblock_t	min_agbno;	/* set an agbno range for NEAR allocs */
+	xfs_agblock_t	max_agbno;	/* ... */
 	xfs_extlen_t	len;		/* output: actual size of extent */
 	xfs_alloctype_t	type;		/* allocation type XFS_ALLOCTYPE_... */
 	xfs_alloctype_t	otype;		/* original allocation type */
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
