Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA6329D260;
	Thu, 23 Jul 2026 14:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818308; cv=none; b=hfCa6T4gWGGf699zwQzRHJafBvtCfr/g27sNFXsVM1rO9CD1OphmCqo+XqvI78u7L/tKEMClW6Hzh821TIyrEG9B1TE5mShGWCGEKr9pzVv4fNJr+o1+cfq4vlaY0wZmLRO/KPlrkZi+lIBhPqTPi1+/wjEUK6YSMnt/Q8yqk9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818308; c=relaxed/simple;
	bh=hYx6YipFzNV3GP8JC5NXlp5hCvKRc4xJd9gginewaf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEzYjc6OHY/uxIGUKOW5GCx18xTPT6eK3+22jiK3EYnwIgt4C6HgYhnROK+x1716SOY5PtABwWoiP73HD8yiXhA6z22wmnyR3LfhHgo67SWlXxzdBpyaQoBcrHtwgfioNmw8Fz7ZYQRQL7vVeJIO+FRokh3aBLtRL4aOFmHX0o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TCbdLhD5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TCbdLhD5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kXfeN8lXGRuVlyJtlNy1+elVhZVbgqLqgZEBAlhBc2o=; b=TCbdLhD5C7N859HkKpJqoGL67C
	kGnDuVk+1q8mDUp0s+su6UAxVKsxDnzWUvCDZGOZKRlz4LEK3ClOq67fq/w6xg4zO+P7xFs5Whdyq
	WQHUNMxZM/zuvuzzqlgMw7ZpUNEhFCVZ2Wf98LL4+I+dVptr8fhoM67Zu1VkKFQ5RI3DuLpw0FDxC
	P6qLXxc7BKVtvtOnQQd1dxqRjYM2LNnVvlsrKt5o23pNni/3Sl8ze5SrWIx7YA6ODmdQNnNxvsW1A
	HmzLOTgp6FdQoc7Lfmy9UPJX1iYW79tvgtpsvnDwmvAophQOmQCpHTxQKFO4qGW7QO+ZMaPqTKtME
	by5djogQ==;
Received: from [2001:4bb8:2e9:b20c:3d3c:bb0:5e13:19af] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmum1-0000000EXP8-1bPh;
	Thu, 23 Jul 2026 14:51:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 22/22] xfs: log a message at mount time when using integrity protection
Date: Thu, 23 Jul 2026 16:49:47 +0200
Message-ID: <20260723145000.116419-23-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260723145000.116419-1-hch@lst.de>
References: <20260723145000.116419-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Log a message in the kernel when using T10 protection information.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e1465e950acc..744e4a94a879 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -5,6 +5,7 @@
  */
 #include "xfs_platform.h"
 #include <linux/backing-dev.h>
+#include <linux/blk-integrity.h>
 #include <linux/dax.h>
 
 #include "xfs_shared.h"
@@ -1674,6 +1675,7 @@ xfs_configure_buftarg(
 	struct xfs_mount	*mp = btp->bt_mount;
 
 	if (btp->bt_bdev) {
+		struct blk_integrity *bi = bdev_get_integrity(btp->bt_bdev);
 		int		error;
 
 		error = bdev_validate_blocksize(btp->bt_bdev, sectorsize);
@@ -1686,6 +1688,15 @@ xfs_configure_buftarg(
 
 		if (bdev_can_atomic_write(btp->bt_bdev))
 			xfs_configure_buftarg_atomic_writes(btp);
+
+		if (!bi)
+			;
+		else if (btp->bt_bdev == btp->bt_mount->m_super->s_bdev)
+			xfs_info(mp, "using %s integrity profile",
+				blk_integrity_profile_name(bi));
+		else
+			xfs_info(mp, "using %s integrity profile for %pg",
+				blk_integrity_profile_name(bi), btp->bt_bdev);
 	}
 
 	btp->bt_meta_sectorsize = sectorsize;
-- 
2.53.0

