Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EF640A93E
	for <linux-xfs@vger.kernel.org>; Mon,  7 Sep 2026 07:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788766493; cv=none; b=edUgdiIwvkOHDzS5gZmoiE2+pXmdh3NViasAH95CH8w43ZNwo8uZ7RUgqdEGieDD9xfQSQo9f+tyMD0aP8Ttqs/mSRDveC7tijCUzYwZYgfb2WHxfIL7sjYPEOmjvqc8j0XnhFgw7/l6pjlk1IeU4UDuFU7D+nz0PrU2HrB3D1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788766493; c=relaxed/simple;
	bh=dwHPt5p6/ZYa5bPVuCbbrOGOGJ7BGJbn0mmLUBUht24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8lI3kFc1ikmsKyVYfr/1j8np+m7T3ns3SlRq98Se0ijgNvXfUoP9Jm63XAFIE4isRg54Fs7iYghK1Qz2SBN/qa6X3ITGpnBIuOo+BEj/2U+JgZ3BkNAHcb15wvd57KIHXf7RoHntF7NwXes4PPtWqugOK5jNSKRTwJSeKer6EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DqXxV2nl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DqXxV2nl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IIaezrPm+M/NDg/y5uFvDA9tvpe0Yb6UaAUbBP1Rxg0=; b=DqXxV2nlDwkWL03HsfQ0hds9nj
	MjoapyiF80s1PbSk/iALx7B6z0wo12UJA3dw2//g0nvCJXjhE9fO0e11t+F0rG0p55ZshDJQST4D3
	ujf4J5pOujide3P+pPvpTJBtBk18L7tBOr2gYnzGFmYHuhvMTkFZ+2UdCFH01DNAnLUn/+42Igoxw
	aNfP8JXxvH8uKh4QHGfR6B7pkU9E/HWsU4oRKqwmQJBk8pKGzlcecZ+ApZgTWF14rDOsXjU8CjQH6
	OlqXUYuvgDpV9MuYSH3/ziBF//iJsnsoMM+ALw7fauooKV2n6xNPmCdzL9Kvo1fA0kqEN/AZXGoQL
	aQvdl1hw==;
Received: from [91.92.197.219] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x3TsP-00000006AVu-3QKi;
	Mon, 07 Sep 2026 07:34:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 2/3] xfs: don't continue on error in xfs_fsync
Date: Mon,  7 Sep 2026 10:33:08 +0300
Message-ID: <20260907073427.719935-3-hch@lst.de>
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

As soon as we get an error from cache flushing or log forcing, there
is no point in continuing as the data integrity is already impacted.
Return the error instead of continuing to do more work.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 426a67b813a7..0d31fea67a2c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -130,8 +130,8 @@ xfs_file_fsync(
 {
 	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
 	struct xfs_mount	*mp = ip->i_mount;
-	int			error, err2;
 	int			log_flushed = 0;
+	int			error;
 
 	trace_xfs_file_fsync(ip);
 
@@ -154,15 +154,17 @@ xfs_file_fsync(
 		error = blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
 	else if (mp->m_logdev_targp != mp->m_ddev_targp)
 		error = blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
+	if (error)
+		return error;
 
 	/*
 	 * If the inode has a inode log item attached, it may need the journal
 	 * flushed to persist any changes the log item might be tracking.
 	 */
 	if (ip->i_itemp) {
-		err2 = xfs_fsync_flush_log(ip, datasync, &log_flushed);
-		if (err2 && !error)
-			error = err2;
+		error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
+		if (error)
+			return error;
 	}
 
 	/*
@@ -178,14 +180,11 @@ xfs_file_fsync(
 	if (!log_flushed) {
 		struct xfs_buftarg *file_targp = xfs_inode_buftarg(ip);
 
-		if (mp->m_logdev_targp == file_targp) {
-			err2 = blkdev_issue_flush(file_targp->bt_bdev);
-			if (err2 && !error)
-				error = err2;
-		}
+		if (mp->m_logdev_targp == file_targp)
+			return blkdev_issue_flush(file_targp->bt_bdev);
 	}
 
-	return error;
+	return 0;
 }
 
 static int
-- 
2.53.0

