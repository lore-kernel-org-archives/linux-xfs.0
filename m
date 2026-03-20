Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282A3349AF6
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 13:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774011833; cv=none; b=CPbsNHpBYUe7J36R7LrEMx+C/l4aR3JD6M0Q8CZ+ivHK5wgpYPsGiOioRhqEDwoPJ4CpIGkwKiUUsGWYVzY6hM7XZ9Tppdmwvz7Vb3hNa/faE5dKB5cwauDJgXYuLbkiMQE9QIx8dMyBkYErpRYFZ4enaSMliktPeIN5GnsrWvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774011833; c=relaxed/simple;
	bh=xqe5ANJXlEq7iUzeMERDOA8SPTdaWTNRSm2WobT5M34=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Oy+YavWY2rh0ydpdG68wl9y7SBDvJd/rzlVyaltNexOjjrx3XyVuOO9oIjpDNBDXjuctrx9piLBE98dyQ3DSMyrYPwzmOQZEiPSTEcLU7LIeb/KOWs81Wg7CFNIp3wVskRp9ShNCa2dZxM7mAQXrFa0nZkKu0kEXnvXZqscjh2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=JsBo0fLK; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JsBo0fLK"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1774011831; x=1805547831;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xqe5ANJXlEq7iUzeMERDOA8SPTdaWTNRSm2WobT5M34=;
  b=JsBo0fLKk4zORQa0gR+nx12uN6WTEZVtHDRCDqA2JMSMM+xKVSSZ3jpU
   BjcQjnM2TDVtjx1R4BK39rbeidTYUYECJj2sYyLgtBcbT9QO1tkfcTdbV
   PRFceu3cJC9ukXjspeMuFXzRMOr+F4B5lHP0vfppn9o+tgNdnpEjdPsHI
   qBupc7HOAPCtiadNrtw+AFMloYKNynCbGv/e3dEJvg8X5XPlkxTLsvIZv
   mUoTrcXupBLq/U+KjcmDRPDVGotsc1lbDkx44QJdRnrkcUwIKcCIFhGBY
   Kao0UFlELZrnJVsh4J6CWfI+C1URPe7bM4A7VS8veRhI0jHQdYTRHUXRS
   g==;
X-CSE-ConnectionGUID: 0VSxZpZMTUWnGXULaTrX+g==
X-CSE-MsgGUID: 6TCbRAq1Q1So4AOQyn+u6Q==
X-IronPort-AV: E=Sophos;i="6.23,130,1770566400"; 
   d="scan'208";a="142488344"
Received: from unknown (HELO uls-op-cesaep03.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Mar 2026 21:03:45 +0800
IronPort-SDR: 69bd4588_1bBikzdLR8svJqpMtelrB2Dz88Ui5iuxmPZArJCdfpheceX
 x/xIqHxfy3YvBULxKDgpqLZxxCEg2iNSTLlPmpw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep03.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 20 Mar 2026 06:03:04 -0700
WDCIronportException: Internal
Received: from unknown (HELO gcv.wdc.com) ([10.224.20.43])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Mar 2026 06:03:01 -0700
From: Hans Holmberg <hans.holmberg@wdc.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH] xfs: start gc on zonegc_low_space attribute updates
Date: Fri, 20 Mar 2026 14:02:56 +0100
Message-ID: <20260320130256.35225-1-hans.holmberg@wdc.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Start gc if the agressiveness of zone garbage collection is changed
by the user (if the file system is not read only).

Without this change, the new setting will not be taken into account
until the gc thread is woken up by e.g. a write.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
---

 fs/xfs/xfs_sysfs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 6c7909838234..ac1329944049 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -14,6 +14,7 @@
 #include "xfs_log_priv.h"
 #include "xfs_mount.h"
 #include "xfs_zones.h"
+#include "xfs_zone_alloc.h"
 
 struct xfs_sysfs_attr {
 	struct attribute attr;
@@ -724,6 +725,7 @@ zonegc_low_space_store(
 	const char		*buf,
 	size_t			count)
 {
+	struct xfs_mount	*mp = zoned_to_mp(kobj);
 	int			ret;
 	unsigned int		val;
 
@@ -734,7 +736,11 @@ zonegc_low_space_store(
 	if (val > 100)
 		return -EINVAL;
 
-	zoned_to_mp(kobj)->m_zonegc_low_space = val;
+	if (mp->m_zonegc_low_space != val) {
+		mp->m_zonegc_low_space = val;
+		if (!xfs_is_readonly(mp))
+			xfs_zone_gc_start(mp);
+	}
 
 	return count;
 }
-- 
2.34.1

