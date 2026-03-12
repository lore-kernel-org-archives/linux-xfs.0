Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A3484A35
	for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 09:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773306506; cv=none; b=b/nDutrYn3+08ZXPkKm6bD+niaMQTEYgzwa39+W4Z7eYuWRo6fBpEmcqdFzhN2nqghedhL94vUJ+ZRC2+iQUY7N5qdh/ENkYIJxxvxvM2TpT9GyRqmqhNObAUPtl2itvnChBviz3ddOvMjrvHnq2sHRrpnJjAp7UeRnqOr8jGFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773306506; c=relaxed/simple;
	bh=cxq+96DcK5Y09iAVcf4m6wU1jysvTWFdlQzugZ3ld8w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FWpZr+DnCS/AfMOWzfVnbR8zUBWzSZXvfEGvJi0VjXe7h+viM2T8FqqEkPWyVybOg4OZaeMZD3LyPKCaVR+O+et7DFRY8coleZ1FcKN8uLLKJCjpLgOxRobuMf9hFKFLxTOIf748XTnbyJsD3s6nz34O+wjPQQyAqG5VO0RKCYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=Jg71CKB8; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="Jg71CKB8"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=l+PXrVhkhvr3YF9pJKf479edZlG4CWlWbIB6BH+l81Q=;
	b=Jg71CKB8eWm5yrt0uw4idHHFrZ7wskBo8CNG2KhN55G5Q66LppnSRv2HWtiBAlhkhYpkt3LMD
	+qvznj2zCFcdtbglvhJuVbci24blhp+KJb8iLKDyl/lMEjYIX2MZgaYxQzC761BUAvoCfrAfliH
	mY1syJOfj0HzeGTbx2DWG/s=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4fWhV53cs8zpSt7;
	Thu, 12 Mar 2026 17:03:09 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id BFFE22025F;
	Thu, 12 Mar 2026 17:08:22 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 12 Mar 2026 17:08:19 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 12 Mar
 2026 17:08:18 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH v2 3/4] xfs: factor out xfs_attr3_leaf_init
Date: Thu, 12 Mar 2026 16:57:59 +0800
Message-ID: <20260312085800.1213919-4-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260312085800.1213919-1-leo.lilong@huawei.com>
References: <20260312085800.1213919-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemn100013.china.huawei.com (7.202.194.116)

Factor out wrapper xfs_attr3_leaf_init function, which exported for
external use.

Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 22 ++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.h |  3 +++
 2 files changed, 25 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 47f48ae555c0..96a65141e812 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1415,6 +1415,28 @@ xfs_attr3_leaf_create(
 	return 0;
 }
 
+/*
+ * Create and initialize an empty attr leaf block at blkno, and attach the
+ * buffer to tp.
+ */
+int
+xfs_attr3_leaf_init(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	xfs_dablk_t		blkno)
+{
+	struct xfs_buf		*bp = NULL;
+	struct xfs_da_args	args = {
+		.trans		= tp,
+		.dp		= dp,
+		.owner		= dp->i_ino,
+		.geo		= dp->i_mount->m_attr_geo,
+	};
+
+	ASSERT(tp != NULL);
+
+	return xfs_attr3_leaf_create(&args, blkno, &bp);
+}
 /*
  * Split the leaf node, rebalance, then add the new entry.
  *
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index aca46da2bc50..72639efe6ac3 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -87,6 +87,9 @@ int	xfs_attr3_leaf_list_int(struct xfs_buf *bp,
 /*
  * Routines used for shrinking the Btree.
  */
+
+int	xfs_attr3_leaf_init(struct xfs_trans *tp, struct xfs_inode *dp,
+				xfs_dablk_t blkno);
 int	xfs_attr3_leaf_toosmall(struct xfs_da_state *state, int *retval);
 void	xfs_attr3_leaf_unbalance(struct xfs_da_state *state,
 				       struct xfs_da_state_blk *drop_blk,
-- 
2.39.2

