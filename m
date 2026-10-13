Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1E73E1729
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871351; cv=none; b=g0w1MqCzfWefSa+Y3AUY0lKY2kFc08eqmny7skSvNtcGxw7UB7xbaC1SAogxWiPeEOqDwvSm9F5bCdBm+NLkwVYpgd7v459h8vNnVXB7Yi2Hm3j1dF+tYwDEKRftIamnS4LEXdyd5r8I3Fb+S+m2kXJg6GLi+jgsUhENv2uflLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871351; c=relaxed/simple;
	bh=qeXNGn9pWwLARsjZ1PXdPnkwomamJaTxxftC4iA6USY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e576QfvpxBTdd8PXyuR3PriPXyVQUiGUCcQkYPa7MdAC7kpMYkfOZ1HILc8/pl4N4a6TgSUK9g0K2xU3nIYtlebYGs/dEhhiLV83zOyQzYz9UPf4EHkS0AAzJOfee1DStyGITgJ5EuzgjgYhF3iWugigihnGPy3THsk+eA8TDEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RnXzL4VD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RnXzL4VD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85791F00893;
	Tue, 13 Oct 2026 06:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871350;
	bh=hbhv5ssn/mt/w3HbXrsi/lxwCfbrqpz35fvB4Z8STXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RnXzL4VDODRyVF1Imn7hcJrH7twhrseBJ7gwr/s4eW453GQW5oT4sfnkhfH4dvxKU
	 EAcvLwdQQq880Cyvgm5TCh+P031GTxC169W55LmOsQuugM269v9mIhteK9lL9ytIj8
	 8EVFZ0WBCfHs6AgU6C+8zddnBl4pk5Wp7313/3KCKMadgSS0ERzi0xlfgr82fBZeua
	 KoZyZ8kXh/i72B+rD9HrKOVzJZ3PgCsi4pVU4goL0BHFyI+X7igSu+am0MMcFONvBW
	 iij4qShGj/fkXrDVA/xq8IzVlpKMrNvHRW9bAXppCST2fTWLPyZASg1GpnQzujh415
	 MO81DtjRo/pUQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 17/48] xfs: dump the corrupt region when log item validation fails
Date: Tue, 13 Oct 2026 17:01:07 +1100
Message-ID: <20261013060204.3138690-18-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Log item validation reports failures with a type specific warning, but that
warning does not include the region contents. The existing recovery code
dumped the offending buffer via XFS_CORRUPTION_ERROR for diagnostics, and that
is being removed as per-type validation replaces it.

Emit XFS_CORRUPTION_ERROR from the region completion path when validation
fails, so the type specific warning is accompanied by a hex dump of the
relevant buffer. A per-region failure dumps that region; a whole-item failure
dumps the format header. This is added before the per-type validation so those
patches can drop their own corruption dumps.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c35bb0fb3249..b353362587cb 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2353,7 +2353,8 @@ xlog_recover_complete_region(
 	struct xlog_recover	*trans)
 {
 	struct xlog_recover_item *item = trans->r_cur_item;
-	int			error;
+	int			region_to_dump = 0;
+	int			error = 0;
 
 	/*
 	 * The format header (region 0) must be at least the minimum size for
@@ -2366,19 +2367,29 @@ xlog_recover_complete_region(
 	"log item type 0x%x header too short (%zu < %u)",
 			item->ri_ops->item_type, item->ri_buf[0].iov_len,
 			item->ri_ops->min_hdr_len);
-		return -EFSCORRUPTED;
+		error = -EFSCORRUPTED;
+		goto out_error;
 	}
 
 	if (item->ri_ops->validate_region) {
 		error = item->ri_ops->validate_region(log, item,
 						      item->ri_cnt - 1);
-		if (error)
-			return error;
+		if (error) {
+			/* dump the bad region rather than the log format header */
+			region_to_dump = item->ri_cnt - 1;
+			goto out_error;
+		}
 	}
 
 	if (item->ri_cnt == item->ri_total)
-		return xlog_recover_complete_item(log, trans);
-	return 0;
+		error = xlog_recover_complete_item(log, trans);
+
+out_error:
+	if (error == -EFSCORRUPTED)
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, log->l_mp,
+				item->ri_buf[region_to_dump].iov_base,
+				item->ri_buf[region_to_dump].iov_len);
+	return error;
 }
 
 STATIC int
-- 
2.55.0

