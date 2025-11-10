Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7791A23C516
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 13:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781090; cv=none; b=Hag5xkxxBBYJ8gwTBAIgj6SxNKgd7xjOy7tF1HGTg6lw5KS8yjjLOfeMHeP4dAq4fZfe38jOHwW8EGIOiRg2zBG56nKlehE4uO0Uk8d7+RtzUD8bIwpcJlR/E4rVBuVDyXXUd5SiwY9uhXxMUfUva5hb9NRwoB+ECFwQ3U9pNY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781090; c=relaxed/simple;
	bh=E1dLRJo6R9UiAHjtzPOiwWnWfcQ6NdpUgxgp2MB7nyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojvbdJD/hnODtZzNJ/j1YAO4XUXIov9P9stE9r1qwRVqrIdlK4uUwdPP2qVcYyR/T6nEh8Rjd90D2ELbzUKsewfUjK1gZKeoQYTRLuulIywcxRhm156DDSCrySj5SznYBG7pJBYNtG7SJ1mDvyRhHl0CkVUFO9wAfScMFsqW2WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EBP+7sxO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EBP+7sxO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=o948vi2c1M1z7+RQi9rjE9yB/xuBE9wt69SKy4KROvo=; b=EBP+7sxODF74FhEpNCBwDdBZ4U
	yZAcn03/5ROpFZrRVtP2Sj0DGq2Y75WQoTBDqe0pN9meULP5rI9DvdD1ATH2uGxGjz82PkJ7xA5Ty
	lQ9JgupJK+Fdfut1WOgo3ZoWMw9aD2CUzMR4PQlxnViKD+E64eMqCCTsSo12CH5WEjpmaTgb7CZPX
	w4mE3vYzJ0xTb0oTycZdfNXsZ9MQOtsDx/LanozcmedAmUfsdWzHx7DJuIZAogtUpg4rwcUCRpNK1
	4hjQ0614IY+vbO0vjJ851i8FMDUyfBCnQyGmz7Uk5VYF/kIiXOTPRJNLOgcZArTldUHKMox2UYFXo
	RL8sIFcQ==;
Received: from [2001:4bb8:2c0:cf7f:fd19:c125:bec7:dd6d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIRt2-00000005UWF-1LIQ;
	Mon, 10 Nov 2025 13:24:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 17/18] xfs: move xfs_dquot_tree calls into xfs_qm_dqget_cache_{lookup,insert}
Date: Mon, 10 Nov 2025 14:23:09 +0100
Message-ID: <20251110132335.409466-18-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110132335.409466-1-hch@lst.de>
References: <20251110132335.409466-1-hch@lst.de>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_dquot.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 1c9c17892874..612ca682a513 100644
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
 
@@ -905,8 +907,6 @@ xfs_qm_dqget(
 	bool			can_alloc,
 	struct xfs_dquot	**O_dqpp)
 {
-	struct xfs_quotainfo	*qi = mp->m_quotainfo;
-	struct radix_tree_root	*tree = xfs_dquot_tree(qi, type);
 	struct xfs_dquot	*dqp;
 	int			error;
 
@@ -915,7 +915,7 @@ xfs_qm_dqget(
 		return error;
 
 restart:
-	dqp = xfs_qm_dqget_cache_lookup(mp, qi, tree, id);
+	dqp = xfs_qm_dqget_cache_lookup(mp, id, type);
 	if (dqp)
 		goto found;
 
@@ -923,7 +923,7 @@ xfs_qm_dqget(
 	if (error)
 		return error;
 
-	error = xfs_qm_dqget_cache_insert(mp, qi, tree, id, dqp);
+	error = xfs_qm_dqget_cache_insert(mp, id, type, dqp);
 	if (error) {
 		xfs_qm_dqdestroy(dqp);
 		if (error == -EEXIST) {
@@ -996,8 +996,6 @@ xfs_qm_dqget_inode(
 	struct xfs_dquot	**dqpp)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_quotainfo	*qi = mp->m_quotainfo;
-	struct radix_tree_root	*tree = xfs_dquot_tree(qi, type);
 	struct xfs_dquot	*dqp;
 	xfs_dqid_t		id;
 	int			error;
@@ -1016,7 +1014,7 @@ xfs_qm_dqget_inode(
 	id = xfs_qm_id_for_quotatype(ip, type);
 
 restart:
-	dqp = xfs_qm_dqget_cache_lookup(mp, qi, tree, id);
+	dqp = xfs_qm_dqget_cache_lookup(mp, id, type);
 	if (dqp)
 		goto found;
 
@@ -1052,7 +1050,7 @@ xfs_qm_dqget_inode(
 		return -ESRCH;
 	}
 
-	error = xfs_qm_dqget_cache_insert(mp, qi, tree, id, dqp);
+	error = xfs_qm_dqget_cache_insert(mp, id, type, dqp);
 	if (error) {
 		xfs_qm_dqdestroy(dqp);
 		if (error == -EEXIST) {
-- 
2.47.3

