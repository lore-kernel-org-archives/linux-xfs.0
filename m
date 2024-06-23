Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE96B20E3
	for <linux-xfs@vger.kernel.org>; Sun, 23 Jun 2024 05:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719120952; cv=none; b=gQg5Ll+zy9BiUEJUphLS8fvfgPuN4AtZR+SVd3PjouqdkR/Asntjs+4v5NsJCdcL5oHFuoNAZQIV+7FLLWoRCYphtYC8ToVR7Bq65JtP/MBnzY1DrvgBUk9AIrL61pZ4XWSxVuLU32jFjXK10ZLIDOlDcLNss0Neyo114ATfNvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719120952; c=relaxed/simple;
	bh=i9n168gM0dDFdc3s9KafIGIjC05KkC8o36NgBEE7FiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZ9c5mkVqEt2+YjGB1dJUi6BrBI01WiZQ7gPGXCquVQRgiw3G5m4yqjmsMkfwQCVVzZbqYw4VF59LL7EepDxkrWYOKywXZcnXOh9xE9guTFm54eGRwZmNlQqOMr42c2yDL6gmVISgM6luSBV+k7dORjqHpYFiGh5z55WC8TGZ0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=x/GqvJvw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="x/GqvJvw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Q9gmdjiWxsfAIqVzBM7T0E2hm79GGb2nIZ8r6MpscLI=; b=x/GqvJvwIyWqPTQuU6ViBNVnks
	iHibOJQzGJYk9d6GrKekuP1X4ensz4wbCOWst4WozS2x0NqsAY1MlLpJBl5Imgzi0/BssBeLOS4rR
	Gb5jZg7HfK3+eQ27vdEEMmVEHhAIhiOzEBrUlSNY/uWALL6EZr5PRy8i5kOtrjvY/JiWUbvKgodcG
	z2P+Xwbix8rSyXa5bpmw7SlU8KK6O+VS7DPXERB/ub8pzziZvt5jb/QyI5lBAmDrfks8UaNGzNPuM
	k/jTBAHn8KII5R1v8JFecseeaZbreynjI2kvYRW8jF/7Ig8DqVOSaWKcJ3O8eGwqLwqesd1+QmYL/
	k4O2bROw==;
Received: from 2a02-8389-2341-5b80-9456-578d-194f-dacd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9456:578d:194f:dacd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLFtF-0000000DOFm-3bEU;
	Sun, 23 Jun 2024 05:35:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/10] xfs: don't bother returning errors from xfs_file_release
Date: Sun, 23 Jun 2024 07:34:49 +0200
Message-ID: <20240623053532.857496-5-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240623053532.857496-1-hch@lst.de>
References: <20240623053532.857496-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

While ->release returns int, the only caller ignores the return value.
As we're only doing cleanup work there isn't much of a point in
return a value to start with, so just document the situation instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d39d0ea522d1c2..7b91cbab80da55 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1186,6 +1186,10 @@ xfs_dir_open(
 	return error;
 }
 
+/*
+ * Don't bother propagating errors.  We're just doing cleanup, and the caller
+ * ignores the return value anyway.
+ */
 STATIC int
 xfs_file_release(
 	struct inode		*inode,
@@ -1193,7 +1197,6 @@ xfs_file_release(
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	int			error;
 
 	/* If this is a read-only mount, don't generate I/O */
 	if (xfs_is_readonly(mp))
@@ -1211,11 +1214,8 @@ xfs_file_release(
 	if (!xfs_is_shutdown(mp) &&
 	    xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED)) {
 		xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
-		if (ip->i_delayed_blks > 0) {
-			error = filemap_flush(inode->i_mapping);
-			if (error)
-				return error;
-		}
+		if (ip->i_delayed_blks > 0)
+			filemap_flush(inode->i_mapping);
 	}
 
 	/*
@@ -1249,14 +1249,14 @@ xfs_file_release(
 			 * dirty close we will still remove the speculative
 			 * allocation, but after that we will leave it in place.
 			 */
-			error = xfs_free_eofblocks(ip);
-			if (!error && ip->i_delayed_blks)
+			xfs_free_eofblocks(ip);
+			if (ip->i_delayed_blks)
 				xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
 		}
 		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 	}
 
-	return error;
+	return 0;
 }
 
 STATIC int
-- 
2.43.0

