Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5A335948
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323807; cv=none; b=BhVVKeVxifEjxx1/dSF6ep3aYNqjdGrVj490OUKDMG3tl8cAqimee1H5jnNuuMrT4eL5ndYEhO64NkhERkWLCp4IGOwX+re0HgPN/qSOIYbp/KSun9QucfsOdEL0/TGSHpCaED2eHoOT5zFzVUBAfUNSjT82/cR8Fof+rAzULEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323807; c=relaxed/simple;
	bh=iFY3MZZzhS/yGP+NUn7jWk3Zi7WrdgP+zSsWqAXagZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMcM2h4BdKCpghqQc75P/Iy++blTH+D/qPCW9Y7+aAgMROzr3WBV6MDPiMu4uOQ3/20w33/dhVv7ZGaGHcJakAtRaTo0Kf4k7kAGO1b0AxENZHXga8fiwIANd0otFm+IpKrBx/oO/Co9zHps6UNmSz0g2F+cEHT2wLiswmyTcRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=w7t+jOKj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="w7t+jOKj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2PFpWdUiRDkY+KANeWibNdcvCk7BM57RSL2AFFXAfBw=; b=w7t+jOKjio9fVy6+IdULLACJBc
	18B2pkFtZKzf97TPWMPbvo/REOeurR81+BnzteANyBrog3xPhuGlkd2nEYSUgG7pBci/TVTf68Xf0
	Wosj+XfIaj8+9LwT1YeoTmCZA0x7NDrSisOika2kqIswuFRneCK/sTaYyrEwwVPqUCwY0gHVinb1X
	kaxcH3qwfsJ0ccrqxE7z74/ydEGJJgUnocfIvtXzbC/HnCapaIqA5FKXsUiLazzs3anl3Zx987MFt
	FY5VLAZIQhBk393vJpwLjCwDuDOBYvIiqZA9556zye6u+K6AP51Za1j5NNR8AH2wQv6uwSQsWJlNS
	k/b72o7A==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88dR-0000000C7lh-1z4b;
	Mon, 13 Oct 2025 02:50:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 17/17] xfs: reduce ilock roundtrips in xfs_qm_vop_dqalloc
Date: Mon, 13 Oct 2025 11:48:18 +0900
Message-ID: <20251013024851.4110053-18-hch@lst.de>
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

xfs_qm_vop_dqalloc only needs the (exclusive) ilock for attaching dquots
to the inode if not done so yet.  All the other locks don't touch the inode
and don't need the ilock - the i_rwsem / iolock protects against changes
to the IDs while we are in a method, and the ilock would not help because
dropping it for the dqget calls would be racy anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm.c | 32 +++-----------------------------
 1 file changed, 3 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 7fbb89fcdeb9..336de0479022 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1861,16 +1861,12 @@ xfs_qm_vop_dqalloc(
 	struct xfs_dquot	*gq = NULL;
 	struct xfs_dquot	*pq = NULL;
 	int			error;
-	uint			lockflags;
 
 	if (!XFS_IS_QUOTA_ON(mp))
 		return 0;
 
 	ASSERT(!xfs_is_metadir_inode(ip));
 
-	lockflags = XFS_ILOCK_EXCL;
-	xfs_ilock(ip, lockflags);
-
 	if ((flags & XFS_QMOPT_INHERIT) && XFS_INHERIT_GID(ip))
 		gid = inode->i_gid;
 
@@ -1879,37 +1875,22 @@ xfs_qm_vop_dqalloc(
 	 * if necessary. The dquot(s) will not be locked.
 	 */
 	if (XFS_NOT_DQATTACHED(mp, ip)) {
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		error = xfs_qm_dqattach_locked(ip, true);
-		if (error) {
-			xfs_iunlock(ip, lockflags);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		if (error)
 			return error;
-		}
 	}
 
 	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
 		ASSERT(O_udqpp);
 		if (!uid_eq(inode->i_uid, uid)) {
-			/*
-			 * What we need is the dquot that has this uid, and
-			 * if we send the inode to dqget, the uid of the inode
-			 * takes priority over what's sent in the uid argument.
-			 * We must unlock inode here before calling dqget if
-			 * we're not sending the inode, because otherwise
-			 * we'll deadlock by doing trans_reserve while
-			 * holding ilock.
-			 */
-			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, from_kuid(user_ns, uid),
 					XFS_DQTYPE_USER, true, &uq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				return error;
 			}
-			/*
-			 * Get the ilock in the right order.
-			 */
-			lockflags = XFS_ILOCK_SHARED;
-			xfs_ilock(ip, lockflags);
 		} else {
 			/*
 			 * Take an extra reference, because we'll return
@@ -1922,15 +1903,12 @@ xfs_qm_vop_dqalloc(
 	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
 		ASSERT(O_gdqpp);
 		if (!gid_eq(inode->i_gid, gid)) {
-			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, from_kgid(user_ns, gid),
 					XFS_DQTYPE_GROUP, true, &gq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				goto error_rele;
 			}
-			lockflags = XFS_ILOCK_SHARED;
-			xfs_ilock(ip, lockflags);
 		} else {
 			ASSERT(ip->i_gdquot);
 			gq = xfs_qm_dqhold(ip->i_gdquot);
@@ -1939,15 +1917,12 @@ xfs_qm_vop_dqalloc(
 	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
 		ASSERT(O_pdqpp);
 		if (ip->i_projid != prid) {
-			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, prid,
 					XFS_DQTYPE_PROJ, true, &pq);
 			if (error) {
 				ASSERT(error != -ENOENT);
 				goto error_rele;
 			}
-			lockflags = XFS_ILOCK_SHARED;
-			xfs_ilock(ip, lockflags);
 		} else {
 			ASSERT(ip->i_pdquot);
 			pq = xfs_qm_dqhold(ip->i_pdquot);
@@ -1955,7 +1930,6 @@ xfs_qm_vop_dqalloc(
 	}
 	trace_xfs_dquot_dqalloc(ip);
 
-	xfs_iunlock(ip, lockflags);
 	if (O_udqpp)
 		*O_udqpp = uq;
 	else
-- 
2.47.3

