Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCFDBE48
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iog29413"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C6BC433C7;
	Sun, 31 Dec 2023 21:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059027;
	bh=OBdZwihqhn+djwnQUW04n8XzBZHvn1G+/5dh7miHgNk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iog29413zUr7KTqEuiFodlAN/GXx4UhjERSD6x98svhwVocLSQ09SwOA/z1v+xDbd
	 xmEEPkM7/tssq3Q6UadOSXyj7C9z+R7MbkS2S9egaoYKTWPqujcdV9j+FWwIuQnb63
	 7gswKfrKa26D5BZYnZYIfTa9vfM6th8OAxL1pN50oSFDLeWiOZnCiR/4m+GP6DLtZe
	 pP60IoGa3wVp7v5GvU76UDjaJgGginr7382SHsmcCUnBEeSwMbL/xK1UIMZyh3QMwV
	 K5ohBi5xxv87z8fCXP9QCuE/HO6r9RewnayoorAg26Bowwp1t85TCyHg4LbWiGc81/
	 lkoGyD5ijnV9Q==
Date: Sun, 31 Dec 2023 13:43:47 -0800
Subject: [PATCH 07/10] xfs: reuse xfs_refcount_update_cancel_item
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851006.1765989.13727370608189862987.stgit@frogsfrogsfrogs>
In-Reply-To: <170404850874.1765989.3728283509894891914.stgit@frogsfrogsfrogs>
References: <170404850874.1765989.3728283509894891914.stgit@frogsfrogsfrogs>
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
 fs/xfs/xfs_refcount_item.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 652507c61573b..4113100dd1e5b 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -335,6 +335,17 @@ xfs_refcount_update_put_group(
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
@@ -354,8 +365,7 @@ xfs_refcount_update_finish_item(
 		return -EAGAIN;
 	}
 
-	xfs_refcount_update_put_group(ri);
-	kmem_cache_free(xfs_refcount_intent_cache, ri);
+	xfs_refcount_update_cancel_item(item);
 	return error;
 }
 
@@ -367,17 +377,6 @@ xfs_refcount_update_abort_intent(
 	xfs_cui_release(CUI_ITEM(intent));
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
 /* Is this recovered CUI ok? */
 static inline bool
 xfs_cui_validate_phys(

