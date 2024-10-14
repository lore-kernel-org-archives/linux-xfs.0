Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69D6762F7
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 06:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728885938; cv=none; b=uabBcriuePDXzhnlSUPvpiUl1fWKdBwO9TcsjzNmXsNBjslp02FJR4uyxR34cXdkBOWK1INvlx8YskxrODsx7i2ZNN2T0QAvtSUv0U6wqSSNB6v3kOZt3IEHrMj9h/p7WIIp2MSA25wEv3CGGe05xeI58AgkmqLB6POTGolqhmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728885938; c=relaxed/simple;
	bh=UvhQbKd5Zb398D6Oyc0SjS9e9Wu0taCFPuapRWaPCls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4q3tL/xNctuLh/oghmamST8vLGJLZ9BtAooIH7o/rvwD9Aq0t0RPT2BmN5e2cnEGvROVJJ7Rm/ao8RBCgpuHKDD3zE2ES4c0+X6xuD9TUyGDYUmGVgYesDxWbeZRRpLypQzaF4V8unhuo7iGu9ErE6TU6UpfBN8GObokUQ8yw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xYYsc4KY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xYYsc4KY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=q/zX6jhtmzY/t6VCeIapDLOt+Qx8Phu62O6x04+tzIc=; b=xYYsc4KYCYqkjuG2Djcpdfrl20
	VglK+WVpw+3Tt+lwGB/hoqArvLBdldXjfS/Rk9lAiOM8YWtqZD70a9no+kjWiSgFrz1VNeJju/j7e
	ilCuI8NyClWHCpis6hNZrvHxYeYbVJywPKWr0bNdw6ePY39HULNdH4ujaoUvdUvhg34E4sWf5PBCF
	+8HIncUrxXyQ0CQDOKi5e2Hr4VdioV17QuVBbu2s5rRl8fu4s/EJfyAvys3E2dIHtHqR+5ygzKXWt
	mbNq5XceWVbt0Z3k1yvxMaWlNqJPb139zK8osBzAq61SLuQS5qDcVt5ClqgqKQ82fcsCXKPNtqn44
	8uDoiKcg==;
Received: from 2a02-8389-2341-5b80-fa4a-5f67-ca73-5831.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:fa4a:5f67:ca73:5831] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t0ED2-00000003pfn-0Mkg;
	Mon, 14 Oct 2024 06:05:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 6/6] xfs: update the pag for the last AG at recovery time
Date: Mon, 14 Oct 2024 08:04:55 +0200
Message-ID: <20241014060516.245606-7-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241014060516.245606-1-hch@lst.de>
References: <20241014060516.245606-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently log recovery never updates the in-core perag values for the
last allocation group when they were grown by growfs.  This leads to
btree record validation failures for the alloc, ialloc or finotbt
trees if a transaction references this new space.

Found by Brian's new growfs recovery stress test.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag.c        | 17 +++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h        |  1 +
 fs/xfs/xfs_buf_item_recover.c | 19 ++++++++++++++++---
 3 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 25cec9dc10c941..5ca8d01068273d 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -273,6 +273,23 @@ xfs_agino_range(
 	return __xfs_agino_range(mp, xfs_ag_block_count(mp, agno), first, last);
 }
 
+int
+xfs_update_last_ag_size(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		prev_agcount)
+{
+	struct xfs_perag	*pag = xfs_perag_grab(mp, prev_agcount - 1);
+
+	if (!pag)
+		return -EFSCORRUPTED;
+	pag->block_count = __xfs_ag_block_count(mp, prev_agcount - 1,
+			mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks);
+	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
+			&pag->agino_max);
+	xfs_perag_rele(pag);
+	return 0;
+}
+
 int
 xfs_initialize_perag(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 6e68d6a3161a0f..9edfe0e9643964 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -150,6 +150,7 @@ int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t old_agcount,
 void xfs_free_perag_range(struct xfs_mount *mp, xfs_agnumber_t first_agno,
 		xfs_agnumber_t end_agno);
 int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
+int xfs_update_last_ag_size(struct xfs_mount *mp, xfs_agnumber_t prev_agcount);
 
 /* Passive AG references */
 struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index a839ff5dcaa908..5180cbf5a90b4b 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -708,6 +708,11 @@ xlog_recover_do_primary_sb_buffer(
 
 	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
 
+	if (orig_agcount == 0) {
+		xfs_alert(mp, "Trying to grow file system without AGs");
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * Update the in-core super block from the freshly recovered on-disk one.
 	 */
@@ -718,15 +723,23 @@ xlog_recover_do_primary_sb_buffer(
 		return -EFSCORRUPTED;
 	}
 
+	/*
+	 * Growfs can also grow the last existing AG.  In this case we also need
+	 * to update the length in the in-core perag structure and values
+	 * depending on it.
+	 */
+	error = xfs_update_last_ag_size(mp, orig_agcount);
+	if (error)
+		return error;
+
 	/*
 	 * Initialize the new perags, and also update various block and inode
 	 * allocator setting based off the number of AGs or total blocks.
 	 * Because of the latter this also needs to happen if the agcount did
 	 * not change.
 	 */
-	error = xfs_initialize_perag(mp, orig_agcount,
-			mp->m_sb.sb_agcount, mp->m_sb.sb_dblocks,
-			&mp->m_maxagi);
+	error = xfs_initialize_perag(mp, orig_agcount, mp->m_sb.sb_agcount,
+			mp->m_sb.sb_dblocks, &mp->m_maxagi);
 	if (error) {
 		xfs_warn(mp, "Failed recovery per-ag init: %d", error);
 		return error;
-- 
2.45.2

