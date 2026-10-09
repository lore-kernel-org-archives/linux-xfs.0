Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC1D2C027B
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589617; cv=none; b=oeF25th5Wr3kDXsqWzBT5uM/da5zuY/n8E+5vh+9cfjgWGLqEVbfxV/zhaC5x/TEns3Bg2Pw/fe7tVA1Hf1hcgsQa4j1dMMonVcLA6nQXCqzGrlzq1+QlqqKzAmWNDtPilfjeU7hKZwwrYK2V5AOmJr50rEq0HaWQaSwq7xky14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589617; c=relaxed/simple;
	bh=7dG0PlGM2bjY9tVZzx6KFxbXasdVr50vTbkxynhiTNY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fjV8y5fdKKyzxyMKYOz7Tw+eo/v/KyVq1BbVPp+mp8msih8wAZVipfMBKIu+pnHQZEiyVphzN4Hz4XUevRVaGFbP9gPXa+64Qcenob6exSEqjsa5MC9lFxw+3758xCyA8tVglYVw5BnHII6PCxtPEoldyDo4fmetoZ8zCMCT2a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E3oabB5D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E3oabB5D"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 850D81F000FF;
	Fri,  9 Oct 2026 23:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589616;
	bh=DVSsptezMWZW5O0Dq4eh3M3+Nc+pMV1YzNCOnX4V6jA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=E3oabB5D/mLS2jWin2VbD+Z2dM33knqo2omWTBY7qZjDJSYDf5ZzWrELUvxgbvLcv
	 gM9ylxgXpf3GDRqybur9P97JiRM3Vlg551YNgrUlxXB7teCNFKj+S9lPnD5eMIhYj8
	 K1dmsVfHLPm/DnnmL513H9qIOtya5t+JuGLfmC/tzt9BywaLBdSL98DuVia77Od4pz
	 mGDp4EI2bkxAMJWPABL6rCDejR8e65NhJJIUuVWLEqFHp7Ppn77hb+ZrtF3MhhPrZA
	 xd7XOCJLGp/gE+VS4vAVy1O+rHbiJZ67QncW1ZnNzHuQDBGsba9a9ArNdcoBpCIj6J
	 ohFJai+/rhz8g==
Date: Fri, 09 Oct 2026 16:46:56 -0700
Subject: [PATCH 05/26] xfs: use kmalloc_objs() instead of kmalloc() in
 xfs_da_grow_inode_int
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cihan.cihan@gmail.com, cmaiolino@redhat.com,
 linux-xfs@vger.kernel.org
Message-ID: <179158947460.3719791.2607446027583829528.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Cihan Karadag <cihan.cihan@gmail.com>

Source kernel commit: 56aa9ef3c413cb13a373226f91a19358cd9f1266

Convert open-coded kmalloc() multiplication to the modern kmalloc_objs()
interface to improve type safety and prevent potential integer
overflows.

No functional changes are intended.

Signed-off-by: Cihan Karadag <cihan.cihan@gmail.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 include/kmem.h        |   12 ++++++++++++
 libxfs/xfs_da_btree.c |    3 +--
 2 files changed, 13 insertions(+), 2 deletions(-)


diff --git a/include/kmem.h b/include/kmem.h
index 2c276e929c4808..4363601ff6820f 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -138,4 +138,16 @@ static inline void *kmemdup(const void *src, size_t len, gfp_t gfp)
 	return p;
 }
 
+/**
+ * kmalloc_objs - Allocate an array of the given type
+ * @VAR_OR_TYPE: Variable or type to allocate an array of.
+ * @COUNT: How many elements in the array.
+ * @...: optional GFP flags for the allocation (GFP_KERNEL when not specified).
+ *
+ * Returns: newly allocated pointer to array of @VAR_OR_TYPE on success,
+ * or NULL on failure.
+ */
+#define kmalloc_objs(VAR_OR_TYPE, COUNT, ...) \
+	__alloc_objs(kmalloc, default_gfp(__VA_ARGS__), typeof(VAR_OR_TYPE), COUNT)
+
 #endif
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 9f25f1658b07d7..b1cdb0ebece92c 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2352,8 +2352,7 @@ xfs_da_grow_inode_int(
 		 * If we didn't get it and the block might work if fragmented,
 		 * try without the CONTIG flag.  Loop until we get it all.
 		 */
-		mapp = kmalloc(sizeof(*mapp) * count,
-				GFP_KERNEL | __GFP_NOFAIL);
+		mapp = kmalloc_objs(*mapp, count, GFP_KERNEL | __GFP_NOFAIL);
 		for (b = *bno, mapi = 0; b < *bno + count; ) {
 			c = (int)(*bno + count - b);
 			nmap = min(XFS_BMAP_MAX_NMAP, c);

