Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB7235948
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323778; cv=none; b=jOzeM2KEU5MaVeRzisJZFKI73Bd5LpTRXU9o8cMWHhxDVNQaJgG1W7oQdMWX18VKa2Kv9G1ljHQD3x61SV2I3RCVNcGx8tl+iz3zrQWP1Moqbb8fjN97EoAnzcTl1SBlAfUxydm/A7cWLCQS6JkLJF2wGbTd6VSUNJPDbbono3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323778; c=relaxed/simple;
	bh=koUwf974DQpjeF894KjFyGzKlMnQbD9cmkoiuhQYmoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIbuMiThmZUPFQ1jxG30N8l7/nDM4M6zKaONMmCpmpOwiwvkS0ODV3IY9ksN9td2w84fU6RaXgrdEtV/DaZNJgQ4WFEuj2NM1Gw5Mji3c2XZDfGeBtzp0XehaxjgQikW1mvAlHYqj+YTeNyz8yMjOAvATFGSpNjh7a2TphTQaQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZZn/quMm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZZn/quMm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UuLEg5P73G7nNHcx/hmcb5AfzLITAiGPAhjIc0T9NAA=; b=ZZn/quMm2QKNE00ACs86w1vh26
	eiYXbo2u8UvonZK9QNarT32o3PDpKvhO4eKOLpJmUQYPhPzEmP9XldUckDfzHcIdQDCzbj7pu3nQc
	dAvHxwGqwP2fNSAsTlv/0Pua/NoOdYjhCfr2JEzaFa5e/fC7+nW22cepQBTYq2xQlxcYMK4l0KIJe
	k5nurQKEVuifNa2jr03T2oudOyjNKIpGrtoKZI8HVdvU/oC+cPx2lK549HhmW5ZeZYHukxVI7KmrH
	eO3DMkNumTkXgghpZMqArUMFDtKIK8Og8d4IHR/E/5E64jUW2wiXmQwiz+f0SxoqmryLRdCZ0Pxfx
	MpIFhV3A==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88cy-0000000C7gj-1tGh;
	Mon, 13 Oct 2025 02:49:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 09/17] xfs: fold xfs_qm_dqattach_one into xfs_qm_dqget_inode
Date: Mon, 13 Oct 2025 11:48:10 +0900
Message-ID: <20251013024851.4110053-10-hch@lst.de>
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

xfs_qm_dqattach_one is a thin wrapper around xfs_qm_dqget_inode.  Move
the extra asserts into xfs_qm_dqget_inode, drop the unneeded q_qlock
roundtrip and merge the two functions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c |  9 ++++++---
 fs/xfs/xfs_qm.c    | 40 +++-------------------------------------
 2 files changed, 9 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index a6030c53a1f9..fa493520bea6 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -992,7 +992,7 @@ xfs_qm_dqget_inode(
 	struct xfs_inode	*ip,
 	xfs_dqtype_t		type,
 	bool			can_alloc,
-	struct xfs_dquot	**O_dqpp)
+	struct xfs_dquot	**dqpp)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
@@ -1001,6 +1001,9 @@ xfs_qm_dqget_inode(
 	xfs_dqid_t		id;
 	int			error;
 
+	ASSERT(!*dqpp);
+	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
+
 	error = xfs_qm_dqget_checks(mp, type);
 	if (error)
 		return error;
@@ -1063,8 +1066,8 @@ xfs_qm_dqget_inode(
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
index 80c99ef91edb..9e173a4b18eb 100644
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

