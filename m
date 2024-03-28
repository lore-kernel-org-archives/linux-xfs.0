Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DC33DAC11
	for <linux-xfs@vger.kernel.org>; Thu, 28 Mar 2024 07:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711609386; cv=none; b=dZhcdJ87LRmEg0yJFlAN/2miUlxx01iR6M5Ubl+rCmUodPgh7MPgXRNWcoK0olVAHoxzAhiIAvaLGTUZa3BuJcBR4+jJ4WL1/qcPIT6EYwKpxi5LNkANGtqYXm4A/+ZMDZJYtBvXVKd0CdWXI6GFcGIzlHblMs9gV/k8QTKLhDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711609386; c=relaxed/simple;
	bh=M2iac5dKciNpUHVKpXkIB0EEv0tsbJr0IBTQjLlp+eo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jkr28rRagAqAFijfxtUXJG6sTi4Qf0pM2vLnPhfN0pNTbE+fjCrx1NbfrrkYs1T+roUsMVmiu5i8kzmIOLcOCN8cjnrlTBg6ziMqt3MEanxbIbHetNfyiwmU7IgDNHuA1Ab51l3AOX7cGglIgq+fO3OGCEuuX5DbdRAolZOv2WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=r18CcPDC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r18CcPDC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wxY519uwgh0FEygpyQiV9860XeDx3FQraMa9vb1OvTY=; b=r18CcPDCoz8KspIFJEikUPsWRc
	iOBGVlp9HpxFb+kDAigSroP7F8Htwd5Vj81eoAc97uVCmtTOIVlKfMT/eDZGlsWu6eNTDdX9+7keh
	TKZMUbDsHIB7DY2rIkq8+6nv4HDGkJqBnBxCvrsRY2CU3lEw8bt5kmOVbdyx1UD5kp6hTHFNDrI7g
	sCqwhnzokTMvE678TkZ2dIQfC1xZgWlyBv/mEZtBkX1W4MC4wMm9otWnTjaWR+KtAfJLla07S5HEn
	5Y5xt4F61QOJaZsuG+KFzozptlHW7nwuqOr+yZvrlx5kGcR87oFbOlnAxHKctAzWMT8XojF2YHJKA
	yzWqTH1Q==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpjmy-0000000CnfX-0ysj;
	Thu, 28 Mar 2024 07:03:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/6] xfs: consolidate the xfs_quota_reserve_blkres defintions
Date: Thu, 28 Mar 2024 08:02:52 +0100
Message-Id: <20240328070256.2918605-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240328070256.2918605-1-hch@lst.de>
References: <20240328070256.2918605-1-hch@lst.de>
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

