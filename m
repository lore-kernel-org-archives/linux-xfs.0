Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A013BC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 22:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347335AbiDNW4r (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 18:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244039AbiDNW4r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 18:56:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED0F65162
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 15:54:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DDE1B82BDB
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 22:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32CBC385A5;
        Thu, 14 Apr 2022 22:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649976856;
        bh=ifyGtJzhm1vlrZ+NzLcSboTIT+xNx1BqoWSI7rVCHpE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LmTTDe97CbQwDgep9e40GNG83NkZVwzdg8XjT4aa/qVNMeIKM+GtTTp6NgLIYOzvN
         CT32tOw2XCcvlnpTFEyzR48zxBH0y1mjlj4mMSRiAF4zNw+nUxT1FccDdc71EeYXYW
         9ODW9e9KEiE7cyO5uUy351bibVrOmp1e0QpI5snVbKe0LcdGiXn0h1zspb6pRJpLAv
         dbikd+3yJNrefPg6hFiacDCQ1x+6E+ahNXtRAicHQA/njXY/hxB1kl4ufR2iPvGgxf
         4li1iZs0UptTM1hsmeJs79Scrjy4uwtAHi2+xSg77wp3KVJOa03z6pdo/tktR6r2vz
         uxzb/6Jzx0xfA==
Subject: [PATCH 3/4] xfs: speed up rmap lookups by using non-overlapped
 lookups when possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 Apr 2022 15:54:16 -0700
Message-ID: <164997685638.383709.4789775648712621300.stgit@magnolia>
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
Try the non-overlapped lookup first, which will make scrub run much
faster.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c |   38 ++++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 3eea8056e7bc..5aa94deb3afd 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -402,12 +402,38 @@ xfs_rmap_lookup_le_range(
 	info.irec = irec;
 	info.stat = stat;
 
-	trace_xfs_rmap_lookup_le_range(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, bno, 0, owner, offset, flags);
-	error = xfs_rmap_query_range(cur, &info.high, &info.high,
-			xfs_rmap_lookup_le_range_helper, &info);
-	if (error == -ECANCELED)
-		error = 0;
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
+	error = xfs_rmap_lookup_le(cur, bno, owner, offset, flags, irec, stat);
+	if (error)
+		return error;
+	if (*stat) {
+		*stat = 0;
+		xfs_rmap_lookup_le_range_helper(cur, irec, &info);
+	}
+	if (!(*stat)) {
+		error = xfs_rmap_query_range(cur, &info.high, &info.high,
+				xfs_rmap_lookup_le_range_helper, &info);
+		if (error == -ECANCELED)
+			error = 0;
+	}
 	if (*stat)
 		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
 				cur->bc_ag.pag->pag_agno, irec->rm_startblock,

