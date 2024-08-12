Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8B114F9C5
	for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2024 06:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723444377; cv=none; b=uH5db48bfqSt41XKoqJN0paspzWCUzt8rE4fdqx9qV1s8x6dmYrlQj0IAGDLQHP9LxOnKaV/pKEZP3PxgHU6R/Vjq5VIIeGn0c1ayFGkyPexPWNZSj/4iJOcrnuiVi6tOSHkJeMi3+yFBdZTdztbiVh9uQMeoR3luEctj/dDemc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723444377; c=relaxed/simple;
	bh=4QuDUTrqyW4BE4dlfoVHnEm/ecmq2iEGILNatH70YMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESLwuHdQ91ooi9OJaJ+tVhg3g0NzGI/+vSQCTt0hcUmxVxLwiaP5uhfGmdbxTkMr5stg5jyGCZJUMtscIMVt8MmT/029FDO37AQ6vNYaS/ZcCYjlF896euKxJVlcQyhvv7PceMA4Vc2kOOHYQpiCSIrjCbM4vc05nIQ5HgpT/f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iOe5EYo1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iOe5EYo1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=s3wsEKpu/FzK4PyKc3qOv9eRN4n12F02jPE3eJ6t5P0=; b=iOe5EYo1/5P0M3Qo2oznvmxxZB
	rthD1ciUR7VOHZYJiRA/LD9poWdLgECkzjAbaXjqmTFCZC6mPIj2uaevM+2kp1s/M8lMVIcLa+1nj
	w7qXyyOevMzFam1G7dvX0QpM8itQBXCvekEh3EL1kJCck3aXnIUs9Q7HI/TdrmB+/EZsXHkoh7qi8
	n89oQ8z8cZbnjMHwEPu3qG3q1rtdGfT4WYUgHtaWZm0X1+RMQ8dnS7+FN63Xv6lz23sIKlUB2suSw
	yooLEPMdRFAyT8ySrO8RM7ZJo/qkK6aLRoNEjibNNdPNKL8qBEzPmKUZVP2Fm0WXleQ/CXIaXgbZX
	6llIZ5bQ==;
Received: from 2a02-8389-2341-5b80-ee60-2eea-6f8f-8d7f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:ee60:2eea:6f8f:8d7f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdObv-0000000H1gO-0dtm;
	Mon, 12 Aug 2024 06:32:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs: use kfree_rcu_mightsleep to free the perag structures
Date: Mon, 12 Aug 2024 08:32:31 +0200
Message-ID: <20240812063243.3806779-5-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240812063243.3806779-1-hch@lst.de>
References: <20240812063243.3806779-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: 7344fea851552b1586ee161147a749995504b368

Using the kfree_rcu_mightsleep is simpler and removes the need for a
rcu_head in the perag structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ag.c | 12 +-----------
 libxfs/xfs_ag.h |  3 ---
 2 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 58ca12f6e..40d1d8a4b 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -183,16 +183,6 @@ out:
 	return error;
 }
 
-STATIC void
-__xfs_free_perag(
-	struct rcu_head	*head)
-{
-	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
-
-	ASSERT(!delayed_work_pending(&pag->pag_blockgc_work));
-	kfree(pag);
-}
-
 /*
  * Free up the per-ag resources associated with the mount structure.
  */
@@ -216,7 +206,7 @@ xfs_free_perag(
 		xfs_perag_rele(pag);
 		XFS_IS_CORRUPT(pag->pag_mount,
 				atomic_read(&pag->pag_active_ref) != 0);
-		call_rcu(&pag->rcu_head, __xfs_free_perag);
+		kfree_rcu_mightsleep(pag);
 	}
 }
 
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index b5eee2c78..d9cccd093 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -63,9 +63,6 @@ struct xfs_perag {
 	/* Blocks reserved for the reverse mapping btree. */
 	struct xfs_ag_resv	pag_rmapbt_resv;
 
-	/* for rcu-safe freeing */
-	struct rcu_head	rcu_head;
-
 	/* Precalculated geometry info */
 	xfs_agblock_t		block_count;
 	xfs_agblock_t		min_block;
-- 
2.43.0

