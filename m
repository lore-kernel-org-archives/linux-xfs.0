Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F0E4F798A
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 11:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773143767; cv=none; b=uigMh5qVBwB34mALsviLmXk0qt3qr8y2zDMKgOAgU0gk4NdW1gXHFcLAwp13FDoBXgp6av/VS1FDdQtMbHBqHzleArdDCHpsmX7O4s45mTWbexRK8bo6fpLS75JMKAO36UsUJEUCmwzXU8cuvNSHkBNIyqQfwJOtRs/O0Tla4DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773143767; c=relaxed/simple;
	bh=FX3LzaBGRsF/pd9oxgBTapM6vJE5c+/3H5oT2X9JDcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSkNA2OCM140Sw1jScEvNgLyVHcOkZuVpA+xjI38a52CRV6PR9YP6wsS0DX9fkG1mJGNBwRSLQPkn7YebAwEiDGeo/ehfkg2gqimLurMJg2nbnTH55XUFRPdXBE+Nvt3ylFyjObMgCQeXjbcSLNKxrRKvN29rtzVXf8ZQUXUt8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MRbWJcZJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MRbWJcZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86030C2BCB1;
	Tue, 10 Mar 2026 11:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773143767;
	bh=FX3LzaBGRsF/pd9oxgBTapM6vJE5c+/3H5oT2X9JDcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRbWJcZJodEsVxgF7Rk2bAxjwsBb2yaWNzkcsKyBjdcCv4lvkql71Shn0G4IflM5e
	 B4pF47NtmQ0Lqjy8MxAnH6UiOchFVdHDvzoxKFbkuylpYC2lJhvofmtyt5UC4hyyoG
	 CG4AEIVnEaAzv7V3+lxsGCWD2hzRS7HXowPRDXBU7LMobDh14i+QMWW/+AtmpH74KS
	 KWUN++g3jD2NCa2j9PyYEFtapLJair7vrHwfiXUIn7zu5hodTe+kP4zk6zg/6VX1DL
	 QobnI3nxA0qCENn67XAbKkgU678ZTVwGEszLLP+UhHASqPRNc8V9AyeLdih/FRxcHt
	 5gbUPhf6xfePg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de,
	dlemoal@kernel.org
Subject: [PATCH 4/4] xfs: opencode xfs_zone_record_blocks
Date: Tue, 10 Mar 2026 12:55:07 +0100
Message-ID: <20260310115555.114197-5-cem@kernel.org>
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

We only have a single caller, no need to keep it in its own function.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_zone_alloc.c | 30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 97149bfc2512..7d712d5a5ce0 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -201,27 +201,6 @@ xfs_zone_inc_written(
 		xfs_open_zone_mark_full(oz);
 }
 
-static void
-xfs_zone_record_blocks(
-	struct xfs_trans	*tp,
-	struct xfs_open_zone	*oz,
-	xfs_fsblock_t		fsbno,
-	xfs_filblks_t		len)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_rtgroup	*rtg = oz->oz_rtg;
-	struct xfs_inode	*rmapip = rtg_rmap(rtg);
-
-	trace_xfs_zone_record_blocks(oz, xfs_rtb_to_rgbno(mp, fsbno), len);
-
-	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
-	xfs_rtgroup_trans_join(tp, rtg, XFS_RTGLOCK_RMAP);
-	rmapip->i_used_blocks += len;
-	ASSERT(rmapip->i_used_blocks <= rtg_blocks(rtg));
-	xfs_zone_inc_written(oz, len);
-	xfs_trans_log_inode(tp, rmapip, XFS_ILOG_CORE);
-}
-
 /*
  * Called for blocks that have been written to disk, but not actually linked to
  * an inode, which can happen when garbage collection races with user data
@@ -252,6 +231,8 @@ xfs_zoned_map_extent(
 	xfs_fsblock_t		old_startblock)
 {
 	struct xfs_bmbt_irec	data;
+	struct xfs_rtgroup	*rtg = oz->oz_rtg;
+	struct xfs_inode	*rmapip = rtg_rmap(rtg);
 	int			nmaps = 1;
 	int			error;
 
@@ -310,7 +291,12 @@ xfs_zoned_map_extent(
 		}
 	}
 
-	xfs_zone_record_blocks(tp, oz, new->br_startblock, new->br_blockcount);
+	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
+	xfs_rtgroup_trans_join(tp, rtg, XFS_RTGLOCK_RMAP);
+	rmapip->i_used_blocks += new->br_blockcount;
+	ASSERT(rmapip->i_used_blocks <= rtg_blocks(rtg));
+	xfs_zone_inc_written(oz, new->br_blockcount);
+	xfs_trans_log_inode(tp, rmapip, XFS_ILOG_CORE);
 
 	/* Map the new blocks into the data fork. */
 	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, new);
-- 
2.53.0

