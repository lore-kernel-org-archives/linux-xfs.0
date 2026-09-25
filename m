Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587BC4CC632
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349679; cv=none; b=dpMxPXAZTgeVlxOHIiYOTNdCsxIhQh5n/XpBuHxMMgwtm5WAkQd4daaxe1hZ1vyM8VVJfm/Lffd2BpEyAQVRJbH/k6E6d9Kw6vzuBQeEuJOpcvY+4jESWFfET99lOqXZjY8FRU9sll6TkKRExMf77jHwkeETxEb7DNN7qk2Z3TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349679; c=relaxed/simple;
	bh=scqG3Id50MTC9uGzvlqs8bXM2fACatPiwbc2rxP6gGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=slvOCx0hC0vrrnRMlxrQoZF+tjfUZRdd0cF7pgVKOx+xG+Ej6lkHdCdwK5TygtMMVpu2EqdD4bLOJWInD2iO327EO7AkoMpRFzztxUTfcoM/vuGA3ziseIzCXo5DwI/PLTq7NJN+1IK9FkHm5rbWG9jLj2InzOMFyoEK2QBFOfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qxjC9gw1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qxjC9gw1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=k5rLpkaJV59HNhktxWs4pXbUMWoDyxXZAVScLzrDL1Q=; b=qxjC9gw14VTSHNGadYcrlP5JcW
	xJEmfaO2o2tY+8m+11FgIhBj4HvZUfuvo8OKV5KOkIdeZjLyi5QymEKcvdJBib+ZsQw5ipYq2IIpr
	zifA4l2KG9yFc8wmVeAezLAIB0BN3s66AuRHbvdsiOCExb5CehGk2JfUDrsPC5/S2fsx8Pfje0WY4
	Hg1U7rhAgNmMZAjG9dUB8h2urJuWyLir1jDZ7iV6ubx6nVC9Exyrs5DqYmtdjl48vlR/W7l2oDPkw
	S+R0fAI4ErW3ioVNhA+RlmltvVxWDrOjXQGSsMJIO17YhjZbQl7LDE3fEboTwm3zTjyS5+pDol7Uu
	WtAhVIew==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA7jh-0000000DlcK-1vgE;
	Fri, 25 Sep 2026 15:21:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 03/13] libxfs: remove a spurious xfs_rtbitmap.h include in xfs_sb.c
Date: Fri, 25 Sep 2026 17:20:22 +0200
Message-ID: <20260925152107.3386097-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925152107.3386097-1-hch@lst.de>
References: <20260925152107.3386097-1-hch@lst.de>
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

