Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017402C95
	for <linux-xfs@vger.kernel.org>; Sun, 23 Jun 2024 05:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719121513; cv=none; b=BfnyRXH52fSFAjszJf3WboDW7KUOklfR3CJKynKnAzUsoZWubLVqM5bysoRAxj8Z247jpwm6G8iEbos47CMcX9OUjYxw/3wmyrBsRc9dyvQouFP4lOoA7+A7zsSmiGw3qnA0w3lmGwzrZAh6tHLsHcNX+NSSE3tMwDBWTKCLq/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719121513; c=relaxed/simple;
	bh=ssiZXCqjvR9877bUwiW7RYByfjxy34Pv6MKMmvlnfHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f37EKx8QjU1ax5sExFhHcPI9chje/+/OWmxQHE4/jL0LyJp+K6gNDCFuHoAW3ZMH+C5LrLa3G+/tmnjL4+4Y8/11BEfn/CCZd1Xp+f5pPfyMrecTsRJRFUcDZwEuxGppf+4KUIOdw8YcMF+N+r50D3GpW8gJSG14U71NNg5F18g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=amElSbGk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="amElSbGk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=M+3l+uJ7AeC8KrjOJFtGhs/AjKRbHQh6XXjOJ6DOAk4=; b=amElSbGkEqIPnY8jXE21z0t/bm
	r8yJjhJt3CkHDURKv8OqSsiKFVGIvAmJeGyYOvQTMgvQtd4bW/X3auE6eKlKeKZz1lBpE4+Yl4pmy
	rWOFoNfoRe+MZZ4FP9h5nWCONKbeeE0ezc0Sevi97sak57pXfJwOjT7gCWGxPvFiGsIxi+6WPe6W3
	s/Z2kxtOqaKKH0T9yd3m+UUj6511ACLl4t290+vIcrD6OXHmyeGSnoYSCguYpiPhht0Etmag83Ia5
	SnpGk/ofRW3KP7qLgkwBPK/xARb4CFk9rkv0v+9rNtTMHnIvt7ZX2yfYKZH0fDtdX5q5jeZ8ROZoq
	yG3hvjOg==;
Received: from 2a02-8389-2341-5b80-9456-578d-194f-dacd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9456:578d:194f:dacd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLG2J-0000000DPAM-0W9i;
	Sun, 23 Jun 2024 05:45:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/6] xfs: cleanup xfs_ilock_iocb_for_write
Date: Sun, 23 Jun 2024 07:44:27 +0200
Message-ID: <20240623054500.870845-3-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240623054500.870845-1-hch@lst.de>
References: <20240623054500.870845-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the relock path out of the straight line and add a comment
explaining why it exists.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b240ea5241dc9d..74c2c8d253e69b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -213,14 +213,18 @@ xfs_ilock_iocb_for_write(
 	if (ret)
 		return ret;
 
-	if (*lock_mode == XFS_IOLOCK_EXCL)
-		return 0;
-	if (!xfs_iflags_test(ip, XFS_IREMAPPING))
-		return 0;
+	/*
+	 * If a reflink remap is in progress we always need to take the iolock
+	 * exclusively to wait for it to finish.
+	 */
+	if (*lock_mode == XFS_IOLOCK_SHARED &&
+	    xfs_iflags_test(ip, XFS_IREMAPPING)) {
+		xfs_iunlock(ip, *lock_mode);
+		*lock_mode = XFS_IOLOCK_EXCL;
+		return xfs_ilock_iocb(iocb, *lock_mode);
+	}
 
-	xfs_iunlock(ip, *lock_mode);
-	*lock_mode = XFS_IOLOCK_EXCL;
-	return xfs_ilock_iocb(iocb, *lock_mode);
+	return 0;
 }
 
 static unsigned int
-- 
2.43.0

