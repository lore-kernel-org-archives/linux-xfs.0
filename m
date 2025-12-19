Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3661A76BB
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 05:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766122938; cv=none; b=gQ1FB6DgmpbL1VSWPO6aBgCa6KQ648z3XKX6onZfFBPVnVsVH1UE0t9gbS7jQYprXJu+6lDxvt4NBtkh8E3UT2IHo90dPbBu6n07eJI++gCJeZGtlMHKsrNFR682FsTz3R82KXVgPWsxKDEUFKdEVK3k0dLTAKa7ETpcBZ5NTO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766122938; c=relaxed/simple;
	bh=GndC6QNXSOTWzqX/285yUOAyD2tChsZejGTDn+siWo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDlinECPTwS7GYGk5hqcI4/gWNCEvCuOJ8vXpiQnBA5uOjnC3uAibNv0ecbkP+Sk1Zha61+/MxC+yLNTepRJ80qvUIntun5bwUZmoBSeneCU1rXYoxcE6XAhUqKEcVxqM0v6lIUw5qXeW/9681pLVlmCL2Hu4MN78ZnKx5Ufw38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oGwnAQXN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oGwnAQXN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gxiAFk+u1ZaFr7YsyGB/FPkgUgumpxpBNcy9Ewdu0yQ=; b=oGwnAQXN9Yjf+G0CcAB0Mr+TiL
	okDldnB5Uz9vphG+dDjjIsyVqxACeX7Vnf2ZxTPRYW6aREFmRHB3v4VAdVjmWMUtJTHKzE5T6zvMh
	Lh2DDaM7rHEm1f0a4lwWSOoor0ZmzZ107lzg97CbKVEkjrjxOZIGLMg+0PqB+O5fPvaNe3ivnfJ+T
	Px1A7BAxHsJ6JW/nGnMdr2eZ9Ynr+CyCQsutzsz10HhfTj/fkOjFKxy6X+yWiH8mSbr40ThYIcgyp
	LnaKTBqtzkb4c8XxYmvNr/AWJUHhc6KJAdsZaac6+CsZ2RVBYy/KyDgYvXe3UgCPBMFkTPc4U/QNK
	PsR4yvGQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWTFo-00000009fI3-1KZV;
	Fri, 19 Dec 2025 05:42:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: move the remaining content from xfs.h to xfs_platform.h
Date: Fri, 19 Dec 2025 06:41:46 +0100
Message-ID: <20251219054202.1773441-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251219054202.1773441-1-hch@lst.de>
References: <20251219054202.1773441-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the global defines from xfs.h to xfs_platform.h to prepare for
removing xfs.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs.h          | 17 -----------------
 fs/xfs/xfs_platform.h | 16 ++++++++++++++++
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs.h b/fs/xfs/xfs.h
index b335a471c088..3ec52f2ec4b2 100644
--- a/fs/xfs/xfs.h
+++ b/fs/xfs/xfs.h
@@ -6,23 +6,6 @@
 #ifndef __XFS_H__
 #define __XFS_H__
 
-#ifdef CONFIG_XFS_DEBUG
-#define DEBUG 1
-#endif
-
-#ifdef CONFIG_XFS_DEBUG_EXPENSIVE
-#define DEBUG_EXPENSIVE 1
-#endif
-
-#ifdef CONFIG_XFS_ASSERT_FATAL
-#define XFS_ASSERT_FATAL 1
-#endif
-
-#ifdef CONFIG_XFS_WARN
-#define XFS_WARN 1
-#endif
-
-
 #include "xfs_platform.h"
 
 #endif	/* __XFS_H__ */
diff --git a/fs/xfs/xfs_platform.h b/fs/xfs/xfs_platform.h
index 5223fe567ac1..c7b013593646 100644
--- a/fs/xfs/xfs_platform.h
+++ b/fs/xfs/xfs_platform.h
@@ -57,6 +57,22 @@
 #include <asm/byteorder.h>
 #include <linux/unaligned.h>
 
+#ifdef CONFIG_XFS_DEBUG
+#define DEBUG 1
+#endif
+
+#ifdef CONFIG_XFS_DEBUG_EXPENSIVE
+#define DEBUG_EXPENSIVE 1
+#endif
+
+#ifdef CONFIG_XFS_ASSERT_FATAL
+#define XFS_ASSERT_FATAL 1
+#endif
+
+#ifdef CONFIG_XFS_WARN
+#define XFS_WARN 1
+#endif
+
 /*
  * Kernel specific type declarations for XFS
  */
-- 
2.47.3

