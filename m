Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0784231832
	for <linux-xfs@vger.kernel.org>; Sat, 20 Dec 2025 02:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766199483; cv=none; b=nc/cXv8tlCHwD8vekPRpmNWMEJhHDFY8YS/Ccmt2iQukAnsqsev3F4A1NHdcPC5Xqls8QtE+1tbnbn1uxmEJFQfy2WObf774xyTKXf1L60Nh03ju+lfAQVZ1A1OSysoHyOf+QvmWlrYLOt1PkfPxedkToxYyDzSvfdiT8hvPpx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766199483; c=relaxed/simple;
	bh=l1B/FKef0JWqNx5yuMkw9lztG/yXHptyonKceBW8I7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJl5bGIU+INhrE6LqVMzIHlUueAlyuRA4Vfb7ciQCM6Dqal8kdcjRcFANWqW+h7i8vmtkQeqiLyjbZMEeuXVOeIApiY8ePdrsA4e/noFyDamI45PfSRW633r9fskc6ll9q9BRKfFhM0cfAfs6pfcwR0yJmY3r3/+Dy++pdKwIi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yxx7T5cK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yxx7T5cK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F32C116D0;
	Sat, 20 Dec 2025 02:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766199482;
	bh=l1B/FKef0JWqNx5yuMkw9lztG/yXHptyonKceBW8I7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yxx7T5cKgqCQWMo8ueWcuQNSoRMo1XX3qufrP5WX21IWp0uwGqNDuUBxIlCr/Dmbr
	 kWyG/NwEi2OFq9x75l7ZK781JlhglBRuR2xanOQsEjnP2OgqdajlmyX/sxzoQ5kF13
	 mx5p4+dcihLMdMu9vcTGj8ZMdFz7GyDHSBSJclJeYhspJewGuKZd2lHI9V2yHmcFbo
	 buWklQ6d419cG8wq/DtGZgxG2PfegjJQaQ2KR7Huf4pPeF/xLMjoA3S2vy1ZrdBzfu
	 P2BBdhRmttriJJf2zIsuW/eyuGzIK7cnhTALSftrmAmVWZBnbZem3UV1rVjg6v5EGV
	 HBsSDga1/5hKQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH v3 5/6] repair: use xfrog_report_zones()
Date: Sat, 20 Dec 2025 11:53:25 +0900
Message-ID: <20251220025326.209196-6-dlemoal@kernel.org>
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

Use the function xfrog_report_zones() to obtain zones information from
a zoned device instead of directly issuing a BLKREPORTZONE ioctl.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 repair/zoned.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/repair/zoned.c b/repair/zoned.c
index 206b0158f95f..c211e02448da 100644
--- a/repair/zoned.c
+++ b/repair/zoned.c
@@ -3,7 +3,7 @@
  * Copyright (c) 2024 Christoph Hellwig.
  */
 #include <ctype.h>
-#include <linux/blkzoned.h>
+#include "libfrog/zones.h"
 #include "libxfs_priv.h"
 #include "libxfs.h"
 #include "xfs_zones.h"
@@ -51,8 +51,7 @@ check_zones(
 	uint64_t		sector = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart);
 	unsigned int		zone_size, zone_capacity;
 	uint64_t		device_size;
-	size_t			rep_size;
-	struct blk_zone_report	*rep;
+	struct blk_zone_report	*rep = NULL;
 	unsigned int		i, n = 0;
 
 	if (ioctl(fd, BLKGETSIZE64, &device_size))
@@ -67,30 +66,18 @@ check_zones(
 		return;
 	}
 
-	rep_size = sizeof(struct blk_zone_report) +
-		   sizeof(struct blk_zone) * ZONES_PER_IOCTL;
-	rep = malloc(rep_size);
-	if (!rep) {
-		do_warn(_("malloc failed for zone report\n"));
-		return;
-	}
-
 	while (n < mp->m_sb.sb_rgcount) {
-		struct blk_zone *zones = (struct blk_zone *)(rep + 1);
-		int ret;
+		struct blk_zone *zones;
 
-		memset(rep, 0, rep_size);
-		rep->sector = sector;
-		rep->nr_zones = ZONES_PER_IOCTL;
+		free(rep);
+		rep = xfrog_report_zones(fd, sector);
+		if (!rep)
+			return;
 
-		ret = ioctl(fd, BLKREPORTZONE, rep);
-		if (ret) {
-			do_error(_("ioctl(BLKREPORTZONE) failed: %d!\n"), ret);
-			goto out_free;
-		}
 		if (!rep->nr_zones)
 			break;
 
+		zones = (struct blk_zone *)(rep + 1);
 		for (i = 0; i < rep->nr_zones; i++) {
 			if (n >= mp->m_sb.sb_rgcount)
 				break;
-- 
2.52.0

