Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72372BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gfo1qb5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B86C433C7;
	Sun, 31 Dec 2023 20:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054130;
	bh=HFLbQBzSGL6NnQdMDztJXdFvKFA92AOmYtB+YK1mbE8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gfo1qb5bVuxAsakqIsyuEMSqsI9eHyLDXx0/mKuXiAsHBreKAVp6+E5+rksf14zbN
	 NGbaQhDKvytvDvV3DilCQxNJ8/6xVLoIPoI9fcWfbsBuOuBszsufVnoDSuFz0zzKOU
	 3FZHTHsy+FzCWZV6zqi3tWcVp1hBq6d7WVmT446Ed9HaHKpZXFAkcB4VDR3da7GcPp
	 mDqveturjzas2S0v6qe8OiKc9zjW6FsLnokKfkaBI2itmhgHE2IqlV8htSSfvvFzSE
	 Vh/IY4f1AyrkJ9fPRJCPkmeqvU44dl+T9Df5oDPEeukppxkafsPq5kB2zzkwiAYDRn
	 BJcMGrNKgMOKg==
Date: Sun, 31 Dec 2023 12:22:09 -0800
Subject: [PATCH 7/7] xfs: add a xattr_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404831535.1749708.14746477172224685881.stgit@frogsfrogsfrogs>
In-Reply-To: <170404831410.1749708.14664484779809794342.stgit@frogsfrogsfrogs>
References: <170404831410.1749708.14664484779809794342.stgit@frogsfrogsfrogs>
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

Add a helper to translate from the item list head to the attr_intent
item structure and use it so shorten assignments and avoid the need for
extra local variables.

Inspired-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 9e02111bd8901..f8c6c34e348f3 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -391,6 +391,11 @@ xfs_attr_free_item(
 		kmem_cache_free(xfs_attr_intent_cache, attr);
 }
 
+static inline struct xfs_attr_intent *attri_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_attr_intent, xattri_list);
+}
+
 /* Process an attr. */
 STATIC int
 xfs_attr_finish_item(
@@ -399,11 +404,10 @@ xfs_attr_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
-	struct xfs_attr_intent		*attr;
+	struct xfs_attr_intent		*attr = attri_entry(item);
 	struct xfs_da_args		*args;
 	int				error;
 
-	attr = container_of(item, struct xfs_attr_intent, xattri_list);
 	args = attr->xattri_da_args;
 
 	/* Reset trans after EAGAIN cycle since the transaction is new */
@@ -443,9 +447,8 @@ STATIC void
 xfs_attr_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_attr_intent		*attr;
+	struct xfs_attr_intent		*attr = attri_entry(item);
 
-	attr = container_of(item, struct xfs_attr_intent, xattri_list);
 	xfs_attr_free_item(attr);
 }
 

