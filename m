Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D44638385
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991360; cv=none; b=srvPW9t1aTe/bdrEcXJKtC8u9PDVScOScV5iNI/ITjcm4ZZi9sAjyajD6mBo64OOwxlDZlSIu7Rd/RPd4AUNnNjNoLJElfCrlu6hTt8m9RIpXU5ZZ2CsaaT1iJ0FEMp2MjGmF5gtmDbwQXVLRVj854smfuC7Yac0ueJn7fnAwsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991360; c=relaxed/simple;
	bh=mpvNgsO6PFCSDiMotJozQWd2IKZZ3Iw5KMskZpiYywU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y4vifRDMHf4WSFgTGnvPMikuZjO96Xwc8nmaQMhVh/ehT/uLvrL9LNzmMXjfDWst0S0GzXGh6Rvo2rebU1uRa6oGLlsKyUw182HfUTREtayc2TSij/T7rg7UU0IXsZKGt+W+udVRi69Pt6lNaipl5aMs5CJjWFk7atQn3BXQjoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M9d4qupH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M9d4qupH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DB8C4CED3;
	Mon, 23 Dec 2024 22:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991359;
	bh=mpvNgsO6PFCSDiMotJozQWd2IKZZ3Iw5KMskZpiYywU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M9d4qupH3F21lo6/uF+3HYYAk6nhPngtT0PfSTxrWKybu+JiXdj0/2+AH8A7Am3ib
	 /Sdv8HA+By7jkhTROrfLRet21eQX08WbxvrXbrHRF8GvBgTPUi65DmLaKNG956+sRd
	 oqmhUSFwjyXQRn8MFNFxktOk7GorqnUTRuMZVvfKEKkidUyaJ6Bq0SGedA1jwrcejm
	 XETRE0N+/lHoValB9xW6rDabofjg3fhvmP5qR6NjpBYU7fdfqQTX7ai2U8Y4higQib
	 HHBeWyAH6DmhgidUPq6yhGPkHoWbS9X99yKIQNZqj33IYawo6clNGI0kWuoC9PyDKv
	 eMX5pE05zMW3A==
Date: Mon, 23 Dec 2024 14:02:39 -0800
Subject: [PATCH 17/52] xfs: add frextents to the lazysbcounters when rtgroups
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942755.2295836.8169743027371644641.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 35537f25d23697716f0070ea0a6e8b3f1fe10196

Make the free rt extent count a part of the lazy sb counters when the
realtime groups feature is enabled.  This is possible because the patch
to recompute frextents from the rtbitmap during log recovery predates
the code adding rtgroup support, hence we know that the value will
always be correct during runtime.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_mount.h |    1 +
 libxfs/xfs_sb.c     |   15 ++++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 31ac60d93c61cc..c03246a08a4af3 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -64,6 +64,7 @@ typedef struct xfs_mount {
 #define m_icount	m_sb.sb_icount
 #define m_ifree		m_sb.sb_ifree
 #define m_fdblocks	m_sb.sb_fdblocks
+#define m_frextents	m_sb.sb_frextents
 	spinlock_t		m_sb_lock;
 
 	/*
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 2e536bc3b2090b..88fb4890d95a72 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1163,11 +1163,6 @@ xfs_log_sb(
 	 * reservations that have been taken out percpu counters. If we have an
 	 * unclean shutdown, this will be corrected by log recovery rebuilding
 	 * the counters from the AGF block counts.
-	 *
-	 * Do not update sb_frextents here because it is not part of the lazy
-	 * sb counters, despite having a percpu counter. It is always kept
-	 * consistent with the ondisk rtbitmap by xfs_trans_apply_sb_deltas()
-	 * and hence we don't need have to update it here.
 	 */
 	if (xfs_has_lazysbcount(mp)) {
 		mp->m_sb.sb_icount = percpu_counter_sum_positive(&mp->m_icount);
@@ -1178,6 +1173,16 @@ xfs_log_sb(
 				percpu_counter_sum_positive(&mp->m_fdblocks);
 	}
 
+	/*
+	 * sb_frextents was added to the lazy sb counters when the rt groups
+	 * feature was introduced.  This counter can go negative due to the way
+	 * we handle nearly-lockless reservations, so we must use the _positive
+	 * variant here to avoid writing out nonsense frextents.
+	 */
+	if (xfs_has_rtgroups(mp))
+		mp->m_sb.sb_frextents =
+				percpu_counter_sum_positive(&mp->m_frextents);
+
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
 	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsb) - 1);

