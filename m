Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BA0C12B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xcyo7yHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F96AC433C8;
	Sun, 31 Dec 2023 22:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061451;
	bh=I2CS/7/Pn+QOpaoI8a/Ez1zsyFfNB9NkkwEvGSwFET4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xcyo7yHVNoPNt6tlTTHLn2iiw6HzQzunH1lNp3a7S+bRBB7xMDapcOMBaUsYWXXWb
	 viwCYZcJY/jtObrkPTmW7ynpkUfV43Tx64G4x454Wx0+ZdBqX5RqQPwpYnJjHzs2Fd
	 QHztVWsAor1w1B0JDxZ62+4WCAH6zn83Ao7bAZUk0q1a5AmGhQXwrGuYu9rOdlHDlK
	 OKh+dDLh0tNzK3S4UUxcMiWMjrr+TLLt6ImjMjZjAirrpasy0bpFeLZphHc8jY07+9
	 frLt4MrC0KehnOld9bO/suAAmyAAS8ADDpbO2u0bO8NTeLs6D5ro+mjp1jLcFeuS4P
	 jFrUUvRiTMJGw==
Date: Sun, 31 Dec 2023 14:24:11 -0800
Subject: [PATCH 2/5] xfs: add a bi_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404994847.1795600.4860162700243104041.stgit@frogsfrogsfrogs>
In-Reply-To: <170404994817.1795600.10635472836293725435.stgit@frogsfrogsfrogs>
References: <170404994817.1795600.10635472836293725435.stgit@frogsfrogsfrogs>
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

Add a helper to translate from the item list head to the bmap_intent
structure and use it so shorten assignments and avoid the need for extra
local variables.

Inspired-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 014589f82ec..8e3ec056ed7 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -438,6 +438,11 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 
 /* Inode Block Mapping */
 
+static inline struct xfs_bmap_intent *bi_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_bmap_intent, bi_list);
+}
+
 /* Sort bmap intents by inode. */
 static int
 xfs_bmap_update_diff_items(
@@ -445,11 +450,9 @@ xfs_bmap_update_diff_items(
 	const struct list_head		*a,
 	const struct list_head		*b)
 {
-	const struct xfs_bmap_intent	*ba;
-	const struct xfs_bmap_intent	*bb;
+	struct xfs_bmap_intent		*ba = bi_entry(a);
+	struct xfs_bmap_intent		*bb = bi_entry(b);
 
-	ba = container_of(a, struct xfs_bmap_intent, bi_list);
-	bb = container_of(b, struct xfs_bmap_intent, bi_list);
 	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
 }
 
@@ -514,10 +517,9 @@ xfs_bmap_update_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
-	struct xfs_bmap_intent		*bi;
+	struct xfs_bmap_intent		*bi = bi_entry(item);
 	int				error;
 
-	bi = container_of(item, struct xfs_bmap_intent, bi_list);
 	error = xfs_bmap_finish_one(tp, bi);
 	if (!error && bi->bi_bmap.br_blockcount > 0) {
 		ASSERT(bi->bi_type == XFS_BMAP_UNMAP);
@@ -541,9 +543,7 @@ STATIC void
 xfs_bmap_update_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_bmap_intent		*bi;
-
-	bi = container_of(item, struct xfs_bmap_intent, bi_list);
+	struct xfs_bmap_intent		*bi = bi_entry(item);
 
 	xfs_bmap_update_put_group(bi);
 	kmem_cache_free(xfs_bmap_intent_cache, bi);

