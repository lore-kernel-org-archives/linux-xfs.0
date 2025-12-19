Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A561A76BB
	for <linux-xfs@vger.kernel.org>; Fri, 19 Dec 2025 05:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766122936; cv=none; b=nR40FVOs0UR15LEGCKUJuAGudSWai6S/ala+ZRZpGjUB/JV7DOwitlEVsZs5koBGXJTpMcH7Eh4P+4qyGD8WlqlPhex03uuUmpOdj7uecoaBdIvsw7hTUcgfcwLSSAns0mgZJtYL6oEdazD3WFqAq3WTDW+sPebAvP+ZXiuU/II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766122936; c=relaxed/simple;
	bh=k3eDAF/69ldmfnCcANyJlEcmU5hRMkwPcLlaA3dx73c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFvQI0b9lWQYqSJjSOPnwReuuStkMyAUvWv0Hsm7cQzzwB7phLBcfjA15IaaInze6HCladXVkcmms1Pv0njy7/Fl+AyQls6xiqTV44DvECWO8JC3dLhoXAEU9JcXU/Ls1cmLAilb1DsFKB/aNpT3og2xhBwOwzXiiowmqAqfaRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aoMgjYQd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aoMgjYQd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Mekq1ZZLDrjTpp0jzrPmu/ixLBbvpH15m819HWS2XTU=; b=aoMgjYQd+8AOUzkmmjf7Yx8AUu
	nHm88oLaSgLFxtzNufn7AqXDdgCa/alHCaZ51KBMnUJ1R9FUGxJXl2ESnu4WPb9Z0G/qAeYWqk9ch
	nPv313mvB9UFwjSwwT8uJGBSppYZNDCQr7YTZ0rvX7SzMz0TX3OHef/HmgoZz4BA35kBa1WtNWrzn
	aZ/uExMzEUHtp34W3JnF43fHPjnpf1JSeuHYRwHHtgRT7exOKkYcWnUNlVZKXAFyzmu3oFUiMr0Qn
	PTDcjA1X8mjbo6ARVPUmwraiczVba2MO6L99ILZTaJZOtdw1ccv2BRX6Cda0IdguNCZF7y2KYyRCD
	QpzgQBrw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWTFl-00000009fHq-01zU;
	Fri, 19 Dec 2025 05:42:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] xfs: include global headers first in xfs_platform.h
Date: Fri, 19 Dec 2025 06:41:45 +0100
Message-ID: <20251219054202.1773441-3-hch@lst.de>
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

Ensure we have all kernel headers included by the time we do our own
thing, just like the rest of the tree.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_platform.h | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_platform.h b/fs/xfs/xfs_platform.h
index ec8cd71fc868..5223fe567ac1 100644
--- a/fs/xfs/xfs_platform.h
+++ b/fs/xfs/xfs_platform.h
@@ -8,19 +8,6 @@
 
 #include <linux/types.h>
 #include <linux/uuid.h>
-
-/*
- * Kernel specific type declarations for XFS
- */
-
-typedef __s64			xfs_off_t;	/* <file offset> type */
-typedef unsigned long long	xfs_ino_t;	/* <inode> type */
-typedef __s64			xfs_daddr_t;	/* <disk address> type */
-typedef __u32			xfs_dev_t;
-typedef __u32			xfs_nlink_t;
-
-#include "xfs_types.h"
-
 #include <linux/semaphore.h>
 #include <linux/mm.h>
 #include <linux/sched/mm.h>
@@ -63,7 +50,6 @@ typedef __u32			xfs_nlink_t;
 #include <linux/xattr.h>
 #include <linux/mnt_idmapping.h>
 #include <linux/debugfs.h>
-
 #include <asm/page.h>
 #include <asm/div64.h>
 #include <asm/param.h>
@@ -71,6 +57,16 @@ typedef __u32			xfs_nlink_t;
 #include <asm/byteorder.h>
 #include <linux/unaligned.h>
 
+/*
+ * Kernel specific type declarations for XFS
+ */
+typedef __s64			xfs_off_t;	/* <file offset> type */
+typedef unsigned long long	xfs_ino_t;	/* <inode> type */
+typedef __s64			xfs_daddr_t;	/* <disk address> type */
+typedef __u32			xfs_dev_t;
+typedef __u32			xfs_nlink_t;
+
+#include "xfs_types.h"
 #include "xfs_fs.h"
 #include "xfs_stats.h"
 #include "xfs_sysctl.h"
-- 
2.47.3

