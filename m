Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C5E4DD6F8
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 11:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773143767; cv=none; b=muIojAxav4OON4WDU1j3jk/bVBoUInpc7BGhx6Lpz/CWDPqCMnGaKlH50AjO9TCpSSheVPhVP6loOgIKUs6rs3ETak4Uhjl4nReAWVAd0HaP8C7B+rlxwrxuji0rrxkyTP9SSzWNDnbfuwnSMbAH24k1+4XE/pv/WhAM+DvVYlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773143767; c=relaxed/simple;
	bh=saqRZaBQ3FT/zcVvHzmm5h1s0AoC159dRuYoOANtuvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxf3/7DtXOFpBnrVBTOFKn3mQqUHLQi2KmwtLvQZr54YeXsq5g0Vc0j50U8oDOBHlZZ9MIcZkgpiLoQBk+7kcQuazoxIfOakwRQS/NWsHkTE/lvy56NUz3vrfCOm4OZi7S8IdjdoeG0KPD4r+YIz9jMxLVqNE/hX6kHEG3LbbSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PFFK5iuf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PFFK5iuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14374C2BCB0;
	Tue, 10 Mar 2026 11:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773143766;
	bh=saqRZaBQ3FT/zcVvHzmm5h1s0AoC159dRuYoOANtuvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PFFK5iuf4RQz07Hu20GK71mMw3PuWHfbt4fSBskBROr29zMiXDsEgSn5dj6ztPRIf
	 zZmYFNF9a2Y97WkYl06ge2f+uFB+x7lcPk6+utXARk2sma8HlcOuokgm4c3LJunIbr
	 ZZbNu9Dj22LM4QGlMGm1NExXNwK/ts73wlNxusBplI33gWLehLKKUrjEQGcu6Nc97W
	 CS0OsSS7pV+mTmkaQMiZnhu6KFuRXX1hN1VMLV7rHz/ZTQnpvLuyDtmOpvpTeMLxxD
	 PR+9VvftDO+xwyeYEp/35LHUtgmkgJCT91GRr1OkbjpHr5CqKKsi6FJpqCi4f5pW1z
	 1OG3Sk+dzYAow==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de,
	dlemoal@kernel.org
Subject: [PATCH 3/4] xfs: factor out xfs_zone_inc_written
Date: Tue, 10 Mar 2026 12:55:06 +0100
Message-ID: <20260310115555.114197-4-cem@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260310115555.114197-1-cem@kernel.org>
References: <20260310115555.114197-1-cem@kernel.org>
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
---
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

