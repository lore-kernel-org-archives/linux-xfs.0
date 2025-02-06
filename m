Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33589225A33
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824432; cv=none; b=X910Xg/IROSscAERXXEom/jgWzw8u1dYh0IQOWRD3L0hMZnVdIiq0SpCXjPajlK/dwA9hVDtwdv0HCkr8AFLVANy4ZoPFWMjzFRAguzrdgoxFjsPoESx18eC7Clu4xfgSmyv+1WnJFQadQdWSP9vInpTKVZsLWTdbNl9TjHPcYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824432; c=relaxed/simple;
	bh=X2QEyCwdCkWp2K/oPwKb3aCqL+kthap7iUJCI4iFKBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6vdYndYSDg3u5CaiBCpl7PF9ZOaepu2vnhdKJUhFHZrzuvMrFvLyZgb+s3Suy2ERbn13mhK9y8mT8F9u2kOpTzDOM+KLjk1MzEEZ3UJdf+4pC+IAyWGvucyRh33Wv8fuN92uCd/F6BilpdwN9ax36vDeqy9Y/5pa0gTSuHbyPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=w1liE61X; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="w1liE61X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bmZ1rcgV1tVrnT9yrM9787KTahCw/eyhQdrhp+I2YME=; b=w1liE61XnLVG6o/oTmPQGKhQVG
	dloA9QGtYruBrj2hPxXU6WgZa7+gHyZ06iS3KdL2xGjp80EoMFXQQwXdbt50qwZMc1OCIp6TuInEk
	vpa+VpFqwgU1KUovdLzuUE0wquKvn4KGEWV3vH9hoTzNC4rdkZ9TkQ5T3ueKzWNJjqtkS7qpQuIZG
	LM5NwR4K7vLLrEYROCCC8tzG/PgPhIft6lf3J3KA4gMWuZR2r3AstbD6ebQyYSIxlC7Gm9fnV9Bfe
	/4YMEsiAMtiyqtA1Y3XFGpbN6H2OSGngFkHatZMBD7pa8aA4vkKnvSUZNkasEZquOBXlN9VNZChe0
	fEd/I4GA==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvfK-00000005QuL-1sTQ;
	Thu, 06 Feb 2025 06:47:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 40/43] xfs: wire up the show_stats super operation
Date: Thu,  6 Feb 2025 07:44:56 +0100
Message-ID: <20250206064511.2323878-41-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The show_stats option allows a file system to dump plain text statistic
on a per-mount basis into /proc/*/mountstats.  Wire up a no-op version
which will grow useful information for zoned file systems later.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_super.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 01166e519413..134859a3719d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1257,6 +1257,14 @@ xfs_fs_shutdown(
 	xfs_force_shutdown(XFS_M(sb), SHUTDOWN_DEVICE_REMOVED);
 }
 
+static int
+xfs_fs_show_stats(
+	struct seq_file		*m,
+	struct dentry		*root)
+{
+	return 0;
+}
+
 static const struct super_operations xfs_super_operations = {
 	.alloc_inode		= xfs_fs_alloc_inode,
 	.destroy_inode		= xfs_fs_destroy_inode,
@@ -1271,6 +1279,7 @@ static const struct super_operations xfs_super_operations = {
 	.nr_cached_objects	= xfs_fs_nr_cached_objects,
 	.free_cached_objects	= xfs_fs_free_cached_objects,
 	.shutdown		= xfs_fs_shutdown,
+	.show_stats		= xfs_fs_show_stats,
 };
 
 static int
-- 
2.45.2

