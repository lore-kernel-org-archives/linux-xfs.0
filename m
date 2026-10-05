Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818FE4825A6
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 12:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205014; cv=none; b=ud42iDkOvtMznbSXK6LZmpjZ05U4ovfQkTGBnc2XNHhxtpT16cmvZ0S+YovpgFUy4EpEKjr1iMCv9jR295UcWfVqKqWkEeMgqx1p3mGZY8ra1NBAJEOMdMbRoy/enGeCvmwEdUI4kLXTN4NQkiz6HnrzDUkMoTLnZKQsTc9Qrlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205014; c=relaxed/simple;
	bh=koYpaFDMbCuLIS9JVk/0icEI6zN6eL1ncd29oLRWC+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7OPhIZN4ku92PUbsBjJW5seG+3dq1VCV4FhbVOdpFgQuwBFsmvzW9wFQDRmmWruss9jLRMw5p6PJY46k14zoqaxGuU1eoNJekeIx07ph/8D7kJHi5mzeLZHX46aMUEn1kF9XkBgrQroRQXE2BcEV8dMaBOAWojEHeXNwaCCS3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3VwfFdbz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3VwfFdbz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4QyEV7rcQTm2yMBsmYDaQP+KGkSUdNLWxuEdYI7PAc0=; b=3VwfFdbzfUQZeu+wGo3pd6og1I
	NrLnWfdZ4HB/VUVYPCxM3jcC9SxAh0bBpAr73atpoLJhLgSFxQIEFDXSK5YSuaUCg1GQv1I9sJC6y
	vKpm3H/awWoXT4neBGGBoVe0vjTz9GTvSB8TEJjo1wTdcJnF5bwqVtQw6kbeeny/0d4Pq9w49ryu4
	G4BfgXUuP7DOVSkAVsMhpInc4vDs5fEIO2sl3dMIRwwPxkSXYTybgM4jUKzPNxW6UM5IL74/iqjUo
	McX1/zcn5M1f/SiEjwAbtFgEzCUBbaqKMF6ArKXKjpsaSs1ilnR0Gc8yXTz++van5ERt53EVEMqJZ
	njAhwrpQ==;
Received: from 2a02-8389-2301-9f00-88fd-fcdd-06aa-821c.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:88fd:fcdd:6aa:821c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xDiFQ-0000000GR4e-2gIk;
	Mon, 05 Oct 2026 12:56:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/13] libxfs: move the xfs_rtbitmap.h include in xfs_bmap.c
Date: Mon,  5 Oct 2026 14:56:14 +0200
Message-ID: <20261005125637.1340355-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261005125637.1340355-1-hch@lst.de>
References: <20261005125637.1340355-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

To better align with the kernel version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index cec59446711b..cfce4358e2bf 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -20,6 +20,7 @@
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
@@ -30,7 +31,6 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_refcount.h"
-#include "xfs_rtbitmap.h"
 #include "xfs_health.h"
 #include "defer_item.h"
 #include "xfs_symlink_remote.h"
-- 
2.53.0

