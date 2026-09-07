Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90513CFF5C
	for <linux-xfs@vger.kernel.org>; Mon,  7 Sep 2026 07:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788766508; cv=none; b=oLA2pug0HuSV1Mbc8GlWo3j1cfspuFDD+IjAeQAT+sRd4LDAyeKBBrFHznDpTfvOZIfesCzgY8BDx3FE41URkqz2A3EgSyGntIRA79mJkpIZzh4VkTkl9dqhjZUQdd0V7KduGUUW8w87/RmpcklKs6bG07dNmJiO7LottCvSPtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788766508; c=relaxed/simple;
	bh=jSZ9lpmra+NKoHccggoZ86IrZs+PhQSDSzfzcKtyt6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzHv6sTwv7CgT5SCV3H/9Rg6zrxQHkhgmLcsA7VA/tOtxGyHhq7E2+JETJ0eQeJ58rCbZnuK9MbAN5zdPnERh0gw1ch/+T5SbVrKksCRrqVXYU/r5X5ZCYoZlBdKeTQX/rEgqLEe2yyKa9vj/5eAyBmYSD+hgP+PJ57I61WZfzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WEZinVL5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WEZinVL5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hqq9q3KQm9IcrVxMfCRmOXejegOiKIlsR26121rVbqs=; b=WEZinVL5vEPFBy4zKrnVNiM7A3
	Hdw7/JcJQjALO2XnaoCIvzcOehFtD1n6Y9liFZQ9bSaX5BDtuEGVWIYNBoZVipvhg8LvJ2G/LjK3+
	d4e6xeua/YA8y15c1zrr89zEk9ovY5lkzZtXyPvZZVErsmAhL22OxbPKKCvyXzwpur8OJDBdu6o9p
	nL6Ag6gcb4LR7Z1PA79tl4oLwhv8ia6RNFsFNMcfK3OmYIjJUsWcPmsv1ssF838C44zu5wu0YLwpP
	7NGdC9yZya5QYfqzT1WbR8vJka0QkNwETN97ucDtg1n8wCZue9KuX082CSjKmyWgS3aAzRAPu86H5
	TlmtiV1A==;
Received: from [91.92.197.219] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x3Tsd-00000006AXO-0179;
	Mon, 07 Sep 2026 07:35:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 3/3] xfs: avoid extra cache flushes for multi-device file systems in xfs_fsync
Date: Mon,  7 Sep 2026 10:33:09 +0300
Message-ID: <20260907073427.719935-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907073427.719935-1-hch@lst.de>
References: <20260907073427.719935-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When xlog_force_lsn sets log_flushed, it has just called xlog_force_iclog
through xlog_force_and_check_iclog, which sets XLOG_ICL_NEED_FLUSH before
writing out the head iclog.  This means that we already flushed the log,
data, and (with the recent fix) RT devices before writing out the iclog
start record and no extra cache flushed is required.

This optimizes the external log case, and fixes a performance regression
due to double RT dev flushes with "xfs: also flush the RT device cache in
xlog_write_iclog".

The explicit flush of the data that the device resides on when no iclog
was written out is still required.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 36 +++++++++---------------------------
 1 file changed, 9 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 0d31fea67a2c..d8202da15aca 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -129,7 +129,6 @@ xfs_file_fsync(
 	int			datasync)
 {
 	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
-	struct xfs_mount	*mp = ip->i_mount;
 	int			log_flushed = 0;
 	int			error;
 
@@ -139,27 +138,17 @@ xfs_file_fsync(
 	if (error)
 		return error;
 
-	if (xfs_is_shutdown(mp))
+	if (xfs_is_shutdown(ip->i_mount))
 		return -EIO;
 
 	xfs_iflags_clear(ip, XFS_ITRUNCATED);
 
 	/*
-	 * If we have an RT and/or log subvolume we need to make sure to flush
-	 * the write cache the device used for file data first.  This is to
-	 * ensure newly written file data make it to disk before logging the new
-	 * inode size in case of an extending write.
-	 */
-	if (XFS_IS_REALTIME_INODE(ip) && mp->m_rtdev_targp != mp->m_ddev_targp)
-		error = blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
-	else if (mp->m_logdev_targp != mp->m_ddev_targp)
-		error = blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
-	if (error)
-		return error;
-
-	/*
-	 * If the inode has a inode log item attached, it may need the journal
-	 * flushed to persist any changes the log item might be tracking.
+	 * If the inode has a log item attached, we must force the log up to the
+	 * last LSN in which the inode was modified to ensure all metadata is
+	 * persisted.  The log force will flush the caches for all devices
+	 * before writing the log records unless it is a no-op because there are
+	 * no modifications to this inode that need to be pushed out.
 	 */
 	if (ip->i_itemp) {
 		error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
@@ -173,17 +162,10 @@ xfs_file_fsync(
 	 * when no metadata needed to be committed.
 	 *
 	 * Use the inode's actual file data target rather than assuming the
-	 * main data device. Realtime inodes with a separate realtime device
-	 * are flushed before the log force, so this fallback only applies
-	 * when the file data target is the same as the log target.
+	 * main data device.
 	 */
-	if (!log_flushed) {
-		struct xfs_buftarg *file_targp = xfs_inode_buftarg(ip);
-
-		if (mp->m_logdev_targp == file_targp)
-			return blkdev_issue_flush(file_targp->bt_bdev);
-	}
-
+	if (!log_flushed)
+		return blkdev_issue_flush(xfs_inode_buftarg(ip)->bt_bdev);
 	return 0;
 }
 
-- 
2.53.0

