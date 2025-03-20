Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB371DE2C2
	for <linux-xfs@vger.kernel.org>; Thu, 20 Mar 2025 07:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742457154; cv=none; b=KNZi+s86rN5lu9zdi+eJcZGKFBmYGFaq9CDN8DCDbc/pWb4SmwUOeoGC7fm06spxV8fPoilNcNPBidkJHFJRnM0/7+UhkEVWeT/NnJyFs3CPEQ3y6JRjZLvFuAtj1+uGIK+Fb+KXaNLaE5DxWZ5zT0PdFZFw3+dQTRPJdyeQ2yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742457154; c=relaxed/simple;
	bh=WuohmqBWHh9cNxt6EfOmsmK0cyvjOmBGf8BOBzae0hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUbAyALGRyzL/9X4VmlfV+gJE8UbVfH/f389hzGEyVmz3dPtbOQwpu0W/SVt4Tbch2qna9kd5f6dQmkA8f8B8/ElEpB9kF1Cv8GsKNHtIniHf0XUWPnNQglRs5EXYaZ7voGabynJ7oeICNaRcTCzXwLB2SHt5a+7dlwPQmlvUFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DAkKokIp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DAkKokIp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9anfpAxznhb4l0+8Utsny3sGkES+/gT9ASSecOGXxbo=; b=DAkKokIpKuwVDqqpHUhpoiIPM2
	G8XugUA2hug64dfnnjH8ZaL7pLoQRpxcvLBwZ8CTe1shkEu/epI1JfJf+d+KB4eHRjH2vY9FbjK6+
	xsMieMNRm3RTEoFcJqJKsi2e7dgMvuIlbqD8QHiRS3BjJOctf+WxRMPCix2J/9Uoe+kWv4/27guHM
	g+AJgVEsvzqMTX7dup9esdVao0wqGR5t63RW2W25fpCfaHX3M7qJLlcYdftHT+co5VtuBjp/c600Q
	Jy/J/FmiVmX8uPsC4t9O+VDnRkXDWDLee23x6jUBmpCJkq/+9lu3MnFoEoAr/GM1i/UywM7w20GMt
	0PyEe/fQ==;
Received: from 2a02-8389-2341-5b80-42af-3c26-e593-7625.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:42af:3c26:e593:7625] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tvAhc-0000000BSlM-25Wn;
	Thu, 20 Mar 2025 07:52:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: remove the leftover xfs_{set,clear}_li_failed infrastructure
Date: Thu, 20 Mar 2025 08:52:13 +0100
Message-ID: <20250320075221.1505190-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250320075221.1505190-1-hch@lst.de>
References: <20250320075221.1505190-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Marking a log item as failed kept a buffer reference around for
resubmission of inode and dquote items.

For inode items commit 298f7bec503f3 ("xfs: pin inode backing buffer to
the inode log item") started pinning the inode item buffers
unconditionally and removed the need for this.  Later commit acc8f8628c37
("xfs: attach dquot buffer to dquot log item buffer") did the same for
dquot items but didn't fully clean up the xfs_clear_li_failed side
for them.  Stop adding the extra pin for dquot items and remove the
helpers.

This happens to fix a call to xfs_buf_free with the AIL lock held,
which would be incorrect for the unlikely case freeing the buffer
ends up calling vfree.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c      |  3 +--
 fs/xfs/xfs_inode_item.c |  6 ------
 fs/xfs/xfs_trans_ail.c  |  5 ++---
 fs/xfs/xfs_trans_priv.h | 28 ----------------------------
 4 files changed, 3 insertions(+), 39 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index edbc521870a1..b4e32f0860b7 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1186,9 +1186,8 @@ xfs_qm_dqflush_done(
 	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags) &&
 	    (lip->li_lsn == qlip->qli_flush_lsn ||
 	     test_bit(XFS_LI_FAILED, &lip->li_flags))) {
-
 		spin_lock(&ailp->ail_lock);
-		xfs_clear_li_failed(lip);
+		clear_bit(XFS_LI_FAILED, &lip->li_flags);
 		if (lip->li_lsn == qlip->qli_flush_lsn) {
 			/* xfs_ail_update_finish() drops the AIL lock */
 			tail_lsn = xfs_ail_delete_one(ailp, lip);
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 40fc1bf900af..c6cb0b6b9e46 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -1089,13 +1089,7 @@ xfs_iflush_abort(
 	 * state. Whilst the inode is in the AIL, it should have a valid buffer
 	 * pointer for push operations to access - it is only safe to remove the
 	 * inode from the buffer once it has been removed from the AIL.
-	 *
-	 * We also clear the failed bit before removing the item from the AIL
-	 * as xfs_trans_ail_delete()->xfs_clear_li_failed() will release buffer
-	 * references the inode item owns and needs to hold until we've fully
-	 * aborted the inode log item and detached it from the buffer.
 	 */
-	clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
 	xfs_trans_ail_delete(&iip->ili_item, 0);
 
 	/*
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 0fcb1828e598..85a649fec6ac 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -909,10 +909,9 @@ xfs_trans_ail_delete(
 		return;
 	}
 
-	/* xfs_ail_update_finish() drops the AIL lock */
-	xfs_clear_li_failed(lip);
+	clear_bit(XFS_LI_FAILED, &lip->li_flags);
 	tail_lsn = xfs_ail_delete_one(ailp, lip);
-	xfs_ail_update_finish(ailp, tail_lsn);
+	xfs_ail_update_finish(ailp, tail_lsn);	/* drops the AIL lock */
 }
 
 int
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index bd841df93021..f945f0450b16 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -167,32 +167,4 @@ xfs_trans_ail_copy_lsn(
 }
 #endif
 
-static inline void
-xfs_clear_li_failed(
-	struct xfs_log_item	*lip)
-{
-	struct xfs_buf	*bp = lip->li_buf;
-
-	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags));
-	lockdep_assert_held(&lip->li_ailp->ail_lock);
-
-	if (test_and_clear_bit(XFS_LI_FAILED, &lip->li_flags)) {
-		lip->li_buf = NULL;
-		xfs_buf_rele(bp);
-	}
-}
-
-static inline void
-xfs_set_li_failed(
-	struct xfs_log_item	*lip,
-	struct xfs_buf		*bp)
-{
-	lockdep_assert_held(&lip->li_ailp->ail_lock);
-
-	if (!test_and_set_bit(XFS_LI_FAILED, &lip->li_flags)) {
-		xfs_buf_hold(bp);
-		lip->li_buf = bp;
-	}
-}
-
 #endif	/* __XFS_TRANS_PRIV_H__ */
-- 
2.45.2

