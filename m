Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0812C15381C
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803959; cv=none; b=NxWu/YCubtqKBmQApCJr4/RTjWJR61WPPfiWhDuRszMiBzyaCGF45XKTlHuojB4rkRb4udmbEd/rr9/L13nH2ROOOxZAkQnaAc/pqLF2WXQee8mv849t5F7GZi7epIG8A8mH9whNR19m+w5JEhogbfRFlJnZeViWrzLqf6I+F6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803959; c=relaxed/simple;
	bh=HBiWaFGI7jV7wElNVXWmabTaHFC/KAZcBXDR78iSVWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVSZme8ZFLMB9mJvQ/3C0Y8qx/AzN89/TbScKmxGArzwttdHDnXMYUdiS5rwGqfqnvnjHYZyDKGdlTiYsMQ2j0cks+xbKykoBq186M0/xX5eSTjeCXECDZMQCOXewMSs27fROVO8r4Z9lCTWa3RUcQ1KSOS6N+1Y8T0BSQ8co6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i9dsPSqn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i9dsPSqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC2FC116B1;
	Mon, 22 Apr 2024 16:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803958;
	bh=HBiWaFGI7jV7wElNVXWmabTaHFC/KAZcBXDR78iSVWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9dsPSqnacqxIPQFhaFD7aiNuMpQyrfKWTjUYXl1wCc9xK421BkLHY4XLtF+bTspL
	 7f8JFC6piomMI4lrs2P7cqbzzLbJuTnh+cJ+fbVuXDGxB14CgInfW6bx0879y67Q6k
	 i02i7lcnkKZbvKK/Rr6OyM2KOSsj+gCMCnz0QlflvWgBYoB//HEv2UndlPPcLeWkjQ
	 5kILmVoxQLnBYmSyZbvloQexKLDVdg4WuE+EkqcP6H9BreXsz4HwQOBwQ13sX3bYtX
	 keswjfcQ7jXAkTgo5g/M54DgIM0bF00r40mIerT0Ov6F9ZYvJl5YkGSHq2unwmljKI
	 MiUsRrzKQq5Uw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 07/67] xfs: use xfs_defer_create_done for the relogging operation
Date: Mon, 22 Apr 2024 18:25:29 +0200
Message-ID: <20240422163832.858420-9-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: bd3a88f6b71c7509566b44b7021581191cc11ae3

Now that we have a helper to handle creating a log intent done item and
updating all the necessary state flags, use it to reduce boilerplate in
the ->iop_relog implementations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 include/xfs_trans.h | 2 +-
 libxfs/xfs_defer.c  | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 8371bc7e8..b39f0c22d 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -158,7 +158,7 @@ libxfs_trans_read_buf(
 }
 
 #define xfs_log_item_in_current_chkpt(lip)	(false)
-#define xfs_trans_item_relog(lip, tp)		(NULL)
+#define xfs_trans_item_relog(lip, dip, tp)	(NULL)
 
 /* Contorted mess to make gcc shut up about unused vars. */
 #define xlog_grant_push_threshold(log, need)    \
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 1be9554e1..43117099c 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -495,7 +495,11 @@ xfs_defer_relog(
 
 		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
 		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
-		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
+
+		xfs_defer_create_done(*tpp, dfp);
+		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent,
+				dfp->dfp_done, *tpp);
+		dfp->dfp_done = NULL;
 	}
 
 	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)
-- 
2.44.0

