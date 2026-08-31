Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242C93B0AD4;
	Mon, 31 Aug 2026 06:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158517; cv=none; b=DhiMJH6MFecs+BGxW1KiLGqpcN7yzg7LVN9eCEm4u5+IYgpg2+ryYav+PTz1swVKhA7SbjhcW2x+GucwyXQ41rF28IkG8EFeyKUEeal4+IZeucMM/Warvdo9cQUCmWEGg7I3bJTvqlcbmPqk1t4bEVDG6tKrYYtYFbY8b8rb4rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158517; c=relaxed/simple;
	bh=1TNzZ7sjG6VwpfGRkiRQNPR4jovUmI3AvioGiiI0+zE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmFedKtdaomp++LEM6tRESBPK4cDrp9EzAHBS5XAu+CQg5rcuz9rxNxtk3IGKoWjoTZqUn9BqWBghtqIV2gssXJ1ZXZpvIatjsGV64NieaVh0tnpIi2u9N/t95tIWEpEWHLJ+6Zcd17pG5VUF5ynfGj/K+3JhZjI7rvyywHyt98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QFSWfy72; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QFSWfy72"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jtsndzrGjc60AU1LrjPLVnSNBjTH8u95z3/ZmN5miUo=; b=QFSWfy7226uEeIPxZLp2fqgHap
	7D4rK4bYxzwCEH+68DI2gZxMzqStWneAKbJMzlijkqyhPXY7/nT1eSNKO91h7h2BLiksFpWWcMq/b
	6pfd9ABX7prbg//t0Ky9Km1+TpCTBDppa7yvJm613ClSIfA7J0I5n2izkuDf9D1vJWlHtj9iEsun3
	4GjkIchpzTK0Vkf4eW1zclLEJOXkrWAz0YEGFLLtE9nRcs1DjU5kDDGXuXnpv04YEbe2kBKAnBqNn
	yEafVLbo/1L/QR2rHb7sPiN4m+DN7KcSnrmZisq3EO2PgDQneMsfyzFfl82Hhsv6846NWV+5C29Bv
	Zs6sDZNw==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0viM-00000008d0V-2pAP;
	Mon, 31 Aug 2026 06:41:55 +0000
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
Subject: [PATCH 16/17] xfs: log a message at mount time when using integrity protection
Date: Mon, 31 Aug 2026 09:40:04 +0300
Message-ID: <20260831064010.2574896-17-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831064010.2574896-1-hch@lst.de>
References: <20260831064010.2574896-1-hch@lst.de>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ee7c2e9c0340..eee491c01d8c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -5,6 +5,7 @@
  */
 #include "xfs_platform.h"
 #include <linux/backing-dev.h>
+#include <linux/blk-integrity.h>
 #include <linux/dax.h>
 
 #include "xfs_shared.h"
@@ -1694,6 +1695,7 @@ xfs_configure_buftarg(
 	struct xfs_mount	*mp = btp->bt_mount;
 
 	if (btp->bt_bdev) {
+		struct blk_integrity *bi = bdev_get_integrity(btp->bt_bdev);
 		int		error;
 
 		error = bdev_validate_blocksize(btp->bt_bdev, sectorsize);
@@ -1706,6 +1708,15 @@ xfs_configure_buftarg(
 
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

