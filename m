Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6507EF
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NHXGmUMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413A8C433C7;
	Mon,  1 Jan 2024 00:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068722;
	bh=JG7dtotQDby+Ur1obd3UEDnMjomEGO8/WvpNO296MlU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NHXGmUMDczF2hLTuTwftByuQ5pUKBKgLi7NoDP98mNIymNaA3fSfebcwMCHKnaQD7
	 kLe8xqDxS4d1oIWZnaXUMHBkZ+IcPbShDNhLStkyz+5+7hNFORmhf/UzQ70vgmpI49
	 b3KcBQps+yosKhvMHtBg5EE5ihRHA/syiAsuNMtkshMpCkNNHp/8/qOufT/b4vkVvw
	 SEO+sLNtqKw+jbCXJ8Dm3Lq5S/K8tumESQlQ3LagXJfghUeRnue4gWmcbZXlEUSXeF
	 8s0HvrU7NlxH4ORSCowa7/QIFoPNq4hW76FtHDtdMxSmduYGyA5V8f1Rt0qb6+ix/i
	 yd40xa5sNs5sg==
Date: Sun, 31 Dec 2023 16:25:21 +9900
Subject: [PATCH 6/9] xfs: reuse xfs_refcount_update_cancel_item
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405016700.1816837.13209062353123602860.stgit@frogsfrogsfrogs>
In-Reply-To: <170405016616.1816837.2298941345938137266.stgit@frogsfrogsfrogs>
References: <170405016616.1816837.2298941345938137266.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Reuse xfs_refcount_update_cancel_item to put the AG/RTG and free the
item in a few places that currently open code the logic.

Inspired-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 471e4f6867d..e056c3b449b 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -545,6 +545,17 @@ xfs_refcount_update_put_group(
 	xfs_perag_intent_put(ri->ri_pag);
 }
 
+/* Cancel a deferred refcount update. */
+STATIC void
+xfs_refcount_update_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_refcount_intent	*ri = ci_entry(item);
+
+	xfs_refcount_update_put_group(ri);
+	kmem_cache_free(xfs_refcount_intent_cache, ri);
+}
+
 /* Process a deferred refcount update. */
 STATIC int
 xfs_refcount_update_finish_item(
@@ -565,8 +576,7 @@ xfs_refcount_update_finish_item(
 		return -EAGAIN;
 	}
 
-	xfs_refcount_update_put_group(ri);
-	kmem_cache_free(xfs_refcount_intent_cache, ri);
+	xfs_refcount_update_cancel_item(item);
 	return error;
 }
 
@@ -577,17 +587,6 @@ xfs_refcount_update_abort_intent(
 {
 }
 
-/* Cancel a deferred refcount update. */
-STATIC void
-xfs_refcount_update_cancel_item(
-	struct list_head		*item)
-{
-	struct xfs_refcount_intent	*ri = ci_entry(item);
-
-	xfs_refcount_update_put_group(ri);
-	kmem_cache_free(xfs_refcount_intent_cache, ri);
-}
-
 const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.name		= "refcount",
 	.create_intent	= xfs_refcount_update_create_intent,

