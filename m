Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F662EB11
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803989; cv=none; b=C3J0uHDpUY5xPkF0LHhKLLGgsLrtdJk/U2tns7ud0o1RIBwakXmDX0RDeY8C5n3v99FGm1V5QvXQiYBt2oGBvZ91YObYI84Wrn8hO/uQEfp/44SAAK1c1nU24l0piMNFNylVb6Z4T5tdbtDpYh4kL5Bq76A3x5msf1ciSNBvDtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803989; c=relaxed/simple;
	bh=AI59iQzEZ+B9kXgW+eKlfBTqice+eI8bN3YrL77T8Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDncr8xKD4kIIeinIjVn5IT6gPGZOMb4V6KSMDee8ja8dneFLZT/OArenPyCME+f7YL2R67M8AsAvlowDS4aAUzfY8kiURXxBozyOD34IMooQf7qE8HhGIblG2sJsPh5SfdJCpNiSVcfOH3k3XUN29lnvZ9V5ZxvAWetKvM1N7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NQH0+IoJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NQH0+IoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703BBC113CC;
	Mon, 22 Apr 2024 16:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803989;
	bh=AI59iQzEZ+B9kXgW+eKlfBTqice+eI8bN3YrL77T8Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQH0+IoJ5B+2RtS+2/BPCQ4dsr6HWRHhS4O5DptWVxxkaGcTKGSHDz3oRPFADATAI
	 AlSxh+6DMBw67KROLHL2wFEyr4nIBVmvQ8g/Hg+Cf8ekdE1Et7nhqENnZsVNCX6uVl
	 2vB7FqtwOsmbhObK37yRoDuxJeg09pEricDVHfl0DxtALN9ofkHVYCi8BWiCXxyQ38
	 LBD/sHryVA/wvxRST0OzRSP/dblyWGSYdMYfZJ+ujGq0bhH14SeEvYWoOBg6/v2YmA
	 EXwiqnz6FB7+x3s03D7saAr6Mg/f4HYl4IUtQ/V9DhvCbzhOEKOGKqKhlHGVRQlL8P
	 lyGdMHVeouaSA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 27/67] xfs: pass the defer ops instead of type to xfs_defer_start_recovery
Date: Mon, 22 Apr 2024 18:25:49 +0200
Message-ID: <20240422163832.858420-29-cem@kernel.org>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: dc22af64368291a86fb6b7eb2adab21c815836b7

xfs_defer_start_recovery is only called from xlog_recover_intent_item,
and the callers of that all have the actual xfs_defer_ops_type operation
vector at hand.  Pass that directly instead of looking it up from the
defer_op_types table.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c | 6 +++---
 libxfs/xfs_defer.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index bb5411b84..033283017 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -888,14 +888,14 @@ xfs_defer_add_barrier(
 void
 xfs_defer_start_recovery(
 	struct xfs_log_item		*lip,
-	enum xfs_defer_ops_type		dfp_type,
-	struct list_head		*r_dfops)
+	struct list_head		*r_dfops,
+	const struct xfs_defer_op_type	*ops)
 {
 	struct xfs_defer_pending	*dfp;
 
 	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
 			GFP_NOFS | __GFP_NOFAIL);
-	dfp->dfp_ops = defer_op_types[dfp_type];
+	dfp->dfp_ops = ops;
 	dfp->dfp_intent = lip;
 	INIT_LIST_HEAD(&dfp->dfp_work);
 	list_add_tail(&dfp->dfp_list, r_dfops);
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 957a06278..60de91b66 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -147,7 +147,7 @@ void xfs_defer_ops_capture_abort(struct xfs_mount *mp,
 void xfs_defer_resources_rele(struct xfs_defer_resources *dres);
 
 void xfs_defer_start_recovery(struct xfs_log_item *lip,
-		enum xfs_defer_ops_type dfp_type, struct list_head *r_dfops);
+		struct list_head *r_dfops, const struct xfs_defer_op_type *ops);
 void xfs_defer_cancel_recovery(struct xfs_mount *mp,
 		struct xfs_defer_pending *dfp);
 int xfs_defer_finish_recovery(struct xfs_mount *mp,
-- 
2.44.0

