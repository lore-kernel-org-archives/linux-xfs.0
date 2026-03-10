Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC683B6373
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 17:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773164391; cv=none; b=X+su6U7TPJJP5CiMnCcJV9AIrHe2ZHCDknXfvuoxhk0V0C4HKNeAlAwss1zGxFvchRBM3861LvV5DWdwEcAF9y/Bw01Pqw2QPj3HuCq5EINEfpp5nz547QpCpkU24KijaqcuQT3cFmOi1zQ+AxJ+u9kw6r7eCXdAYQd51nmmNYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773164391; c=relaxed/simple;
	bh=jA5pFCfW8hJaq15EQauV4B30iajeorI8AYd48H2r2pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpCqQLvVmO36qcOjPa2HQVeI9PzM7kYxUsRQXPVmySZXJsQcenfehUgE3kSNpz1Je78RekNzY3yxo3WhxLB9DhFjIdA5X6EVc6M4kXVJIPnNIVLWj6ffo1GKJei8poRizp5XdCEsuolc/vYJJnopzmKzQdv671xzqCHUzG/yeJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VNkuZ01V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VNkuZ01V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC26C19425;
	Tue, 10 Mar 2026 17:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773164391;
	bh=jA5pFCfW8hJaq15EQauV4B30iajeorI8AYd48H2r2pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNkuZ01V/QLNp12oyK3cDtCwdZRE+9kyr7EEsDCFJpIkmGfsYwVCLiJyl4BXCH9V+
	 Na2v2B69CdMwLOEt8Hg5ckMo1PE7S3+6a8B3zDS3FqE/7b3TDml6rm1WUaLgKq04Lb
	 jYtuGlPidpDG5MlblNR6hFIHai7YWmYjd2zNdaYb1/lW5LlcmPb/rQ8f3Z1JZQo96a
	 JfnbNhQZSOsP+YYyhOvo7jNGUixbO5QA9ak50j2mCVoFHxR5yu4fpPN7rvQ/eZ5GuV
	 lwAt4vB1Z6b3RNsQzTkcN0Jju5EIRGdLun4KNVZywsgixD7zJ/PZ4bAkMwXLiNg799
	 DerLFvGi0d/Kw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de,
	dlemoal@kernel.org
Subject: [PATCH v2 4/4] xfs: opencode xfs_zone_record_blocks
Date: Tue, 10 Mar 2026 18:36:49 +0100
Message-ID: <20260310173709.457047-5-cem@kernel.org>
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

We only have a single caller, no need to keep it in its own function.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

---
v2: add RwB tags, no changes

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

