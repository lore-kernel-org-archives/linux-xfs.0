Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85638148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529348; cv=none; b=djGO3YGx/QwxR0WpWobC+RTb6jOL+X+7GTvMShCVdMdD2d6nQuDdgMfZ36xaC5d+R5IMdvssi4iF+P/eT0dFIsPIRNGKDOH/neCOeI1GWBDUoF+bkaNs/Kg97jiDQvX+6/KVl2nY/D1wSb0YaznhhzdfMcSzQMs5J5lV3oMpJcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529348; c=relaxed/simple;
	bh=mpvNgsO6PFCSDiMotJozQWd2IKZZ3Iw5KMskZpiYywU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rDLvAXyGgQxItXji9+uiNdUJtR8owUi8gJ+kf44Y/Mb2h4WNyonQpDrjayBLmwwuqR7jxBcENG0c6x8vD/tsHt72tmtm3Fxu0lBTDH9vx6Xi3QVmgS7zr0ZeFbZor0cdXdaXDFM+6qNWfOic6WraV6KVmkkOvOV5J2IpkudOTr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DrlJojsb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DrlJojsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16790C4CED1;
	Fri,  6 Dec 2024 23:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529348;
	bh=mpvNgsO6PFCSDiMotJozQWd2IKZZ3Iw5KMskZpiYywU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DrlJojsbL7KmXT5JlCAncs+TL8G6ysOyyd17GJGc/ZY2rRejD3RQ02CSd1vUk6rPQ
	 OYsoVLATCAGIx5Zzckc21FuFAFBZMh+BKaDVjfm5ztrMcV8z3/J48XlSK1GMI6OWy1
	 0XkoMML/0XYH+Yuf5LSukAz3tlwjUS9TqdxB9YXVXhimjCQ7gfeUnTe2/x0sqqWHn7
	 qSAKquh+Da+xak12xmTklx8OoP+hfKqjcY2H77bMu0hEuwFPJZscg+cBPvmooXOHvW
	 OJ8ZGxwBELTgWHirZUg72u9+Tmm5oybYndG6ty3DspqbZYnE3zn280YhMiBuyuOE9V
	 RWVR3SYjWlR4A==
Date: Fri, 06 Dec 2024 15:55:47 -0800
Subject: [PATCH 17/46] xfs: add frextents to the lazysbcounters when rtgroups
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750254.124560.18305986642582090915.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
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

