Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E698BC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 22:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244039AbiDNW4v (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 18:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347370AbiDNW4u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 18:56:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764AEE1E
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 15:54:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1291B62071
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 22:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C57BC385A1;
        Thu, 14 Apr 2022 22:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649976862;
        bh=JJHgNs7wL3i8MsKwDqvRpiCDBMeux9LXZj+1ewn3VTw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QOMukMyp4w9eEcSsFr/Smo2c0BPQNrUsGQ1YDl5t5fYZ0FPjtOO6jLhxEBuPHZz/6
         nIBjuWU5t4lg9N0LBP8vrT/2ToJ8sIFE5QSrxHUoI97fw31dYob/c98m3bu+ZzVZMu
         zdhffT4hp/r0xjLdhPc0Rx/3rjZOYRhfdTx88/fvm1Wvw4q73hjvbdOPLiazPPcv/e
         10E6DIIdmiVpae5IMOgCsqmvug+A2lx9Ayhq3FY5y5Sbut4+fAQjDnsZV/+XgI4Rel
         33shje7PR8vS//VgFfBwNGR4l6FZ/kY5GMxYJ1ZOSV9c3hBzICUN6GpTKVnY/rkRsV
         AlM8bB5h+lTgA==
Subject: [PATCH 4/4] xfs: speed up write operations by using non-overlapped
 lookups when possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 Apr 2022 15:54:22 -0700
Message-ID: <164997686196.383709.14448633533668211390.stgit@magnolia>
In-Reply-To: <164997683918.383709.10179435130868945685.stgit@magnolia>
References: <164997683918.383709.10179435130868945685.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Reverse mapping on a reflink-capable filesystem has some pretty high
overhead when performing file operations.  This is because the rmap
records for logically and physically adjacent extents might not be
adjacent in the rmap index due to data block sharing.  As a result, we
use expensive overlapped-interval btree search, which walks every record
that overlaps with the supplied key in the hopes of finding the record.

However, profiling data shows that when the index contains a record that
is an exact match for a query key, the non-overlapped btree search
function can find the record much faster than the overlapped version.
Try the non-overlapped lookup first when we're trying to find the left
neighbor rmap record for a given file mapping, which makes unwritten
extent conversion and remap operations run faster if data block sharing
is minimal in this part of the filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c |   35 ++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_rmap.h |    3 ---
 2 files changed, 30 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 5aa94deb3afd..bd394138df9e 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -299,7 +299,7 @@ xfs_rmap_find_left_neighbor_helper(
  * return a match with the same owner and adjacent physical and logical
  * block ranges.
  */
-int
+STATIC int
 xfs_rmap_find_left_neighbor(
 	struct xfs_btree_cur	*cur,
 	xfs_agblock_t		bno,
@@ -332,10 +332,35 @@ xfs_rmap_find_left_neighbor(
 	trace_xfs_rmap_find_left_neighbor_query(cur->bc_mp,
 			cur->bc_ag.pag->pag_agno, bno, 0, owner, offset, flags);
 
-	error = xfs_rmap_query_range(cur, &info.high, &info.high,
-			xfs_rmap_find_left_neighbor_helper, &info);
-	if (error == -ECANCELED)
-		error = 0;
+	/*
+	 * Historically, we always used the range query to walk every reverse
+	 * mapping that could possibly overlap the key that the caller asked
+	 * for, and filter out the ones that don't.  That is very slow when
+	 * there are a lot of records.
+	 *
+	 * However, there are two scenarios where the classic btree search can
+	 * produce correct results -- if the index contains a record that is an
+	 * exact match for the lookup key; and if there are no other records
+	 * between the record we want and the key we supplied.
+	 *
+	 * As an optimization, try a non-overlapped lookup first.  This makes
+	 * extent conversion and remap operations run a bit faster if the
+	 * physical extents aren't being shared.  If we don't find what we
+	 * want, we fall back to the overlapped query.
+	 */
+	error = xfs_rmap_lookup_le(cur, bno, owner, offset, flags, irec, stat);
+	if (error)
+		return error;
+	if (*stat) {
+		*stat = 0;
+		xfs_rmap_find_left_neighbor_helper(cur, irec, &info);
+	}
+	if (!(*stat)) {
+		error = xfs_rmap_query_range(cur, &info.high, &info.high,
+				xfs_rmap_find_left_neighbor_helper, &info);
+		if (error == -ECANCELED)
+			error = 0;
+	}
 	if (*stat)
 		trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
 				cur->bc_ag.pag->pag_agno, irec->rm_startblock,
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 11ec9406a0ea..54741a591a17 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -184,9 +184,6 @@ int xfs_rmap_finish_one(struct xfs_trans *tp, enum xfs_rmap_intent_type type,
 		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
 		xfs_exntst_t state, struct xfs_btree_cur **pcur);
 
-int xfs_rmap_find_left_neighbor(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-		uint64_t owner, uint64_t offset, unsigned int flags,
-		struct xfs_rmap_irec *irec, int	*stat);
 int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		uint64_t owner, uint64_t offset, unsigned int flags,
 		struct xfs_rmap_irec *irec, int	*stat);

