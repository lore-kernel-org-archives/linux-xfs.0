Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 23C727FB1
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:36:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 202F6304043
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:36:59 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	EYFGMAdPpp8lLRya for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:36:57 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpB4i-0003C4-Rz
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:56 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpB4O-0000El-OH
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:36:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 17/50] libxfs: update xfs_alloc to current kernel version
Date: Wed, 19 Jun 2013 15:35:40 +1000
Message-Id: <1371620173-712-18-git-send-email-david@fromorbit.com>
In-Reply-To: <1371620173-712-1-git-send-email-david@fromorbit.com>
References: <1371620173-712-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_alloc.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 1d7ea8f..757b43d 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -153,6 +153,7 @@ xfs_alloc_compute_diff(
 	xfs_agblock_t	wantbno,	/* target starting block */
 	xfs_extlen_t	wantlen,	/* target length */
 	xfs_extlen_t	alignment,	/* target alignment */
+	char		userdata,	/* are we allocating data? */
 	xfs_agblock_t	freebno,	/* freespace's starting block */
 	xfs_extlen_t	freelen,	/* freespace's length */
 	xfs_agblock_t	*newbnop)	/* result: best start block from free */
@@ -167,7 +168,14 @@ xfs_alloc_compute_diff(
 	ASSERT(freelen >= wantlen);
 	freeend = freebno + freelen;
 	wantend = wantbno + wantlen;
-	if (freebno >= wantbno) {
+	/*
+	 * We want to allocate from the start of a free extent if it is past
+	 * the desired block or if we are allocating user data and the free
+	 * extent is before desired block. The second case is there to allow
+	 * for contiguous allocation from the remaining free space if the file
+	 * grows in the short term.
+	 */
+	if (freebno >= wantbno || (userdata && freeend < wantend)) {
 		if ((newbno1 = roundup(freebno, alignment)) >= freeend)
 			newbno1 = NULLAGBLOCK;
 	} else if (freeend >= wantend && alignment > 1) {
@@ -783,7 +791,8 @@ xfs_alloc_find_best_extent(
 			xfs_alloc_fix_len(args);
 
 			sdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-						       args->alignment, *sbnoa,
+						       args->alignment,
+						       args->userdata, *sbnoa,
 						       *slena, &new);
 
 			/*
@@ -954,7 +963,8 @@ restart:
 			if (args->len < blen)
 				continue;
 			ltdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-				args->alignment, ltbnoa, ltlena, &ltnew);
+				args->alignment, args->userdata, ltbnoa,
+				ltlena, &ltnew);
 			if (ltnew != NULLAGBLOCK &&
 			    (args->len > blen || ltdiff < bdiff)) {
 				bdiff = ltdiff;
@@ -1106,7 +1116,8 @@ restart:
 			args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
 			xfs_alloc_fix_len(args);
 			ltdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-				args->alignment, ltbnoa, ltlena, &ltnew);
+				args->alignment, args->userdata, ltbnoa,
+				ltlena, &ltnew);
 
 			error = xfs_alloc_find_best_extent(args,
 						&bno_cur_lt, &bno_cur_gt,
@@ -1122,7 +1133,8 @@ restart:
 			args->len = XFS_EXTLEN_MIN(gtlena, args->maxlen);
 			xfs_alloc_fix_len(args);
 			gtdiff = xfs_alloc_compute_diff(args->agbno, args->len,
-				args->alignment, gtbnoa, gtlena, &gtnew);
+				args->alignment, args->userdata, gtbnoa,
+				gtlena, &gtnew);
 
 			error = xfs_alloc_find_best_extent(args,
 						&bno_cur_gt, &bno_cur_lt,
@@ -1181,7 +1193,7 @@ restart:
 	}
 	rlen = args->len;
 	(void)xfs_alloc_compute_diff(args->agbno, rlen, args->alignment,
-				     ltbnoa, ltlena, &ltnew);
+				     args->userdata, ltbnoa, ltlena, &ltnew);
 	ASSERT(ltnew >= ltbno);
 	ASSERT(ltnew + rlen <= ltbnoa + ltlena);
 	ASSERT(ltnew + rlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
@@ -2173,13 +2185,8 @@ xfs_agf_verify(
 	struct xfs_agf	*agf = XFS_BUF_TO_AGF(bp);
 
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
-	    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_uuid)) {
-		char uu[64], uu2[64];
-		platform_uuid_unparse(&agf->agf_uuid, uu);
-		platform_uuid_unparse(&mp->m_sb.sb_uuid, uu2);
-
+	    !uuid_equal(&agf->agf_uuid, &mp->m_sb.sb_uuid))
 			return false;
-	}
 
 	if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
 	      XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
