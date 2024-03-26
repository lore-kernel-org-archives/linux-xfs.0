Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A169128392
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422593; cv=none; b=TBN4ANShD/HTJZIACQu7VyMw2rZjcIg/6sW2eBEb20LPRTLYUeWv+kkXUwxEQ/zvhIUtn3p2TQBIlVJoT4sa6R7VWrhDqrsNZYpoNLowu1+KhDZUJZCquGL/o6wEUzdOVDMDMb2c0QSdobC8+B56fKlAXy2denZatmb69iGD/jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422593; c=relaxed/simple;
	bh=4vTPY0cFNGhHGEpHPudrEF1T4xP/AcTnd+7DheJO8g0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SQUO+oM4IsbFEYZx7G0tkU8DNzjmneqSie9nddl7HfNld7ZpajiOjmqmZUjskNAZNGiUX4qBurjRc67pzD3zJMnLhmvCcUQQp80uh0HDSFPjGgD+c0u9+kog5ev2CKPNRBZV+vSYaQ5yQLX8+XOaXHMYLyOgodoEghpMGviVv5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UtpIaclV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UtpIaclV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C6CC433F1;
	Tue, 26 Mar 2024 03:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422593;
	bh=4vTPY0cFNGhHGEpHPudrEF1T4xP/AcTnd+7DheJO8g0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UtpIaclVR3JCkwkUQmE5Pxaw2EKm66DemcctRDme1HUEzsLetFPHcWh7eMfdoKOar
	 AVIeDsSaamMFqGS/iTR3/m4yYixUsR011I2/v+OJVi7aAYB6oVQiT2XQj9HpVTXfp/
	 j9ONuoFMcvZxaJTlJ3aPNt2iIczwZa7V9zFZSPaRL3ky0EV7WE6GSxmDOh1wicj4nW
	 +wXK+KmrhcZVN2H+xc0os9jLwnJIqHE6vcSmJmaz4OC5MU3I4bdCiTmo1erLWFl8vG
	 rW2IKO2CgjcgyDok//aKo1/8f+f7jCbceMM+5ijRYHEl/hP/JwwjLuKp2g3/DYI8/L
	 IpDDhN6qjbjOg==
Date: Mon, 25 Mar 2024 20:09:52 -0700
Subject: [PATCH 27/67] xfs: pass the defer ops instead of type to
 xfs_defer_start_recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127351.2212320.14427128839924353240.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

