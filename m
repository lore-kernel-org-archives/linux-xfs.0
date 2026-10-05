Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92F113CF82
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 12:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205012; cv=none; b=uPpJ8GxR3VAvrgqMQpCglJjH46IACkkx4/xF/qtwlbDwSZP1i/ZqZbSwiPkQBX3BJHdQhTFA/SkrNQ0HxYE42uyjsPAOqiikg+2BbjNMeh4sLBlWm531qYku/VjLaKw4kGRnFTrV9PXUWtmKWaO8abJ8W9FfFAnierC0psFqc/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205012; c=relaxed/simple;
	bh=scqG3Id50MTC9uGzvlqs8bXM2fACatPiwbc2rxP6gGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSGGbyVb3EvmzTcEHnJb2Ov8ovCpsSIojE+qxaCaluGWvd5BJ+fkqQX59QtsKpfDezTQTSYj+GN/kCXVRMlDpH97iwGJvH7Tj/camY/0g8DL7jTeAcJXuAoXw9FzoqkmN3hCPfGD0OdXxGkKXzAag/Ucze9uNjcMJAAaXUOaeo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MUXfBQn1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MUXfBQn1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=k5rLpkaJV59HNhktxWs4pXbUMWoDyxXZAVScLzrDL1Q=; b=MUXfBQn124nl3Q5twJ2maq8Icu
	qKgTfPA43edJepNaqlq2O9dlGQ7OGq7wslq8EnmVkQviOhbSpCKq1ZpHOKrqyp2I+8aoiu+x9RKDi
	BZa75zfPkABejeHahd+78KP7fHvcXsApx4HHbSc22cYVfExO9HbOAYkQcTGel+vJwdD5AyEKTPlh+
	l/LwfL73PCxDC0H4ctFo+il3+ZEDdm2NZTTg4KcPh9Lv5zuIIOzTUj8bltwPGjoSoAxbwOXjH+FyX
	Mx5KKWia4w66uwTMlRLLrQG1C7xNwoVCSP9ucuiJlW3buR/fncSiPYkq7b2k0p5GPvsND/mQoP+7c
	KY2uz1aQ==;
Received: from 2a02-8389-2301-9f00-88fd-fcdd-06aa-821c.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:88fd:fcdd:6aa:821c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xDiFN-0000000GR49-1iD6;
	Mon, 05 Oct 2026 12:56:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong " <djwong@kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 03/13] libxfs: remove a spurious xfs_rtbitmap.h include in xfs_sb.c
Date: Mon,  5 Oct 2026 14:56:13 +0200
Message-ID: <20261005125637.1340355-4-hch@lst.de>
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

This fully resyncs with the kernel version.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_sb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index ea99f8b5eee5..cccbcd153316 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -27,7 +27,6 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtrefcount_btree.h"
-#include "xfs_rtbitmap.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
-- 
2.53.0

