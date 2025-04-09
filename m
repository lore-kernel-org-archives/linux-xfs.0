Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B64A259C
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185433; cv=none; b=E8VUCW2ePRkvFXQvYloPwAQoO+xSekDZwEl+WYFy7dfA2IoicT9IBUQtWnr8TtvhiC21She9m4of6KAWeCfqmqiRPJ8kz3ALwd0pIzcwKEhhk9q93om8OnzD1PFJaUoHRSuL/BLx1IFY+R+K/1k+DNiOZf14wETnjEvFygryFSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185433; c=relaxed/simple;
	bh=5X4TVzcvx4st+t5NwFLPursOa1//obZ4xkayt1dXrxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EivrM6D69RFgprL017iN1tc67GWwhvxfihXzcgbl/BU96b6ks3O8IpUyJF2s28ew5xTx65LDIvBdGBTP5OdoDgWrUibWnhbRsIPSjEWnUTGEv7SLa3MEW618vOCMfNUskK3UX5cZBfkQrulRc86lTV43L0fdPJTi9ZLKKF96AGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XC+pdCpm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XC+pdCpm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pY4EOGfVezDFizpLcX6O4Ks1HMm4LZLU0nlMJtCpAvQ=; b=XC+pdCpmDyOoUxdwBpd1rMv6QU
	whSHp2OSFGBTD/LDlmPAwxpV6pObuyy4vW4P9jznxZbH2kQGiPDBKs8i7zNhvRo17L3PUYAjYlAsc
	hCun52TxvunQuT8OU29BDIf38oSr0zHlbMEnvvtDI+95k2cAuhvqCJIZiYLGXjwJr/iYlzVRcTFpH
	nW953L/U9D1XENjUDatlOWHduFYSwAI145TowWVFKcvDQNxK71xE0Acp1J9T3GcDmr/6EmWgE0gLr
	0X+tBOtwaEywnJK1FuwarzO+/Lt4JO9VYLCFi6x9VTGVrExcoXGCElH7mkdDJKEAz4iNu7q3p1VaG
	pfrBOLdQ==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QJ5-00000006UTT-0TP2;
	Wed, 09 Apr 2025 07:57:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 17/45] FIXUP: xfs: parse and validate hardware zone information
Date: Wed,  9 Apr 2025 09:55:20 +0200
Message-ID: <20250409075557.3535745-18-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250409075557.3535745-1-hch@lst.de>
References: <20250409075557.3535745-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

