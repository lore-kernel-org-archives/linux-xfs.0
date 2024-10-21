Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366CA2CA9
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 21:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729547999; cv=none; b=JOUjAohNjS7u4mcVzm15X3h2xH8NE/vy7fNx+woMG18h5h+HqcoqiSgXBrkppA/KUoHmGLid5T7P+XD7lU5vyOZ85/duIIObPnjF+A4Lg++FMeFDLy4Cj0jgjCwhIj2BLk0NZy3HYaK0C1yW+HcivH7TEvbO7KxP7+RyHMgoTZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729547999; c=relaxed/simple;
	bh=p8s03YUPGL5T3AUYprap2ZNhUpLsCpMbOZdOciQjSvA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iHJr6a3Dt15roax9/b6OzygWfw0RxpqYAXrJ4TaeRHgVRFInjQh1dsBrxhwbrHl5cJNFLLYdw0ypXKC0mmgBnT48Kjna6eSM7e1sduPCS1ITkIR8ofGL07OaFUvAdLWO4esZdKw7vIJSbSW3TJC2tCjUTvXzVBs+91JoK3YyPTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XGTh92Lx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XGTh92Lx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8A2C4CEC3;
	Mon, 21 Oct 2024 21:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729547998;
	bh=p8s03YUPGL5T3AUYprap2ZNhUpLsCpMbOZdOciQjSvA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XGTh92LxSgd1XaSqNFpsmKXYBE29ZPdXpmGWPh4XdACDjyBbmMlETRlXXhL1kKWxA
	 3tZiMYtZJEddfdiiC+1oh6uQP1RIRoaDp+eBicQWNpMP9zVsOnWI1yVQs0nMedfcqH
	 7nq4X4yEH+9iSXBijWDyPvQQhaA/GF3vJLCBUP6IuewM79hNj7uj3Q/Z3f/eW1e4gv
	 EqD5lDVjgXeKavEer5lNZdqDkkoDuSRkD2q8op68ucaBj1YpT7XsbGXLro0EUUrhJ7
	 bG2Ko4031ytR/rMTzueNKqVgDaxy/V7jIHSHfhOPNkcD2ToaJAAAQKFVO5YtOWa2ei
	 jBCk8AXq1gSew==
Date: Mon, 21 Oct 2024 14:59:58 -0700
Subject: [PATCH 04/37] libfrog: add xarray emulation
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783532.34558.3574729108397726957.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
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

