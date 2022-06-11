Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3997CCA47B
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Jun 2022 01:27:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348077AbiFKB1j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jun 2022 21:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349012AbiFKB1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:21 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BBC203A4CC0
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B2F735EC7FB
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:05 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-005APw-7x
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu4-00ELNh-6u
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 39/50] xfs: use xfs_bmap_longest_free_extent() in filestreams
Date:   Sat, 11 Jun 2022 11:26:48 +1000
Message-Id: <20220611012659.3418072-40-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62a3ef69
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=ic2w9fSLWmZYSFiV4WUA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The code in xfs_bmap_longest_free_extent() is open coded in
xfs_filestream_pick_ag(). Export xfs_bmap_longest_free_extent and
call it from the filestreams code instead.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c |  2 +-
 fs/xfs/libxfs/xfs_bmap.h |  2 ++
 fs/xfs/xfs_filestream.c  | 22 ++++++++--------------
 3 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 94d284f7d1d1..65f407ace78f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3166,7 +3166,7 @@ xfs_bmap_adjacent(
 #undef ISVALID
 }
 
-static int
+int
 xfs_bmap_longest_free_extent(
 	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 16db95b11589..8bb37868ddb1 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -168,6 +168,8 @@ static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
 #define xfs_valid_startblock(ip, startblock) \
 	((startblock) != 0 || XFS_IS_REALTIME_INODE(ip))
 
+int	xfs_bmap_longest_free_extent(struct xfs_perag *pag,
+		struct xfs_trans *tp, xfs_extlen_t *blen);
 void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 		xfs_filblks_t len);
 unsigned int xfs_bmap_compute_attr_offset(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 7e8b25ab6c46..2eb702034d05 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -124,17 +124,14 @@ xfs_filestream_pick_ag(
 		trace_xfs_filestream_scan(mp, ip->i_ino, ag);
 
 		pag = xfs_perag_get(mp, ag);
-
-		if (!xfs_perag_initialised_agf(pag)) {
-			err = xfs_alloc_read_agf(pag, NULL, trylock, NULL);
-			if (err) {
-				if (err != -EAGAIN) {
-					xfs_perag_put(pag);
-					return err;
-				}
-				/* Couldn't lock the AGF, skip this AG. */
-				goto next_ag;
-			}
+		longest = 0;
+		err = xfs_bmap_longest_free_extent(pag, NULL, &longest);
+		if (err) {
+			xfs_perag_put(pag);
+			if (err != -EAGAIN)
+				return err;
+			/* Couldn't lock the AGF, skip this AG. */
+			goto next_ag;
 		}
 
 		/* Keep track of the AG with the most free blocks. */
@@ -154,9 +151,6 @@ xfs_filestream_pick_ag(
 			goto next_ag;
 		}
 
-		longest = xfs_alloc_longest_free_extent(pag,
-				xfs_alloc_min_freelist(mp, pag),
-				xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE));
 		if (((minlen && longest >= minlen) ||
 		     (!minlen && pag->pagf_freeblks >= minfree)) &&
 		    (!xfs_perag_prefers_metadata(pag) ||
-- 
2.35.1

