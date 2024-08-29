Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5812C1870
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 04:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724904541; cv=none; b=Ycc5RjDUhfmzgkO62xTShD3+vf4gzbPqqkcFaBE/jniEls49+vOJ3h5J8PE1PaANRJuE1DxUn1lmRH0h8etzl0DOlY05z0PZFIEcznvjpvjF19jmWUhaWmDVQZzk4mpTM4zoD4sLoJZhudlYxwywr9eDLEtRS9QG/81VJNgil4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724904541; c=relaxed/simple;
	bh=3PEriSLYVy2I721CyhEIVv9YPOBVQEhnLomR9sCUQZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fg8JaIegnuQ1hEnnSo0VIGz6c0hfIagJCSrEbn+f3s2v2HQ0BI2Lc1loQHR0L/G96NLpahLS2Dxg2UanU6Se304OrPAN/OpngN4q/KL1t5GYrXRNmLn+xqLL0X2WXc7XQtoIN93pHihpbonHbCB8KC92vXhmx4njoFNsitODobs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wNTwmGJV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wNTwmGJV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=43977Olov3pq7YOdJMItc7minZOgHWWmYFzs7HSfVZo=; b=wNTwmGJV7VtJSlVUXYq/hmwRox
	WYdquPB+83jT4VTLOkvgbgqyiBI0Ax4hWKrVvOoyLOOGqLUjGTHe5keh4uyBS9BEQZfxVlORpo92B
	g7vDv8VPTZf0/FB6L03RnZWX0S7akzhc4c7aAuChT0noghN7q4oSqhARF2Ejbu6yVxnm9Ro9P3169
	qrP6nZ3WlYvOgbj/NjZzPoHTiKEMwsSAx3PDz/wRG8oEiGJYsTbRPtaloIgwrQoniJMTFn5mnef9j
	ypJgABCaPa2sNbEqQerrEGICV0hAJvD6vPhRSELhFXYCdGhcIifr3MEEuRg+556Y2ULWKJBoJ1XxI
	rrVNbP9Q==;
Received: from ppp-2-84-49-240.home.otenet.gr ([2.84.49.240] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sjWSx-00000000RwY-1ZHU;
	Thu, 29 Aug 2024 04:08:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] xfs: use kfree_rcu_mightsleep to free the perag structures
Date: Thu, 29 Aug 2024 07:08:37 +0300
Message-ID: <20240829040848.1977061-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240829040848.1977061-1-hch@lst.de>
References: <20240829040848.1977061-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Using the kfree_rcu_mightsleep is simpler and removes the need for a
rcu_head in the perag structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag.c | 12 +-----------
 fs/xfs/libxfs/xfs_ag.h |  3 ---
 2 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 7e80732cb54708..4b5a39a83f7aed 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -235,16 +235,6 @@ xfs_initialize_perag_data(
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
@@ -270,7 +260,7 @@ xfs_free_perag(
 		xfs_perag_rele(pag);
 		XFS_IS_CORRUPT(pag->pag_mount,
 				atomic_read(&pag->pag_active_ref) != 0);
-		call_rcu(&pag->rcu_head, __xfs_free_perag);
+		kfree_rcu_mightsleep(pag);
 	}
 }
 
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 35de09a2516c70..d62c266c0b44d5 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
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

