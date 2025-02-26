Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0630823908C
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596258; cv=none; b=c9L3+6p9ol7DN3qcCwfyLkU+A4wEo6DxYhrbUINtJ8bAOMjDnHfmh99j2okEfiqN4SzRnUt2vtfwuiQb+qyCFvSMXjW8s79corbGL6PXH0Ge59S1fOl1NURQY3xYrqzT3hXj+9+LW5p+EFCAWvtB1uniaPVtfY1hDPQrEgBYdfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596258; c=relaxed/simple;
	bh=P9aw6pw+PlL4uG5aWQPu6LUhQ1T+fShcmLT9syrJjZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/tlWLjCpoVLTX5vQGRshgvTh0qgZewmFvzH02BNLZGGA9LtWDVeiRj6G5d735pDPlziZZkJ35ehSIh56lXlKzDYTVm9CNPFu1M9nKQve1vKN3qktLAtx2Yl9nhxv9E3frliqsmjCk+YDPTbGV3v4ST+OcjoXH/8G6DbZE4pnUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=t9wn0hq3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t9wn0hq3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Rz8s/HWdG6QJSNUbJTD8nlt1qTFtS5glDrl+mmqFrw0=; b=t9wn0hq3t4100S+zRiKVEfKJl7
	gWELNfsw2ZKc1P8b6M7ewy7GgO0v6PPk+MR2khyt9Z5JjZLDdkCJxJ6mJA4LVKqLY1GEWy0JCq3NC
	CC7Ka56tS6hhzbqA197FCL4GcvpfIBbtagbpLNRsOgjTDUMBOtgSenuFf4h3YczupmcDZAOjU2S61
	d8TnBUVnhNmvJWrOrYbgBRK0VfoAP/X1NMXC/gPQUjqK8AbkXrb1tkAjBgOf54GI+6qMG8xsjWUIo
	WPIGFZ+LJuqCRx9ONmWaiNFnVRC/Lct4jvOzzqS7a11XlX0k6wQrNNgxlCuG5e84TPB8hZxOxKdCI
	jygAg9Pw==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMbA-000000053yL-34FN;
	Wed, 26 Feb 2025 18:57:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 41/44] xfs: wire up the show_stats super operation
Date: Wed, 26 Feb 2025 10:57:13 -0800
Message-ID: <20250226185723.518867-42-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226185723.518867-1-hch@lst.de>
References: <20250226185723.518867-1-hch@lst.de>
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
index 6ae2a3937791..ec71e9db5e62 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1258,6 +1258,14 @@ xfs_fs_shutdown(
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
@@ -1272,6 +1280,7 @@ static const struct super_operations xfs_super_operations = {
 	.nr_cached_objects	= xfs_fs_nr_cached_objects,
 	.free_cached_objects	= xfs_fs_free_cached_objects,
 	.shutdown		= xfs_fs_shutdown,
+	.show_stats		= xfs_fs_show_stats,
 };
 
 static int
-- 
2.45.2

