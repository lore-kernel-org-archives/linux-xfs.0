Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005EA23ED5F
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 14:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736777575; cv=none; b=nDPk2jAvXeWafpC17eHikCkmJvEX3v95vA56+nFkuGvqLNoIfmvnA4UfQjUs68QlC4xRjmDgIdsuUtsYypDAPEtMUXtr5xS7FXJkMFv6yX8wSMgK8ieB8GGUGFjZ24suVHxfwTZWBgcMY2d8J4lVSjkiE+2YqGneST67SXkzhlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736777575; c=relaxed/simple;
	bh=P8RrAtansMom+/USymFN4IoqAdHa+0mJmGOlSWFCJhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7GMSyC5QlqVcUp9rC00XmXCMiwkModUqQdL1iaE2Uku12pl/6sIeKRoxRiLor2mi2EKQhRimbELbWpythFbzF4PmXl22vauhObITi2yb17JK1youfPVUQvNWEB445QhkwY8E6vZDQ4xape9ug/9UYGV8bClzgSr3Ht6HqQqL2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dCyai3ci; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dCyai3ci"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UqVLQz2FaZX3mSgvasOq72KzYQ3U8qKxOQPzVnswZYI=; b=dCyai3cicT0mA9X2tbLHyteshw
	fx61GQABLCjtbILIOQOXWaWfIpJTlZGjdJZ9L0qxSaOKQqRNiX7ScmSTGWckKHs6IgW++58FrhULH
	JA0mbdJf8Ilre0hec9NoERnaSDyJjb4SY4V4UdQ3cIj4Rj5jWVmH3nElC/XYB5swx2kRocyVxqDpf
	tbE8ULuXWburqHvOoMkfu+kaQzwIjfKLACf3bwLIGJNqPaHE7tbuLarnw7CPpgWjqKsnixKNix1Fo
	keKQUcACqT9K0Intx9o8IiNFxHO3Mgy0Jibd9rFculdr9hfTyTiOM++I5aIWMbFFJDV9yiQkap5hH
	UKkkixFg==;
Received: from 2a02-8389-2341-5b80-b273-11c2-5421-183d.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:b273:11c2:5421:183d] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXLBV-00000005Mpk-09XT;
	Mon, 13 Jan 2025 14:12:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/15] xfs: move write verification out of _xfs_buf_ioapply
Date: Mon, 13 Jan 2025 15:12:11 +0100
Message-ID: <20250113141228.113714-8-hch@lst.de>
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

Split the write verification logic out of _xfs_buf_ioapply into a new
xfs_buf_verify_write helper called by xfs_buf_submit given that it isn't
about applying the I/O and doesn't really fit in with the rest of
_xfs_buf_ioapply.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 67 ++++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 37318201db9a..02df4fde35b5 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1612,36 +1612,6 @@ _xfs_buf_ioapply(
 
 	if (bp->b_flags & XBF_WRITE) {
 		op = REQ_OP_WRITE;
-
-		/*
-		 * Run the write verifier callback function if it exists. If
-		 * this function fails it will mark the buffer with an error and
-		 * the IO should not be dispatched.
-		 */
-		if (bp->b_ops) {
-			bp->b_ops->verify_write(bp);
-			if (bp->b_error) {
-				xfs_force_shutdown(bp->b_mount,
-						   SHUTDOWN_CORRUPT_INCORE);
-				return;
-			}
-		} else if (bp->b_rhash_key != XFS_BUF_DADDR_NULL) {
-			struct xfs_mount *mp = bp->b_mount;
-
-			/*
-			 * non-crc filesystems don't attach verifiers during
-			 * log recovery, so don't warn for such filesystems.
-			 */
-			if (xfs_has_crc(mp)) {
-				xfs_warn(mp,
-					"%s: no buf ops on daddr 0x%llx len %d",
-					__func__, xfs_buf_daddr(bp),
-					bp->b_length);
-				xfs_hex_dump(bp->b_addr,
-						XFS_CORRUPTION_DUMP_LEN);
-				dump_stack();
-			}
-		}
 	} else {
 		op = REQ_OP_READ;
 		if (bp->b_flags & XBF_READ_AHEAD)
@@ -1690,6 +1660,36 @@ xfs_buf_iowait(
 	return bp->b_error;
 }
 
+/*
+ * Run the write verifier callback function if it exists. If this fails, mark
+ * the buffer with an error and do not dispatch the I/O.
+ */
+static bool
+xfs_buf_verify_write(
+	struct xfs_buf		*bp)
+{
+	if (bp->b_ops) {
+		bp->b_ops->verify_write(bp);
+		if (bp->b_error)
+			return false;
+	} else if (bp->b_rhash_key != XFS_BUF_DADDR_NULL) {
+		/*
+		 * Non-crc filesystems don't attach verifiers during log
+		 * recovery, so don't warn for such filesystems.
+		 */
+		if (xfs_has_crc(bp->b_mount)) {
+			xfs_warn(bp->b_mount,
+				"%s: no buf ops on daddr 0x%llx len %d",
+				__func__, xfs_buf_daddr(bp),
+				bp->b_length);
+			xfs_hex_dump(bp->b_addr, XFS_CORRUPTION_DUMP_LEN);
+			dump_stack();
+		}
+	}
+
+	return true;
+}
+
 /*
  * Buffer I/O submission path, read or write. Asynchronous submission transfers
  * the buffer lock ownership and the current reference to the IO. It is not
@@ -1745,8 +1745,15 @@ xfs_buf_submit(
 	atomic_set(&bp->b_io_remaining, 1);
 	if (bp->b_flags & XBF_ASYNC)
 		xfs_buf_ioacct_inc(bp);
+
+	if ((bp->b_flags & XBF_WRITE) && !xfs_buf_verify_write(bp)) {
+		xfs_force_shutdown(bp->b_mount, SHUTDOWN_CORRUPT_INCORE);
+		goto done;
+	}
+
 	_xfs_buf_ioapply(bp);
 
+done:
 	/*
 	 * If _xfs_buf_ioapply failed, we can get back here with only the IO
 	 * reference we took above. If we drop it to zero, run completion so
-- 
2.45.2

