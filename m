Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E071C1C84A0
	for <linux-xfs@vger.kernel.org>; Sat, 20 Dec 2025 02:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766199483; cv=none; b=YCLMnPyCzq4jBYzm+qYg2c8VMchUf+QqBN31KRzdcP8R854lQMZQrE4Ug9yL+iBtSfa59siE4DTuPmc/camWWijuW7c33Sgecb33q34EpmVPJg6Yc8jl+doFWFxEaK7Q43Mogm8Ypt/SN9l1uZX18TCMLlrdIwRi6sDvcK766PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766199483; c=relaxed/simple;
	bh=z77u65O7Vp4bQvA0POOcB0A19cq0v5xOXrEAj0oJUO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BoyXCYsiJtG5UkQy7L9Ae2+SsliMTuZvAhMf/Hg2vu3sLwPRoinpz36dwbavSMCB/NLGllDU0Hd+9USV9cZ1WRg9xW5fN4XuzskqP6DQB9HuQwMvic9Pgu6u0rrBlg0/ENIccJgsZvf/kCaL/qnElRgdgk6kNoQfKybcwDbVKZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R0nMYIrY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R0nMYIrY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EA6C116C6;
	Sat, 20 Dec 2025 02:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766199481;
	bh=z77u65O7Vp4bQvA0POOcB0A19cq0v5xOXrEAj0oJUO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0nMYIrYKL4tHjEei3YverNUjSCX1qEmxGtTKgHNcf1aNHGPvQFU4lkxm4Xn+S8Vi
	 qJqAMRVqLLVGFgUIWbTo24gyOmP/8riCbiAh1/KA3BIAgnjAxwYUOwSMta+u0yCFre
	 nsn30Nq/KrYVL8sNEKd5FsolMEkQ8STiUCOONULK5FPysKMSfd2r1LwChmQ3AaJxfb
	 Lsi5LMvqWAdQAlbhzwv8RBUF1ZIWVLumrpmYkIJ9FDUZbJv6wFSrP+xXhS/Dxn7hCP
	 bPqMDbXvYhV0duiQ5Bftco69Nm3MxwJAjNkmSNKPq42uwZknwNSmFpArVXpg6+P/Jv
	 RRqjyxuZqwb5A==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH v3 4/6] mkfs: use xfrog_report_zones()
Date: Sat, 20 Dec 2025 11:53:24 +0900
Message-ID: <20251220025326.209196-5-dlemoal@kernel.org>
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

Use the function xfrog_report_zones() to obtain zone information from
a zoned device instead of directly issuing a BLKREPORTZONE ioctl.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 mkfs/xfs_mkfs.c | 35 +++++++++--------------------------
 1 file changed, 9 insertions(+), 26 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 550fc011b614..ac7ad0661805 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -6,7 +6,6 @@
 #include "libfrog/util.h"
 #include "libxfs.h"
 #include <ctype.h>
-#include <linux/blkzoned.h>
 #include "libxfs/xfs_zones.h"
 #include "xfs_multidisk.h"
 #include "libxcmd.h"
@@ -15,6 +14,7 @@
 #include "libfrog/crc32cselftest.h"
 #include "libfrog/dahashselftest.h"
 #include "libfrog/fsproperties.h"
+#include "libfrog/zones.h"
 #include "proto.h"
 #include <ini.h>
 
@@ -2566,20 +2566,16 @@ struct zone_topology {
 	struct zone_info	log;
 };
 
-/* random size that allows efficient processing */
-#define ZONES_PER_IOCTL			16384
-
 static void
 report_zones(
 	const char		*name,
 	struct zone_info	*zi)
 {
-	struct blk_zone_report	*rep;
+	struct blk_zone_report	*rep = NULL;
 	bool			found_seq = false;
-	int			fd, ret = 0;
+	int			fd;
 	uint64_t		device_size;
 	uint64_t		sector = 0;
-	size_t			rep_size;
 	unsigned int		i, n = 0;
 	struct stat		st;
 
@@ -2606,31 +2602,18 @@ report_zones(
 	zi->nr_zones = device_size / zi->zone_size;
 	zi->nr_conv_zones = 0;
 
-	rep_size = sizeof(struct blk_zone_report) +
-		   sizeof(struct blk_zone) * ZONES_PER_IOCTL;
-	rep = malloc(rep_size);
-	if (!rep) {
-		fprintf(stderr,
-_("Failed to allocate memory for zone reporting.\n"));
-		exit(1);
-	}
-
 	while (n < zi->nr_zones) {
-		struct blk_zone *zones = (struct blk_zone *)(rep + 1);
+		struct blk_zone *zones;
 
-		memset(rep, 0, rep_size);
-		rep->sector = sector;
-		rep->nr_zones = ZONES_PER_IOCTL;
-
-		ret = ioctl(fd, BLKREPORTZONE, rep);
-		if (ret) {
-			fprintf(stderr,
-_("ioctl(BLKREPORTZONE) failed: %d!\n"), -errno);
+		free(rep);
+		rep = xfrog_report_zones(fd, sector);
+		if (!rep)
 			exit(1);
-		}
+
 		if (!rep->nr_zones)
 			break;
 
+		zones = (struct blk_zone *)(rep + 1);
 		for (i = 0; i < rep->nr_zones; i++) {
 			if (n >= zi->nr_zones)
 				break;
-- 
2.52.0

