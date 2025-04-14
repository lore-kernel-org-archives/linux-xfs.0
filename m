Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5313A1A01CC
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609046; cv=none; b=TNaJxeq55tjhKi6SeEDaUvePBZXoVOXoWb5NlG/dCppxrwCPkmXW+iozDazNmUBDHCUwPxyDfCte0/ariCtLjA+Z7HOwog++J6b/iSpuD8IRxgMbzAsrJ+5LwfiGdIr5EJXqpupXTURAW1YGEmfknReDKWyqeqSRG3op4aoLQhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609046; c=relaxed/simple;
	bh=5+OsLLy9oVucTYFHWzCfEs8OoVjOtAQzpAPCbXFM6fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ab2sAM5r0FoS7YBln+CRkc3UpU4HASiT/HjGwEJs9EiZ8cFy954MtrbLfiUjEYUJju5oJYidosWs4O2+vFlylhEuqHLkAZpyn0Rw9qP+U/roUaxSj/C+Pn9nwCdKubuXgxqVF1pIF8B6005ToJjRNjPyEAC3gZTwxWw2GL9EfwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iUDfP1ij; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iUDfP1ij"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=y1MkrUo6mQybEmEjFHD4D1jEuoyzoBtQoIj9Jn/VQ3Q=; b=iUDfP1ijY7I+hEePMCp3O17LQY
	6pswUneA5LVyEVyZN0zwK1f+TCy3Xd/v9E1DM5Ao7vQyF+1F62Z8Ovigmmff3dNPVaQWoZKiOZuDh
	gjHrgESLnj7k4UrPzy9ugEO6MrLNk+nNejDNKn+GeApEryNeJLResVDyM6X0963bD86fzkS/0vtDH
	vdx46xc306PBue9ieq9KBqP0NZhD9u25XLA3E/HuuEQSqujeeoP0KF/CxAnCCGlsBHKvqjCvBSvXb
	oRGeL9NDDmLucTKUchXDVWTg7y+XDfAAUXzolSk/XVw5Fg+rsLjpZskNH+dY4vzQckcK0w6aHjoLO
	m+/WrfZA==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CVY-00000000iFx-17Y9;
	Mon, 14 Apr 2025 05:37:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 17/43] FIXUP: xfs: parse and validate hardware zone information
Date: Mon, 14 Apr 2025 07:36:00 +0200
Message-ID: <20250414053629.360672-18-hch@lst.de>
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
 libxfs/Makefile    | 6 ++++--
 libxfs/xfs_zones.c | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/libxfs/Makefile b/libxfs/Makefile
index f3daa598ca97..61c43529b532 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -71,7 +71,8 @@ HFILES = \
 	xfs_shared.h \
 	xfs_trans_resv.h \
 	xfs_trans_space.h \
-	xfs_dir2_priv.h
+	xfs_dir2_priv.h \
+	xfs_zones.h
 
 CFILES = buf_mem.c \
 	cache.c \
@@ -135,7 +136,8 @@ CFILES = buf_mem.c \
 	xfs_trans_inode.c \
 	xfs_trans_resv.c \
 	xfs_trans_space.c \
-	xfs_types.c
+	xfs_types.c \
+	xfs_zones.c
 
 EXTRA_CFILES=\
 	ioctl_c_dummy.c
diff --git a/libxfs/xfs_zones.c b/libxfs/xfs_zones.c
index b022ed960eac..712c0fe9b0da 100644
--- a/libxfs/xfs_zones.c
+++ b/libxfs/xfs_zones.c
@@ -3,6 +3,8 @@
  * Copyright (c) 2023-2025 Christoph Hellwig.
  * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
  */
+#include <linux/blkzoned.h>
+#include "libxfs_priv.h"
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
-- 
2.47.2

