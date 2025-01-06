Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B9DB676
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 09:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736157396; cv=none; b=TqqW0ae/PiKk6pZXUzSdE6pYYldVz8eArXHBPH5FGwnBLhMymyYQcyDsnXAhbwnPAMYsObBuf68wDMT+D9QVgvWgcDoRNaQ9huTtTrlOq8c5wR9OfnmvoAdz8LZMl/cveo3Z59CExtf6pQBRfES9oSMnNXlE6etVj0AmV91+gew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736157396; c=relaxed/simple;
	bh=EtxAFI+1lZcnuboGT9hbyldNbfqfKa3HmBiJTB5zWps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQBCILnHg56pmekb5BLJKKO4YfJLybnNGxfP+SQ4fO3D2ZMUJg8VVE0tzguUXybxVkSzJnMxjzWGX5UWLBM7wCBGNpMKnSxdl8Oxu6T1FiExOCVNV9NZjwMvQyP6/O+Cu2sO6lgVCqRHHbmTj0M5dLUoI07wg5CRDjfQoP6DqWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TTHAITmd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TTHAITmd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QpkF5rqe9qPrPHPx4phjTHqZ3WunJpMacmD170dG4NU=; b=TTHAITmdmWXdCZqdzpbdp7nbOs
	YSRpZaCixfC+PimSnm8EOIjkyT6g5RIQMm4V+K+NQRqmK6f3vNdU9AAsFxADYoX1mjOU1N5Q/9jid
	ce555RKRoUdc3XMT5MuCqzeyMWBgekrQFmYzvTlqxhN4tsG6cJWs0pez5igInv0oF7kGPE3BI9KuZ
	GZ/78ylthCRSxfuUov+aXGtrv9hWJajLQjQ9C1CeTbdsCz3grmKAmVza5CHch5MYqFNopVxe/ATKR
	hX0uZSrqq5sY68mc3SDDdDpTj7G4j7zv1ni+fMFJEOFNld7+WBwCfPfyFG0m31rzLIUjs4jRYP62L
	PJKZWzXQ==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUjqc-00000000lIS-0guk;
	Mon, 06 Jan 2025 09:56:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/15] xfs: move write verification out of _xfs_buf_ioapply
Date: Mon,  6 Jan 2025 10:54:44 +0100
Message-ID: <20250106095613.847700-8-hch@lst.de>
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

Split the write verification logic out of _xfs_buf_ioapply into a new
xfs_buf_verify_write helper called by xfs_buf_submit given that it isn't
about applying the I/O and doesn't really fit in with the rest of
_xfs_buf_ioapply.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 67 ++++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e48d796c786b..18e830c4e990 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1615,36 +1615,6 @@ _xfs_buf_ioapply(
 
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
@@ -1693,6 +1663,36 @@ xfs_buf_iowait(
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
@@ -1751,8 +1751,15 @@ xfs_buf_submit(
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

