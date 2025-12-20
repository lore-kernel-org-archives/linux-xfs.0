Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9211C84A0
	for <linux-xfs@vger.kernel.org>; Sat, 20 Dec 2025 02:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766199483; cv=none; b=aJz4kN4C0wgQ4muNxv/8Y63l9EP+/IOnUf+BZu6Sv7LzanysjcjWVjeKJWHnQx6IndZyZPVAB2p9lanJx6ZUHjD4/vNYdEx6jcqJI/lNhwKyJXgG3H5yxvx8rQyLI6JDiMHSmXgnwEk9aDFkugpGP7acK1Z/PekQGSw8wRlJAdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766199483; c=relaxed/simple;
	bh=rOQIlJnt7D8agvlPsVrbAGVofv4lX2DJBi2OwaufFQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYSSu26Dow0W3nXKJm+RYSlYmao0ZtB9C+yosBK4vwHGOCVVFY1iiTIyS+YQAeLFvB88Jghx6LgrJIJk1SZqvK0EK3qOeagf11pIk40/A0PItVOkbujR29vdH6EIdnKUfTXiCUE2xczmQh8HmNS17WSgE21E6uYnaR1m+3xTEUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BGYyu+qd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BGYyu+qd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF932C16AAE;
	Sat, 20 Dec 2025 02:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766199483;
	bh=rOQIlJnt7D8agvlPsVrbAGVofv4lX2DJBi2OwaufFQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGYyu+qd0PgM/nxVozKa7GpXJDR7GjYco/PXjfEM1oojjS/OW7YrRN6jZjtSYFuDM
	 k+G7+YQ4rEwpD56H6jSBiCi65v3BORoxufkBXfbbs/bMtLN8ILOWfjf+9kOQfMO3fT
	 +9RYstfQgCn8+w8txYO/5tk0ioH8X/YSptTbO96vcDMLROD0kj2L+pCI6MTqY9ZBwr
	 P4P+wvdG8s5ZWlDd7epSc5BGwt2+SnAiPfXLoggkuTp6uAi8ThgFW8s3MDvaGBEIpx
	 Th10QEZIaYAuo7WLcZvtO7ePch9F6WrJurybr3HUKdUeqFS17hEBZlUWZ+jP6zS5sd
	 JmI4NX0Qd58Yw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH v3 6/6] libfrog: enable cached report zones
Date: Sat, 20 Dec 2025 11:53:26 +0900
Message-ID: <20251220025326.209196-7-dlemoal@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251220025326.209196-1-dlemoal@kernel.org>
References: <20251220025326.209196-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Modify the function xfrog_report_zones() to default to always trying
first a cached report zones using the BLKREPORTZONEV2 ioctl.
If the kernel does not support BLKREPORTZONEV2, fall back to the
(slower) regular report zones BLKREPORTZONE ioctl.

TO enable this feature even if xfsprogs is compiled on a system where
linux/blkzoned.h does not define BLKREPORTZONEV2, this ioctl is defined
in libfrog/zones.h, together with the BLK_ZONE_REP_CACHED flag and the
BLK_ZONE_COND_ACTIVE zone condition.

Since a cached report zone  always return the condition
BLK_ZONE_COND_ACTIVE for any zone that is implicitly open, explicitly
open or closed, the function xfs_zone_validate_seq() is modified to
handle this new condition as being equivalent to the implicit open,
explicit open or closed conditions.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 libfrog/zones.c    | 11 ++++++++++-
 libfrog/zones.h    |  9 +++++++++
 libxfs/xfs_zones.c |  3 ++-
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/libfrog/zones.c b/libfrog/zones.c
index 0187edce5fa4..8b45066de176 100644
--- a/libfrog/zones.c
+++ b/libfrog/zones.c
@@ -27,10 +27,19 @@ _("Failed to allocate memory for reporting zones.\n"));
 		return NULL;
 	}
 
+	/*
+	 * Try cached report zones first. If this fails, fallback to the regular
+	 * (slower) report zones.
+	 */
 	rep->sector = sector;
 	rep->nr_zones = ZONES_PER_REPORT;
+	rep->flags = BLK_ZONE_REP_CACHED;
 
-	ret = ioctl(fd, BLKREPORTZONE, rep);
+	ret = ioctl(fd, BLKREPORTZONEV2, rep);
+	if (ret < 0 && errno == ENOTTY) {
+		rep->flags = 0;
+		ret = ioctl(fd, BLKREPORTZONE, rep);
+	}
 	if (ret) {
 		fprintf(stderr,
 _("ioctl(BLKREPORTZONE) failed: %d!\n"), -errno);
diff --git a/libfrog/zones.h b/libfrog/zones.h
index 66df7a426a27..4605aea93114 100644
--- a/libfrog/zones.h
+++ b/libfrog/zones.h
@@ -8,6 +8,15 @@
 #include <stdint.h>
 #include <linux/blkzoned.h>
 
+/*
+ * Cached report ioctl (/usr/include/linux/blkzoned.h)
+ */
+#ifndef BLKREPORTZONEV2
+#define BLKREPORTZONEV2		_IOWR(0x12, 142, struct blk_zone_report)
+#define BLK_ZONE_REP_CACHED	(1U << 31)
+#define BLK_ZONE_COND_ACTIVE	0xff
+#endif
+
 struct blk_zone_report	*xfrog_report_zones(int	fd, uint64_t sector);
 
 #endif /* __LIBFROG_ZONE_H__ */
diff --git a/libxfs/xfs_zones.c b/libxfs/xfs_zones.c
index 7a81d83f5b3e..3c89a89ca21e 100644
--- a/libxfs/xfs_zones.c
+++ b/libxfs/xfs_zones.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2023-2025 Christoph Hellwig.
  * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
  */
-#include <linux/blkzoned.h>
+#include <libfrog/zones.h>
 #include "libxfs_priv.h"
 #include "xfs.h"
 #include "xfs_fs.h"
@@ -97,6 +97,7 @@ xfs_zone_validate_seq(
 	case BLK_ZONE_COND_IMP_OPEN:
 	case BLK_ZONE_COND_EXP_OPEN:
 	case BLK_ZONE_COND_CLOSED:
+	case BLK_ZONE_COND_ACTIVE:
 		return xfs_zone_validate_wp(zone, rtg, write_pointer);
 	case BLK_ZONE_COND_FULL:
 		return xfs_zone_validate_full(zone, rtg, write_pointer);
-- 
2.52.0

