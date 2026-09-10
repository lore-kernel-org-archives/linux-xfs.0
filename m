Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3039D48A8DB
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 13:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789046945; cv=none; b=PSD+sm/sIto9x+J0cQ4D9My2vAtzQiaxu07EaXVhTVCAsp4PQhxpVVSm4K7RXFSj+Sucb0VoPk2LlaXUZRpPATFJDcaEJkq/VOOlhzIABWd0ceAdFmblz5Er8W79k+HesgigNzzh3lf6CdtRRvN8OX1PbFChKegOSwL3HO2ofuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789046945; c=relaxed/simple;
	bh=ZZ/J5DewEbbGsBJgd7/UB0A6vXyB/IlyfiGUzgHaZow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozSsM18/qeqd+CPos+0yU58IK/2VzD1UfMWxJfyMrKuxSbEyOZxTCYo2RAxMrc1xwm36e3L5HoumUOopnYhJtxQtf82CaALO56yZA4hOrL0/ZEpi2+ptxwJOzUeiveB+ckyilgJcyYD5FHdPxq9IWk3wOW7MwT7/7s9eccLHP+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ksh/Nfjn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ksh/Nfjn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Mkb2IGddBjEU3G5HI1WW6w9tu0pxrLfRJJFFB3jSifM=; b=ksh/NfjnwQ5ArWXqLevujtSm4c
	6TWyrC6MEsM8tQBESnj+ARHfK7jRICpUFK4XKdByLMPmA1dLPir6Npsmo3Nj9JDbKARnKl5zz3D1f
	E/rNXrCtMdXtCYdWNsCKGiZ23gmXpxFP2gIvg8VEtB/GbQ3h1hwlcDp2iIkCIbg7RElIj2t6OVfRJ
	FltH8XV65kARwb+f0J+npT+ec8Ofj6ye6GToMgoBB4bsbBvXE/o8BpBCHAt/5fiCVcxzRbquGNf2J
	2hRNRwV/rtcGPXztIkqAW0RHHJ04Rw6n7qS9OnM4RtrucAZ34P43gHId/TG9PjmTLogwaLB0HN/Ue
	7Kqghhiw==;
Received: from [2001:4bb8:2c4:6e16:7921:e451:555c:a765] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4epq-0000000EStH-1o94;
	Thu, 10 Sep 2026 13:29:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 3/8] libxfs: move a few xfs_health.h includes
Date: Thu, 10 Sep 2026 15:28:33 +0200
Message-ID: <20260910132840.1541283-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260910132840.1541283-1-hch@lst.de>
References: <20260910132840.1541283-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Reduction of spurious differences to the kernel version of these files.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_alloc_btree.c    | 2 +-
 libxfs/xfs_ialloc_btree.c   | 2 +-
 libxfs/xfs_refcount_btree.c | 2 +-
 libxfs/xfs_rmap_btree.c     | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 54f0ff75a238..f62565bb55a1 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -14,10 +14,10 @@
 #include "xfs_btree_staging.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
+#include "xfs_health.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_ag.h"
-#include "xfs_health.h"
 
 static struct kmem_cache	*xfs_allocbt_cur_cache;
 
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index e0d886f324d8..85b24b8449c7 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -16,11 +16,11 @@
 #include "xfs_ialloc.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_alloc.h"
+#include "xfs_health.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
-#include "xfs_health.h"
 
 static struct kmem_cache	*xfs_inobt_cur_cache;
 
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 5a39dbbc635c..6738a68ffa49 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -15,12 +15,12 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_refcount.h"
 #include "xfs_alloc.h"
+#include "xfs_health.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_bit.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
-#include "xfs_health.h"
 
 static struct kmem_cache	*xfs_refcountbt_cur_cache;
 
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index c39faa4aac6c..f63d2df45070 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -16,10 +16,10 @@
 #include "xfs_btree_staging.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_health.h"
 #include "xfs_trace.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
-#include "xfs_health.h"
 #include "xfile.h"
 #include "buf_mem.h"
 #include "xfs_btree_mem.h"
-- 
2.53.0

