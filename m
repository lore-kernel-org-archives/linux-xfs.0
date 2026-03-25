Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D493E9580
	for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 16:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774456414; cv=none; b=oX52qL1mLyDTz6ZCuQYb3rforr9n84m2Gyi60Ys/uOSFKZeGQBG9OcCBoASm1ouqHu3VTZaC7UZpRIpXpTWjy+rSqlUJTcfbO8FbWb+8r7g2THY8q96QYoDN77W/QO8xEXRDT3hcAp6K6QkCHxrGhMQkN6r1pavUgiojXs0BUMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774456414; c=relaxed/simple;
	bh=abDGi10TzrACksgz184ywKsugMsSOMLl0JHnyc55lOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=asxZGw7SU7VM7AtZ7iXFohbn7SbRBAq4GMN1KwAuuZEFYutcAkkE6QJhbomEitzF0UuumhCTZt+lJDLl86CzF1ZvAiSgES4SdzNDJGM8a4vqVeouZf551KbENzEbajfUZugcxrx1SwtmdekpM2koa8GyrIUaSrCdj//ed+ZECpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=puVLzkis; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="puVLzkis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99170C4CEF7;
	Wed, 25 Mar 2026 16:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774456413;
	bh=abDGi10TzrACksgz184ywKsugMsSOMLl0JHnyc55lOY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=puVLzkisJ/6g07DQ5W/AwDGSIRX3Oe5PYQSvEjU9ufeO3Zpep0Pa+gTgp/x8EkxIH
	 Mm8zH44qu0JTXcu1ziBjM9+9X58uuRgN0zJS/DBeHzyi/7qXrngx7Qp56+0Dh45XOG
	 2T5h2eq/kUijVTG7UQBWznF+CpQIayjAS69T0howypPn9Zh0RmC9Hrs7/ISM4RRvgU
	 lgpwg6aOEbA9svl7WLgx81Y999APZvqcJ2T1Kcwa1Bcu6ceMSmCBTXXNXOSEU/y+X4
	 ZmeXALO9Ec4Ohc7SMBjtZJdih4LNRLjFb4Mjc3mmuAyz2wOVfdXSPQHnIaGVCQfo5w
	 zPFgEwsiVtmlA==
Date: Wed, 25 Mar 2026 09:33:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH v1.1 02/40] libxfs: port various kernel apis from 7.0
Message-ID: <20260325163333.GY6223@frogsfrogsfrogs>
References: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
 <177429120775.2266274.16124276962731944084.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177429120775.2266274.16124276962731944084.stgit@frogsfrogsfrogs>

From: Darrick J. Wong <djwong@kernel.org>

Port more kernel APIs from Linux, as of version 7.0.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
v1.1: add rvb, clarify the commit message
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
