Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C57935948
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323745; cv=none; b=ub0gyvNKA5Cm8W1WdkRSDx3X220j1ZEyiVMsVxSeVvEv8gKhZ6KfDX4oQVT8NzjqZW2nnc0p+10MNLemI7vrQ2U7geMtug5tznzvv26r9XhLVMNM0QbP1ov0xGQQ0IITkU5qI1hcsryOwtDQo2pqpPIXEKT8Fk3XjxidHgOV74k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323745; c=relaxed/simple;
	bh=dDglilGD5ZiV/1kfYu5Rs50aEUchKBL0Yuq9IQsNLas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2rEcwM0Fx2HHEcgUYsa9mFZLIgj9jC34xhLk/H5V8JDmt76ZdlzDKsFNkYgZ9x9G3oQyhG/09ek+d1MvjqWILmq2AuRhuT1umoXuHK0R5xigabDwOWpT8zURLCbRNDUUmA4M5HKVJj115taGgJKTfS9Mx9ogGqoh/yJEJJ3oXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lX4uqkOk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lX4uqkOk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=t5W/vkxwZg9Xh9HZEoNdpibFgXIkukqFsNF7w0uLDiI=; b=lX4uqkOk1mu4sE3BIywiHCluOo
	IAqNYYzPfYSVeUO3Ph6PdI42EqahUb64nHMoH8poesBL4M/IkjCjgeIzOM2XdBcRGDSP5UZgsfjx1
	q6dikz7tQT1GjvGTWTeki4iSYIIImN/aHYT5X14f5dkhOYusGqn4Qxsd8SqopdlnSo4qTYJ4nWL9n
	OdWbTC4+D2nIt/WuYl2rc3TuWpgViHc9qCpxrhoDyBZdoChMU2iMz4q/zjAb2CYcMEcF+JvEsoSSH
	3kT29UQnLbmUmrWzJ3JSkk7twlgoZ4F1HoWFYz7PQSatDIAW+Ck5Yb6j1GiOXEmBhHmBAOjJnF6yI
	RrWuSS/w==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88cR-0000000C7cc-0I2X;
	Mon, 13 Oct 2025 02:49:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 01/17] xfs: make qi_dquots a 64-bit value
Date: Mon, 13 Oct 2025 11:48:02 +0900
Message-ID: <20251013024851.4110053-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013024851.4110053-1-hch@lst.de>
References: <20251013024851.4110053-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

qi_dquots counts all quotas in the file system, which can be up to
3 * UINT_MAX and overflow a 32-bit counter, but can't be negative.
Make qi_dquots a uint64_t, and saturate the value to UINT_MAX for
userspace reporting.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm.h       | 2 +-
 fs/xfs/xfs_quotaops.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 35b64bc3a7a8..e88ed6ad0e65 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -57,7 +57,7 @@ struct xfs_quotainfo {
 	struct xfs_inode	*qi_pquotaip;	/* project quota inode */
 	struct xfs_inode	*qi_dirip;	/* quota metadir */
 	struct list_lru		qi_lru;
-	int			qi_dquots;
+	uint64_t		qi_dquots;
 	struct mutex		qi_quotaofflock;/* to serialize quotaoff */
 	xfs_filblks_t		qi_dqchunklen;	/* # BBs in a chunk of dqs */
 	uint			qi_dqperchunk;	/* # ondisk dq in above chunk */
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 4c7f7ce4fd2f..1045c4c262ad 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -65,7 +65,7 @@ xfs_fs_get_quota_state(
 	memset(state, 0, sizeof(*state));
 	if (!XFS_IS_QUOTA_ON(mp))
 		return 0;
-	state->s_incoredqs = q->qi_dquots;
+	state->s_incoredqs = max_t(uint64_t, q->qi_dquots, UINT_MAX);
 	if (XFS_IS_UQUOTA_ON(mp))
 		state->s_state[USRQUOTA].flags |= QCI_ACCT_ENABLED;
 	if (XFS_IS_UQUOTA_ENFORCED(mp))
-- 
2.47.3

