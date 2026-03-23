Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249433033EC
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291309; cv=none; b=K1B2YtZH3hdHs5xSeES4SOWluOvR9sW7Z0ESLP8bRD7HnZqH1V+ZE8l77An9VRmNoQJ3YzoMfoNMXxTrYwkwshE6FhcDDPVF//A7StJ7P6BMh+WIypHXY+UiCMa1qu9pexBCl7lwWQCPwS7u+u6B0rj92Pf9I70ExPtCDCqRd2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291309; c=relaxed/simple;
	bh=ZbCepsLlGUl9t+ND6H8Uokz8XN/xbQmqng8xHBY74tc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WNdWJQVbJ2rY2Oycy5Oiqd82talX9EXJWD4eEpW3oiDALsLcMxK2AxJrYJFnHzgqJKhuDA0awpgcKfDs+Iy6oFlGs92/lYd7OjLWhF6DcSrEPQFxA5nYa9rRKb6gNkn5VRewokbKpIkRyJbVbWJdxDhoVWlmpH7UQB/+af0ZWss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LegtwnGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LegtwnGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63FFC4CEF7;
	Mon, 23 Mar 2026 18:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291308;
	bh=ZbCepsLlGUl9t+ND6H8Uokz8XN/xbQmqng8xHBY74tc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LegtwnGGZxCyXFn2OsMZ3PyLZi7+cRqdP9cUF4YAV9YUhI7yYhOC/aeMfq3+Jr3++
	 av45zqHBBdMceRX6eUmHE8P4hwxYKEzeJc0TG9Dk2dheChkHybSS6PuGGJH7XYMI4F
	 /vG5ZsKmX4hN14blS2Ni5rFqqQB4wClp0VvsUnyJZZiNn8VXxAU/Xh5S7+qAD1y249
	 eQahwddJyUCaDu1T2ZcN/dzewsVCXjPMko/9+ekHPFNj+wSIjvTINYVcK4K/EvrmjB
	 KNayzxihlT25dSNHp4nDh7dk0clxSZgD2my4MJ6p5nNhrKFWzStq4pmuzO9Y8Zz7Al
	 f0oVOtYOB1MBw==
Date: Mon, 23 Mar 2026 11:41:48 -0700
Subject: [PATCH 02/40] libxfs: port various kernel apis from 7.0
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177429120775.2266274.16124276962731944084.stgit@frogsfrogsfrogs>
In-Reply-To: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Port more kernel APIs from Linux 7.0.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 include/kmem.h |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)


diff --git a/include/kmem.h b/include/kmem.h
index 66f8b1fbea8fdf..2c276e929c4808 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -61,6 +61,56 @@ static inline void *kmalloc(size_t size, gfp_t flags)
 #define kzalloc(size, gfp)	kvmalloc((size), (gfp) | __GFP_ZERO)
 #define kvzalloc(size, gfp)	kzalloc((size), (gfp))
 
+/**
+ * kmalloc_array - allocate memory for an array.
+ * @n: number of elements.
+ * @size: element size.
+ * @flags: the type of memory to allocate (see kmalloc).
+ */
+static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
+{
+	size_t bytes;
+
+	if (unlikely(check_mul_overflow(n, size, &bytes)))
+		return NULL;
+	return kmalloc(bytes, flags);
+}
+#define kcalloc(n, size, gfp)	kmalloc_array((n), (size), (gfp) | __GFP_ZERO)
+
+/**
+ * size_mul() - Calculate size_t multiplication with saturation at SIZE_MAX
+ * @factor1: first factor
+ * @factor2: second factor
+ *
+ * Returns: calculate @factor1 * @factor2, both promoted to size_t,
+ * with any overflow causing the return value to be SIZE_MAX. The
+ * lvalue must be size_t to avoid implicit type conversion.
+ */
+static inline size_t __must_check size_mul(size_t factor1, size_t factor2)
+{
+	size_t bytes;
+
+	if (check_mul_overflow(factor1, factor2, &bytes))
+		return SIZE_MAX;
+
+	return bytes;
+}
+
+#define __alloc_objs(KMALLOC, GFP, TYPE, COUNT)				\
+({									\
+	const size_t __obj_size = size_mul(sizeof(TYPE), COUNT);	\
+	(TYPE *)KMALLOC(__obj_size, GFP);				\
+})
+
+/* Helper macro to avoid gfp flags if they are the default one */
+#define __default_gfp(a,b,...) b
+#define default_gfp(...) __default_gfp(,##__VA_ARGS__,GFP_KERNEL)
+
+#define kzalloc_obj(P, ...) \
+	__alloc_objs(kzalloc, default_gfp(__VA_ARGS__), typeof(P), 1)
+#define kmalloc_obj(VAR_OR_TYPE, ...) \
+	__alloc_objs(kmalloc, default_gfp(__VA_ARGS__), typeof(VAR_OR_TYPE), 1)
+
 static inline void kfree(const void *ptr)
 {
 	free((void *)ptr);

