Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9270EC433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348779AbiFKB1d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348828AbiFKB1U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:20 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CE07B3A483B
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 270255EC7F8
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:05 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-005APu-72
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-00ELNc-5s
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 38/50] xfs: get rid of notinit from xfs_bmap_longest_free_extent
Date:   Sat, 11 Jun 2022 11:26:47 +1000
Message-Id: <20220611012659.3418072-39-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62a3ef69
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=3aDLIeUOPozzPTmn6VcA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It is only set if reading the AGF gets a EAGAIN error. Just return
the EAGAIN error and handle that error in the callers.

This means we can remove the not_init parameter from
xfs_bmap_select_minlen(), too, because the use of not_init there is
pessimistic. If we can't read the agf, it won't increase blen.
Howeverm the only time we actually care whether we checked all the
AGFs for contiguous free space is when the best length is less than
the minimum allocation length. If not_init is set, then we ignore
blen and set the minimum alloc length to the absolute minimum, not
the best length we know already is present.

However, if blen is less than the minimum, we're going to ignore it
anyway, regardless of whether we scanned all the AGFs or not, so it
does not matter if those unchecked AGFs have space in them or not.
Hence not_init can go away, because we already know if blen is good
from the scanned AGs, or if it is not good enough we ignore it
regardless of whether we scanned all the AGs or not.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 84 +++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 48 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c8045cca2ec6..94d284f7d1d1 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3170,8 +3170,7 @@ static int
 xfs_bmap_longest_free_extent(
 	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
-	xfs_extlen_t		*blen,
-	int			*notinit)
+	xfs_extlen_t		*blen)
 {
 	xfs_extlen_t		longest;
 	int			error = 0;
@@ -3179,14 +3178,8 @@ xfs_bmap_longest_free_extent(
 	if (!xfs_perag_initialised_agf(pag)) {
 		error = xfs_alloc_read_agf(pag, tp, XFS_ALLOC_FLAG_TRYLOCK,
 				NULL);
-		if (error) {
-			/* Couldn't lock the AGF, so skip this AG. */
-			if (error == -EAGAIN) {
-				*notinit = 1;
-				error = 0;
-			}
+		if (error)
 			return error;
-		}
 	}
 
 	longest = xfs_alloc_longest_free_extent(pag,
@@ -3198,32 +3191,28 @@ xfs_bmap_longest_free_extent(
 	return 0;
 }
 
-static void
+static xfs_extlen_t
 xfs_bmap_select_minlen(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
-	xfs_extlen_t		*blen,
-	int			notinit)
+	xfs_extlen_t		blen)
 {
-	if (notinit || *blen < ap->minlen) {
-		/*
-		 * Since we did a BUF_TRYLOCK above, it is possible that
-		 * there is space for this request.
-		 */
-		args->minlen = ap->minlen;
-	} else if (*blen < args->maxlen) {
-		/*
-		 * If the best seen length is less than the request length,
-		 * use the best as the minimum.
-		 */
-		args->minlen = *blen;
-	} else {
-		/*
-		 * Otherwise we've seen an extent as big as maxlen, use that
-		 * as the minimum.
-		 */
-		args->minlen = args->maxlen;
-	}
+
+	/*
+	 * Since we used XFS_ALLOC_FLAG_TRYLOCK in _longest_free_extent(), it is
+	 * possible that there is enough contiguous free space for this request.
+	 */
+	if (blen < ap->minlen)
+		return ap->minlen;
+
+	/*
+	 * If the best seen length is less than the request length,
+	 * use the best as the minimum, otherwise we've got the maxlen we
+	 * were asked for.
+	 */
+	if (blen < args->maxlen)
+		return blen;
+	return args->maxlen;
 }
 
 STATIC int
@@ -3235,7 +3224,6 @@ xfs_bmap_btalloc_filestreams(
 	struct xfs_mount	*mp = ap->ip->i_mount;
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		start_agno;
-	int			notinit = 0;
 	int			error;
 
 	args->total = ap->total;
@@ -3246,11 +3234,13 @@ xfs_bmap_btalloc_filestreams(
 
 	pag = xfs_perag_grab(mp, start_agno);
 	if (pag) {
-		error = xfs_bmap_longest_free_extent(pag, args->tp, blen,
-				&notinit);
+		error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
 		xfs_perag_rele(pag);
-		if (error)
-			return error;
+		if (error) {
+			if (error != -EAGAIN)
+				return error;
+			*blen = 0;
+		}
 	}
 
 	if (*blen < args->maxlen) {
@@ -3266,18 +3256,18 @@ xfs_bmap_btalloc_filestreams(
 		if (!pag)
 			goto out_select;
 
-		error = xfs_bmap_longest_free_extent(pag, args->tp,
-				blen, &notinit);
+		error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
 		xfs_perag_rele(pag);
-		if (error)
-			return error;
-
+		if (error) {
+			if (error != -EAGAIN)
+				return error;
+			*blen = 0;
+		}
 		start_agno = agno;
-
 	}
 
 out_select:
-	xfs_bmap_select_minlen(ap, args, blen, notinit);
+	args->minlen = xfs_bmap_select_minlen(ap, args, *blen);
 
 	/*
 	 * Set the failure fallback case to look in the selected AG as stream
@@ -3666,7 +3656,6 @@ xfs_btalloc_nullfb_bestlen(
 	struct xfs_mount	*mp = args->mp;
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno, startag;
-	int			notinit = 0;
 	int			error = 0;
 
 	args->total = ap->total;
@@ -3677,9 +3666,8 @@ xfs_btalloc_nullfb_bestlen(
 
 	*blen = 0;
 	for_each_perag_wrap(mp, startag, agno, pag) {
-		error = xfs_bmap_longest_free_extent(pag, args->tp, blen,
-						     &notinit);
-		if (error)
+		error = xfs_bmap_longest_free_extent(pag, args->tp, blen);
+		if (error && error != -EAGAIN)
 			break;
 		if (*blen >= args->maxlen)
 			break;
@@ -3687,7 +3675,7 @@ xfs_btalloc_nullfb_bestlen(
 	if (pag)
 		xfs_perag_rele(pag);
 
-	xfs_bmap_select_minlen(ap, args, blen, notinit);
+	args->minlen = xfs_bmap_select_minlen(ap, args, *blen);
 	return 0;
 }
 
-- 
2.35.1

