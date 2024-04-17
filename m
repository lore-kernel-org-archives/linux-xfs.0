Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B0B8F4A
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389329; cv=none; b=OawhVPSGsnFuOYrxhFSmy1t8Z58rD/pz7re0HA8O7Byugjg+xkt5EezKiY49m82lKrRSQsgFj2gWZCl3E02g+p56zfLAV2kRjV78Q8aR5lHPp5SfYoLI7wCkPYTJe4aV2ExTSgYlaZGOtBilxIh9evFMVrF8JX8eeG8fPfUaDj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389329; c=relaxed/simple;
	bh=yjQ8V51bV2XjCGtJ7OdzPS1KWe9EZHBoArmzUfyCyfc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nEZAbAf1VQY+r03wxC55L5q4EzoF/SVVwAhMd0J8pXyJsW7EX9NB7n5INcfEQgH9qz7NYcVg/P39A3kqphs1iNG157cLJw4MPXSwkc4p1xJGT9n/nY4RGusEtLDXCnndfCUgvkbL6EXFf2bDuAXqupIiTd5Y+TPD8NvADU6JdAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BZtRxiEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BZtRxiEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92376C072AA;
	Wed, 17 Apr 2024 21:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389329;
	bh=yjQ8V51bV2XjCGtJ7OdzPS1KWe9EZHBoArmzUfyCyfc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BZtRxiEtYC8XRapmFBVfDWPyFxJ4NocHWHFb3ZApjAwB0/NG3tf/7z5U4kjAI+fp9
	 CfDnenJRsZWwyZyIMne7vEchZ9YSf2nqy8TyjhjfqDHhPdLDmEGzP9z33E9knlw7le
	 Rqhr0I6po4Jujm/oSouHZ5Ii02yD4gGi0fZCeFPQynzD9b876x2vk6f4ApoGff1C2L
	 zKNgMIPWtUYNr0s4QPogjHw7GesJMCuf4e+hLovM8KKqSBuaFP+/LpWJvLc9yP4kDt
	 GZjGMH7d6UHPkeUpHhSLsqmn98ljHAl2xzDbTv6KwXotr7JghsTiB3lq2Lix9TuDZI
	 p92/DrouWzpwQ==
Date: Wed, 17 Apr 2024 14:28:49 -0700
Subject: [PATCH 27/67] xfs: pass the defer ops instead of type to
 xfs_defer_start_recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338842745.1853449.14602549402170481771.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_defer.c |    6 +++---
 libxfs/xfs_defer.h |    2 +-
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

