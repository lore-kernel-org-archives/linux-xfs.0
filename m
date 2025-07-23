Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A6FEEDE
	for <linux-xfs@vger.kernel.org>; Wed, 23 Jul 2025 12:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753273219; cv=none; b=QtTApPbMcFCSoFQAZVm3zhdo+qsqE5xSYhT3FMgZ3Z2a4ExzNArmPvFGn5C7QamJNorZvX9IPj5anRDzKWpwDwZ5w0GmBE4cW7n43LWh3NDEWgpFaeJcBTxRSMfrCGXHx/U6IkKeDPlCaK4pu6G6CPEoG/49Ghg8TYjnrBhkv7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753273219; c=relaxed/simple;
	bh=R48nTpsDqqJWOKukCS1pWSiG5wESkEMk64ZpoJ8bjFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogK4D2n2PzFJaQ9S0NkjrQ3kT4ByF5OkaTpm7KN3iIqBN6GoxwhRmnndpdS8sAnR2zIGiF1DIez9zLepsUMJWse/0Wu4d2rddHBy6jS6mglCnp7FYPn4FxqUHgarxSk2zhRB0UHyXP5SxaRuEkXK54wOzfm3Z9oYsIdquKb5B1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BJ6RUeP2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BJ6RUeP2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3TcsjmcXx8hNggo0aJ8LwSvbVz9f6T2uf+riN/eg0d0=; b=BJ6RUeP2PPDYm/GmOCCDyix+/G
	a2RO7s5lQ4b3AdMtX7+WOes3y+ndotm+Z5aoN4ntpLwqd0h+p+pKXMjPk3I8ASsgUo+FU/n6p3a8g
	87pVFS6/MUOFw8BYXh/eiBSQDq3DKdJOL1JvxnYNz/vmFOKMHWo+XVdyN4YgXlUeq9Wt/IJ8wQH1Y
	mz78DFuQ4k5sPM6BKZuVYEDmDxJiLWXlO5dUdQWKe1ohrh49d5Mh0/4UEpwkM9SMnBbNw0QkE5Zry
	uYENczYHBvzrWWn0NztJ+kPGkE596UX6/mdTICY0UX9VQu6uNTbKZQbZVLUvEQAIc+7tDVfdPic5L
	Fm1P49yw==;
Received: from [2001:67c:1232:144:a1d2:d12d:cb2d:5181] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ueYSH-00000004tVg-1KOg;
	Wed, 23 Jul 2025 12:20:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: cen zhang <zzzccc427@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: remove XFS_IBULK_SAME_AG
Date: Wed, 23 Jul 2025 14:19:45 +0200
Message-ID: <20250723122011.3178474-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250723122011.3178474-1-hch@lst.de>
References: <20250723122011.3178474-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a new field to struct xfs_ibulk to directly pass XFS_IWALK* flags,
and thus remove the need to indirect the SAME_AG flag through
XFS_IBULK*.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c  |  2 +-
 fs/xfs/xfs_itable.c | 12 ++----------
 fs/xfs/xfs_itable.h | 10 ++++------
 3 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index fe1f74a3b6a3..e1051a530a50 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -219,7 +219,7 @@ xfs_bulk_ireq_setup(
 		else if (XFS_INO_TO_AGNO(mp, breq->startino) < hdr->agno)
 			return -EINVAL;
 
-		breq->flags |= XFS_IBULK_SAME_AG;
+		breq->iwalk_flags |= XFS_IWALK_SAME_AG;
 
 		/* Asking for an inode past the end of the AG?  We're done! */
 		if (XFS_INO_TO_AGNO(mp, breq->startino) > hdr->agno)
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 5116842420b2..2aa37a4d2706 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -307,7 +307,6 @@ xfs_bulkstat(
 		.breq		= breq,
 	};
 	struct xfs_trans	*tp;
-	unsigned int		iwalk_flags = 0;
 	int			error;
 
 	if (breq->idmap != &nop_mnt_idmap) {
@@ -328,10 +327,7 @@ xfs_bulkstat(
 	 * locking abilities to detect cycles in the inobt without deadlocking.
 	 */
 	tp = xfs_trans_alloc_empty(breq->mp);
-	if (breq->flags & XFS_IBULK_SAME_AG)
-		iwalk_flags |= XFS_IWALK_SAME_AG;
-
-	error = xfs_iwalk(breq->mp, tp, breq->startino, iwalk_flags,
+	error = xfs_iwalk(breq->mp, tp, breq->startino, breq->iwalk_flags,
 			xfs_bulkstat_iwalk, breq->icount, &bc);
 	xfs_trans_cancel(tp);
 	kfree(bc.buf);
@@ -447,21 +443,17 @@ xfs_inumbers(
 		.breq		= breq,
 	};
 	struct xfs_trans	*tp;
-	unsigned int		iwalk_flags = 0;
 	int			error = 0;
 
 	if (xfs_bulkstat_already_done(breq->mp, breq->startino))
 		return 0;
 
-	if (breq->flags & XFS_IBULK_SAME_AG)
-		iwalk_flags |= XFS_IWALK_SAME_AG;
-
 	/*
 	 * Grab an empty transaction so that we can use its recursive buffer
 	 * locking abilities to detect cycles in the inobt without deadlocking.
 	 */
 	tp = xfs_trans_alloc_empty(breq->mp);
-	error = xfs_inobt_walk(breq->mp, tp, breq->startino, iwalk_flags,
+	error = xfs_inobt_walk(breq->mp, tp, breq->startino, breq->iwalk_flags,
 			xfs_inumbers_walk, breq->icount, &ic);
 	xfs_trans_cancel(tp);
 
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index f10e8f8f2335..2d0612f14d6e 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -13,17 +13,15 @@ struct xfs_ibulk {
 	xfs_ino_t		startino; /* start with this inode */
 	unsigned int		icount;   /* number of elements in ubuffer */
 	unsigned int		ocount;   /* number of records returned */
-	unsigned int		flags;    /* see XFS_IBULK_FLAG_* */
+	unsigned int		flags;    /* XFS_IBULK_FLAG_* */
+	unsigned int		iwalk_flags; /* XFS_IWALK_FLAG_* */
 };
 
-/* Only iterate within the same AG as startino */
-#define XFS_IBULK_SAME_AG	(1U << 0)
-
 /* Fill out the bs_extents64 field if set. */
-#define XFS_IBULK_NREXT64	(1U << 1)
+#define XFS_IBULK_NREXT64	(1U << 0)
 
 /* Signal that we can return metadata directories. */
-#define XFS_IBULK_METADIR	(1U << 2)
+#define XFS_IBULK_METADIR	(1U << 1)
 
 /*
  * Advance the user buffer pointer by one record of the given size.  If the
-- 
2.47.2

