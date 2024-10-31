Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5C4197A87
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416185; cv=none; b=YlBwBSmQaaq5TlBTqZg0wbycICFZsF11EYz1x2eM6ozej0guU0gWFvVqC3mdgjCbRSUVV82RcZOTp+vdSgW3wOHWhDpTZo+r9w2TfcAaSpyyzJe1RnbHDpy0PXeTpFTSkdjmwP7g3k3n2I9BnGr2vKY7c0yEyuj0+Pj35o4STAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416185; c=relaxed/simple;
	bh=p8s03YUPGL5T3AUYprap2ZNhUpLsCpMbOZdOciQjSvA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HXDs57PT52Zd0FBwA385cBU66eCQNVnpIGEQQjRRjzo0QT5X8ThpflPdmKX7UqZu4gNRB3utziXJ8zLxXuN7qMZOFOwdzhPdeSMZF9hRE66GlC+EKfe5fconC7y5DhdOzezXBiOspt8judZFx8WMbnFq1qafJuqHBs6YTdoWjik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hxZmlLBI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hxZmlLBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CD7C4CEC3;
	Thu, 31 Oct 2024 23:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416184;
	bh=p8s03YUPGL5T3AUYprap2ZNhUpLsCpMbOZdOciQjSvA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hxZmlLBIh1VBAdmySaoXNwGi1hn9ib8jaQCYYLQlNa+f82jDWECKtIZcMiMTeHL0j
	 J/fu7BiJE0z+KjK1fDGTkgF1iKrFjKhbTwzAWRFvx/qmSPKOImdTuUNi+tRY9elmT7
	 16McgonTkxuHMoiA0kuJ+ILAh8IBlsEAr8sSJFegI+mZeSGkFA+50LKXVsnk6a/thO
	 ukvofB6GtvWFWCrm7S59DSY7sW9XtAQU7lYP3dXlx9USWLumM6MNgjbsHnrZrcj+SJ
	 Wi0gVMoS2BvUATIeVYOC3RcF7un6NrPEWs85x8y9EdsBfXAH8LfQ9B7ffgCJxT5CvY
	 LPgaW2vkQmdmg==
Date: Thu, 31 Oct 2024 16:09:44 -0700
Subject: [PATCH 04/41] libfrog: add xarray emulation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041565981.962545.11363601112621213881.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Implement the simple parts of the kernel xarray API on-top of the libfrog
radix-tree.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/radix-tree.h |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)


diff --git a/libfrog/radix-tree.h b/libfrog/radix-tree.h
index dad5f5b72039e3..fe896134eeb283 100644
--- a/libfrog/radix-tree.h
+++ b/libfrog/radix-tree.h
@@ -63,4 +63,39 @@ int radix_tree_tagged(struct radix_tree_root *root, unsigned int tag);
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
+static inline int xa_insert(struct xarray *xa, unsigned long index, void *entry,
+		unsigned int gfp)
+{
+	int error;
+
+	error = radix_tree_insert(&xa->r, index, entry);
+	if (error == -EEXIST)
+		return -EBUSY;
+	return error;
+}
+
 #endif /* __LIBFROG_RADIX_TREE_H__ */

