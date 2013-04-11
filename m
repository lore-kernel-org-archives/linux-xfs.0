Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7E7697FB4
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 06:45:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4E5E930405F
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 04:45:00 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id RAYI6AZGVL4JTV6U for <xfs@oss.sgi.com>;
	Thu, 11 Apr 2013 04:44:58 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] xfs: Avoid pathological backwards allocation
Date: Thu, 11 Apr 2013 13:44:51 +0200
Message-Id: <1365680691-5330-1-git-send-email-jack@suse.cz>
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
Cc: Jan Kara <jack@suse.cz>, tinguely@sgi.com, Dave Chinner <dchinner@redhat.com>

Writing a large file using direct IO in 16 MB chunks sometimes results
in a pathological allocation pattern where 16 MB chunks of large free
extent are allocated to a file in a reversed order. So extents of a file
look for example as:

 ext logical physical expected length flags
   0        0        13          4550656
   1  4550656 188136807   4550668 12562432
   2 17113088 200699240 200699238 622592
   3 17735680 182046055 201321831   4096
   4 17739776 182041959 182050150   4096
   5 17743872 182037863 182046054   4096
   6 17747968 182033767 182041958   4096
   7 17752064 182029671 182037862   4096
...
6757 45400064 154381644 154389835   4096
6758 45404160 154377548 154385739   4096
6759 45408256 252951571 154381643  73728 eof

This happens because XFS_ALLOCTYPE_THIS_BNO allocation fails (the last
extent in the file cannot be further extended) so we fall back to
XFS_ALLOCTYPE_NEAR_BNO allocation which picks end of a large free
extent as the best place to continue the file. Since the chunk at the
end of the free extent again cannot be further extended, this behavior
repeats until the whole free extent is consumed in a reversed order.

For data allocations this backward allocation isn't beneficial so make
xfs_alloc_compute_diff() pick start of a free extent instead of its end
for them. That avoids the backward allocation pattern.

Based on idea by Dave Chinner <dchinner@redhat.com>.

CC: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_alloc.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

  BTW, I've tested With this patch applied I really cannot reproduce the
problematic allocation pattern anymore.

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 0ad2325..64c6247 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -173,6 +173,7 @@ xfs_alloc_compute_diff(
 	xfs_agblock_t	wantbno,	/* target starting block */
 	xfs_extlen_t	wantlen,	/* target length */
 	xfs_extlen_t	alignment,	/* target alignment */
+	char		userdata,	/* are we allocating data? */
 	xfs_agblock_t	freebno,	/* freespace's starting block */
 	xfs_extlen_t	freelen,	/* freespace's length */
 	xfs_agblock_t	*newbnop)	/* result: best start block from free */
@@ -187,7 +188,12 @@ xfs_alloc_compute_diff(
 	ASSERT(freelen >= wantlen);
 	freeend = freebno + freelen;
 	wantend = wantbno + wantlen;
-	if (freebno >= wantbno) {
+	/*
+	 * We want to allocate from the start of a free extent if it is past
+	 * the desired block or if we are allocating user data and the free
+	 * extent is before desired block.
+	 */
+	if (freebno >= wantbno || (userdata && freeend < wantend)) {
 		if ((newbno1 = roundup(freebno, alignment)) >= freeend)
 			newbno1 = NULLAGBLOCK;
 	} else if (freeend >= wantend && alignment > 1) {
@@ -772,7 +778,8 @@ xfs_alloc_find_best_extent(
 			xfs_alloc_fix_len(args);
 
 			sdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-						       args->alignment, *sbnoa,
+						       args->alignment,
+						       args->userdata, *sbnoa,
 						       *slena, &new);
 
 			/*
@@ -943,7 +950,8 @@ restart:
 			if (args->len < blen)
 				continue;
 			ltdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-				args->alignment, ltbnoa, ltlena, &ltnew);
+				args->alignment, args->userdata, ltbnoa,
+				ltlena, &ltnew);
 			if (ltnew != NULLAGBLOCK &&
 			    (args->len > blen || ltdiff < bdiff)) {
 				bdiff = ltdiff;
@@ -1095,7 +1103,8 @@ restart:
 			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
 			xfs_alloc_fix_len(args);
 			ltdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-				args->alignment, ltbnoa, ltlena, &ltnew);
+				args->alignment, args->userdata, ltbnoa,
+				ltlena, &ltnew);
 
 			error = xfs_alloc_find_best_extent(args,
 						&bno_cur_lt, &bno_cur_gt,
@@ -1111,7 +1120,8 @@ restart:
 			args->len = XFS_EXTLEN_MIN(gtlena, args->maxlen);
 			xfs_alloc_fix_len(args);
 			gtdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-				args->alignment, gtbnoa, gtlena, &gtnew);
+				args->alignment, args->userdata, gtbnoa,
+				gtlena, &gtnew);
 
 			error = xfs_alloc_find_best_extent(args,
 						&bno_cur_gt, &bno_cur_lt,
@@ -1170,7 +1180,7 @@ restart:
 	}
 	rlen = args->len;
 	(void)xfs_alloc_compute_diff(args->agbno, rlen, args->alignment,
-				     ltbnoa, ltlena, &ltnew);
+				     args->userdata, ltbnoa, ltlena, &ltnew);
 	ASSERT(ltnew >= ltbno);
 	ASSERT(ltnew + rlen <= ltbnoa + ltlena);
 	ASSERT(ltnew + rlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
