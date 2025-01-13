Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC91723ED45
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 14:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736777598; cv=none; b=iM5fEks/bOxk4yjJcc6k+u3U/IXdObi/TQp1JZXcL/R6jPPA/DXWFkvAGw1RUOZkVDI0gG2AFkI620OCtwPwvce6IkDGg1Qht2JViXisnTgO3LMIoBgXDrOIyLZP/ObPvX0UQ5PIKWOECTlTwOhaoFpKFS7XaMBoCDb8IMlm+T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736777598; c=relaxed/simple;
	bh=OmQSIKhUjJq1/Bva9O8qRqJ4zOkzl9Z8adFPsXxcBPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3LhfoOwWXJqxNKe91EuTxg2D9QjpHPS0yt2HLaF5AoUAK09JNm4CMXDQEmscjr7bxK0ZWKovdOFRQfMkBdxNduhrmSex0CfHZwxHft/lU0DZIi9j2HhUlazhlRo4+8NZLoe/YLPCGvXGxjpc5LDJMySxww5/ViEfIthd5uOJ/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iRfQmZ1x; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iRfQmZ1x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=37OxpMFA8hdKCUHC8t3+yrU8JXZ2d5NS5i0ryB+h1b0=; b=iRfQmZ1xsavOwl1YjchwXm6adC
	ank9u5HZyOh4NK85b8YN4GAPgUgkzaQYz42itxR81jb9XRKNKODzNIAaz5AuXDCmRjMy+wH71yu2K
	YO+pGkhqUv6Gm02Bzu+odLrfu0Ky5bKFFNHpAJ752n4aiKDGB/t6NT+8O2pw7lIqUzlubxognB0px
	akbkNyfALnpkld0FHzU8ttjGcCKPEKI+BB0XvZYVZBo6ZX736IfNz8NdGDZabxT8Rw+abNr5OigY+
	LJKjhLy2T+zKujMWj6uq4DyTYSuWUwj9Zj8jKoh63zvw7qMzxCwNkTWY0ZF1h8BG8d27p+wAwI+cO
	lkg3Oq6g==;
Received: from 2a02-8389-2341-5b80-b273-11c2-5421-183d.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:b273:11c2:5421:183d] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXLBs-00000005Mum-0027;
	Mon, 13 Jan 2025 14:13:16 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 14/15] xfs: move b_li_list based retry handling to common code
Date: Mon, 13 Jan 2025 15:12:18 +0100
Message-ID: <20250113141228.113714-15-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250113141228.113714-1-hch@lst.de>
References: <20250113141228.113714-1-hch@lst.de>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c        | 12 ++++++------
 fs/xfs/xfs_buf_item.h   |  5 -----
 fs/xfs/xfs_dquot.c      | 12 ------------
 fs/xfs/xfs_inode_item.c | 12 ------------
 4 files changed, 6 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 8e795ccd57d6..d5e23c4c7674 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1286,6 +1286,7 @@ xfs_buf_ioend_handle_error(
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_error_cfg	*cfg;
+	struct xfs_log_item	*lip;
 
 	/*
 	 * If we've already shutdown the journal because of I/O errors, there's
@@ -1333,12 +1334,11 @@ xfs_buf_ioend_handle_error(
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
index 84b69f686ba8..1082c5d980c8 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1230,18 +1230,6 @@ xfs_buf_dquot_iodone(
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
index 70283c6419fd..9b3dac5b2a33 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -1039,18 +1039,6 @@ xfs_buf_inode_iodone(
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

