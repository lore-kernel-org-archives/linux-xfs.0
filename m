Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96056B652
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295205; cv=none; b=uTxMSHQS/aFpnA5FCeQMdMjWzObBWseirheUUoEfh/AlJgnGmbSoYXbUjd6Lr/q0ERpkBYJ02g5E9TsQGordFwlpgHsgN7uN3fqCAeCAlw6LxGmOmLslYkFOcZOcT6q/A0752btsGvKaYKF2MlbmdHBAe/JJBFDfMKArTbsn5TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295205; c=relaxed/simple;
	bh=/w/dr/ffKKTv5hz0j62vKKDB6wimBxeXPYFVaFxsasI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=skRT6dNy20ux7ZB9N9bTa5mbvCbV5NLahgGUuVGMqgh5CX9Qprbsf9tip6nvZlGf843b+JXr1ig1kPJlmQ6kPzWoCz+SCtgkqn65dKe66dsT15fUft59og6Y41m8HYCNIP+sL1r4XVlhedw4q2uzTDFtDZZ5+z9oFpXBA1TXeVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mLOZb+uh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mLOZb+uh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B550C433F1;
	Wed, 13 Mar 2024 02:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295205;
	bh=/w/dr/ffKKTv5hz0j62vKKDB6wimBxeXPYFVaFxsasI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mLOZb+uheEVfH7XxUvjNVN6rp+KW98jEf00fhnrJBHKzkdrnzb6jqPqXVjVP63Eux
	 eFpsguoHIM9VSiNyP3cujnpT/89V6bKTKD/96T9gQAFQyC6mQ2DpXVeByuQeAKEDpH
	 2xJ5i91Zx5BYo0/JprOqDXqgHn48UVoH1KuVYd220Bxc5BoMdrk8/huSsq35XCMgfi
	 lUQlFja2KQyI+KlT1QvNPSbWfpxuqDY/lwORzFgarfemecDB5iMbdPA09wZtaGYYmK
	 8b8g/jxLtfZcGlUkUa8L1W2qKCDj/Q+dtIoJPGD1xA3K9drRFGevs9x1KYN50zSzBZ
	 sqKmDhe0Z4hCg==
Date: Tue, 12 Mar 2024 19:00:04 -0700
Subject: [PATCH 27/67] xfs: pass the defer ops instead of type to
 xfs_defer_start_recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <171029431583.2061787.7515895765301523262.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: dc22af64368291a86fb6b7eb2adab21c815836b7

xfs_defer_start_recovery is only called from xlog_recover_intent_item,
and the callers of that all have the actual xfs_defer_ops_type operation
vector at hand.  Pass that directly instead of looking it up from the
defer_op_types table.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_defer.c |    6 +++---
 libxfs/xfs_defer.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index bb5411b84545..033283017fae 100644
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
index 957a06278e88..60de91b66392 100644
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

