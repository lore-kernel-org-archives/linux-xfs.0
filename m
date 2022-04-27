Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92C6C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354007AbiD0Ay7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245394AbiD0Ay7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:54:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2B113DC5
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:51:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A1C361AF9
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 00:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFF6C385A0;
        Wed, 27 Apr 2022 00:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651020708;
        bh=ElZ4x4VmEWU+0bw5gOCnE8Uj7kgXan2rRnRbMrlN82w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OMCN55ledBylMBtjtuE7HydXUiScCoFNtw6jGr6lSL9zEf8kA9IaX1h+R8tEmNEnV
         09Wqh86gt0HUypa/Up59WSuVQGdQ+ujxzucZQ4xNMdjAKeDbAUJYa6H3AU4NWL6Drs
         MM+6m9oCbM0p90gK40TEvQ9RK1oOfQlJmaP/rS8SLkBoLMnzDvv18mZzFAV579kLro
         BeBAS8DoXf/glR0rFxvkpqeWjO30SXzB6mos/kKWfReWmlACEG9Zm5f+gDePfi+BFQ
         yG6u8gAEKXrKL501gtsuz2io0CDhPZYiMhQr1HyAL5zjl9RNzoG6RQjuqY4ver47a/
         Obxng5aygXD6w==
Subject: [PATCH 4/4] xfs: speed up write operations by using non-overlapped
 lookups when possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 26 Apr 2022 17:51:48 -0700
Message-ID: <165102070826.3922526.7040761074869734523.stgit@magnolia>
In-Reply-To: <165102068549.3922526.15959517253241370597.stgit@magnolia>
References: <165102068549.3922526.15959517253241370597.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_rmap.c |   50 +++++++++++++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_rmap.h |    3 ---
 2 files changed, 36 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 6f74dcda44b5..2845019d31da 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -265,7 +265,6 @@ xfs_rmap_get_rec(
 struct xfs_find_left_neighbor_info {
 	struct xfs_rmap_irec	high;
 	struct xfs_rmap_irec	*irec;
-	int			*stat;
 };
 
 /* For each rmap given, figure out if it matches the key we want. */
@@ -290,7 +289,6 @@ xfs_rmap_find_left_neighbor_helper(
 		return 0;
 
 	*info->irec = *rec;
-	*info->stat = 1;
 	return -ECANCELED;
 }
 
@@ -299,7 +297,7 @@ xfs_rmap_find_left_neighbor_helper(
  * return a match with the same owner and adjacent physical and logical
  * block ranges.
  */
-int
+STATIC int
 xfs_rmap_find_left_neighbor(
 	struct xfs_btree_cur	*cur,
 	xfs_agblock_t		bno,
@@ -310,6 +308,7 @@ xfs_rmap_find_left_neighbor(
 	int			*stat)
 {
 	struct xfs_find_left_neighbor_info	info;
+	int			found = 0;
 	int			error;
 
 	*stat = 0;
@@ -327,21 +326,44 @@ xfs_rmap_find_left_neighbor(
 	info.high.rm_flags = flags;
 	info.high.rm_blockcount = 0;
 	info.irec = irec;
-	info.stat = stat;
 
 	trace_xfs_rmap_find_left_neighbor_query(cur->bc_mp,
 			cur->bc_ag.pag->pag_agno, bno, 0, owner, offset, flags);
 
-	error = xfs_rmap_query_range(cur, &info.high, &info.high,
-			xfs_rmap_find_left_neighbor_helper, &info);
-	if (error == -ECANCELED)
-		error = 0;
-	if (*stat)
-		trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, irec->rm_startblock,
-				irec->rm_blockcount, irec->rm_owner,
-				irec->rm_offset, irec->rm_flags);
-	return error;
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
+	error = xfs_rmap_lookup_le(cur, bno, owner, offset, flags, irec,
+			&found);
+	if (error)
+		return error;
+	if (found)
+		error = xfs_rmap_find_left_neighbor_helper(cur, irec, &info);
+	if (!error)
+		error = xfs_rmap_query_range(cur, &info.high, &info.high,
+				xfs_rmap_find_left_neighbor_helper, &info);
+	if (error != -ECANCELED)
+		return error;
+
+	*stat = 1;
+	trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
+			cur->bc_ag.pag->pag_agno, irec->rm_startblock,
+			irec->rm_blockcount, irec->rm_owner, irec->rm_offset,
+			irec->rm_flags);
+	return 0;
 }
 
 /* For each rmap given, figure out if it matches the key we want. */
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

