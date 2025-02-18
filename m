Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E506222B8A2
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866448; cv=none; b=nEDVA6bsIotFrU23if1q9Md4kRRpXp0i9Pguj7Xt+BabFuzprWE+/ziWASMMt6hf65cRo13gBKbglHfN3z06telo4kGbeo0QK8fVVH2qTfFGXDxMsss3FN2EHI/42mF6tjm3jxmWp7eGDXZjzXISgjCPGTEAEachzlcdZgeXzY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866448; c=relaxed/simple;
	bh=P9aw6pw+PlL4uG5aWQPu6LUhQ1T+fShcmLT9syrJjZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGYpLTdMtBRYiIyHOEN0xIMdcrjCyiZ8CplOT0bLJnrTwiERzKM8ZAZxqDFjTHjC4DvjyUWJGwulthzR4zJ80+0Uf4wdg+zsUX6Z2vtGeMRomjVuMiOQnOUpbXX779QIS4vRXA1nubOvbQ0AiOVNyYMX+IDbC1nFmBxdJ9rs8QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VV/U8MX8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VV/U8MX8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Rz8s/HWdG6QJSNUbJTD8nlt1qTFtS5glDrl+mmqFrw0=; b=VV/U8MX82g6OQw9ZejDOqg33L5
	huJUBF6a7fSyAnxnIBuyg+Xtc8GRp8KWw9G+gIfgmx5kKFZlcMzwZVgbh7QyoBzNx/VRIXkxebjww
	MMDY7DWF/cqeiceLPh1mgAqGbxOntCiZWKIz3EQ6GL2NFa487JECxL5CsSWF4f+d9vJDfyFSUrjZx
	lDZ09PtO0tSIDHtRaslXfq5TQhsXBqNcV5r5bjm5dHYODwwp7rLzg6aYY2JaGPV5EDByuMotlXK0C
	fG9K29nwgFPllRJc+01YDTDN5Nd5PxdpSG1MYC6zVEm9dla7dKFugh+ZNr1t2F3seqcfcj5JHFrYm
	zBtrI5iQ==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIk2-00000007Cvf-1Oqr;
	Tue, 18 Feb 2025 08:14:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 42/45] xfs: wire up the show_stats super operation
Date: Tue, 18 Feb 2025 09:10:45 +0100
Message-ID: <20250218081153.3889537-43-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
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

