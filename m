Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412D417165C
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481910; cv=none; b=IAglhBBi3wpK7kzLmLKY3/NjC4+LpLY06KwJi/LhH9jL4A5FRIYTcCA4c91M8mk+5/37g/F8+wsqMIYhBjdzIrMXtiluHtZUzRADCxyJzA24da0wtcFrntPkaqlDyoyzhUEmwd3pZ31YcMj0XpjInLIwBCAy1Qf2nGWqAcEDTNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481910; c=relaxed/simple;
	bh=ve83gv0X9U2tiW9IMX9OfigUzgJIKdNTd1RdJD3Q7yE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gujfi9Wya7fASfBnbB+swxjZmb/ej4P0bA/3KcCC40Fgwiz+UpmmmSIqyw7BRpV5yAvUtUd+URe5T3lrsk9R/0zPD7gAf8LC1Npm9AAa87+nvedceuGPm9EWPT5zzp9xPYkc35jJ0sid/TlGhdotYjGaMqcTuGnmMb7J/uKH1Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MA1quNMQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MA1quNMQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hMGWqVK2bA5X5NVVQXVyIdiFvN0d0hPuzmYdi662Byw=; b=MA1quNMQwly0hhDYyUg8qDOj9q
	l0UPNuVP9nJDDSaNMVOl1LDv7MaHu0zXrmpqMuzZqX/zLYUzPurRyG62BlABQL0PPWDWH7W28H1eG
	A1I6Fba9PWRwGjGln/rh4F8YDUpzE+/tnAsjI5X/2fikqR4fNds5aNo7DfqaIS2Rgs08z+jozy8jh
	sdr91y+6sHLOkhtH7CoHdCPLuaEVZELD+9+LqFYJ5R8cXDuixdxH+dYFfg9QXFFmHirC4q7gxO1da
	F9C5azmqdUwUB46yLAdEPJA9cVKo6WAEKKt1UNv4PWP8doZ+l1jLoRYZMvV97omi6V46COpNHB+J4
	xjppU14w==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1n40-00000006PzC-0Wc5;
	Tue, 30 Apr 2024 12:58:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: consolidate the xfs_quota_reserve_blkres definitions
Date: Tue, 30 Apr 2024 14:58:21 +0200
Message-Id: <20240430125822.1776274-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240430125822.1776274-1-hch@lst.de>
References: <20240430125822.1776274-1-hch@lst.de>
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

