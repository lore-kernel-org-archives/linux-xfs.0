Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9DAC129
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 04:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714366171; cv=none; b=DMDaD5UtVzcvf5gXDz1CFIb0rj9VgQsC4eH2FDmWQ0oS1+rDE2a71IMVOPqX0Z0HVxN0lMWgC4/SAiDcMB3ZCv+IFVnCxoYqEF5JkctuLFV0vxkjNpIqsX3iOdoN3lWojbJAqBoDHdFBaQXyE9CF2kLWEnnSgtWwOVzadW+u2RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714366171; c=relaxed/simple;
	bh=ve83gv0X9U2tiW9IMX9OfigUzgJIKdNTd1RdJD3Q7yE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N2/42ExIf0WTPwphWuSt+qAP4VI+wEOl9h77zoEv4Tgdwxg7J/9QJN61jQX2lyawCLGkYqeAkrk9uxzmdXaR8Zn/VEvmbAZq9LqA7VYIlgDb8geyi8LkISStL+eoJ/V8Rubb/yYNJCHFXnlfdUwqlNZIFBh8v8T+AYFHjeLu3KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jWuCMDMR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jWuCMDMR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hMGWqVK2bA5X5NVVQXVyIdiFvN0d0hPuzmYdi662Byw=; b=jWuCMDMRDTeokYxRSItIP0fqbx
	u3u9VEb5c0azY6M57EzvxBACYt9wy7yHb5FWgIS3fCZyW3s8KbuoERnELAISJgX67h+1e4qalb0F7
	IXtw5IyUZ7idEFF3Nrbs6FCbR1r6h8iz1lNWP8a8Vm5BfCRvC2lxc+AK8P1oMLRXlw3NoLgS3fgGy
	N95+rzzIW4CXEhmbt9tUpGA6VO8pem9xlckKxh4YmAl1HUmXawqBjXa26CGPjQ2RXsAfYdbh7IWRL
	HTmLglxqlJijCEvu/eY7AeVe7gcITyLyBoFfdQBGJcpulmHSvpJbBuTrvcMgeyIMrgt9LWoi+Yv0+
	mimNGHzA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1IxF-00000001S5c-0Vg0;
	Mon, 29 Apr 2024 04:49:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 3/8] xfs: consolidate the xfs_quota_reserve_blkres definitions
Date: Mon, 29 Apr 2024 06:49:12 +0200
Message-Id: <20240429044917.1504566-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240429044917.1504566-1-hch@lst.de>
References: <20240429044917.1504566-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_trans_reserve_quota_nblks is already stubbed out if quota support
is disabled, no need for an extra xfs_quota_reserve_blkres stub.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_quota.h | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 85a4ae1a17f672..621ea9d7cf06d9 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -123,12 +123,6 @@ extern int xfs_qm_newmount(struct xfs_mount *, uint *, uint *);
 extern void xfs_qm_mount_quotas(struct xfs_mount *);
 extern void xfs_qm_unmount(struct xfs_mount *);
 extern void xfs_qm_unmount_quotas(struct xfs_mount *);
-
-static inline int
-xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
-{
-	return xfs_trans_reserve_quota_nblks(NULL, ip, blocks, 0, false);
-}
 bool xfs_inode_near_dquot_enforcement(struct xfs_inode *ip, xfs_dqtype_t type);
 
 # ifdef CONFIG_XFS_LIVE_HOOKS
@@ -187,12 +181,6 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
 	return 0;
 }
 
-static inline int
-xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
-{
-	return 0;
-}
-
 static inline int
 xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
 		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp, int64_t dblocks)
@@ -221,6 +209,12 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
 
 #endif /* CONFIG_XFS_QUOTA */
 
+static inline int
+xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
+{
+	return xfs_trans_reserve_quota_nblks(NULL, ip, blocks, 0, false);
+}
+
 static inline int
 xfs_quota_unreserve_blkres(struct xfs_inode *ip, int64_t blocks)
 {
-- 
2.39.2

