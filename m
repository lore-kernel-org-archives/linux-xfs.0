Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C188730D407
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 05:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328201; cv=none; b=I80L6BDfSjoI7yV6KszOYRd3twW7hF1im4goYGfQTKXKTv0ec47dGsrZLG9+umxUihPDlccAD3/ghY43jri3+toi2fdtXErIQkMPlaYwxIZU4IYr4Jauy3eomGQq40CfFmYSjiLOgn8sBZfp6J/XZ+8VXkpCFHEqZjNBxfFfeOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328201; c=relaxed/simple;
	bh=DIHDOib2uYC4uU8Bt7LvAkeL9FHW53knHIKA1mJ+gYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPI+ZwK6Br+kBWXETtaNhhP56B4+my37ykXc4Nknh1KscPBEzxQC5cFN3934e7v20i+OUqF78ybubY/owhBHRVGKWWK7z/T1uLnjJ54xgA6LKx4h6zNnnrQZL7Ba1eR7hnQqPtrbWniPS9y+9bamNX7Vv58qH6oieU3hryMtOog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oCaZfd11; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oCaZfd11"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vDRoEIy+FC60AEMiutdtaZfp4Np6+qB0cBNLGVXzyWw=; b=oCaZfd11kvYbQiiSPyyoahkSp4
	LCUjcySMsq+Z0OlPAV/PaxutHVXB35WZIqJAL0WTN+YcsRSCW1WTLU/QaMyT2TEbPIB9YejNQXD4f
	Jro9hstzlr8mmXe5GXCnG60LwbIQYglYX7dm5frvKyBma4f0NFyv6bYlGgTGN7/uRZ7neaAzPAUAd
	2ZbI/Jf8JCg+zYDgUpuzxtWG8oTXTz+F6HxjFjz7+GIAhfoYXVIsD4aQiGPG0+YBzru1keyofhYVi
	WU7cNwuGEKfEpfbjQksbC1OMMRdL+IzHiFAA8QmJMmxd7MOokl1WBwC5I2V7yJOJDLBIkvNqhH9E7
	XLxnL95g==;
Received: from 87-119-185-211.ip.elisa.ee ([87.119.185.211] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1drC-0000000Dp5p-2tqY;
	Wed, 02 Sep 2026 05:49:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 4/6] xfs: avoid extra cache flushes for multi-device file systems in xfs_fsync
Date: Wed,  2 Sep 2026 08:49:18 +0300
Message-ID: <20260902054942.111988-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902054942.111988-1-hch@lst.de>
References: <20260902054942.111988-1-hch@lst.de>
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

The explicit flush of the data that the device resides on when no iclog
was written out is still required.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 36 +++++++++---------------------------
 1 file changed, 9 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index cce324321b4c..795e72e1b599 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -128,7 +128,6 @@ xfs_file_fsync(
 	int			datasync)
 {
 	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
-	struct xfs_mount	*mp = ip->i_mount;
 	int			log_flushed = 0;
 	int			error;
 
@@ -138,27 +137,17 @@ xfs_file_fsync(
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
@@ -172,17 +161,10 @@ xfs_file_fsync(
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

