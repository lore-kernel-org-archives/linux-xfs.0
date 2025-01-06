Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55AD4159596
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 09:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736157419; cv=none; b=mJSoXT/OpqIPtmOyhHkCZSJr7lLDgp+s0TSdqCrMJhyzjBMkcPtDrpX0/Ys7rOz7WzVERnsB5HObCLBpmg7JlMeFj6Dhz2sg5yQ4DOZEYj/gAisb671+xwum/e6o47ATUVO529XWHPZ7iJkxtAOx5M08d9qTL6v1Mulp8tvOWLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736157419; c=relaxed/simple;
	bh=w/mqqOWAGHV9xRqAglEtr4ly1s4dq2a8CK+8hXozWqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4qs+XR7ZPCFPq5AOKrfpaWGCqArIguEFyROMK4NsGEoKVIRM5dsjfj9qmFQWWybfN7V/SBE/CnD1W0qv/6tsPka3EzgoS35aKSy0UN6mDJ4tqam8tAX/MWMj7uzcrSp7B3zbCl9/VWBwjGNF5twe60IVUIPAMMVM0cueDIEtXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1E4LBJAI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1E4LBJAI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aTuw2t8c7t095/pOOAwwG1lLQYmCsj1zyLUFJX1OmeY=; b=1E4LBJAIR80kEa1TAUQIddplrt
	LY6n+ghPpUWbkqVRIG/4/yiskQ21vE0PfvAxPz4fLs5LyeaWwPuT9CyMc8aljkNYdNu1gEjWILznD
	KVqJKi+ge9lN4cnNWMg1ip+cGb8WinNUN4yYzYay2l40ioQ4jcYeh0CLBQxF0gJi3iB8ThWGdPMOG
	4RuqlZGdsmPuhyrUrHalmecTCg1ufYaW32B/TEXIyRL1lz43oHmTlV1t1pE30z+0pVNdB37C1Ew5g
	+Q2uzrNNmy1beSzNj1KQu7aO2o/+2VOOxo9Knkk9GXo74DJZOLb6gwJ7SJMaizsz6jilS1tg0VdQp
	Ekn3qW/Q==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUjqz-00000000lPf-1aZI;
	Mon, 06 Jan 2025 09:56:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 14/15] xfs: move b_li_list based retry handling to common code
Date: Mon,  6 Jan 2025 10:54:51 +0100
Message-ID: <20250106095613.847700-15-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250106095613.847700-1-hch@lst.de>
References: <20250106095613.847700-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The dquot and inode version are very similar, which is expected given the
overall b_li_list logic.  The differences are that the inode version also
clears the XFS_LI_FLUSHING which is defined in common but only ever set
by the inode item, and that the dquot version takes the ail_lock over
the list iteration.  While this seems sensible given that additions and
removals from b_li_list are protected by the ail_lock, log items are
only added before buffer submission, and are only removed when completing
the buffer, so nothing can change the list when retrying a buffer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c        | 12 ++++++------
 fs/xfs/xfs_buf_item.h   |  5 -----
 fs/xfs/xfs_dquot.c      | 12 ------------
 fs/xfs/xfs_inode_item.c | 12 ------------
 4 files changed, 6 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 0ad3cacfdba1..1cf5d14d0d06 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1288,6 +1288,7 @@ xfs_buf_ioend_handle_error(
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_error_cfg	*cfg;
+	struct xfs_log_item	*lip;
 
 	/*
 	 * If we've already shutdown the journal because of I/O errors, there's
@@ -1335,12 +1336,11 @@ xfs_buf_ioend_handle_error(
 	}
 
 	/* Still considered a transient error. Caller will schedule retries. */
-	if (bp->b_flags & _XBF_INODES)
-		xfs_buf_inode_io_fail(bp);
-	else if (bp->b_flags & _XBF_DQUOTS)
-		xfs_buf_dquot_io_fail(bp);
-	else
-		ASSERT(list_empty(&bp->b_li_list));
+	list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
+		set_bit(XFS_LI_FAILED, &lip->li_flags);
+		clear_bit(XFS_LI_FLUSHING, &lip->li_flags);
+	}
+
 	xfs_buf_ioerror(bp, 0);
 	xfs_buf_relse(bp);
 	return true;
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 4d8a6aece995..8cde85259a58 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -54,17 +54,12 @@ bool	xfs_buf_item_put(struct xfs_buf_log_item *);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
 void	xfs_buf_inode_iodone(struct xfs_buf *);
-void	xfs_buf_inode_io_fail(struct xfs_buf *bp);
 #ifdef CONFIG_XFS_QUOTA
 void	xfs_buf_dquot_iodone(struct xfs_buf *);
-void	xfs_buf_dquot_io_fail(struct xfs_buf *bp);
 #else
 static inline void xfs_buf_dquot_iodone(struct xfs_buf *bp)
 {
 }
-static inline void xfs_buf_dquot_io_fail(struct xfs_buf *bp)
-{
-}
 #endif /* CONFIG_XFS_QUOTA */
 void	xfs_buf_iodone(struct xfs_buf *);
 bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index f11d475898f2..78dde811ab16 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1229,18 +1229,6 @@ xfs_buf_dquot_iodone(
 	}
 }
 
-void
-xfs_buf_dquot_io_fail(
-	struct xfs_buf		*bp)
-{
-	struct xfs_log_item	*lip;
-
-	spin_lock(&bp->b_mount->m_ail->ail_lock);
-	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
-		set_bit(XFS_LI_FAILED, &lip->li_flags);
-	spin_unlock(&bp->b_mount->m_ail->ail_lock);
-}
-
 /* Check incore dquot for errors before we flush. */
 static xfs_failaddr_t
 xfs_qm_dqflush_check(
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 912f0b1bc3cb..4fb2e1a6ad26 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -1023,18 +1023,6 @@ xfs_buf_inode_iodone(
 		list_splice_tail(&flushed_inodes, &bp->b_li_list);
 }
 
-void
-xfs_buf_inode_io_fail(
-	struct xfs_buf		*bp)
-{
-	struct xfs_log_item	*lip;
-
-	list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
-		set_bit(XFS_LI_FAILED, &lip->li_flags);
-		clear_bit(XFS_LI_FLUSHING, &lip->li_flags);
-	}
-}
-
 /*
  * Clear the inode logging fields so no more flushes are attempted.  If we are
  * on a buffer list, it is now safe to remove it because the buffer is
-- 
2.45.2

