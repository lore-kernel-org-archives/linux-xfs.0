Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D5115098E
	for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2024 06:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723444369; cv=none; b=B7AwakMv7uLsIKtSm/jatHyeeP0w/1rhTzg/RnkTK9xGyw/6GeNXFFtS6Mr329v5BRBZNQPQrgpD5Z1Qe6GahtaD2lOZ9qeh3oDxaQ4tUHMPMzQJbJIdER3qGCU4jA4IMxDj5g3fBX3vs/YNUCdjcP115SMUsPLeKQMrAEnpvtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723444369; c=relaxed/simple;
	bh=jZkXPLR7DVlQa3QZyd8cAT+BqJMsXp43O4ht54FD728=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4QEAmjuBs/+SenBDa1ha0+wCB7T5L7fs3JMZkX5MxUh3RhRJ6H4yQMfLFbil2fEhIlUR0A669lnoW2ik480AP1BVhXHsHNUZXt+X3cmxRIgmi/+N422E03o26J2+B5uEnJ/gh2qp9QlRnZtWWdOMlNDsLvkG2HLKWlZmOt+6to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jthS7VGu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jthS7VGu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EZUHvCtJVPrlKrRPQJDdPVm5IjZscNg9uEKZZius/Vw=; b=jthS7VGudGJ61WUtTjNTS80hyO
	SvRxTu+M7epD0B+Dffv8kKG3kp4QhqOEUQsD4Nz6cLTU6Vr4Wuq/TCB/6kL5SplfRUTq5b2tkFb8v
	MwQi6YOjO1SBunsx/15/trBzpEiGsUafZD/d5XCcQGPib5o0N9hsUMF5CKVtA/Z8b30ws2GoMFKeF
	KOwKLRK4ND1A4vlGdqtopzuESVMSRAuLSuP+lqc8lM6pMDu3cIABCFmQPITyDF8j55bwtxS79fDeE
	yOsOSirIVTtpeQLRfoORSlGtEpxsjy0U7bMp4/yV90jhHO8JT8a93YXzpjgLs739kn3aY3vx0jDuH
	aYPNaGKA==;
Received: from 2a02-8389-2341-5b80-ee60-2eea-6f8f-8d7f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:ee60:2eea:6f8f:8d7f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdObn-0000000H1dv-3Ocr;
	Mon, 12 Aug 2024 06:32:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] libfrog: add xarray emulation
Date: Mon, 12 Aug 2024 08:32:28 +0200
Message-ID: <20240812063243.3806779-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240812063243.3806779-1-hch@lst.de>
References: <20240812063243.3806779-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Implement the simple parts of the kernel xarray API on-top of the libfrog
radix-tree.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/radix-tree.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/libfrog/radix-tree.h b/libfrog/radix-tree.h
index dad5f5b72..7436b1337 100644
--- a/libfrog/radix-tree.h
+++ b/libfrog/radix-tree.h
@@ -63,4 +63,34 @@ int radix_tree_tagged(struct radix_tree_root *root, unsigned int tag);
 static inline int radix_tree_preload(int gfp_mask) { return 0; }
 static inline void radix_tree_preload_end(void) { }
 
+/*
+ * Emulation of the kernel xarray API.  Note that unlike the kernel
+ * xarray, there is no internal locking so code using this should not
+ * allow concurrent operations in userspace.
+ */
+struct xarray {
+	struct radix_tree_root	r;
+};
+
+static inline void xa_init(struct xarray *xa)
+{
+	INIT_RADIX_TREE(&xa->r, GFP_KERNEL);
+}
+
+static inline void *xa_load(struct xarray *xa, unsigned long index)
+{
+	return radix_tree_lookup(&xa->r, index);
+}
+
+static inline void *xa_erase(struct xarray *xa, unsigned long index)
+{
+	return radix_tree_delete(&xa->r, index);
+}
+
+static inline int xa_set(struct xarray *xa, unsigned long index, void *entry,
+		unsigned int gfp)
+{
+	return radix_tree_insert(&xa->r, index, entry);
+}
+
 #endif /* __LIBFROG_RADIX_TREE_H__ */
-- 
2.43.0

