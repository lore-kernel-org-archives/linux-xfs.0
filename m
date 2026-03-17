Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7546D35966
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 02:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773712966; cv=none; b=FbSxiGQd+MmeL0Jsn4Qj4c42Z+4BQSAh39dIJ2XaAk6Eyb+zFomyKtuM2JiqNeFuG7FyHbrmrbwG3OdpwOOLWMBszrkZAKyEC9tj6avic8QhuzR2qpJqeSCjUQyGGIH3HEYL73/BmMPzwH/3uziDgp7x8eUINzTSRHhpKFp+w8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773712966; c=relaxed/simple;
	bh=02HKZy6jKe0j0P2557iZE/+h6x4GuYMRxizF6ibbUr4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NOnttm92pV7LjLpqYFdsbrjd6983ijoknUf4iNPC7Gqn7vnOmVqL3cMppiKM4AQnajDyIq4YWi3jZADFQO4Ye1ecdsNCZLmL0KhqhUuuP/DzmfxH+TBfMcdWTfkro5gKXPDYFx72z1e5xIIrLPJrHhKU+oTSuoRSedjPIdqx+yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=qg71gtyI; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="qg71gtyI"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fyKPnqgkvDrQX7XCLPDzhVz/lkqzkJkueOCHdQ6kDbs=;
	b=qg71gtyIfHajXrO6ZsfEKVhpwsWZeCF9g9GT4cTkG3UWzbtMyx12rH94eJQxVmq8IdawyjOgk
	QYDrcxbmxPN7I6Bb2xcGNZSIiiuPxihZJQ1VDKlCn4kdr4abVDlUULh+jYEP8Rl39509oNmhC/p
	SpfqU8wlAcL21zFcwFpmV8s=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fZZpl3YLPzKm58;
	Tue, 17 Mar 2026 09:57:35 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id E3C7740562;
	Tue, 17 Mar 2026 10:02:34 +0800 (CST)
Received: from kwepemn100013.china.huawei.com (7.202.194.116) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 17 Mar 2026 10:02:34 +0800
Received: from huawei.com (10.50.159.234) by kwepemn100013.china.huawei.com
 (7.202.194.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 17 Mar
 2026 10:02:33 +0800
From: Long Li <leo.lilong@huawei.com>
To: <djwong@kernel.org>, <cem@kernel.org>
CC: <linux-xfs@vger.kernel.org>, <david@fromorbit.com>, <yi.zhang@huawei.com>,
	<houtao1@huawei.com>, <leo.lilong@huawei.com>, <yangerkun@huawei.com>,
	<lonuxli.64@gmail.com>
Subject: [PATCH v3 3/4] xfs: factor out xfs_attr3_leaf_init
Date: Tue, 17 Mar 2026 09:51:54 +0800
Message-ID: <20260317015155.589955-4-leo.lilong@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260317015155.589955-1-leo.lilong@huawei.com>
References: <20260317015155.589955-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemn100013.china.huawei.com (7.202.194.116)

Factor out wrapper xfs_attr3_leaf_init function, which exported for
external use.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Long Li <leo.lilong@huawei.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 22 ++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.h |  3 +++
 2 files changed, 25 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 47f48ae555c0..2b78041e8672 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1415,6 +1415,28 @@ xfs_attr3_leaf_create(
 	return 0;
 }
 
+/*
+ * Reinitialize an existing attr fork block as an empty leaf, and attach
+ * the buffer to tp.
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

