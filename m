Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444A135948
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323804; cv=none; b=igD4T4RlzHtqwQHbZzwMvoufjquFYDZMepFpGpZpCNQpHoBnR04yZ8WwSd5dvDzG0v5qZ6N0xFa6DqJ8bltd9T0sESV+Tswquyzlmdv129Zvcv6RxpZBd4qnptvIrZ42CEE2KhmbXLfBAsyWLA3LSokkn2tcLwdSY97PkhBCDvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323804; c=relaxed/simple;
	bh=Qhfm3MRjPhz7fnAoohXekXPEtuPdBLvzhKLE7ign77Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGbSmD0fZOWR9Xf9+7hB+vjRN2B+3ZPM+cStBFwbLIhz/okOXmz6uZkp6Pa/W/y0XpBgo/CDkd0kzjsKwmksjHIF97VD1mCJXlEECc8dJO4d/NUPezFM5fyBPiIO/Dzy0x5a8zpN79cKriDisrNLzF9t9tOZdC4NFDQNyqrtZoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=f/o+XzKy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="f/o+XzKy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iWe3CZ/eRfJdOZfxKZFQP5oPwEqgxITveYDJzYmrQHs=; b=f/o+XzKyGZwTpWML+QpqX8hUbZ
	SpKYqxYCf1YMAR77RqkuMIGcjQSLBhu9LkAcMOhL79ckqQLcabT48UO6CUC/8tZi0zUJnEGynV8Wk
	sHptkgi6GW8rFw4akp6u6ovF+anLkIkqs6As/s/m0vNr8Y+acGIf6bsJrwe0pc2K5N5TYpUBo4Clm
	YrPP7eHD2tsQcqZH7DwRKCpR8MhWrxx6cWnloDNo/W8mmbWy3Jq0qSO5MWK/QNVaX6UvcMiPdcX/G
	m2BBMrLXuCiTDscQSRtt6anFi6G6D3XDIArwy7P+f93m7OSQ2QHQt2s3omxfDSIBc9wYo2y0idkb4
	8oF5oWNQ==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88dO-0000000C7lE-0O7b;
	Mon, 13 Oct 2025 02:50:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 16/17] xfs: move xfs_dquot_tree calls into xfs_qm_dqget_cache_{lookup,insert}
Date: Mon, 13 Oct 2025 11:48:17 +0900
Message-ID: <20251013024851.4110053-17-hch@lst.de>
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

These are the low-level functions that needs them, so localize the
(trivial) calculation of the radix tree root there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 98593b380e94..29f578d66230 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -801,10 +801,11 @@ xfs_dq_get_next_id(
 static struct xfs_dquot *
 xfs_qm_dqget_cache_lookup(
 	struct xfs_mount	*mp,
-	struct xfs_quotainfo	*qi,
-	struct radix_tree_root	*tree,
-	xfs_dqid_t		id)
+	xfs_dqid_t		id,
+	xfs_dqtype_t		type)
 {
+	struct xfs_quotainfo	*qi = mp->m_quotainfo;
+	struct radix_tree_root	*tree = xfs_dquot_tree(qi, type);
 	struct xfs_dquot	*dqp;
 
 restart:
@@ -843,11 +844,12 @@ xfs_qm_dqget_cache_lookup(
 static int
 xfs_qm_dqget_cache_insert(
 	struct xfs_mount	*mp,
-	struct xfs_quotainfo	*qi,
-	struct radix_tree_root	*tree,
 	xfs_dqid_t		id,
+	xfs_dqtype_t		type,
 	struct xfs_dquot	*dqp)
 {
+	struct xfs_quotainfo	*qi = mp->m_quotainfo;
+	struct radix_tree_root	*tree = xfs_dquot_tree(qi, type);
 	unsigned int		nofs_flags;
 	int			error;
 
@@ -906,8 +908,6 @@ xfs_qm_dqget(
 	bool			can_alloc,
 	struct xfs_dquot	**O_dqpp)
 {
-	struct xfs_quotainfo	*qi = mp->m_quotainfo;
-	struct radix_tree_root	*tree = xfs_dquot_tree(qi, type);
 	struct xfs_dquot	*dqp;
 	int			error;
 
@@ -916,7 +916,7 @@ xfs_qm_dqget(
 		return error;
 
 restart:
-	dqp = xfs_qm_dqget_cache_lookup(mp, qi, tree, id);
+	dqp = xfs_qm_dqget_cache_lookup(mp, id, type);
 	if (dqp)
 		goto found;
 
@@ -924,7 +924,7 @@ xfs_qm_dqget(
 	if (error)
 		return error;
 
-	error = xfs_qm_dqget_cache_insert(mp, qi, tree, id, dqp);
+	error = xfs_qm_dqget_cache_insert(mp, id, type, dqp);
 	if (error) {
 		/*
 		 * Duplicate found. Just throw away the new dquot and start
@@ -994,8 +994,6 @@ xfs_qm_dqget_inode(
 	struct xfs_dquot	**dqpp)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_quotainfo	*qi = mp->m_quotainfo;
-	struct radix_tree_root	*tree = xfs_dquot_tree(qi, type);
 	struct xfs_dquot	*dqp;
 	xfs_dqid_t		id;
 	int			error;
@@ -1014,7 +1012,7 @@ xfs_qm_dqget_inode(
 	id = xfs_qm_id_for_quotatype(ip, type);
 
 restart:
-	dqp = xfs_qm_dqget_cache_lookup(mp, qi, tree, id);
+	dqp = xfs_qm_dqget_cache_lookup(mp, id, type);
 	if (dqp)
 		goto found;
 
@@ -1050,7 +1048,7 @@ xfs_qm_dqget_inode(
 		return -ESRCH;
 	}
 
-	error = xfs_qm_dqget_cache_insert(mp, qi, tree, id, dqp);
+	error = xfs_qm_dqget_cache_insert(mp, id, type, dqp);
 	if (error) {
 		/*
 		 * Duplicate found. Just throw away the new dquot and start
-- 
2.47.3

