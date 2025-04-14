Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4752319DFA7
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609053; cv=none; b=EUeUIy4S9Z+91akA+3206Dmc/5Gvmgly8pbJMxTpr5QBD7zcAPkgeqqQCpYP+bW8ciN3WYuTTxP+82k4gCcR+S/2zvcvQm1l7ub2HGSmZwE0cGqy8D8oYghDgn3vKFtKITnbFCLLKTGZSd4TQCR4K7fgvaJttTKNy8LSt03q0IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609053; c=relaxed/simple;
	bh=N6T/hu96ft8lBKc7kVH27mj5xdiJXAbvgvrHW3yeEyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ES9DI8Gxs+ubkGS7/QvSIxsR1q0UdlXczhBs9OXBRBCFc1RTnqHMueOdINm8bdlx0IvR06sfrfQiwGM6Vh++xqOMYKzNdhAl94Y/ZxSMtzUFalB9BtpsyfGLdA8Y84nNH9+g49G+0eb48+dTR9tO6lgDzrZzc4GGIiHJA6YQl8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZEmS3lcp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZEmS3lcp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=7IaqIwCkt7W5ACa51QRjjMyGMX8Vn414Qjyen5Igl7w=; b=ZEmS3lcp7XM/phsImtXWw8bMdU
	x2nL63mPRdQb1dZ4E7hKOlXkYdtXjRfKkTrOaW2UruznYwrBhyy5Jt/8eNaeh1qZ9jsjCA6WhSuTn
	5hbW4tDMVllAlEp9Yhfcsa+o7b91iVN5ABC5HckWfHdZrHXjkmNYo6HI9S1XkD9P4tf5P+Vlh4AcY
	Yl+NibLZKIq8/wRtY5wZ4G7wHNDZ8VPNSFkOeehzQXxJLdi5CDp9uX4kO167KmcznWcmLQhopvEp/
	w3URLkClT+TYUmdcJUdeQLhrwxc/6H2Izy8hpiNLi+3cu/tc/8U0aBAay2qREmSsPUrZPSM57S+DZ
	diJphEYQ==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CVf-00000000iHa-2lfd;
	Mon, 14 Apr 2025 05:37:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 20/43] FIXUP: xfs: add support for zoned space reservations
Date: Mon, 14 Apr 2025 07:36:03 +0200
Message-ID: <20250414053629.360672-21-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/libxfs_priv.h | 2 ++
 libxfs/xfs_bmap.c    | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 82952b0db629..d5f7d28e08e2 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -471,6 +471,8 @@ static inline int retzero(void) { return 0; }
 #define xfs_sb_validate_fsb_count(sbp, nblks)		(0)
 #define xlog_calc_iovec_len(len)		roundup(len, sizeof(uint32_t))
 
+#define xfs_zoned_add_available(mp, rtxnum)	do { } while (0)
+
 /*
  * Prototypes for kernel static functions that are aren't in their
  * associated header files.
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 3a857181bfa4..3cb47c3c8707 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -35,7 +35,6 @@
 #include "xfs_symlink_remote.h"
 #include "xfs_inode_util.h"
 #include "xfs_rtgroup.h"
-#include "xfs_zone_alloc.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
-- 
2.47.2

