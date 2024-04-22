Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF69153803
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803953; cv=none; b=NjuZwfUQhTOoewuP5twZuemTxDlaxCTGwDf7cCQ2hU2wdXd61htq3e4RWR1aJBtN6FD0m4kQAk5e6jJSLZRQrvav8JMueh/JN/m4au/6P2Ggc6NzYiq+T+IaOFiX9fngAzj+46WgV3cCeEBue8ElueLexZ0REoFM4VqSy/MD7TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803953; c=relaxed/simple;
	bh=bdA/ao3InQv5eRhL8YMt8R7khrzhuOYrWNGIKFzpDS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LT9BWpCNfvS3z8ea92fTJLWBvfzrTNYf0IotcZNFz5io/ZQk/Bw+HJIaOaFJd5KBed+AIf955QpQ3iuznkddcCwGiD1impv7DYzUPwkSyVouK2feb0WplnYICZXha583TOt+FLdIb7wfCzl7OwkMwTMfLyRIELjepJJct5cuebg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DaRBmyWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DaRBmyWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DA5C113CC;
	Mon, 22 Apr 2024 16:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803952;
	bh=bdA/ao3InQv5eRhL8YMt8R7khrzhuOYrWNGIKFzpDS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DaRBmyWOUn8mdkxdKmGHbYJ1iZIW7vlcZjcte5Dta7uZoz7yLmT/Pn2OLnpungDIc
	 8Cmh2qViDZDz28Ed7yJrN6iL5QJ9cJXhMHBvhBPW0HJcdNQPVwpvp/W244gPn/rmt/
	 tT6vLpb2Mu6LkXcgZXTr3OuGiGtlts8OounG5djo14xcw8Rp2Gn/82hUDqpl4HDf/k
	 x8zX8nWpt8Jsw1l8Qkc/Gg1CqthV536+8M9WBgBtUXilGm0R5aqLVVrTCd+Af8B0ri
	 vH2HzhOxc7hn0bg5X4g07Uma1XjI0qageWs+uISFq/FY8cBK1sfCtW9o/9OuG9tdeD
	 MoG70QlEgsHRg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 03/67] xfs: use xfs_defer_finish_one to finish recovered work items
Date: Mon, 22 Apr 2024 18:25:25 +0200
Message-ID: <20240422163832.858420-5-cem@kernel.org>
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

Source kernel commit: e5f1a5146ec35f3ed5d7f5ac7807a10c0062b6b8

Get rid of the open-coded calls to xfs_defer_finish_one.  This also
means that the recovery transaction takes care of cleaning up the dfp,
and we have solved (I hope) all the ownership issues in recovery.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c | 2 +-
 libxfs/xfs_defer.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 4900a7d62..4ef9867cc 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -479,7 +479,7 @@ xfs_defer_relog(
  * Log an intent-done item for the first pending intent, and finish the work
  * items.
  */
-static int
+int
 xfs_defer_finish_one(
 	struct xfs_trans		*tp,
 	struct xfs_defer_pending	*dfp)
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index bef5823f6..c1a648e99 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -41,6 +41,7 @@ void xfs_defer_add(struct xfs_trans *tp, enum xfs_defer_ops_type type,
 		struct list_head *h);
 int xfs_defer_finish_noroll(struct xfs_trans **tp);
 int xfs_defer_finish(struct xfs_trans **tp);
+int xfs_defer_finish_one(struct xfs_trans *tp, struct xfs_defer_pending *dfp);
 void xfs_defer_cancel(struct xfs_trans *);
 void xfs_defer_move(struct xfs_trans *dtp, struct xfs_trans *stp);
 
-- 
2.44.0

