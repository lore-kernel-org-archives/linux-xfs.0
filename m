Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC53C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353871AbiD0Ay6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245394AbiD0Ay5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:54:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2860713DC5
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:51:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B833A61AF9
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 00:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211E2C385A0;
        Wed, 27 Apr 2022 00:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651020703;
        bh=AhilXe0K0F89pshfb8Fn1IwJD+Jinm7/hMffCe6/D0U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=euFs8IrTG7VuxG+Gx3kLjAbgxKKX1dzyID2/S9tlEgFysZsnx4bVfO/Nvgkh6VIR4
         IOZwSbKHyCiMtaaz5gXJiapMJzUOymdB1ouzFRi4EAq1KpgegalyuYxjzyfhV3old1
         pEh+wQ51/wW0s9JsaDJ4KLm4RaSLZ6oF7BAfSBwzUKRm0gp2UqAYbzFVrEhN6jsrUU
         F4OU2Yeov8x834i7Q+FQf8aszu8mUtb4z5VIZXqdjWsXSSup4oJBnDcyRwBQ2AvM1h
         Ys/KaXhagloFs+OcwLpx7vQyT3+y63vV+YajgybPB1XYmJuKnuZVOhKCOeeS11RhfE
         9OUPlIlQXJxhA==
Subject: [PATCH 3/4] xfs: speed up rmap lookups by using non-overlapped
 lookups when possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 26 Apr 2022 17:51:42 -0700
Message-ID: <165102070261.3922526.1584531429524068308.stgit@magnolia>
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
Try the non-overlapped lookup first, which will make scrub run much
faster.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c |   52 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 3eea8056e7bc..6f74dcda44b5 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -367,7 +367,6 @@ xfs_rmap_lookup_le_range_helper(
 		return 0;
 
 	*info->irec = *rec;
-	*info->stat = 1;
 	return -ECANCELED;
 }
 
@@ -388,6 +387,7 @@ xfs_rmap_lookup_le_range(
 	int			*stat)
 {
 	struct xfs_find_left_neighbor_info	info;
+	int			found = 0;
 	int			error;
 
 	info.high.rm_startblock = bno;
@@ -400,20 +400,44 @@ xfs_rmap_lookup_le_range(
 	info.high.rm_blockcount = 0;
 	*stat = 0;
 	info.irec = irec;
-	info.stat = stat;
 
-	trace_xfs_rmap_lookup_le_range(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, bno, 0, owner, offset, flags);
-	error = xfs_rmap_query_range(cur, &info.high, &info.high,
-			xfs_rmap_lookup_le_range_helper, &info);
-	if (error == -ECANCELED)
-		error = 0;
-	if (*stat)
-		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, irec->rm_startblock,
-				irec->rm_blockcount, irec->rm_owner,
-				irec->rm_offset, irec->rm_flags);
-	return error;
+	trace_xfs_rmap_lookup_le_range(cur->bc_mp, cur->bc_ag.pag->pag_agno,
+			bno, 0, owner, offset, flags);
+
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
+	 * scrub run much faster on most filesystems because bmbt records are
+	 * usually an exact match for rmap records.  If we don't find what we
+	 * want, we fall back to the overlapped query.
+	 */
+	error = xfs_rmap_lookup_le(cur, bno, owner, offset, flags, irec,
+			&found);
+	if (error)
+		return error;
+	if (found)
+		error = xfs_rmap_lookup_le_range_helper(cur, irec, &info);
+	if (!error)
+		error = xfs_rmap_query_range(cur, &info.high, &info.high,
+				xfs_rmap_lookup_le_range_helper, &info);
+	if (error != -ECANCELED)
+		return error;
+
+	*stat = 1;
+	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
+			cur->bc_ag.pag->pag_agno, irec->rm_startblock,
+			irec->rm_blockcount, irec->rm_owner, irec->rm_offset,
+			irec->rm_flags);
+	return 0;
 }
 
 /*

