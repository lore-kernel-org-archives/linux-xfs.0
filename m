Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAA93D47A8
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 17:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773164390; cv=none; b=dTIwZr2vGeXMH+Sh3NQlx5+5Ng1Lksd8mHJLzstAarQnPx9167PV+DEAV9lkmP3EO15nK/lv1ehw9+7kZMQToTvl619HkH3wBKFmdmjdGslIsfkKqo1LRxz4Oq3nJhiCScZHgIPIahkgMtnOtlCU5W5UULIMs8asFKmLFxWn7/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773164390; c=relaxed/simple;
	bh=ZM6z1mO4J4H4Ast9XdiUkg0mXot2SkvDH0zzIdiD9x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxtTt/IYfqkf8H4w1gDiUGiScsYOcXo04rtdBLoZy/GWYjWOZIaDdOlx/ybJZe2Bxez8d6XoJSB1IZd4vrLELDZcuve+YRk5JhUJzbWPUC360/PYqTcYGk7Nh55lyX+o3cWS9nXtVi4GGhMNyF7OG/n36n1cTkAcICzpg6tdgBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ICA7u8FY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ICA7u8FY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC176C19425;
	Tue, 10 Mar 2026 17:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773164389;
	bh=ZM6z1mO4J4H4Ast9XdiUkg0mXot2SkvDH0zzIdiD9x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ICA7u8FYixU45UsQR9bQG0CjBUxjjoYieGPyt6hdno6D6i3tP8VkF+Lr3xikYT0ao
	 ZxhqZGlxCXrKC2R/IYLbnDI20DRFFpOnH8z0MJQK+pVYVtFyJUwHBp/ia20ME57sTw
	 iVfnicDS9xw+tEpbSWCgjrnnBsILvOAPA/cYf+lu23KTfVFhH3GHP7ax/4MQMtrxKT
	 adbOnaYioMO3Wmzd9pvQ949e3KW/MgFaPs9eiK5lp35iDxJ1ELY70PEabkltwuNi09
	 mjB+fqXFOCvjZXPceo9OlMamgbgycsyPyfnlUyoG/Dw7zmlJ0sDvv3VcaX0/L5HZT5
	 glVHZ5XTlGNHw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de,
	dlemoal@kernel.org
Subject: [PATCH v2 3/4] xfs: factor out xfs_zone_inc_written
Date: Tue, 10 Mar 2026 18:36:48 +0100
Message-ID: <20260310173709.457047-4-cem@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260310173709.457047-1-cem@kernel.org>
References: <20260310173709.457047-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Carlos Maiolino <cem@kernel.org>

Move the written blocks increment and full zone check into a new helper.
Also add an assert to ensure rmap lock is held here.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

---
v2: add RwB tags, no changes

 fs/xfs/xfs_zone_alloc.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index e3d19b6dc64a..97149bfc2512 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -189,6 +189,18 @@ xfs_open_zone_mark_full(
 		xfs_zone_account_reclaimable(rtg, rtg_blocks(rtg) - used);
 }
 
+static inline void
+xfs_zone_inc_written(
+	struct xfs_open_zone	*oz,
+	xfs_filblks_t		len)
+{
+	xfs_assert_ilocked(rtg_rmap(oz->oz_rtg), XFS_ILOCK_EXCL);
+
+	oz->oz_written += len;
+	if (oz->oz_written == rtg_blocks(oz->oz_rtg))
+		xfs_open_zone_mark_full(oz);
+}
+
 static void
 xfs_zone_record_blocks(
 	struct xfs_trans	*tp,
@@ -206,9 +218,7 @@ xfs_zone_record_blocks(
 	xfs_rtgroup_trans_join(tp, rtg, XFS_RTGLOCK_RMAP);
 	rmapip->i_used_blocks += len;
 	ASSERT(rmapip->i_used_blocks <= rtg_blocks(rtg));
-	oz->oz_written += len;
-	if (oz->oz_written == rtg_blocks(rtg))
-		xfs_open_zone_mark_full(oz);
+	xfs_zone_inc_written(oz, len);
 	xfs_trans_log_inode(tp, rmapip, XFS_ILOG_CORE);
 }
 
@@ -227,9 +237,7 @@ xfs_zone_skip_blocks(
 	trace_xfs_zone_skip_blocks(oz, 0, len);
 
 	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
-	oz->oz_written += len;
-	if (oz->oz_written == rtg_blocks(rtg))
-		xfs_open_zone_mark_full(oz);
+	xfs_zone_inc_written(oz, len);
 	xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
 
 	xfs_add_frextents(rtg_mount(rtg), len);
-- 
2.53.0

