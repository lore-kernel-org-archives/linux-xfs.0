Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42ABB3D7D91
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 09:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790243897; cv=none; b=pGTvMLC/ZrR3Bjl51N8IWIt7Q9lVCtxNLeCrNbfAwgrjmRyXVldEQTHPdjvx2v4ZaWZjZwcyv0RAq9ICS3Qe+oCigxDtveitrTxuRTnTr1/YlfEhqKu/Q2HMbBWy0bZ/yUsNXuQwdm2EiE8H7teMKs4KYIsycURyVVwv4pbCxyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790243897; c=relaxed/simple;
	bh=9ij3o5DuZqGB/aCJ/FuVswqaLysljwvh8kj6gkiKnO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=db/lQaCycySGMjvgJoMKfw0d8QHTUqFUCl4iY37gtcPE7qQo7Pt5Zcs/9xrkxAJUA/77Nzx9W3rrlUJQ8qGjwRqeaXGd67tQOKJsB14GfWgjt/GZuZJU04K2Jz2V/6Wwol7TzKICRaSQa9tcP2spJeAQHhDFW0di3lKebABnB3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iFCxMr+6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iFCxMr+6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4SFik6R8I6QKqVVN1CF1f9Dd2ghz/+PayioqJyq4l84=; b=iFCxMr+6O7awVB0msuZHXKHQnb
	H8y2+zxehx5K1refxWP9osm6J9n1Rc/pMP/nD391Ed2oVB+38G+wyKo9kXtl4tWrfjT9GKiXcAGSl
	G5hwNWBHQJGpRLIgB7j9219AhNIfeAqctvNf7kyOMamz9sWg1PEZPZIX9AeFIx1wKM+qTJfmal7jA
	Ypv+5JGhqlXJ3YcPTE2EH/ArXWBg9asbSsDkYjAGDCW2+pn2n56+2o6iwpQpGiBTWO66mVy8sEkXf
	NTKFMc9xdZjLZs2cpxbsk/Khx5g37iy+HWs2zZnAxnD855r/5w6427g9T4oXePsWZ6ZLmZEWXpPqL
	/ywMtkhQ==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gDL-0000000AeNK-0OBS;
	Thu, 24 Sep 2026 09:58:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 6/9] xfs: lift setting the NOFS context to xfs_end_io
Date: Thu, 24 Sep 2026 11:57:07 +0200
Message-ID: <20260924095740.2732474-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924095740.2732474-1-hch@lst.de>
References: <20260924095740.2732474-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

No point in clearing and restoring it for every processed bio.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioend.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
index e70be5b86f0b..258c6130bee8 100644
--- a/fs/xfs/xfs_ioend.c
+++ b/fs/xfs/xfs_ioend.c
@@ -175,16 +175,8 @@ xfs_end_ioend_write(
 	bool			is_zoned = xfs_is_zoned_inode(ip);
 	xfs_off_t		offset = ioend->io_offset;
 	size_t			size = ioend->io_size;
-	unsigned int		nofs_flag;
 	int			error;
 
-	/*
-	 * We can allocate memory here while doing writeback on behalf of
-	 * memory reclaim.  To avoid memory allocation deadlocks set the
-	 * task-wide nofs context for the following operations.
-	 */
-	nofs_flag = memalloc_nofs_save();
-
 	/*
 	 * Just clean up the in-memory structures if the fs has been shut down.
 	 */
@@ -241,7 +233,6 @@ xfs_end_ioend_write(
 	if (is_zoned)
 		xfs_ioend_put_open_zones(ioend);
 	iomap_finish_ioends(ioend, error);
-	memalloc_nofs_restore(nofs_flag);
 }
 
 /*
@@ -266,6 +257,7 @@ xfs_end_io(
 		container_of(work, struct xfs_inode, i_ioend_work);
 	struct iomap_ioend	*ioend;
 	struct list_head	tmp;
+	unsigned int		nofs_flag;
 	unsigned long		flags;
 
 	spin_lock_irqsave(&ip->i_ioend_lock, flags);
@@ -273,6 +265,13 @@ xfs_end_io(
 	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
 
 	iomap_sort_ioends(&tmp);
+
+	/*
+	 * We can allocate memory here while doing writeback on behalf of
+	 * memory reclaim.  To avoid memory allocation deadlocks set the
+	 * task-wide nofs context for the following operations.
+	 */
+	nofs_flag = memalloc_nofs_save();
 	while ((ioend = list_first_entry_or_null(&tmp, struct iomap_ioend,
 			io_list))) {
 		list_del_init(&ioend->io_list);
@@ -280,6 +279,7 @@ xfs_end_io(
 		xfs_end_ioend_write(ioend);
 		cond_resched();
 	}
+	memalloc_nofs_restore(nofs_flag);
 }
 
 void
-- 
2.53.0

