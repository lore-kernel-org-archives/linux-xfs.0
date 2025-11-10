Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B7A19DF4F
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 13:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762781058; cv=none; b=VtyeOyakUiEgXZp5GrB2JOjig7OT4XoURk4KFWnGyuDiSs4tTByPPxBSPgwicrutrM/jbNzngXxRD/oFHgyOSheQMPpIPAihIHL6G6750MY5nrvRRyZEAw2DPAOnGARH+O97Woxs8b+0t+/w8NDv9yLV5O5Sr9ObQyaMpnej5+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762781058; c=relaxed/simple;
	bh=RukYdGtsl9cRz6s/gC93DvmYItZFqOt5ki3XWbhUUVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibq75Z0dmWZ+fQ7eSgZ/RZR1iokuMhnUHt5F2rApQaCEW3D42reVYwhYvtHUp2tZmiK1bScZ4MqJYuCnQrVbbZkVD0Dog1J48mNKBw7CmALNKeMBeZ/LxJMM7e1ccB+bv4YEl9bXlCZ1NqW3gbntAR2Hj7/EpZqegR8EHkyb0LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F221YRkx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F221YRkx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=nwu4wkuJ7o7xnjEvOTTZBy0oy4/6Czfp/e8a2b/mrfU=; b=F221YRkx6tNjzLMSz9YMTf4OeT
	t2cpFPqWFcsLYf8gszzBA3rkVcq3Jdv2ZnwFcNno/oE5ysb0cZA9ttul/9zdnHiKRyDXZcTRUzhX2
	DVyQw14uHL+As1B6P4pf4CJZfp2vzfqlY0WeqU8jcGxRZ6c+vOAKdyb4F3cHqTILowgvkALiKwte6
	kitbXEkn3feK/jRo/CpL9HJYxUwZWebyNUsV7EnghDKYpZYsh7VJ3RajUbcGTJzffJg+BQCkpuHRV
	A2sriYO5NBJmlxvnvLkVZHRQUhrZMX6kYMOaTarkrMfC8EPfzUJjQv8u6/FBpvysaiAQA41cd4pKt
	wc4ebYZg==;
Received: from [2001:4bb8:2c0:cf7f:fd19:c125:bec7:dd6d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIRsW-00000005UTN-1kF2;
	Mon, 10 Nov 2025 13:24:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 09/18] xfs: fold xfs_qm_dqattach_one into xfs_qm_dqget_inode
Date: Mon, 10 Nov 2025 14:23:01 +0100
Message-ID: <20251110132335.409466-10-hch@lst.de>
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

xfs_qm_dqattach_one is a thin wrapper around xfs_qm_dqget_inode.  Move
the extra asserts into xfs_qm_dqget_inode, drop the unneeded q_qlock
roundtrip and merge the two functions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_dquot.c |  9 ++++++---
 fs/xfs/xfs_qm.c    | 40 +++-------------------------------------
 2 files changed, 9 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 8b4434e6df09..862fec529512 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -994,7 +994,7 @@ xfs_qm_dqget_inode(
 	struct xfs_inode	*ip,
 	xfs_dqtype_t		type,
 	bool			can_alloc,
-	struct xfs_dquot	**O_dqpp)
+	struct xfs_dquot	**dqpp)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
@@ -1003,6 +1003,9 @@ xfs_qm_dqget_inode(
 	xfs_dqid_t		id;
 	int			error;
 
+	ASSERT(!*dqpp);
+	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
+
 	error = xfs_qm_dqget_checks(mp, type);
 	if (error)
 		return error;
@@ -1068,8 +1071,8 @@ xfs_qm_dqget_inode(
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 	trace_xfs_dqget_miss(dqp);
 found:
-	*O_dqpp = dqp;
-	mutex_lock(&dqp->q_qlock);
+	trace_xfs_dqattach_get(dqp);
+	*dqpp = dqp;
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b571eff51694..f3f7947bc4ed 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -287,40 +287,6 @@ xfs_qm_unmount_quotas(
 		xfs_qm_destroy_quotainos(mp->m_quotainfo);
 }
 
-STATIC int
-xfs_qm_dqattach_one(
-	struct xfs_inode	*ip,
-	xfs_dqtype_t		type,
-	bool			doalloc,
-	struct xfs_dquot	**IO_idqpp)
-{
-	struct xfs_dquot	*dqp;
-	int			error;
-
-	ASSERT(!*IO_idqpp);
-	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
-
-	/*
-	 * Find the dquot from somewhere. This bumps the reference count of
-	 * dquot and returns it locked.  This can return ENOENT if dquot didn't
-	 * exist on disk and we didn't ask it to allocate; ESRCH if quotas got
-	 * turned off suddenly.
-	 */
-	error = xfs_qm_dqget_inode(ip, type, doalloc, &dqp);
-	if (error)
-		return error;
-
-	trace_xfs_dqattach_get(dqp);
-
-	/*
-	 * dqget may have dropped and re-acquired the ilock, but it guarantees
-	 * that the dquot returned is the one that should go in the inode.
-	 */
-	*IO_idqpp = dqp;
-	mutex_unlock(&dqp->q_qlock);
-	return 0;
-}
-
 static bool
 xfs_qm_need_dqattach(
 	struct xfs_inode	*ip)
@@ -360,7 +326,7 @@ xfs_qm_dqattach_locked(
 	ASSERT(!xfs_is_metadir_inode(ip));
 
 	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
-		error = xfs_qm_dqattach_one(ip, XFS_DQTYPE_USER,
+		error = xfs_qm_dqget_inode(ip, XFS_DQTYPE_USER,
 				doalloc, &ip->i_udquot);
 		if (error)
 			goto done;
@@ -368,7 +334,7 @@ xfs_qm_dqattach_locked(
 	}
 
 	if (XFS_IS_GQUOTA_ON(mp) && !ip->i_gdquot) {
-		error = xfs_qm_dqattach_one(ip, XFS_DQTYPE_GROUP,
+		error = xfs_qm_dqget_inode(ip, XFS_DQTYPE_GROUP,
 				doalloc, &ip->i_gdquot);
 		if (error)
 			goto done;
@@ -376,7 +342,7 @@ xfs_qm_dqattach_locked(
 	}
 
 	if (XFS_IS_PQUOTA_ON(mp) && !ip->i_pdquot) {
-		error = xfs_qm_dqattach_one(ip, XFS_DQTYPE_PROJ,
+		error = xfs_qm_dqget_inode(ip, XFS_DQTYPE_PROJ,
 				doalloc, &ip->i_pdquot);
 		if (error)
 			goto done;
-- 
2.47.3

